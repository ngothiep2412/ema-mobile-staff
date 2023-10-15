import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:intl/intl.dart';

class TaskDetailViewController extends BaseController {
  //TODO: Implement TaskDetailViewController

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

  @override
  void onInit() {
    super.onInit();

    var myJSON = jsonDecode(
        r'[{"insert":"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n"}]');

    quillServerController.value = QuillController(
      document: Document.fromJson(myJSON),
      selection: TextSelection.collapsed(offset: 0),
    );
    quillController.value = QuillController(
      document: Document.fromJson(myJSON),
      selection: TextSelection.collapsed(offset: 0),
    );

    focusNodeComment.addListener(() {
      if (focusNodeComment.hasFocus) {
        log('Comment is focus');
        isEditDescription.value = false;
      }
    });
    focusNodeDetail.addListener(() {
      if (focusNodeDetail.hasFocus) {
        log('Detail is focus');
        focusNodeComment.unfocus();
      } else {
        log('Detail is not focus');
        if (isEditDescription.value) {
          Get.snackbar('Thông báo', 'Làm hàm lưu thay đổi');
        }
        // isEditDescription.value = false;
      }
    });
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
    await Future.delayed(Duration(seconds: 1));
    testList.value = math.Random().nextInt(10);
    isLoadingFetchUser(false);
  }

  addData(String value) {
    listFind.add(value);
  }

  onTapEditDescription() {
    isEditDescription.value = true;
  }

  saveDescription() {
    isEditDescription.value = false;
    quillServerController.value = coppyController(quillController.value);
  }

  discardDescription() {
    quillController.value = coppyController(quillServerController.value);
    isEditDescription.value = false;
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
