import 'dart:developer';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/forgot_password/api/forgot_password_api.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordController extends BaseController {
  RxString emailTxt = ''.obs;
  RxString errorInputEmail = ''.obs;
  RxBool isLoading = false.obs;
  ResponseApi? responseApi;
  RxBool errorForgotPassword = false.obs;
  RxString errorForgotPasswordText = ''.obs;

  final count = 0.obs;
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

  sendOtp() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (emailTxt.value.isEmpty) {
      errorForgotPassword.value = true;
      isLoading.value = false;
      errorForgotPasswordText.value = "Vui lòng nhập email";
    } else if (!emailTxt.value.contains('@')) {
      errorForgotPassword.value = true;
      isLoading.value = false;
      errorForgotPasswordText.value = "Vui lòng nhập đúng định dạng email";
    } else {
      try {
        responseApi = await ForgotPasswordApi.sendOtp(emailTxt.value);
        if (responseApi!.statusCode == 400 || responseApi!.statusCode == 500) {
          errorForgotPassword.value = true;
          errorForgotPasswordText.value = "Email không tồn tại";
        } else if (responseApi!.statusCode == 200 ||
            responseApi!.statusCode == 201) {
          prefs.setString('Email', emailTxt.value);
          errorForgotPassword.value = false;
          Get.toNamed(Routes.OTP);
        }
        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        isLoading.value = false;
        errorForgotPassword.value = true;
        errorForgotPasswordText.value = "Có lỗi xảy ra";
      }
    }
  }

  setEmail(String value) {
    emailTxt.value = value;
    validatorEmail();
  }

  validatorEmail() {
    if (emailTxt.value.isEmpty) {
      errorInputEmail("Email không được để trống".tr);
    } else if (!emailTxt.value.contains('@')) {
      errorInputEmail("Email không hợp lệ".tr);
    } else {
      errorInputEmail("");
    }
    log(errorInputEmail.value);
  }

  void increment() => count.value++;
}
