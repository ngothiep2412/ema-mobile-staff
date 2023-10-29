import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';

class EventDetailController extends BaseController {
  EventDetailController({required this.eventID});
  String eventID = '';

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
