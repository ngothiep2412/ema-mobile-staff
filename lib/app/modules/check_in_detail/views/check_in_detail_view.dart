import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';

import '../controllers/check_in_detail_controller.dart';

class CheckInDetailView extends BaseView<CheckInDetailController> {
  const CheckInDetailView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context)),
          child: Column(children: [
            SizedBox(
              height: UtilsReponsive.height(20, context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'event name',
                  style: GetTextStyle.getTextStyle(20, 'Roboto', FontWeight.w600, ColorsManager.textColor),
                ),
              ],
            ),
            Expanded(
                child: ListView.separated(
                    padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                    itemBuilder: (context, index) => _itemData(context),
                    separatorBuilder: (context, index) => SizedBox(
                          height: UtilsReponsive.height(10, context),
                        ),
                    itemCount: 100))
          ]),
        ),
      ),
    );
  }

  Card _itemData(BuildContext context) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          height: UtilsReponsive.height(60, context),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ngày check-in",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "9:00:00",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Giờ check-in",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "17:00:00",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox()
            ],
          )),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.backgroundContainer,
      leading: IconButton(
        onPressed: () {
          Get.back();
          controller.onDelete();
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: ColorsManager.primary,
        ),
      ),
    );
  }
}
