import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_timekeeping_controller/tab_timekeeping_controller.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';

class TabTimeKeepingView extends BaseView<TabTimeKeepingController> {
  const TabTimeKeepingView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Padding(
          padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
          child: controller.isLoading.value == true
              ? Center(
                  child: SpinKitFadingCircle(
                    color: ColorsManager.primary,
                    // size: 30.0,
                  ),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Chấm công',
                              style: GetTextStyle.getTextStyle(20, 'Roboto',
                                  FontWeight.w600, ColorsManager.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
