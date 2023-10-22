import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/api/task_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/file_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-overall-view/controllers/task_overall_view_controller.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
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

  RxBool checkCommentFile = false.obs;

  final isLoadingFetchUser = false.obs;
  RxList<String> listFind = <String>[].obs;
  Rx<QuillController> quillController = QuillController.basic().obs;

  Rx<QuillController> quillServerController = QuillController.basic().obs;

  RxList<String> dataAssign = <String>['Nguyễn Văn A', 'Nguyễn Văn B'].obs;
  RxList<CommentModel> listComment = <CommentModel>[].obs;
  RxBool isEditComment = false.obs;

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
      checkToken();

      taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
      if (taskModel.value.subTask!.isEmpty) {
        progressSubTaskDone.value = 0.0;
      } else {
        for (var item in taskModel.value.subTask!) {
          if (item.status == Status.DONE || item.status == Status.CONFIRM) {
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

      UserModel creater = await TaskDetailApi.getAssignerDetail(
          jwt, taskModel.value.createdBy!);
      if (creater.statusCode == 200 || creater.statusCode == 201) {
        taskModel.value.nameAssigner = creater.result!.fullName;
        taskModel.value.avatarAssigner = creater.result!.avatar;
        quillController.value = QuillController(
          document: Document.fromJson(jsonDecode(taskModel.value.description!)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
      listComment.value =
          await TaskDetailApi.getAllComment(jwt, taskModel.value.id!);

      // for (var item in taskModel.value.assignTasks!) {
      //   UserModel assigner = await TaskDetailApi.getAssignerDetail(
      //       jwt, taskModel.value.createdBy!);
      //   if (assigner.statusCode == 200 || assigner.statusCode == 201) {
      //     taskModel.value.assignTasks = assigner.result!.fullName;
      //     taskModel.value.avatarAssigner = assigner.result!.avatar;
      //     quillController.value = QuillController(
      //       document:
      //           Document.fromJson(jsonDecode(taskModel.value.description!)),
      //       selection: const TextSelection.collapsed(offset: 0),
      //     );
      //   }
      // }

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
    print('taskModel detail ${taskModel.value.id}');
    // connectAndListen();
    // var myJSON = jsonDecode(
    //     r'[{"insert": "The Two Towers"}, {"insert": "\n", "attributes": {"header": 1}}, {"insert": "Aragorn sped on up the hill.\n"}]');
    // descriptionString.value =
    //     '[{"insert": "The Two Towers\\n"}, {"insert": "Aragorn sped on up the hill.\\n"}]';

    if (taskModel.value.description != "" &&
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
      checkToken();
      List<FileModel> listFile = [];
      if (filePicker.isNotEmpty) {
        for (var item in filePicker) {
          File fileResult = File(item.path!);
          UploadFileModel responseApi = await TaskDetailApi.uploadFile(
              jwt, fileResult, item.extension ?? '');
          if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
            listFile.add(FileModel(
                fileName: responseApi.result!.fileName,
                fileUrl: responseApi.result!.downloadUrl));
            ResponseApi uplodateFileRsp = await TaskDetailApi.updateFileTask(
                jwt,
                taskID,
                responseApi.result!.downloadUrl!,
                responseApi.result!.fileName!);
            if (uplodateFileRsp.statusCode == 400 ||
                uplodateFileRsp.statusCode == 500) {
              errorUpdateTaskText.value = 'Có lỗi xảy ra';
              errorUpdateTask.value = true;
              isLoading.value = false;
              return;
            }
          } else {
            errorUpdateTaskText.value = 'Có lỗi xảy ra';
            errorUpdateTask.value = true;
            isLoading.value = false;
            return;
          }
        }
      } else {
        ResponseApi responseApi = await TaskDetailApi.createComment(
            jwt, taskID, commentController.text, listFile);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          await getTaskDetail();
          errorUpdateTask.value = false;
        } else {
          errorUpdateTask.value = true;
          errorUpdateTaskText.value = responseApi.message!;
        }
      }

      isLoading.value = false;
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
    quillController.value.dispose();
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
      // "quillController": quillController,
      "taskModel": taskModel,
      "isSubtask": false,
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
      checkToken();
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
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    checkToken();
    //  else {
    //   jwt = prefs.getString('JWT')!;
    // }
    if (titleSubTaskController.text.isEmpty) {
      errorUpdateTask.value = true;
      errorUpdateTaskText.value = 'Phải đặt tên tiêu đề công việc nhỏ';
      isLoading.value = false;
    } else {
      try {
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
          errorUpdateTask.value = false;
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
    // isLoading.value = true;
    // try {
    // checkToken();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'xlsx', 'docx', 'png', 'jpeg'],
      // allowedExtensions: ['pdf'],
    );
    if (result == null) {
      // Get.snackbar('Lỗi', 'Không thể lấy tài liệu',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.redAccent,
      //     colorText: Colors.white);
      isLoading.value = false;
      return;
    }

    final file = result.files.first;
    File fileResult = File(result.files[0].path!);
    double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;

    if (fileLength > 10) {
      Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      isLoading.value = false;
      return;
    }

    // final newFile = await saveFilePermaently(file);

    filePicker.add(file);
    // UploadFileModel responseApi =
    //     await TaskDetailApi.uploadFile(jwt, fileResult, file.extension ?? '');
    // if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
    //   String fileName = fileResult.path.split('/').last;
    //   ResponseApi updateFileTask = await TaskDetailApi.updateFileTask(
    //       jwt, taskID, responseApi.result!.downloadUrl!, fileName);
    //   if (updateFileTask.statusCode == 200 ||
    //       updateFileTask.statusCode == 201) {
    //     await getTaskDetail();
    //     errorUpdateTask.value = false;
    //   } else {
    //     errorUpdateTaskText.value = 'Có lỗi xảy ra';
    //     errorUpdateTask.value = true;
    //   }
    // } else {
    //   errorUpdateTask.value = true;
    //   errorUpdateTaskText.value = 'Có lỗi xảy ra';
    // }
    // isLoading.value = false;
    // } catch (e) {
    // errorUpdateTask.value = true;
    // print(e);
    // errorUpdateTaskText.value = 'Có lỗi xảy ra';
    // isLoading.value = false;
    // }
  }

  Future<File> saveFilePermaently(PlatformFile file) async {
    final appStorage = await getApplicationCacheDirectory();

    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
