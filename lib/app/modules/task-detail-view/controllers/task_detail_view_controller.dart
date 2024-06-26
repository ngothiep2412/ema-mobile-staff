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
import 'package:hrea_mobile_staff/app/modules/subtask-detail-view/api/subtask_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/subtask-detail-view/model/attachment_model.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/api/task_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/file_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/item_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-overall-view/controllers/task_overall_view_controller.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaskDetailViewController extends BaseController {
  TaskDetailViewController(
      {required this.taskID, required this.isNavigateOverall, required this.isNavigateNotification, required this.isNavigateSchedule});

  String taskID = '';
  bool isNavigateOverall = false;
  bool isNavigateNotification = false;
  bool isNavigateSchedule = false;

  Rx<TaskModel> taskModel = TaskModel().obs;

  final isLoading = true.obs;
  TextEditingController textSearchController = TextEditingController();
  TextEditingController titleSubTaskController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController effortController = TextEditingController();

  final testList = 0.obs;

  RxBool checkCommentFile = false.obs;

  final isLoadingFetchUser = false.obs;
  final isLoadingDeleteComment = false.obs;

  final isCheckEditComment = false.obs;

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
  DateFormat dateFormatf2 = DateFormat('dd-MM-yyyy', 'vi');

  List<DateTime?> listChange = [];

  FocusNode focusNodeDetail = FocusNode();
  FocusNode focusNodeComment = FocusNode();

  RxBool errorUpdateTask = false.obs;
  RxString errorUpdateTaskText = ''.obs;

  RxString descriptionString = ''.obs;

  String jwt = '';
  String idUser = '';
  RxInt count = 0.obs;
  RxDouble progressSubTaskDone = 0.0.obs;

  RxList<PlatformFile> filePicker = <PlatformFile>[].obs;

  RxList<AttachmentModel> listAttachment = <AttachmentModel>[].obs;

  RxBool isExpanded = false.obs;
  RxDouble effort = 0.0.obs;
  RxDouble est = 0.0.obs;

  RxBool isCheckin = false.obs;
  RxBool checkView = false.obs;

  RxBool isLoadingComment = false.obs;
  RxBool isLoadingCommentV2 = false.obs;

  // late IO.Socket socket;

  // Socket socket = io('API_URL', <String, dynamic>{
  //   'transports': ['websocket'],
  //   'autoConnect': false
  // });

  // void connectAndListen() {
  //   // socket = IO.io(BaseLink.localBaseLink + BaseLink.createComment,
  //   //     IO.OptionBuilder().setTransports(['websocket']).build());
  //   socket.connect();
  //   socket.onConnect((data) {
  //     print('connect socket');
  //   });
  // }

  Future<void> getTaskDetail() async {
    isLoading.value = true;
    // isDateCheckIn();
    try {
      checkToken();

      taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
      UserModel creater = await TaskDetailApi.getAssignerDetail(jwt, taskModel.value.createdBy!);
      if (creater.statusCode == 200 || creater.statusCode == 201) {
        taskModel.value.nameAssigner = creater.result!.fullName;
        taskModel.value.avatarAssigner = creater.result!.avatar;
      } else {
        taskModel.value.nameAssigner = '';
        taskModel.value.avatarAssigner = '';
      }

      if (taskModel.value.subTask!.isEmpty) {
        progressSubTaskDone.value = 0.0;
      } else {
        for (var item in taskModel.value.subTask!) {
          if (item.status == Status.DONE || item.status == Status.CONFIRM) {
            count.value++;
          }
        }
        progressSubTaskDone.value = count / taskModel.value.subTask!.where((item) => item.status != Status.CANCEL).length;
        taskModel.value.subTask!.sort((a, b) {
          // Xử lý trường hợp startDate là null
          if (a.startDate == null && b.startDate != null) {
            return -1; // Đưa a lên đầu nếu a.startDate là null và b.startDate không phải là null.
          } else if (a.startDate != null && b.startDate == null) {
            return 1; // Đưa b lên đầu nếu b.startDate là null và a.startDate không phải là null.
          } else if (a.startDate == null && b.startDate == null) {
            return 0; // Nếu cả hai đều là null, không cần sắp xếp.
          }

          // So sánh ngày nếu cả hai đều không phải là null
          int dateComparison = a.startDate!.compareTo(b.startDate!);
          if (dateComparison != 0) {
            return dateComparison; // Trả về kết quả nếu ngày không giống nhau.
          } else {
            // Sắp xếp theo độ ưu tiên nếu ngày giống nhau
            final priorityOrder = {Priority.HIGH: 0, Priority.MEDIUM: 1, Priority.LOW: 2};
            final priorityA = priorityOrder[a.priority] ?? 2;
            final priorityB = priorityOrder[b.priority] ?? 2;
            return priorityA.compareTo(priorityB);
          }
        });
      }
      print(taskModel);
      count.value = 0;

      // if (progressSubTaskDone.value == 1) {
      //   await updateStatusTaskV2('DONE', taskID, true);
      // }

      //
      // else {
      //   if (taskModel.value.startDate!.day == taskModel.value.endDate!.day && DateTime.now().toLocal().isAfter(taskModel.value.startDate!)) {
      //     await updateStatusTask('OVERDUE', taskID);
      //   } else if (taskModel.value.startDate!.day != taskModel.value.endDate!.day && DateTime.now().toLocal().isAfter(taskModel.value.endDate!)) {
      //     await updateStatusTask('OVERDUE', taskID);
      //   } else {
      //     await updateStatusTask('PROCESSING', taskID);
      //   }
      // }

      // for (var item in taskModel.value.taskFiles!) {
      //   final ref = FirebaseStorage.instance.ref().child(item.fileUrl!);
      //   final byte = await ref.getData();
      //   filePicker.add(await parseFile(item.fileUrl!, byte!));
      //   print('filePicker ${filePicker.length}');
      // }

      // quillController.value = QuillController(
      //   document: Document.fromJson(jsonDecode(taskModel.value.description!)),
      //   selection: const TextSelection.collapsed(offset: 0),
      // );
      listComment.value = await TaskDetailApi.getAllComment(jwt, taskModel.value.id!);
      listComment.sort((comment1, comment2) {
        return comment2.createdAt!.compareTo(comment1.createdAt!);
      });

      if (taskModel.value.estimationTime != null) {
        est.value = taskModel.value.estimationTime!.toDouble();
      }
      if (taskModel.value.effort != null) {
        effort.value = taskModel.value.effort!.toDouble();
        effortController.text = taskModel.value.effort.toString();
      } else {
        effortController.text = '0.0';
      }
      getAllAttachment();

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
    } catch (e) {
      isLoading.value = false;
      print(e);
      checkView.value = false;
    }
  }

  Future<void> isDateCheckIn() async {
    checkToken();
    try {
      print('task Created At: ${taskModel.value.startDate}');
      print('task Created At: ${DateTime.now().toLocal().add(const Duration(hours: 7))}');
      if (DateTime.now().toLocal().add(const Duration(hours: 7)).difference(taskModel.value.startDate!).inMinutes > 2) {
        print('aaaa');
      }

      // List<TimesheetModel> listCheckIn =
      //     await TabTimeSheetApi.getTimeSheet(jwt, taskModel.value.eventId!, DateTime.now().toLocal().add(const Duration(hours: 7)).toString());
      // if (listCheckIn.isEmpty) {
      //   if (DateTime.now().toLocal().add(const Duration(hours: 7)).difference(taskModel.value.startDate!).inMinutes > 2) {
      //     isCheckin.value = false;
      //   }
      // } else {
      //   isCheckin.value = true;
      // }
    } catch (e) {
      log('Lỗi');
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    checkView.value = await checkTaskForUser();
    if (checkView.value) {
      await getTaskDetail();
    }
    // connectAndListen();
    // var myJSON = jsonDecode(
    //     r'[{"insert": "The Two Towers"}, {"insert": "\n", "attributes": {"header": 1}}, {"insert": "Aragorn sped on up the hill.\n"}]');
    // descriptionString.value =
    //     '[{"insert": "The Two Towers\\n"}, {"insert": "Aragorn sped on up the hill.\\n"}]';

    if (taskModel.value.description != "" && taskModel.value.description != null) {
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
    if (commentController.text.isEmpty) {
      Get.snackbar('Thông báo', 'Bạn phải nhập ít nhất 1 kí tự',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
    } else {
      try {
        isLoadingComment.value = true;
        checkToken();
        bool checkTask = await checkTaskForUser();
        if (checkTask) {
          List<FileModel> listFile = [];
          if (filePicker.isNotEmpty) {
            for (var item in filePicker) {
              File fileResult = File(item.path!);
              UploadFileModel responseApi = await TaskDetailApi.uploadFile(jwt, fileResult, item.extension ?? '', 'comment');
              if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
                listFile.add(FileModel(fileName: responseApi.result!.fileName, fileUrl: responseApi.result!.downloadUrl));
              } else {
                checkView.value = false;
              }
            }
            ResponseApi responseApi = await TaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              listComment.value = await TaskDetailApi.getAllComment(jwt, taskModel.value.id!);
              listComment.sort((comment1, comment2) {
                return comment2.createdAt!.compareTo(comment1.createdAt!);
              });
              getAllAttachment();
            } else {
              checkView.value = false;
            }
          } else {
            ResponseApi responseApi = await TaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              listComment.value = await TaskDetailApi.getAllComment(jwt, taskModel.value.id!);
              listComment.sort((comment1, comment2) {
                return comment2.createdAt!.compareTo(comment1.createdAt!);
              });
              getAllAttachment();
            } else {
              checkView.value = false;
            }
          }
          commentController.text = '';
          filePicker.value = [];
        } else {
          Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
        }
        isLoadingComment.value = false;
      } catch (e) {
        print(e);
        isLoadingComment.value = false;
        checkView.value = false;
      }
    }
  }

  // void emitComment() {
  //   socket.emit('comment-${taskModel.value.id}', {
  //     'taskID': taskModel.value.id,
  //     'content': '',
  //   });
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textSearchController.dispose();
    quillController.value.dispose();
    super.onClose();
    // socket.disconnect();
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
    isLoading.value = true;
    bool checkTask = await checkTaskForUser();
    if (checkTask) {
      await getTaskDetail();
    } else {
      Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
    }

    isLoading.value = false;
  }

  Future<void> updateStatusTask(String status, String taskID, bool isSubTask) async {
    isLoading.value = true;
    DateTime now = DateTime.now().toLocal();

    try {
      checkToken();
      bool checkTask = await checkTaskForUser();
      if (checkTask) {
        if (isSubTask) {
          if (status == 'DONE' || status == 'CONFIRM') {
            if (taskModel.value.startDate!.toLocal().isAfter(now)
                // || taskModel.value.endDate!.toLocal().isBefore(now)
                ) {
              Get.snackbar('Thông báo', 'Công việc này có thời hạn công việc không cho phép cập nhật',
                  snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
              // return;
            } else {
              ResponseApi responseApi = await SubTaskDetailApi.updateProgressTask(jwt, taskID, 100, status);
              if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
                checkView.value = false;
              }
            }
          } else {
            if (taskModel.value.startDate!.toLocal().isAfter(now)
                // || taskModel.value.endDate!.toLocal().isBefore(now)
                ) {
              Get.snackbar('Thông báo', 'Công việc này có thời hạn công việc không cho phép cập nhật',
                  snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
              // return;
            } else {
              ResponseApi responseApi = await SubTaskDetailApi.updateStatusTask(jwt, taskID, status);
              if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
                checkView.value = false;
              }
            }
          }
          // ResponseApi responseApi = await TaskDetailApi.updateStatusTask(jwt, taskID, status);
          // if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          //   if (status == 'DONE' || status == 'CONFIRM') {
          //     ResponseApi responseApi = await SubTaskDetailApi.updateProgressTask(jwt, taskID, 100);
          //     if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
          //       errorUpdateTask.value = true;
          //       errorUpdateTaskText.value = 'Có lỗi xảy ra';
          //       isLoading.value = false;
          //     }
          //   }

          if (isNavigateOverall == true) {
            Get.find<TaskOverallViewController>().getListTask();
          }
          await getTaskDetail();

          errorUpdateTask.value = false;
          // } else {
          //   checkView.value = false;
          // }
          // if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
          //   errorUpdateTask.value = true;
          //   errorUpdateTaskText.value = responseApi.message!;
          // }
        } else {
          if (taskModel.value.startDate!.toLocal().isAfter(now)
              // || taskModel.value.endDate!.toLocal().isBefore(now)
              ) {
            Get.snackbar('Thông báo', 'Công việc này có thời hạn công việc không cho phép cập nhật',
                snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
            // return;
          } else {
            bool allSubTasksDone = true; // Giả sử tất cả các subTask đều là Done ban đầu
            if (status == 'DONE' && taskModel.value.subTask != null) {
              for (var subTask in taskModel.value.subTask!) {
                if (subTask.status != Status.CONFIRM) {
                  allSubTasksDone = false;
                  break; // Không cần kiểm tra tiếp nếu có ít nhất một subTask chưa Done
                }
              }
            }
            if (allSubTasksDone) {
              checkToken();
              ResponseApi responseApi = await TaskDetailApi.updateStatusTask(jwt, taskID, status);
              if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
                if (isNavigateOverall == true) {
                  Get.find<TaskOverallViewController>().getListTask();
                }

                await getTaskDetail();

                errorUpdateTask.value = false;
              } else {
                checkView.value = false;
              }
              // if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
              //   errorUpdateTask.value = true;
              //   errorUpdateTaskText.value = responseApi.message!;
              // }
            } else {
              Get.snackbar('Không thể cập nhật', 'Tất cả công việc con phải Đã Xác Thực thì mới đổi thành trạng thái Hoàn thành',
                  snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
            }
          }
        }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }

      isLoading.value = false;
    } catch (e) {
      errorUpdateTask.value = true;
      errorUpdateTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
      checkView.value = false;
    }
  }

  void getAllAttachment() {
    List<AttachmentModel> list = [];

    if (taskModel.value.taskFiles!.isNotEmpty) {
      taskModel.value.taskFiles!.sort((taskFile1, taskFile2) {
        return taskFile2.createdAt!.compareTo(taskFile1.createdAt!);
      });
      for (var item in taskModel.value.taskFiles!) {
        list.add(AttachmentModel(fileName: item.fileName, fileUrl: item.fileUrl, mode: 1));
      }
    }
    // if (listComment.isNotEmpty) {
    //   for (var item in listComment) {
    //     if (item.commentFiles!.isNotEmpty) {
    //       for (var file in item.commentFiles!) {
    //         list.add(AttachmentModel(
    //             fileName: file.fileName, fileUrl: file.fileUrl, mode: 2));
    //       }
    //     }
    //   }
    // }

    listAttachment.value = list;
  }

  Future<void> createSubTask() async {
    isLoading.value = true;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    checkToken();

    if (titleSubTaskController.text.isEmpty) {
      errorUpdateTask.value = true;
      errorUpdateTaskText.value = 'Phải đặt tên tiêu đề công việc nhỏ';
      isLoading.value = false;
    } else {
      try {
        String title = titleSubTaskController.text;
        bool checkTask = await checkTaskForUser();
        String itemID = '';
        if (checkTask) {
          List<ItemModel> itemModel = await TaskDetailApi.getAllItem(jwt, idUser, taskModel.value.eventDivision!.event!.id!);
          for (var i in itemModel) {
            if (i.id == taskModel.value.id) {
              itemID = i.item!.id!;
            }
          }
          ResponseApi responseApi =
              await TaskDetailApi.createSubTask(jwt, title, taskModel.value.eventDivision!.event!.id!, taskModel.value.id!, itemID);
          if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
            errorUpdateTask.value = false;

            if (isNavigateOverall == true) {
              Get.find<TaskOverallViewController>().getListTask();
            }
            await getTaskDetail();
          } else {
            errorUpdateTask.value = true;
            errorUpdateTaskText.value = responseApi.message!;
            checkView.value = false;
          }
        } else {
          Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
        }

        isLoading.value = false;
      } catch (e) {
        errorUpdateTask.value = true;
        errorUpdateTaskText.value = 'Có lỗi xảy ra';
        isLoading.value = false;
        print(e);
        checkView.value = false;
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
      // isLoading.value = false;
      return;
    }

    final file = result.files.first;
    File fileResult = File(result.files[0].path!);
    double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;

    if (fileLength > 10) {
      Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      // isLoading.value = false;
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

  Future selectFileInEditComment(List<PlatformFile> filePickerEditCommentFile) async {
    filePickerEditCommentFile.clear();
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
      // isLoading.value = false;
      return;
    }

    final file = result.files.first;
    // File fileResult = File(result.files[0].path!);
    double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;

    if (fileLength > 10) {
      Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      // isLoading.value = false;
      return;
    }

    // final newFile = await saveFilePermaently(file);

    filePickerEditCommentFile.add(file);
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
    DateTime now = DateTime.now().toLocal();
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      print('decodedToken ${decodedToken}');
      print('now ${now}');

      DateTime expTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      print(expTime.toLocal());
      idUser = decodedToken['id'];
      // if (JwtDecoder.isExpired(jwt)) {
      //   Get.offAllNamed(Routes.LOGIN);
      //   return;
      // }
      if (expTime.toLocal().isBefore(now)) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
  }

  void deleteCommentFile(CommentFile commentFile) {
    isLoadingDeleteComment.value = true;
    try {
      for (var item in listComment) {
        item.commentFiles!.removeWhere(
          (element) => element.id == commentFile.id,
        );
      }

      // getAllAttachment();
      isLoadingDeleteComment.value = false;
    } catch (e) {
      isLoadingDeleteComment.value = false;
    }
  }

  void deleteAttachmentCommentFile(int index) {
    isLoading.value = true;
    try {
      filePicker.removeAt(index);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> deleteComment(CommentModel commentModel) async {
    try {
      checkToken();
      bool checkTask = await checkTaskForUser();
      if (checkTask) {
        ResponseApi responseApi = await TaskDetailApi.deleteComment(jwt, commentModel.id!);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          listComment.value = await TaskDetailApi.getAllComment(jwt, taskModel.value.id!);
          listComment.sort((comment1, comment2) {
            return comment2.createdAt!.compareTo(comment1.createdAt!);
          });
          getAllAttachment();
        } else {
          checkView.value = false;
        }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }
    } catch (e) {
      print(e);
      checkView.value = false;
    }
  }

  Future<void> cancel(String commentID) async {
    // isLoadingDeleteComment.value = true;
    try {
      listComment.value = await TaskDetailApi.getAllComment(jwt, taskModel.value.id!);
      listComment.sort((comment1, comment2) {
        return comment2.createdAt!.compareTo(comment1.createdAt!);
      });
      // isLoadingDeleteComment.value = false;
    } catch (e) {
      checkView.value = false;
      // isLoadingDeleteComment.value = false;
    }
  }

  Future<void> updateEffort(String taskID, double effortInput) async {
    try {
      checkToken();
      ResponseApi responseApi = await TaskDetailApi.updateEffort(jwt, taskID, taskModel.value.eventDivision!.event!.id!, effortInput);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        effort.value = effortInput;
        effortController.text = effortInput.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editComment(CommentModel commentModel, String content, String commentID, List<PlatformFile> filePickerEditCommentFile) async {
    try {
      checkToken();
      bool checkTask = await checkTaskForUser();
      isLoadingCommentV2.value = true;
      if (checkTask) {
        List<CommentFile> list = [];
        for (var item in listComment) {
          if (item.id == commentID) {
            for (var files in item.commentFiles!) {
              list.add(files);
            }
          }
        }
        List<FileModel> listFile = [];
        if (filePickerEditCommentFile.isNotEmpty) {
          for (var item in filePickerEditCommentFile) {
            File fileResult = File(item.path!);
            UploadFileModel responseApi = await TaskDetailApi.uploadFile(jwt, fileResult, item.extension ?? '', 'comment');
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              listFile.add(FileModel(fileName: responseApi.result!.fileName, fileUrl: responseApi.result!.downloadUrl));
            } else {
              checkView.value = false;
            }
          }
          for (var fileNew in listFile) {
            list.add(CommentFile(fileName: fileNew.fileName, fileUrl: fileNew.fileUrl));
          }
        }

        ResponseApi responseApi = await TaskDetailApi.updateComment(jwt, commentModel.id!, content, list);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          listComment.value = await TaskDetailApi.getAllComment(jwt, taskModel.value.id!);
          listComment.sort((comment1, comment2) {
            return comment2.createdAt!.compareTo(comment1.createdAt!);
          });
          // getAllAttachment();
        } else {
          checkView.value = false;
        }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }
      isLoadingCommentV2.value = false;
    } catch (e) {
      print(e);
      isLoadingCommentV2.value = false;
      checkView.value = false;
    }
  }

  Future<bool> checkTaskForUser() async {
    try {
      checkToken();
      Rx<TaskModel> taskModelCheck = TaskModel().obs;
      taskModelCheck.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
      if (taskModelCheck.value.status == null || taskModelCheck.value.priority == null) {
        return false;
      }

      taskModelCheck.value.assignTasks = taskModelCheck.value.assignTasks!.where((task) => task.status == "active").toList();

      bool isCheckTask = false;
      if (taskModelCheck.value.assignTasks != null && taskModelCheck.value.assignTasks!.isNotEmpty) {
        // for (var item in taskModelCheck.value.assignTasks!) {
        //   if (item.user!.id == idUser && item.status == "active") {
        //     isCheckTask = true;
        //     break;
        //   }
        // }

        for (var index = 0; index < taskModelCheck.value.assignTasks!.length; index++) {
          if (taskModelCheck.value.assignTasks![index].user!.id == idUser) {
            isCheckTask = true;
            break;
          }
        }
      }
      if (isCheckTask) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
