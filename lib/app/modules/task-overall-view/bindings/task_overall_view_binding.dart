import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';
import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewBinding extends BaseBindings {
  String eventID = '';
  String eventName = '';

  @override
  void injectService() {
    eventID = Get.arguments["eventID"] as String;
    eventName = Get.arguments["eventName"] as String;
    Get.lazyPut<TaskOverallViewController>(
      () => TaskOverallViewController(eventID: eventID, eventName: eventName),
    );
  }
}
