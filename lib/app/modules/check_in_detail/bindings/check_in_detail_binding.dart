import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/check_in_detail_controller.dart';

class CheckInDetailBinding extends BaseBindings {
  String eventID = '';
  @override
  void injectService() {
    eventID = Get.arguments["eventID"] as String;
    Get.lazyPut<CheckInDetailController>(
      () => CheckInDetailController(eventID: eventID),
    );
  }
}
