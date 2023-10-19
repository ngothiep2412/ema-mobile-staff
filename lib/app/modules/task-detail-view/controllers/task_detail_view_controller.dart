import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/api/task_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/task-overall-view/controllers/task_overall_view_controller.dart';
import 'package:hrea_mobile_staff/app/resources/base_link.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaskDetailViewController extends BaseController {
  TaskDetailViewController({required this.taskID});

  String taskID = '';

  Rx<TaskModel> taskModel = TaskModel().obs;

  final isLoading = true.obs;
  TextEditingController textSearchController = TextEditingController();
  TextEditingController titleSubTaskController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  final testList = 0.obs;

  final isLoadingFetchUser = false.obs;
  RxList<String> listFind = <String>[].obs;
  Rx<QuillController> quillController = QuillController.basic().obs;

  Rx<QuillController> quillServerController = QuillController.basic().obs;

  RxList<String> dataAssign = <String>['Nguyễn Văn A', 'Nguyễn Văn B'].obs;
  final isEditDescription = false.obs;

  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  List<DateTime?> listChange = [];

  FocusNode focusNodeDetail = FocusNode();
  FocusNode focusNodeComment = FocusNode();

  RxBool errorUpdateTask = false.obs;
  RxString errorUpdateTaskText = ''.obs;

  RxString descriptionString = ''.obs;

  String jwt = '';
  RxInt count = 0.obs;
  RxDouble progressSubTaskDone = 0.0.obs;

  RxList<PlatformFile> filePicker = <PlatformFile>[].obs;

  // late IO.Socket socket;

  Socket socket = io('API_URL', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  void connectAndListen() {
    // socket = IO.io(BaseLink.localBaseLink + BaseLink.createComment,
    //     IO.OptionBuilder().setTransports(['websocket']).build());
    socket.connect();
    socket.onConnect((data) {
      print('connect socket');
    });
  }

  Future<void> getTaskDetail() async {
    isLoading.value = true;
    try {
      String jwt = GetStorage().read('JWT');

      taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
      if (taskModel.value.subTask!.isEmpty) {
        progressSubTaskDone.value = 0.0;
      } else {
        for (var item in taskModel.value.subTask!) {
          if (item.status == Status.DONE) {
            count.value++;
            print('count ${count.value}');
          }
        }
        progressSubTaskDone.value = count / taskModel.value.subTask!.length;
        print('progressSubTaskDone ${progressSubTaskDone}');
      }
      count.value = 0;

      // for (var item in taskModel.value.taskFiles!) {
      //   final ref = FirebaseStorage.instance.ref().child(item.fileUrl!);
      //   final byte = await ref.getData();
      //   filePicker.add(await parseFile(item.fileUrl!, byte!));
      //   print('filePicker ${filePicker.length}');
      // }

      print('aaaa123 ${taskModel.value.taskFiles!.length}');

      UserModel assigner = await TaskDetailApi.getAssignerDetail(
          jwt, taskModel.value.createdBy!);
      if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        taskModel.value.nameAssigner = assigner.result!.fullName;
        taskModel.value.avatarAssigner = assigner.result!.avatar;
        quillController.value = QuillController(
          document: Document.fromJson(jsonDecode(taskModel.value.description!)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }

      isLoading.value = false;
      print('taskModel ${taskModel.value.endDate}');
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getTaskDetail();
    // connectAndListen();
    // var myJSON = jsonDecode(
    //     r'[{"insert": "The Two Towers"}, {"insert": "\n", "attributes": {"header": 1}}, {"insert": "Aragorn sped on up the hill.\n"}]');
    // descriptionString.value =
    //     '[{"insert": "The Two Towers\\n"}, {"insert": "Aragorn sped on up the hill.\\n"}]';

    if (taskModel.value.description != "" ||
        taskModel.value.description != null) {
      var myJSON = jsonDecode(taskModel.value.description!);
      quillController.value = QuillController(
        document: Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

// Parse the modified string into a list of maps
    // List<Map<String, dynamic>> parsedList = jsonDecode(jsonString);
    // quillServerController.value = QuillController(
    //   document: Document.fromJson(myJSON),
    //   selection: const TextSelection.collapsed(offset: 0),
    // );

    // print('asd ${quillServerController.value}');
    focusNodeComment.addListener(() {
      if (focusNodeComment.hasFocus) {
        log('Comment is focus');
        isEditDescription.value = false;
      }
    });
    // focusNodeDetail.addListener(() {
    //   if (focusNodeDetail.hasFocus) {
    //     log('Detail is focus');
    //     focusNodeComment.unfocus();
    //   } else {
    //     log('Detail is not focus');
    //     if (isEditDescription.value) {
    //       Get.snackbar('Thông báo', 'Làm hàm lưu thay đổi');
    //     }
    //     // isEditDescription.value = false;
    //   }
    // });
    isLoading(false);
  }

  Future<void> createComment() async {
    isLoading.value = true;
    try {
      String jwt = GetStorage().read('JWT');

      ResponseApi responseApi = await TaskDetailApi.createComment(
          jwt, taskID, commentController.text);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        await getTaskDetail();
        errorUpdateTask.value = false;
      } else if (responseApi.statusCode == 400 ||
          responseApi.statusCode == 500) {
        errorUpdateTask.value = true;
        errorUpdateTaskText.value = responseApi.message!;
      }
      // emitComment();

      isLoading.value = false;
      print('taskModel ${taskModel.value.endDate}');
    } catch (e) {
      errorUpdateTask.value = true;
      errorUpdateTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  void emitComment() {
    socket.emit('comment-${taskModel.value.id}', {
      'taskID': taskModel.value.id,
      'content': '',
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textSearchController.dispose();
    super.onClose();
    socket.disconnect();
  }

  testController() async {
    isLoadingFetchUser(true);
    await Future.delayed(const Duration(seconds: 1));
    testList.value = math.Random().nextInt(10);
    isLoadingFetchUser(false);
  }

  addData(String value) {
    listFind.add(value);
  }

  onTapEditDescription() {
    // isEditDescription.value = true;
    print('descriptionString.value ${descriptionString.value.toString()}');
    Get.toNamed(Routes.EDIT_DESCRIPTION, arguments: {
      "quillController": quillController,
      "taskModel": taskModel
    });
  }

  // saveDescription() {
  //   isEditDescription.value = false;
  //   quillServerController.value = coppyController(quillController.value);

  //   print('quillController.value ${quillController.value.toString()}');
  // }

  // discardDescription() {
  //   quillController.value = coppyController(quillServerController.value);
  //   isEditDescription.value = false;
  //   print(
  //       'quillController.value 2 ${quillServerController.value.document.toDelta()}');
  // }

  // QuillController coppyController(QuillController controller) {
  //   QuillController abc = QuillController(
  //     document: Document.fromDelta(controller.document.toDelta()),
  //     selection: const TextSelection.collapsed(offset: 0),
  //   );
  //   return abc;
  // }

  getTimeRange(List<DateTime?> listTime) {
    listChange = listTime;
  }

  saveTime() {
    startDate.value = listChange.first!;
    endDate.value = listChange.last!;
  }

  Future<void> refreshPage() async {
    String jwt = GetStorage().read('JWT');
    print('1: ${isLoading.value}');
    isLoading.value = true;
    // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
    // UserModel assigner =
    //     await TaskDetailApi.getAssignerDetail(jwt, taskModel.value.createdBy!);
    // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
    //   taskModel.value.nameAssigner = assigner.result!.fullName;
    //   taskModel.value.avatarAssigner = assigner.result!.avatar;
    // }
    await getTaskDetail();
    isLoading.value = false;
  }

  Future<void> updateStatusTask(String status, String taskID) async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (GetStorage().read('JWT') != null) {
        jwt = GetStorage().read('JWT');
      } else {
        jwt = prefs.getString('JWT')!;
      }
      ResponseApi responseApi =
          await TaskDetailApi.updateStatusTask(jwt, taskID, status);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
        // UserModel assigner = await TaskDetailApi.getAssignerDetail(
        //     jwt, taskModel.value.createdBy!);
        // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        //   taskModel.value.nameAssigner = assigner.result!.fullName;
        //   taskModel.value.avatarAssigner = assigner.result!.avatar;

        // }
        await getTaskDetail();
        Get.find<TaskOverallViewController>().getListTask();
        errorUpdateTask.value = false;
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateTask.value = true;
      errorUpdateTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> createSubTask() async {
    isLoading.value = true;
    if (titleSubTaskController.text.isEmpty) {
      errorUpdateTask.value = true;
      errorUpdateTaskText.value = 'Phải đặt tên tiêu đề công việc nhỏ';
      isLoading.value = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (GetStorage().read('JWT') != null) {
          jwt = GetStorage().read('JWT');
        } else {
          jwt = prefs.getString('JWT')!;
        }
        print('itleSubTaskController.text ${titleSubTaskController.text}');
        ResponseApi responseApi = await TaskDetailApi.createSubTask(
            jwt,
            titleSubTaskController.text,
            taskModel.value.eventId!,
            taskModel.value.id!);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
          // UserModel assigner = await TaskDetailApi.getAssignerDetail(
          //     jwt, taskModel.value.createdBy!);
          // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
          //   taskModel.value.nameAssigner = assigner.result!.fullName;
          //   taskModel.value.avatarAssigner = assigner.result!.avatar;

          // }

          await getTaskDetail();
          Get.find<TaskOverallViewController>().getListTask();
        } else {
          errorUpdateTask.value = true;
          print('responseApi.message ${responseApi.message}');
          errorUpdateTaskText.value = responseApi.message!;
        }
        isLoading.value = false;
      } catch (e) {
        errorUpdateTask.value = true;
        errorUpdateTaskText.value = 'Có lỗi xảy ra';
        isLoading.value = false;
        print(e);
      }
    }
  }

  Future selectFile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (GetStorage().read('JWT') != null) {
        jwt = GetStorage().read('JWT');
      } else {
        jwt = prefs.getString('JWT')!;
      }
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'xlsx', 'docx', 'png', 'jpeg'],
        // allowedExtensions: ['pdf'],
      );
      if (result == null) {
        Get.snackbar('Lỗi', 'Không thể lấy tài liệu',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      final file = result.files.first;
      File fileResult = File(result.files[0].path!);

      // final newFile = await saveFilePermaently(file);

      filePicker.add(file);
      ResponseApi responseApi =
          await TaskDetailApi.uploadFile(jwt, fileResult, file.extension ?? '');
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        ResponseApi updateFileTask = await TaskDetailApi.updateFileTask(
            jwt, taskID, responseApi.result!);
        if (updateFileTask.statusCode == 200 ||
            updateFileTask.statusCode == 201) {
          await getTaskDetail();
          errorUpdateTask.value = false;
        } else {
          print('responseApi.message ${responseApi.message}');
          errorUpdateTaskText.value = responseApi.message!;
          errorUpdateTask.value = true;
        }
      } else {
        errorUpdateTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateTask.value = true;
      print(e);
      errorUpdateTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
    }
  }

  Future<File> saveFilePermaently(PlatformFile file) async {
    final appStorage = await getApplicationCacheDirectory();

    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
