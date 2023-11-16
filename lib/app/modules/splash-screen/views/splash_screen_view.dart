import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends BaseView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primary,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.defaultAvatar,
            height: 150,
          ),
          SizedBox(
            height: UtilsReponsive.height(30, context),
          ),
          if (defaultTargetPlatform == TargetPlatform.iOS)
            const CupertinoActivityIndicator(
              color: Colors.white,
              radius: 20,
            )
          else
            const CircularProgressIndicator(
              color: Colors.white,
            )
        ],
      )),
    );
  }
}
