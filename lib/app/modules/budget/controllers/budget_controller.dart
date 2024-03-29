import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/api/task_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/item_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class BudgetController extends BaseController {
  BudgetController({required this.eventID});

  RxBool isLoading = false.obs;

  DateTime createdAt = DateTime(2023, 10, 17, 14, 30);

  DateFormat dateFormat = DateFormat('dd-MM-yyyy', 'vi');

  RxBool isModalVisible = false.obs;

  String eventID = '';

  String jwt = '';
  String idUser = '';

  RxBool errorGetBudget = false.obs;
  RxString errorGetBudgetText = ''.obs;

  RxList<ItemModel> itemModelList = <ItemModel>[].obs;

  RxBool checkView = true.obs;
  @override
  Future<void> onInit() async {
    super.onInit();

    await getAllRequestBudget();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void createBudget() {
    Get.toNamed(Routes.CREATE_BUDGET, arguments: {"eventID": eventID});
  }

  void checkToken() {
    DateTime now = DateTime.now().toLocal();
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      print('decodedToken ${decodedToken}');
      print('now ${now}');

      DateTime expTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      print(expTime.toLocal());
      idUser = decodedToken['id'];
      // if (JwtDecoder.isExpired(jwt)) {
      //   Get.offAllNamed(Routes.LOGIN);
      //   return;
      // }
      if (expTime.toLocal().isBefore(now)) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
  }

  Future<void> refreshPage() async {
    // listBudget.clear();
    checkView.value = true;
    await getAllRequestBudget();
  }

  Future<void> getAllRequestBudget() async {
    isLoading.value = true;

    try {
      checkToken();
      List<ItemModel> itemModel = await TaskDetailApi.getAllItem(jwt, idUser, eventID);

      if (itemModel.isNotEmpty) {
        itemModelList.value = itemModel;
      }
      isLoading.value = false;
    } catch (e) {
      checkView.value = false;
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  String formatCurrency(int amount) {
    String formattedAmount = amount.toString();
    final length = formattedAmount.length;

    if (length > 3) {
      for (var i = length - 3; i > 0; i -= 3) {
        formattedAmount = formattedAmount.replaceRange(i, i, ',');
      }
    }

    return formattedAmount;
  }
}
