import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';

import '../controllers/edit_description_controller.dart';

class EditDescriptionBinding extends BaseBindings {
  Rx<QuillController> quillController = QuillController.basic().obs;
  Rx<TaskModel> taskModel = TaskModel().obs;
  @override
  void injectService() {
    quillController = Get.arguments['quillController'] as Rx<QuillController>;
    taskModel = Get.arguments['taskModel'] as Rx<TaskModel>;

    Get.put(
      EditDescriptionController(
          quillController: quillController, taskModel: taskModel),
    );
  }
}