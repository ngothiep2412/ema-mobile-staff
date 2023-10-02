import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';

import '../controllers/tab_view_controller.dart';

class TabViewBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<TabViewController>(
      () => TabViewController(),
    );
    Get.lazyPut<TabHomeController>(
      () => TabHomeController(),
    );
  }
}
