import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/views/tab_home_view/tab_home_view.dart';

class TabViewController extends BaseController {
  //TODO: Implement TabViewController

  RxList<Widget> body = RxList([TabHomeView()]);
  RxInt selectedIndex = 0.obs;
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

  onTapped(int index) {
    switch (index) {
      case 0:
        Get.find<TabHomeController>();
        selectedIndex(0);
        break;
      default:
    }
  }
}
