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
      backgroundColor: Colors.red.shade50,
        bottomNavigationBar: _bottomNav(context),
        body: Obx(
            () => controller.body.elementAt(controller.selectedIndex.value)));
  }

  Padding _bottomNav(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: UtilsReponsive.height(15,context)),
      child: GNav(
          gap: 15,
          padding: EdgeInsets.all(UtilsReponsive.width(15,context)),
          activeColor: ColorsManager.primary,
          iconSize: 24,
          tabBackgroundColor:
              ColorsManager.colorBottomNav, // selected tab background color
          tabs: [
            GButton(
                icon: LineIcons.hollyBerry,
                text: 'Sự kiện',
                iconColor: ColorsManager.primary,
                onPressed: () {
                  controller.onTapped(0);
                }),
            GButton(
                icon: Icons.event_available,
                text: 'Chấm công',
                iconColor: ColorsManager.primary,
                onPressed: () {
                  controller.onTapped(1);
                }),
            GButton(
                icon: Icons.note_add_outlined,
                text: 'Đơn',
                iconColor: ColorsManager.primary,
                onPressed: () {
                  controller.onTapped(2);
                }),
            GButton(
                icon: LineIcons.bell,
                text: 'Thông báo',
                iconColor: ColorsManager.primary,
                onPressed: () {
                  controller.onTapped(3);
                }),
            GButton(
                icon: LineIcons.list,
                text: 'Khác',
                iconColor: ColorsManager.primary,
                onPressed: () {
                  controller.onTapped(4);
                })
          ]),
    );
  }
}
