import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';

import '../controllers/detail_request_transaction_controller.dart';

class DetailRequestTransactionView extends BaseView<DetailRequestTransactionController> {
  const DetailRequestTransactionView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        backgroundColor: ColorsManager.backgroundContainer,
        body: SafeArea(
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
                  : controller.checkView.value == false
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageAssets.noInternet,
                                fit: BoxFit.cover,
                                width: UtilsReponsive.widthv2(context, 200),
                                height: UtilsReponsive.heightv2(context, 200),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(20, context),
                              ),
                              Text(
                                'Đang có lỗi xảy ra',
                                style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                              ),
                            ],
                          ),
                        )
                      : Column(children: [
                          Center(
                            child: Text(
                              'Thông tin yêu cầu chi tiết',
                              style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w800, ColorsManager.primary),
                            ),
                          ),
                          SizedBox(
                            height: UtilsReponsive.heightv2(context, 5),
                          ),
                          Expanded(
                            child: Padding(
                              padding: UtilsReponsive.paddingHorizontal(context, padding: 5),
                              child: RefreshIndicator(
                                onRefresh: controller.refreshPage,
                                child: ListView(
                                  children: [
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 15),
                                    ),
                                    Text(
                                      'Trạng thái',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 10),
                                    ),
                                    Container(
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          UtilsReponsive.height(10, context),
                                        ),
                                      ),
                                      child: Text(
                                        controller.transactionView.value.status! == "REJECTED" ? "Từ chối" : "Chấp nhận",
                                        style: GetTextStyle.getTextStyle(
                                            14,
                                            'Nunito',
                                            FontWeight.w700,
                                            controller.transactionView.value.status! == "REJECTED"
                                                ? ColorsManager.red
                                                : controller.transactionView.value.status! == "ACCEPTED"
                                                    ? ColorsManager.green
                                                    : controller.transactionView.value.status! == "PENDING"
                                                        ? ColorsManager.grey
                                                        : ColorsManager.purple),
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 15),
                                    ),
                                    Text(
                                      'Mã giao dịch',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 10),
                                    ),
                                    Container(
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          UtilsReponsive.height(10, context),
                                        ),
                                      ),
                                      child: Text(
                                        controller.transactionView.value.transactionCode!,
                                        style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 20),
                                    ),
                                    Text(
                                      'Tên giao dịch',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 10),
                                    ),
                                    Container(
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          UtilsReponsive.height(10, context),
                                        ),
                                      ),
                                      child: Text(
                                        controller.transactionView.value.transactionName!,
                                        style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 20),
                                    ),
                                    Text(
                                      'Chi phí (VNĐ)',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 10),
                                    ),
                                    Container(
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          UtilsReponsive.height(10, context),
                                        ),
                                      ),
                                      child: Text(
                                        controller.formatCurrency(controller.transactionView.value.amount!),
                                        style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 20),
                                    ),
                                    Text(
                                      'Ngày tạo',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 10),
                                    ),
                                    Container(
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          UtilsReponsive.height(10, context),
                                        ),
                                      ),
                                      child: Text(
                                        controller.dateFormat.format(controller.transactionView.value.createdAt!.toLocal()),
                                        style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 20),
                                    ),
                                    Text(
                                      'Mô tả',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 10),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(minHeight: UtilsReponsive.width(150, context)),
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          UtilsReponsive.height(10, context),
                                        ),
                                      ),
                                      child: Text(
                                        controller.transactionView.value.description!,
                                        style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                      ),
                                    ),
                                    controller.transactionView.value.status! == "REJECTED"
                                        ? SizedBox(
                                            height: UtilsReponsive.heightv2(context, 20),
                                          )
                                        : SizedBox(),
                                    controller.transactionView.value.status! == "REJECTED"
                                        ? Text(
                                            'Lí do từ chối',
                                            style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.red),
                                          )
                                        : SizedBox(),
                                    controller.transactionView.value.status! == "REJECTED"
                                        ? SizedBox(
                                            height: UtilsReponsive.heightv2(context, 10),
                                          )
                                        : SizedBox(),
                                    controller.transactionView.value.status! == "REJECTED"
                                        ? Container(
                                            constraints: BoxConstraints(minHeight: UtilsReponsive.width(150, context)),
                                            padding: UtilsReponsive.paddingAll(context, padding: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                UtilsReponsive.height(10, context),
                                              ),
                                            ),
                                            child: Text(
                                              controller.transactionView.value.rejectNote!,
                                              style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
            ),
          ),
        ));
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
        actions: const []);
  }
}
