import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';

import '../controllers/tab_attendance_controller.dart';

class AttendanceTabView extends BaseView<AttendanceTabController> {
  const AttendanceTabView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.ATTENDANCE);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))
                      ),
                                  height: UtilsReponsive.height(60, context),
                                  child: Center(
                    child: Text('Attendance', style: GetTextStyle.getTextStyle(
                            UtilsReponsive.height(18, context), 'Roboto', FontWeight.w800, Colors.white),
                      ),
                                  ),
                                ),
                  )),
              SizedBox(
                width: UtilsReponsive.width(20, context),
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.TIME_SHEET);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))
                      ),
                                  height: UtilsReponsive.height(60, context),
                                  child: Center(
                    child: Text('Confirm TimeSheet', style: GetTextStyle.getTextStyle(
                            UtilsReponsive.height(18, context), 'Roboto', FontWeight.w800, Colors.white),
                      ),
                                  ),
                                ),
                  )),
            ],
          )
        ],
      ),
    )));
  }
}
