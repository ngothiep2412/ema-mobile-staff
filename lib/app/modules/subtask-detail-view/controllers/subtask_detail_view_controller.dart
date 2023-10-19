import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/api/task_detail_api.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

class SubtaskDetailViewController extends BaseController {
  SubtaskDetailViewController({required this.taskID});
  String taskID = '';
  Rx<TaskModel> taskModel = TaskModel().obs;

  final isLoading = true.obs;
  TextEditingController textSearchController = TextEditingController();
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

  RxBool errorUpdateSubTask = false.obs;
  RxString errorUpdateSubTaskText = ''.obs;

  RxString descriptionString = ''.obs;

  Future<void> getTaskDetail() async {
    isLoading.value = true;
    try {
      String jwt = GetStorage().read('JWT');

      taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
      UserModel assigner = await TaskDetailApi.getAssignerDetail(
          jwt, taskModel.value.createdBy!);
      if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        taskModel.value.nameAssigner = assigner.result!.fullName;
        taskModel.value.avatarAssigner = assigner.result!.avatar;
      }
      print(taskModel.value.description);
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
    // var myJSON = jsonDecode(
    //     r'[{"insert": "The Two Towers"}, {"insert": "\n", "attributes": {"header": 1}}, {"insert": "Aragorn sped on up the hill.\n"}]');
    if (taskModel.value.description != null &&
        taskModel.value.description != "") {
      var myJSON = jsonDecode(taskModel.value.description!);
      quillController.value = QuillController(
        document: Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textSearchController.dispose();
    super.onClose();
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
    Get.toNamed(Routes.EDIT_DESCRIPTION,
        arguments: {"quillController": quillController});
  }

  saveDescription() {
    isEditDescription.value = false;
    quillServerController.value = coppyController(quillController.value);

    print('quillController.value ${quillController.value.toString()}');
  }

  discardDescription() {
    quillController.value = coppyController(quillServerController.value);
    isEditDescription.value = false;
    print(
        'quillController.value 2 ${quillServerController.value.document.toDelta()}');
  }

  QuillController coppyController(QuillController controller) {
    QuillController abc = QuillController(
      document: Document.fromDelta(controller.document.toDelta()),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return abc;
  }

  getTimeRange(List<DateTime?> listTime) {
    listChange = listTime;
  }

  saveTime() {
    startDate.value = listChange.first!;
    endDate.value = listChange.last!;
  }
}
