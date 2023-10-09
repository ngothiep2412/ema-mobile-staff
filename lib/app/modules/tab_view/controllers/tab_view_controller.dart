import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_notification_controller/tab_notification_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_timekeeping_controller/tab_timekeeping_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/views/tab_home_view/tab_home_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/views/tab_notification_view/tab_notification_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/views/tab_request_view/tab_request_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/views/tab_setting_view/tab_setting_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/views/tab_timesheet_view/tab_timesheet_view.dart';

class TabViewController extends BaseController {
  //TODO: Implement TabViewController

  RxList<Widget> body = RxList([
    const TabHomeView(),
    const TabTimeKeepingView(),
    const TabRequestView(),
    const TabNotificationView(),
    const TabSettingView()
  ]);
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
        selectedIndex(index);
        break;
      case 1:
        Get.find<TabTimeKeepingController>();
        selectedIndex(index);
        break;
      case 2:
        Get.find<TabRequestController>();
        selectedIndex(index);
        break;
      case 3:
        Get.find<TabNotificationController>();
        selectedIndex(index);
        break;
      case 4:
        Get.find<TabSettingController>();
        selectedIndex(index);
        break;
      default:
    }
  }
}
