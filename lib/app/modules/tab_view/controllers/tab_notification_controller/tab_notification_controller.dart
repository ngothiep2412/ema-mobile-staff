import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/api/tab_notification_api/tab_notification_api.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/notification.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TabNotificationController extends BaseController {
  RxBool isLoading = false.obs;
  DateTime createdAt = DateTime(2023, 10, 17, 14, 30);

  var page = 1;
  RxBool mark = false.obs;
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;

  String jwt = '';
  String idUser = '';

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  RxBool errorGetBudget = false.obs;
  RxString errorGetBudgetText = ''.obs;

  RxList<NotificationModel> listNotifications = <NotificationModel>[].obs;
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    super.onInit();

    await getAllLeaveRequest(page);

    paginateBudget();
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

  void markAllRead() {
    if (mark.value) {
      mark.value = false;
    } else {
      mark.value = true;
    }
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> getAllLeaveRequest(var page) async {
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    try {
      checkToken();
      listNotifications.clear();
      List<NotificationModel> list =
          await TabNotificationApi.getAllNotification(jwt, page);

      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      listNotifications.value = list;

      // listNotifications.value =
      //     listNotifications.where((e) => e.status != "CANCEL").toList();

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  void paginateBudget() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('reached end');
        page++;
        getMoreBudget(page);
      }
    });
  }

  void getMoreBudget(var page) async {
    try {
      List<NotificationModel> list = [];

      list = await TabNotificationApi.getAllNotification(jwt, page);

      if (list.isNotEmpty) {
        isMoreDataAvailable(true);
      } else {
        isMoreDataAvailable(false);
      }
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      listNotifications.addAll(list);

      // listNotifications.value =
      //     listNotifications.where((e) => e.status != "CANCEL").toList();

      isLoading.value = false;
    } catch (e) {
      isMoreDataAvailable(false);
      print(e);
      ;
    }
  }

  Future<void> refreshPage() async {
    // listBudget.clear();
    page = 1;
    await getAllLeaveRequest(page);
  }
}
