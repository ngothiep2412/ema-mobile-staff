import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:pinput/pinput.dart';

import '../controllers/otp_controller.dart';

class OtpView extends BaseView<OtpController> {
  const OtpView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    TextEditingController _otp = TextEditingController();
    PinTheme defaultTheme = PinTheme(
      height: UtilsReponsive.height(context, 75),
      width: UtilsReponsive.height(context, 75),
      textStyle: const TextStyle(fontSize: 25),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          border: Border.all(
            color: const Color(0xFFE8ECF4),
          ),
          borderRadius: BorderRadius.circular(8)),
    );
    PinTheme focusedTheme = PinTheme(
      height: UtilsReponsive.height(context, 75),
      width: UtilsReponsive.height(context, 75),
      textStyle: const TextStyle(fontSize: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ColorsManager.primary,
          ),
          borderRadius: BorderRadius.circular(8)),
    );
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
                    'Xác thực CODE',
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
                  'Hãy nhập code xác thực mà chúng tôi vừa gửi cho bạn qua email.',
                  style: GetTextStyle.getTextStyle(
                      16, 'Roboto', FontWeight.w500, ColorsManager.colorIcon),
                ),
              ),
              SizedBox(height: UtilsReponsive.height(context, 20)),
              Row(
                children: [
                  Expanded(
                    child: Pinput(
                      controller: _otp,
                      length: 5,
                      defaultPinTheme: defaultTheme,
                      focusedPinTheme: focusedTheme,
                      submittedPinTheme: focusedTheme,
                      onChanged: (value) {
                        print('111' + _otp.text);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: ColorsManager.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Xác nhận",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Không nhận được mã code? ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Gửi lại",
                      style: TextStyle(
                        color: ColorsManager.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
