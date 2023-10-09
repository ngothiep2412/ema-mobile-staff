import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';

import '../controllers/reset_password_successfully_controller.dart';

class ResetPasswordSuccessfullyView
    extends BaseView<ResetPasswordSuccessfullyController> {
  const ResetPasswordSuccessfullyView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Lottie.asset('animations/successfully.json',
            height: UtilsReponsive.height(context, 300),
            reverse: true,
            repeat: true,
            fit: BoxFit.cover),
        SizedBox(
          height: UtilsReponsive.height(context, 30),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UtilsReponsive.width(context, 30),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorsManager.primary,
            ),
            child: MaterialButton(
              onPressed: () async {
                await controller.goToLogin();
              },
              child: Text(
                "Trở về đăng nhập",
                style: GetTextStyle.getTextStyle(
                    18, 'Roboto', FontWeight.w500, Colors.white),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
