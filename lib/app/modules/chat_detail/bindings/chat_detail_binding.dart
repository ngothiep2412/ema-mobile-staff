import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<ChatDetailController>(
      () => ChatDetailController(),
    );
  }
}
