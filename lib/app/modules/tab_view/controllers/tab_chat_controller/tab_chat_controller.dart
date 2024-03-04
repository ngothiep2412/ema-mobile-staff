import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TabChatController extends BaseController {
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = true.obs;

  final count = 0.obs;
  RxList<EventModel> listEvent = <EventModel>[].obs;
  RxList<EventModel> listEventToday = <EventModel>[].obs;

  RxBool isLoading = false.obs;
  String jwt = '';

  Future<void> refreshpage() async {
    listEvent.clear();
    listEventToday.clear();
    print('1: ${isLoading.value}');
    isLoading.value = true;

    isLoading.value = false;
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      if (JwtDecoder.isExpired(jwt)) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
  }

  @override
  Future<void> onInit() async {
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
}
