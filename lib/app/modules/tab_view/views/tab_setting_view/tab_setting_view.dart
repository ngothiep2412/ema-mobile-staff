import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabSettingView extends BaseView<TabSettingController> {
  const TabSettingView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Khác',
            style: GetTextStyle.getTextStyle(
                25, 'Roboto', FontWeight.w600, ColorsManager.backgroundWhite),
          ),
        ),
        backgroundColor: ColorsManager.primary,
      ),
      body: Container(
        padding:
            UtilsReponsive.paddingOnly(context, left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: UtilsReponsive.width(context, 150),
                    height: UtilsReponsive.height(context, 150),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg",
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //     bottom: 0,
                  //     right: 0,
                  //     child: Container(
                  //       height: 40,
                  //       width: 40,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: Border.all(
                  //           width: 4,
                  //           color: Theme.of(context).scaffoldBackgroundColor,
                  //         ),
                  //         color: Colors.green,
                  //       ),
                  //       child: Icon(
                  //         Icons.edit,
                  //         color: Colors.white,
                  //       ),
                  //     )),
                ],
              ),
            ),
            SizedBox(
              height: UtilsReponsive.height(context, 10),
            ),
            Center(
              child: Text(
                'Ngo Xuan Thiep',
                style: GetTextStyle.getTextStyle(
                    17, 'Roboto', FontWeight.w600, ColorsManager.textColor),
              ),
            ),
            Center(
              child: Text(
                'ngothiep@gmail.com',
                style: GetTextStyle.getTextStyle(
                    16, 'Roboto', FontWeight.w500, ColorsManager.textColor2),
              ),
            ),
            SizedBox(
              height: UtilsReponsive.height(context, 30),
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: ColorsManager.primary,
                ),
                SizedBox(
                  width: UtilsReponsive.width(context, 8),
                ),
                Text(
                  "Tài khoản",
                  style: GetTextStyle.getTextStyle(
                      20, 'Roboto', FontWeight.w700, ColorsManager.primary),
                ),
              ],
            ),
            Divider(
              height: UtilsReponsive.height(context, 20),
              thickness: 2,
            ),
            buildAccountOptionRow(
                context, "Thay đổi thông tin", Routes.PROFILE),
            buildAccountOptionRow(context, "Đơn vị công tác", Routes.PROFILE),
            buildAccountOptionRow(
                context, "Thay đổi mật khẩu", Routes.PROFILE),
            buildAccountOptionRow(
                context, "Quyền riêng tư và bảo mật", Routes.PROFILE),
            SizedBox(
              height: UtilsReponsive.height(context, 40),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      UtilsReponsive.paddingHorizontal(context, padding: 40),
                  child: OutlinedButton(
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.clear();
                      GetStorage().remove('user');
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: Text(
                      "Đăng xuất",
                      style: GetTextStyle.getTextStyle(
                          20, 'Roboto', FontWeight.w700, ColorsManager.primary),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow(
      BuildContext context, String title, String routeName) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GetTextStyle.getTextStyle(
                  18, 'Roboto', FontWeight.w600, Colors.grey[600]!),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
