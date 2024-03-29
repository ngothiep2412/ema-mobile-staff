import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/budget_detail/model/budget_item_model.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/transaction_detail_controller.dart';

class TransactionDetailView extends BaseView<TransactionDetailController> {
  const TransactionDetailView({Key? key}) : super(key: key);
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
                              'Thông tin giao dịch chi tiết',
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
                                    _statusBuilder(
                                        context: context,
                                        objectStatusTask: controller.transactionView.value.status == 'PENDING'
                                            ? 'Chờ duyệt'
                                            : controller.transactionView.value.status! == 'ACCEPTED'
                                                ? 'Chấp nhận'
                                                : controller.transactionView.value.status! == 'REJECTED'
                                                    ? 'Từ chối'
                                                    : 'Thành công',
                                        taskID: controller.transactionID),
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
                                      height: UtilsReponsive.heightv2(context, 10),
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
                                    controller.transactionView.value.status == 'ACCEPTED' || controller.transactionView.value.status == 'SUCCESS'
                                        ? Text(
                                            'Tài liệu và hóa đơn chứng từ',
                                            style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: UtilsReponsive.heightv2(context, 30),
                                    ),
                                    controller.transactionView.value.status == 'ACCEPTED' || controller.transactionView.value.status == 'SUCCESS'
                                        ? _documentV2(context)
                                        : const SizedBox(),
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

