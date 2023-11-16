import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';
import '../controllers/create_request_controller.dart';

class CreateRequestBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<CreateRequestController>(
      () => CreateRequestController(),
    );
  }
}
