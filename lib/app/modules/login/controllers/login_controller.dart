import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';

class LoginController extends BaseController {
  RxBool passwordObscured = true.obs;

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

  void increment() => count.value++;
}
