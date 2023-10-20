import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/tab_attendance_controller.dart';

class AttendanceTabBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<AttendanceTabController>(
      () => AttendanceTabController(),
    );
  }
}
