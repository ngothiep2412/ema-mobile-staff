import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
