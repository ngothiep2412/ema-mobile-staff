import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/api/tab_home_api/tab_home_api.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabHomeController extends BaseController {
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = true.obs;

  final count = 0.obs;
  RxList<EventModel> listEvent = <EventModel>[].obs;
  RxBool isLoading = false.obs;
  String jwt = '';

  Future<void> refreshpage() async {
    listEvent.clear();
    print('1: ${isLoading.value}');
    isLoading.value = true;
    listEvent.value = await TabHomeApi.getEvent(jwt);
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

  Future<void> getEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    checkToken();
    print('JWT 123: $jwt');
    isLoading.value = true;

    listEvent.value = await TabHomeApi.getEvent(jwt);
    isLoading.value = false;
    print('2: ${isLoading.value}');
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getEvent();

    // listEvent.value = [
    //   EventModel(id:'1',image: 'https://www.shutterstock.com/image-vector/events-colorful-typography-banner-260nw-1356206768.jpg',title: 'Công việc cá nhân'),
    //   EventModel(id:'2',image: 'https://www.adobe.com/content/dam/www/us/en/events/overview-page/eventshub_evergreen_opengraph_1200x630_2x.jpg',title: 'Lễ kỉ niệm 10 năm')
    // ];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapEvent({required String eventID, required String eventName}) {
    Get.toNamed(Routes.TASK_OVERALL_VIEW,
        arguments: {"eventID": eventID, "eventName": eventName});
  }
}
