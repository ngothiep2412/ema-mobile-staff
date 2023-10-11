import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';

class ProfileController extends BaseController {
  //TODO: Implement ProfileController
  TextEditingController? firstNameController;
  final count = 0.obs;
  @override
  void onInit() {
    firstNameController = TextEditingController(text: 'Thiep');
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

  setFullName(String value) {
    print('value ${value}');
  }

  void increment() => count.value++;
}
