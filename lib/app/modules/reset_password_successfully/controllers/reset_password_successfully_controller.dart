import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordSuccessfullyController extends BaseController {
  //TODO: Implement ResetPasswordSuccessfullyController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  goToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  void increment() => count.value++;
}
