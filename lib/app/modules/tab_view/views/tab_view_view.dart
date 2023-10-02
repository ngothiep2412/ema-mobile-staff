import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:line_icons/line_icons.dart';

import '../controllers/tab_view_controller.dart';

class TabViewView extends BaseView<TabViewController> {
  const TabViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomNav(context),
        body: Obx(
            () => controller.body.elementAt(controller.selectedIndex.value)));
  }

  Padding _bottomNav(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: UtilsReponsive.height(context, 15)),
      child: GNav(
          gap: 20,
          padding: EdgeInsets.all(UtilsReponsive.width(context, 15)),
          activeColor: ColorsManager.mainColor,
          iconSize: 24,
          tabBackgroundColor:
              ColorsManager.colorBottomNav, // selected tab background color
          tabs: [
            GButton(
                icon: LineIcons.home,
                text: 'Home',
                iconColor: ColorsManager.mainColor,
                onPressed: () {
                  controller.onTapped(0);
                }),
            GButton(
                icon: LineIcons.briefcase,
                text: 'Schedule',
                iconColor: ColorsManager.mainColor,
                onPressed: () {
                  controller.onTapped(1);
                }),
            GButton(
                icon: LineIcons.bell,
                text: 'Notification',
                iconColor: ColorsManager.mainColor,
                onPressed: () {
                  controller.onTapped(2);
                }),
            GButton(
                icon: LineIcons.user,
                text: 'Profile',
                iconColor: ColorsManager.mainColor,
                onPressed: () {
                  controller.onTapped(3);
                })
          ]),
    );
  }
}
