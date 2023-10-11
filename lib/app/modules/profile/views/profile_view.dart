import 'package:flutter/material.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends BaseView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.primary,
        elevation: 0,
      ),
      body: Container(
        padding:
            UtilsReponsive.paddingOnly(context, left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Edit Profile",
              style: GetTextStyle.getTextStyle(
                  22, 'Roboto', FontWeight.w700, ColorsManager.textColor),
            ),
            SizedBox(
              height: UtilsReponsive.height(context, 15),
            ),
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
                              "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                            ))),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: UtilsReponsive.height(context, 50),
                        width: UtilsReponsive.width(context, 50),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: ColorsManager.primary,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: UtilsReponsive.height(context, 35),
            ),
            buildTextField(context, "Họ và tên", "Ví dụ: Thiệp", false,
                controller.firstNameController),
            buildTextField(context, "E-mail", "Ví dụ: hrea@gmail.com", false,
                controller.firstNameController),
            buildTextField(
                context,
                "Địa chỉ",
                "Ví dụ: thành Phố Hồ Chí Minh",
                false,
                controller.firstNameController),
            SizedBox(
              height: UtilsReponsive.height(context, 35),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Đặt border radius theo mong muốn
                ),
              ),
              child: Text(
                "SAVE",
                style: GetTextStyle.getTextStyle(
                  14,
                  'Roboto',
                  FontWeight.w800,
                  ColorsManager.backgroundWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    BuildContext context,
    String labelText,
    String hintText,
    bool isPasswordTextField,
    TextEditingController? nameTextEditingController,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 30),
      child: TextField(
        controller: nameTextEditingController,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(
              14, 'Roboto', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  // Widget buildTextField(
  //   BuildContext context,
  //   String labelText,
  //   bool isPasswordTextField,
  //   TextEditingController? nameTextEditingController,
  // ) {
  //   return Padding(
  //     padding: UtilsReponsive.paddingOnly(context, bottom: 35),
  //     child: TextField(
  //       controller: nameTextEditingController,
  //       decoration: InputDecoration(
  //         contentPadding: UtilsReponsive.paddingOnly(context, bottom: 3),
  //         labelText: labelText,
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         hintText: labelText,
  //         hintStyle: GetTextStyle.getTextStyle(
  //             14, 'Roboto', FontWeight.w400, ColorsManager.textColor2),
  //       ),
  //     ),
  //   );
  // }
}
