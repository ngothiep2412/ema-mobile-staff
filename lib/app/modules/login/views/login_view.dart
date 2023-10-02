import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends BaseView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[800]!,
                Colors.blue[600]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: UtilsReponsive.height(context, 36),
                        horizontal: UtilsReponsive.width(context, 24)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HREA',
                          style: GetTextStyle.getTextStyle(
                              46, 'Roboto', FontWeight.w800, Colors.white),
                        ),
                        SizedBox(
                          height: UtilsReponsive.height(context, 10),
                        ),
                        Text(
                          'Đăng nhập',
                          style: GetTextStyle.getTextStyle(
                              20, 'Roboto', FontWeight.w400, Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(40))),
                    child: Padding(
                      padding: UtilsReponsive.paddingAll(context, padding: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
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
                          SizedBox(
                            height: UtilsReponsive.height(context, 20),
                          ),
                          Obx(
                            () => TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: controller.passwordObscured.value,
                              decoration: InputDecoration(
                                  errorBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: ColorsManager.textInput,
                                  hintText: "Mật khẩu",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey[600]!,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.passwordObscured.value =
                                          !controller.passwordObscured.value;
                                    },
                                    icon: Icon(
                                      controller.passwordObscured.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey[600]!,
                                    ),
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.FORGOT_PASSWORD);
                                },
                                child: Text(
                                  "Quên mật khẩu?",
                                  style: GetTextStyle.getTextStyle(15, 'Roboto',
                                      FontWeight.w400, ColorsManager.primary),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(context, 20),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorsManager.primary,
                            ),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                "Đăng nhập",
                                style: GetTextStyle.getTextStyle(20, 'Roboto',
                                    FontWeight.w400, Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