  StatefulBuilder _documentV2(BuildContext context) {
    return StatefulBuilder(builder: (context, setStateX) {
      return Obx(
        () => Container(
            // height: controller.listAttachment.isEmpty
            //     ? 50
            //     : UtilsReponsive.height(200, context),
            // padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.listAttachmentEvidence.isEmpty ? 'Chưa có tài liệu' : 'Đang có',
                            style: TextStyle(color: ColorsManager.primary, fontSize: UtilsReponsive.height(15, context), fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: UtilsReponsive.width(10, context),
                          ),
                          controller.listAttachmentEvidence.isNotEmpty
                              ? CircleAvatar(
                                  radius: controller.listAttachmentEvidence.length >= 100
                                      ? 15
                                      : controller.listAttachmentEvidence.length >= 10
                                          ? 15
                                          : 10,
                                  child: Text(
                                    controller.listAttachmentEvidence.length.toString(),
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        color: ColorsManager.backgroundWhite,
                                        fontSize: UtilsReponsive.height(15, context),
                                        fontWeight: FontWeight.w800),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(20, context),
                    ),
                  ],
                ),
                children: [
                  controller.listAttachmentEvidence.isEmpty
                      ? Container(
                          padding: EdgeInsets.only(
                              left: UtilsReponsive.height(20, context),
                              right: UtilsReponsive.height(15, context),
                              bottom: UtilsReponsive.height(10, context)),
                          // height: UtilsReponsive.height(120, context),
                          child: Column(
                            children: [
                              SizedBox(
                                height: UtilsReponsive.height(20, context),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: UtilsReponsive.height(15, context),
                                  right: UtilsReponsive.height(15, context),
                                  bottom: UtilsReponsive.height(10, context)),
                              height: UtilsReponsive.height(80, context),
                              width: UtilsReponsive.width(300, context),
                              child: ListView.separated(
                                primary: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.listAttachmentEvidence.length,
                                separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(10, context)),
                                itemBuilder: (context, index) {
                                  return _files(controller.listAttachmentEvidence[index], index, context);
                                },
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            )),
      );
    });
  }

  Widget _statusBuilder({required BuildContext context, required String objectStatusTask, required String taskID}) {
    return GestureDetector(
      onTap: () {
        if (controller.transactionView.value.status == 'PENDING') {
          _showBottomSheetStatus(context, taskID);
        } else if (controller.transactionView.value.status == 'ACCEPTED') {
          _showBottomSheetStatusSucess(context, taskID);
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
        padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.width(10, context), vertical: UtilsReponsive.width(5, context)),
        decoration: BoxDecoration(
          color: controller.transactionView.value.status == 'PENDING'
              ? ColorsManager.orange
              : controller.transactionView.value.status! == 'ACCEPTED'
                  ? ColorsManager.green
                  : controller.transactionView.value.status! == 'REJECTED'
                      ? ColorsManager.red
                      : ColorsManager.blue,
          borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              objectStatusTask,
              style: TextStyle(letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(14, context), fontWeight: FontWeight.w800),
            ),
            controller.transactionView.value.status! != 'SUCCESS' && controller.transactionView.value.status! != 'REJECTED'
                ? Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.white,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetStatus(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundContainer,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          // "Đang chuẩn bị",
          "Chấp nhận",
          "Từ chối",
          // "Quá hạn",
        ]
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    if (e == "Chấp nhận") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Xác nhận",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            content: const Text(
                              "Bạn có muốn đổi trạng thái giao dịch này là chấp nhận",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context, rootNavigator: true).pop();
                                  await controller.updateStatusTransaction("ACCEPTED", '');
                                  // await controller.updateStatusTask("DONE", taskID, false);
                                },
                                child: Text(
                                  "Có",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (e == "Từ chối") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Xác nhận",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            content: const Text(
                              "Bạn có muốn đổi trạng thái giao dịch này là từ chối",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context, rootNavigator: true).pop();

                                  String text = ''; // Chuỗi lý do được nhập
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text(
                                        'Nhập lý do',
                                        style: TextStyle(
                                            fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                                      ),
                                      content: TextFormField(
                                        minLines: 4, // Số dòng tối thiểu
                                        maxLines: null, // Số dòng tối đa (null để cho phép nhập nhiều dòng)
                                        keyboardType: TextInputType.multiline,
                                        decoration: const InputDecoration(
                                          hintText: 'Nhập lý do ở đây...',
                                          border: OutlineInputBorder(), // Thêm đường viền nếu cần
                                        ),
                                        onChanged: (value) {
                                          text = value;
                                        },
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'Hủy',
                                            style:
                                                TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Get.back(result: text);
                                            await controller.updateStatusTransaction("REJECTED", text);
                                          },
                                          child: Text(
                                            'Xác nhận',
                                            style: TextStyle(
                                                fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  // await controller.updateStatusTask("DONE", taskID, false);
                                },
                                child: Text(
                                  "Có",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: e == "Chấp nhận" ? ColorsManager.green : ColorsManager.red,
                        child: Text(e[0],
                            style: TextStyle(
                                letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(16, context), fontWeight: FontWeight.w800)),
                      ),
                      title: Text(
                        e,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            letterSpacing: 1,
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(16, context),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }

  void _showBottomSheetStatusSucess(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundContainer,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          // "Đang chuẩn bị",
          "Thành công",
          // "Quá hạn",
        ]
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Xác nhận",
                            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                          ),
                          content: const Text(
                            "Bạn có muốn đổi trạng thái giao dịch này là thành công",
                            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng hộp thoại
                              },
                              child: Text(
                                "Hủy",
                                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context, rootNavigator: true).pop();
                                if (controller.listAttachmentEvidence.isEmpty) {
                                  Get.snackbar('Lỗi', 'Giao dịch này chưa cập nhật tài liệu và hóa đơn',
                                      snackPosition: SnackPosition.TOP, backgroundColor: Colors.white, colorText: Colors.black);
                                } else {
                                  await controller.updateStatusTransaction("SUCCESS", '');
                                }
                                // await controller.updateStatusTask("DONE", taskID, false);
                              },
                              child: Text(
                                "Có",
                                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(e[0],
                            style: TextStyle(
                                letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(16, context), fontWeight: FontWeight.w800)),
                      ),
                      title: Text(
                        e,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            letterSpacing: 1,
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(16, context),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
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
                  'Thay đổi thông tin thu chi thành công',
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
                      controller.errorUpdateBudgetText.value,
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

  InkWell _files(Evidence evidenceFile, int index, BuildContext context) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(evidenceFile.evidenceUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorsManager.backgroundGrey,
        ),
        // width: UtilsReponsive.width(110, context),
        padding: UtilsReponsive.paddingOnly(
          context,
          top: 10,
          left: 10,
          bottom: 5,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(evidenceFile.evidenceFileName!, style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary)),
          ],
        ),
      ),
    );
    //   CachedNetworkImage(
    //     imageUrl: evidenceFile.evidenceUrl!,
    //     imageBuilder: (context, imageProvider) => Container(
    //         width: UtilsReponsive.width(120, context),
    //         // height: UtilsReponsive.height(120, context),
    //         padding: UtilsReponsive.paddingAll(context, padding: 5),
    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
    //     progressIndicatorBuilder: (context, url, downloadProgress) => Container(
    //       padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
    //       height: UtilsReponsive.height(5, context),
    //       width: UtilsReponsive.height(5, context),
    //       child: CircularProgressIndicator(
    //         color: ColorsManager.primary,
    //       ),
    //     ),
    //     errorWidget: (context, url, error) => Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         color: ColorsManager.backgroundGrey,
    //       ),
    //       width: UtilsReponsive.width(110, context),
    //       padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
    //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //         Expanded(
    //           flex: 2,
    //           // child: Text('hiii'),
    //           child: evidenceFile.evidenceFileName!.length > 35
    //               ? Text(
    //                   evidenceFile.evidenceFileName!.length > 35
    //                       ? '${evidenceFile.evidenceFileName!.substring(0, 35)}...'
    //                       : evidenceFile.evidenceFileName!,
    //                   style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
    //                 )
    //               : Text(
    //                   evidenceFile.evidenceFileName!,
    //                   style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
    //                 ),
    //         ),
    //         // const Expanded(
    //         //   child: Column(
    //         //     mainAxisAlignment: MainAxisAlignment.end,
    //         //     children: [
    //         //       Text(
    //         //         'Kích thước',
    //         //         style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
    //         //       ),
    //         //     ],
    //         //   ),
    //         // ),
    //       ]),
    //     ),
    //   ),
    // );
  }
}
