import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenBinding extends BaseBindings {
  @override
  void injectService() {
    Get.put(
      SplashScreenController(),
    );
  }
}
