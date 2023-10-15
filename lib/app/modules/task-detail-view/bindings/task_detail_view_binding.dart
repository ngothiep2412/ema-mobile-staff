import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewBinding extends BaseBindings {
  @override
  void injectService() {
    Get.put(
      TaskDetailViewController(),
    );
   
  }
}
