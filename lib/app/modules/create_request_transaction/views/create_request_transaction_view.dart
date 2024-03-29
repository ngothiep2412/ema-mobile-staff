import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/dev_utils.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';

import '../controllers/create_request_transaction_controller.dart';

class CreateRequestTransactionView extends BaseView<CreateRequestTransactionController> {
  const CreateRequestTransactionView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: UtilsReponsive.paddingHorizontal(context, padding: 20),
              child: ListView(
                children: [
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 15),
                  ),
                  Center(
                    child: Text(
                      'Yêu cầu thêm ngân sách công việc',
                      style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 30),
                  ),
                  Text(
                    'Tên chi phí yêu cầu',
                    style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Tên chi phí yêu cầu", "Ví dụ: Tiền thuê mic", controller.transactionNameController),
                  Text(
                    'Chi phí dự kiến (VNĐ)',
                    style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildWidgetmoney(context, "Chi phí dự kiến", "Ví dụ: 100.000", controller.estExpenseController),
                  Text(
                    'Mô tả yêu cầu chi phí',
                    style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextarea(context, "Mô tả yêu cầu chi phí", "Ví dụ: Loại nhỏ", controller.descriptionController),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 20),
                  ),
                  Obx(
                    () => SizedBox(
                      height: UtilsReponsive.heightv2(context, 60),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.createBudget();
                          controller.errorCreateBudget.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), // Đặt border radius theo mong muốn
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorsManager.backgroundWhite,
                                ),
                              )
                            : Text(
                                "Tạo đơn",
                                style: GetTextStyle.getTextStyle(
                                  14,
                                  'Nunito',
                                  FontWeight.w800,
                                  ColorsManager.backgroundWhite,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  )
                ],
              ),
            ),
          ),
        ]),
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
      padding: UtilsReponsive.paddingOnly(context, bottom: 10),
      child: TextField(
        controller: nameTextEditingController,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          // labelText: labelText,
          // labelStyle: TextStyle(color: ColorsManager.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  Widget buildWidgetmoney(
    BuildContext context,
    String labelText,
    String hintText,
    TextEditingController? nameTextEditingController,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: nameTextEditingController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          CurrencyInputFormatter(),
        ],
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          // labelText: labelText,
          // labelStyle: TextStyle(color: ColorsManager.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  Widget buildTextarea(
    BuildContext context,
    String labelText,
    String hintText,
    TextEditingController? textEditingController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: textEditingController,
        maxLines: null,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          // labelText: labelText,
          // labelStyle: TextStyle(color: ColorsManager.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  _successMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          height: UtilsReponsive.heightv2(context, 80),
          decoration: const BoxDecoration(color: Color.fromARGB(255, 81, 146, 83), borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Tạo đơn thành công',
                  style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w500, Colors.white),
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
          decoration: const BoxDecoration(color: Color.fromARGB(255, 219, 90, 90), borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.errorCreateBudgetText.value,
                      style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w500, Colors.white),
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
