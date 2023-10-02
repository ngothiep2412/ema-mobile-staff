import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends BaseView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: UtilsReponsive.height(context, 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(context, 20),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    'Quên mật khẩu?',
                    style: GetTextStyle.getTextStyle(
                        30, 'Roboto', FontWeight.w700, ColorsManager.primary),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(context, 20),
                  vertical: UtilsReponsive.height(context, 10),
                ),
                child: Text(
                  'Hãy nhập email và chúng tôi sẽ gửi mã code cho bạn.',
                  style: GetTextStyle.getTextStyle(
                      16, 'Roboto', FontWeight.w500, ColorsManager.colorIcon),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(context, 15),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(context, 20),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: ColorsManager.textInput,
                    hintText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey[600]!,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(context, 30),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(context, 20),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorsManager.primary,
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Get.toNamed(Routes.OTP);
                    },
                    child: Text(
                      "Lấy lại mật khẩu",
                      style: GetTextStyle.getTextStyle(
                          20, 'Roboto', FontWeight.w400, Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(context, 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã nhớ mật khẩu? ',
                    style: GetTextStyle.getTextStyle(
                        16, 'Roboto', FontWeight.w500, Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAndToNamed(Routes.LOGIN);
                    },
                    child: Text(
                      'Đăng nhập',
                      style: GetTextStyle.getTextStyle(
                          16, 'Roboto', FontWeight.w700, ColorsManager.primary),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
