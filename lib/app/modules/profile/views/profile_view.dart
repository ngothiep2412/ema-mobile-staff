import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
              "Thay đổi thông tin",
              style: GetTextStyle.getTextStyle(
                  22, 'Roboto', FontWeight.w700, ColorsManager.textColor),
            ),
            SizedBox(
              height: UtilsReponsive.heightv2(context, 15),
            ),
            Center(
              child: Stack(
                children: [
                  Obx(() => CircleAvatar(
                        backgroundColor:
                            ColorsManager.primary, // Màu nền mà bạn muốn
                        radius:
                            60, // Điều chỉnh kích thước hình tròn theo ý muốn
                        child: controller.selectImagePath.value.isEmpty
                            ? controller.imageUrl.value.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      'https://img.freepik.com/premium-photo/cartoon-esports-logo-gaming-brand_902820-461.jpg',
                                      fit: BoxFit.cover,
                                      width: UtilsReponsive.widthv2(context,
                                          120), // Kích thước của hình ảnh
                                      height:
                                          UtilsReponsive.heightv2(context, 145),
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      ImageAssets.defaultAvatar,
                                      fit: BoxFit.cover,
                                      width: UtilsReponsive.widthv2(context,
                                          120), // Kích thước của hình ảnh
                                      height:
                                          UtilsReponsive.heightv2(context, 145),
                                    ),
                                  )
                            : ClipOval(
                                child: Image.file(
                                  File(controller.selectImagePath.value),
                                  fit: BoxFit.cover,
                                  width: UtilsReponsive.widthv2(
                                      context, 120), // Kích thước của hình ảnh
                                  height: UtilsReponsive.heightv2(context, 145),
                                ),
                              ),
                      )),
                  Positioned(
                      bottom: 0,
                      right: -5,
                      child: Container(
                        height: UtilsReponsive.heightv2(context, 50),
                        width: UtilsReponsive.widthv2(context, 50),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: ColorsManager.primary,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showAlertDialog(context);
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: UtilsReponsive.heightv2(context, 35),
            ),
            buildTextField(context, "Họ và tên", "Ví dụ: Thiệp",
                controller.fullNameController),
            // buildTextField(context, "E-mail", "Ví dụ: hrea@gmail.com",
            //     controller.emailController),
            buildTextField(
                context,
                "Địa chỉ",
                "Ví dụ: thành Phố Hồ Chí Minh",
                controller.addressController),
            buildTextFieldDate(
              context,
              "Ngày sinh",
              "Ví dụ: 2001/24/12",
            ),
            buildTextField(context, "Số điện thoại", "Ví dụ: 0905952718",
                controller.phoneController),

            DropdownButtonFormField(
              items: controller.genderList
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                controller.setGender(value as String);
              },
              value: controller.selectedGenderVal == "MALE" ? "Nam" : "Nữ",
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: ColorsManager.primary,
              ),
              decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  errorBorder: InputBorder.none,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  fillColor: ColorsManager.textInput,
                  filled: true),
            ),
            SizedBox(
              height: UtilsReponsive.heightv2(context, 20),
            ),
            Container(
              height: UtilsReponsive.heightv2(context, 40),
              child: ElevatedButton(
                onPressed: () {
                  controller.updateProfile();
                  print('${controller.errorUpdateProfile}');
                  controller.errorUpdateProfile.value
                      ? _errorMessage(context)
                      : _successMessage(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5.0), // Đặt border radius theo mong muốn
                  ),
                ),
                child: controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.primary,
                        ),
                      )
                    : Text(
                        "Cập nhật",
                        style: GetTextStyle.getTextStyle(
                          14,
                          'Roboto',
                          FontWeight.w800,
                          ColorsManager.backgroundWhite,
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 10,
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

  Widget buildTextFieldDate(
    BuildContext context,
    String labelText,
    String hintText,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 30),
      child: TextField(
        controller: controller.dateController,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              controller.chooseDate();
            },
            icon: Icon(
              Icons.calendar_today_rounded,
              color: Colors.grey[600]!,
            ),
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

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          controller.selectImage(ImageSource.gallery);
        },
        child: const Text('Gallery'));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          controller.selectImage(ImageSource.camera);
        },
        child: const Text('Camera'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Select option'),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _successMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          height: UtilsReponsive.heightv2(context, 80),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 81, 146, 83),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            const Icon(
              Icons.check_circle,
              color: ColorsManager.backgroundWhite,
              size: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thành công',
                  style: GetTextStyle.getTextStyle(
                      18, 'Roboto', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Thay đổi thông tin cá nhân thành công',
                  style: GetTextStyle.getTextStyle(
                      12, 'Roboto', FontWeight.w500, Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ))
          ]),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
    );
  }

  _errorMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          height: UtilsReponsive.heightv2(context, 80),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 219, 90, 90),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            const Icon(
              Icons.error_outline,
              color: ColorsManager.backgroundWhite,
              size: 40,
            ),
            SizedBox(
              width: UtilsReponsive.widthv2(context, 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thất bại',
                    style: GetTextStyle.getTextStyle(
                        18, 'Roboto', FontWeight.w800, Colors.white),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.errorUpdateProfileText.value,
                      style: GetTextStyle.getTextStyle(
                          12, 'Roboto', FontWeight.w500, Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
    );
  }
}
