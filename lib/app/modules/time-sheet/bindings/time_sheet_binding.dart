import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/time_sheet_controller.dart';

class TimeSheetBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<TimeSheetController>(
      () => TimeSheetController(),
    );
  }
}
