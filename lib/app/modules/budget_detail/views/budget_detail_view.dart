import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/budget_detail/model/budget_item_model.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import '../controllers/budget_detail_controller.dart';

class BudgetDetailView extends BaseView<BudgetDetailController> {
  const BudgetDetailView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.9),
      body: Obx(
        () => SafeArea(
          child: controller.checkView.value == false
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: ColorsManager.backgroundWhite,
                            )),
                        SizedBox(
                          width: UtilsReponsive.width(5, context),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              // Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                            },
                            child: Text(
                              controller.nameItem.value,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: ColorsManager.backgroundWhite, fontSize: UtilsReponsive.height(20, context), fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.only(top: controller.taskView.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                        color: Colors.white,
                        child: (Center(
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
                        )),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: ColorsManager.backgroundWhite,
                                  )),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () {
                                    // Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                                  },
                                  child: Text(
                                    controller.nameItem.value,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ColorsManager.backgroundWhite,
                                        fontSize: UtilsReponsive.height(20, context),
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),

                              // IconButton(
                              //     onPressed: () {
                              //       Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                              //     },
                              //     icon: Icon(
                              //       Icons.info_rounded,
                              //       color: ColorsManager.orange,
                              //       size: 35,
                              //     )),
                              // CircleAvatar(
                              //   backgroundColor: ColorsManager.backgroundWhite,
                              //   radius: UtilsReponsive.height(20, context),
                              //   child: IconButton(
                              //       onPressed: () {
                              //         Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                              //       },
                              //       icon: Icon(
                              //         Icons.request_page_rounded,
                              //         color: ColorsManager.green,
                              //       )),
                              // )
                            ],
                          ),
                          // SizedBox(
                          //   height: UtilsReponsive.height(20, context),
                          // ),
                        ],
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      // IconButton(
                      //     onPressed: () {
                      //       Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                      //     },
                      //     icon: Icon(
                      //       Icons.request_page_rounded,
                      //       color: ColorsManager.green,
                      //     )),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.REQUEST_TRANSACTION, arguments: {"taskID": controller.taskID, "statusTask": controller.statusTask});
                        },
                        child: Container(
                          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              UtilsReponsive.height(10, context),
                            ),
                            color: Colors.blueGrey,
                          ),
                          child: Text(
                            'Quản lí yêu cầu',
                            style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                    ]),

                    SizedBox(
                      height: UtilsReponsive.height(30, context),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => controller.isLoading.value == true
                            ? Center(
                                child: SpinKitFadingCircle(
                                  color: ColorsManager.blue,
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: UtilsReponsive.height(20, context),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${controller.formatCurrency(controller.budgetItemModel.value.totalTransactionUsed!)} VNĐ',
                                        style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                                      ),
                                      Text(
                                        '${controller.formatCurrency((controller.budgetItemModel.value.itemExisted!.plannedAmount! * controller.budgetItemModel.value.itemExisted!.plannedPrice! * ((controller.budgetItemModel.value.itemExisted!.percentage!) / 100)).toInt().ceil())} VNĐ',
                                        style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: UtilsReponsive.height(20, context),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          backgroundColor: ColorsManager.grey,
                                          value: controller.progress.value,
                                          color: ColorsManager.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: UtilsReponsive.height(20, context),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Số tiền tiêu dụng',
                                        style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                      ),
                                      Text(
                                        'Tổng tiền được giao',
                                        style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                    // SizedBox(
                    //   height: UtilsReponsive.height(20, context),
                    // ),
                    Obx(
                      () => controller.isLoading.value == true
                          ? Expanded(
                              flex: 4,
                              child: Container(
                                padding: EdgeInsets.only(top: controller.taskView!.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.only(
                                  //   topLeft: Radius.circular(UtilsReponsive.height(20, context)),
                                  //   topRight: Radius.circular(UtilsReponsive.height(20, context)),
                                  // ),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: SpinKitFadingCircle(
                                    color: ColorsManager.blue,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              flex: 4,
                              child: controller.taskView.isEmpty
                                  ? Container(
                                      padding: EdgeInsets.only(top: controller.taskView!.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.only(
                                        //   topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                        //   topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                        // ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: UtilsReponsive.height(200, context),
                                            child: Image.asset(
                                              ImageAssets.noTask,
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'Chưa có task trong hạng mục này',
                                              style: GetTextStyle.getTextStyle(17, 'Nunito', FontWeight.w800, Colors.blueAccent),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Obx(
                                      () => Container(
                                        padding: EdgeInsets.only(top: controller.taskView!.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                          //   topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                          // ),
                                          color: Colors.white,
                                        ),
                                        child: RefreshIndicator(
                                          onRefresh: controller.refreshPage,
                                          child: ListView.separated(
                                              padding: UtilsReponsive.paddingAll(context, padding: 15),
                                              itemBuilder: (context, index) => _taskCommon(context, controller.taskView![index], index),
                                              separatorBuilder: (context, index) => SizedBox(
                                                    height: UtilsReponsive.height(15, context),
                                                  ),
                                              itemCount: controller.taskView!.length),
                                        ),
                                      ),
                                    )),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Container _taskCommon(BuildContext context, Task task, int index) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4), // Màu của shadow và độ mờ
          spreadRadius: 1, // Độ lan rộng của shadow
          blurRadius: 3, // Độ mờ của shadow
          offset: const Offset(0, 1), // Độ dịch chuyển của shadow
        ),
      ]),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // controller.getTaskDetail(transaction.id!);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: UtilsReponsive.height(15, context),
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: UtilsReponsive.height(30, context),
                  ),
                ),
              ),
              SizedBox(
                width: UtilsReponsive.width(10, context),
              ),
              Expanded(
                child: Text(
                  task.title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      color: ColorsManager.textColor,
                      fontSize: UtilsReponsive.height(20, context),
                      fontWeight: FontWeight.w800),
                ),
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: UtilsReponsive.height(12, context),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Số giao dịch: ',
                      style: TextStyle(
                        color: Colors.grey, // Đặt màu xám cho văn bản này
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: '${task.transactions!.length}', // Sử dụng giá trị của transactions.length
                      style: TextStyle(
                        color: Colors.blue, // Đặt màu xanh cho văn bản này
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(12, context),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ngân sách (VNĐ): ',
                      style: TextStyle(
                        color: Colors.grey, // Đặt màu xám cho văn bản này
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: '${controller.formatCurrency(task.totalPriceTransaction!)} ', // Sử dụng giá trị của transactions.length
                      style: TextStyle(
                        color: Colors.blue, // Đặt màu xanh cho văn bản này
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(12, context),
              ),
              Row(children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: task.status! == 'PENDING'
                          ? ColorsManager.grey.withOpacity(0.7)
                          : task.status! == 'PROCESSING'
                              ? ColorsManager.blue.withOpacity(0.7)
                              : task.status! == 'OVERDUE'
                                  ? ColorsManager.red.withOpacity(0.7)
                                  : task.status! == 'DONE'
                                      ? ColorsManager.green.withOpacity(0.7)
                                      : ColorsManager.purple.withOpacity(0.7),
                      radius: UtilsReponsive.height(13, context),
                    ),
                    SizedBox(
                      width: UtilsReponsive.width(15, context),
                    ),
                    Text(
                        task.status! == 'PENDING'
                            ? "Đang chuẩn bị"
                            : task.status! == 'PROCESSING'
                                ? "Đang thực hiện"
                                : task.status! == 'DONE'
                                    ? "Hoàn thành"
                                    : task.status == 'OVERDUE'
                                        ? 'Quá hạn'
                                        : "Đã xác thực",
                        style: GetTextStyle.getTextStyle(
                          16,
                          'Nunito',
                          FontWeight.w600,
                          task.status! == 'PENDING'
                              ? ColorsManager.grey
                              : task.status! == 'PROCESSING'
                                  ? ColorsManager.blue
                                  : task.status! == 'DONE'
                                      ? ColorsManager.green
                                      : task.status! == 'OVERDUE'
                                          ? ColorsManager.red
                                          : ColorsManager.purple,
                        ))
                  ],
                ),
              ]),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
            ],
          ),
          children: task.transactions!.isNotEmpty
              ? () {
                  var transactions = task.transactions!;
                  transactions.sort((a, b) {
                    if (a.createdAt == null && b.createdAt == null) {
                      return 0;
                    }
                    if (a.createdAt == null) {
                      return 1;
                    }
                    if (b.createdAt == null) {
                      return -1;
                    }
                    return b.createdAt!.compareTo(a.createdAt!);
                  });

                  return task.transactions!.asMap().entries.map((entry) {
                    return _itemTask(context: context, transaction: entry.value, index: index);
                  }).toList();
                }()
              : [],
        ),
      ),
    );
  }

  Widget _itemTask({
    required BuildContext context,
    required Transaction transaction,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.TRANSACTION_DETAIL, arguments: {"transactionID": transaction.id!, "isNotiNavigate": false});
      },
      child: Padding(
        padding: UtilsReponsive.paddingAll(context, padding: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: ColorsManager.grey,
              blurRadius: 2,
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: UtilsReponsive.heightv2(context, 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(UtilsReponsive.height(5, context)), topRight: Radius.circular(UtilsReponsive.height(5, context))),
                  boxShadow: [
                    BoxShadow(
                      color: transaction.status! == 'PENDING'
                          ? ColorsManager.orange
                          : transaction.status! == 'ACCEPTED'
                              ? ColorsManager.green
                              : transaction.status! == 'REJECTED'
                                  ? ColorsManager.red
                                  : ColorsManager.blue,
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                    ),
                  ],
                  color: transaction.status! == 'PENDING'
                      ? ColorsManager.orange
                      : transaction.status! == 'ACCEPTED'
                          ? ColorsManager.green
                          : transaction.status! == 'REJECTED'
                              ? ColorsManager.red
                              : ColorsManager.blue,
                ),
                child: Center(
                    child: Text(
                        transaction.status! == 'PENDING'
                            ? 'Chờ duyệt'
                            : transaction.status! == 'ACCEPTED'
                                ? 'Chấp nhận'
                                : transaction.status! == 'REJECTED'
                                    ? 'Từ chối'
                                    : 'Thành công',
                        style: TextStyle(
                            letterSpacing: 1.2,
                            fontFamily: 'Nunito',
                            color: Colors.white,
                            fontSize: UtilsReponsive.heightv2(context, 14),
                            fontWeight: FontWeight.w700))),
              ),
              SizedBox(
                height: UtilsReponsive.height(15, context),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.transactionName!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: ColorsManager.textColor,
                                fontSize: UtilsReponsive.height(16, context),
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(5, context),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Ngân sách (VNĐ): ',
                                  style: TextStyle(
                                    color: Colors.grey, // Đặt màu xám cho văn bản này
                                    fontSize: 12,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: '${controller.formatCurrency(transaction.amount!)} ', // Sử dụng giá trị của transactions.length
                                  style: TextStyle(
                                    color: Colors.blue, // Đặt màu xanh cho văn bản này
                                    fontSize: 12,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(15, context),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: transaction.status! == 'PENDING'
                                    ? ColorsManager.orange
                                    : transaction.status! == 'ACCEPTED'
                                        ? ColorsManager.green
                                        : transaction.status! == 'REJECTED'
                                            ? ColorsManager.red
                                            : ColorsManager.blue,
                                size: 16,
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                controller.dateFormat.format(transaction.createdAt!.toLocal()),
                                style: GetTextStyle.getTextStyle(
                                  12,
                                  'Nunito',
                                  FontWeight.w700,
                                  transaction.status! == 'PENDING'
                                      ? ColorsManager.orange
                                      : transaction.status! == 'ACCEPTED'
                                          ? ColorsManager.green
                                          : transaction.status! == 'REJECTED'
                                              ? ColorsManager.red
                                              : ColorsManager.blue,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(5, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
