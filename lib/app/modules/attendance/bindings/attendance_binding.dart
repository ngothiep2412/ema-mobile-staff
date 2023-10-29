import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/attendance_controller.dart';

class AttendanceBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(),
    );
  }
}
