import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';

class TabNotificationController extends BaseController {
  RxBool isLoading = false.obs;
  DateTime createdAt = DateTime(2023, 10, 17, 14, 30);

  Future<void> refreshpage() {
    print('1111');
    return Future.delayed(const Duration(seconds: 5));
  }

  RxBool mark = false.obs;

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

  void markAllRead() {
    if (mark.value) {
      mark.value = false;
    } else {
      mark.value = true;
    }
  }
}
