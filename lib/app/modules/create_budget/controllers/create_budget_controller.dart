import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/budget/controllers/budget_controller.dart';
import 'package:hrea_mobile_staff/app/modules/create_budget/api/create_budget_api.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CreateBudgetController extends BaseController {
  CreateBudgetController({required this.eventID});
  TextEditingController budgetNameController = TextEditingController();
  TextEditingController estExpenseController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController supplierController = TextEditingController();

  RxBool errorCreateBudget = false.obs;
  RxString errorCreateBudgetText = ''.obs;

  String jwt = '';
  String idUser = '';

  String eventID = '';

  RxBool isLoading = false.obs;
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

  Future<void> createBudget() async {
    isLoading.value = true;
    String inputText = estExpenseController.text;
    String cleanedText = inputText.replaceAll('.', '');
    int amount = int.tryParse(cleanedText) ?? 0;
    if (budgetNameController.text == '') {
      print(budgetNameController.text);
      errorCreateBudget.value = true;
      errorCreateBudgetText.value = "Vui lòng nhập tên yêu cầu ngân sách";
      isLoading.value = false;
    } else if (estExpenseController.text.isEmpty) {
      errorCreateBudget.value = true;
      errorCreateBudgetText.value = "Vui lòng nhập số tiền chi phí ước tính";
      isLoading.value = false;
    } else if (amount < 999 && estExpenseController.text.isNotEmpty) {
      errorCreateBudget.value = true;
      errorCreateBudgetText.value = "Vui lòng nhập số tiền chi phí ước tính lớn hơn 999 đồng";
      isLoading.value = false;
    } else if (supplierController.text.isEmpty) {
      errorCreateBudget.value = true;
      errorCreateBudgetText.value = "Vui lòng nhập tên nhà cung cấp";
      isLoading.value = false;
    } else {
      try {
        checkToken();

        ResponseApi responseApiv = await CreateBudgetApi.createBudget(
            eventID, budgetNameController.text, amount, descriptionController.text, supplierController.text, idUser, jwt);
        if (responseApiv.statusCode == 200 || responseApiv.statusCode == 201) {
          errorCreateBudget.value = false;
          // await Get.find<BudgetController>().getAllRequestBudget(1);
          budgetNameController.text = '';
          descriptionController.text = '';
          estExpenseController.text = '';
          supplierController.text = '';
        } else {
          errorCreateBudget.value = true;
          errorCreateBudgetText.value = "Không thể tạo đơn";
        }

        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorCreateBudget.value = true;
        isLoading.value = false;
        errorCreateBudgetText.value = "Có lỗi xảy ra";
      }
    }
  }
}
