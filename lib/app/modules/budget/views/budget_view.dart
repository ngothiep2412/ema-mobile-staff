import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/item_model.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import '../controllers/budget_controller.dart';

class BudgetView extends BaseView<BudgetController> {
  const BudgetView({Key? key}) : super(key: key);
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
                            child: Text(
                              'Ngân sách công việc',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: ColorsManager.backgroundWhite, fontSize: UtilsReponsive.height(20, context), fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.only(top: controller.itemModelList.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
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
                                  child: Text(
                                    'Ngân sách công việc',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ColorsManager.backgroundWhite,
                                        fontSize: UtilsReponsive.height(22, context),
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(5, context),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(20, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // IconButton(
                                //     onPressed: () {
                                //       Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                                //     },
                                //     icon: Icon(
                                //       Icons.request_page_rounded,
                                //       color: ColorsManager.green,
                                //     )),
                                // GestureDetector(
                                //   onTap: () {
                                //     Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                                //   },
                                //   child: Container(
                                //     padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(
                                //         UtilsReponsive.height(10, context),
                                //       ),
                                //       color: Colors.green,
                                //     ),
                                //     child: Text(
                                //       'Quản lý ngân sách',
                                //       style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  width: UtilsReponsive.width(10, context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(30, context),
                      ),
                      Obx(
                        () => controller.isLoading.value == true
                            ? Expanded(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(top: controller.itemModelList.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                      topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                    ),
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
                                flex: 5,
                                child: controller.itemModelList.isEmpty
                                    ? Container(
                                        padding: EdgeInsets.only(top: controller.itemModelList.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                            topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: UtilsReponsive.height(200, context),
                                              child: Image.asset(
                                                ImageAssets.noBudget,
                                              ),
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(20, context),
                                            ),
                                            Center(
                                              child: Text(
                                                'Chưa có ngân sách',
                                                style: GetTextStyle.getTextStyle(17, 'Nunito', FontWeight.w800, Colors.blueAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Obx(
                                        () => Container(
                                          padding: EdgeInsets.only(top: controller.itemModelList.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                              topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: RefreshIndicator(
                                            onRefresh: controller.refreshPage,
                                            child: ListView.separated(
                                                padding: UtilsReponsive.paddingAll(context, padding: 15),
                                                itemBuilder: (context, index) => _itemCommon(context, controller.itemModelList[index], index),
                                                separatorBuilder: (context, index) => SizedBox(
                                                      height: UtilsReponsive.height(15, context),
                                                    ),
                                                itemCount: controller.itemModelList.length),
                                          ),
                                        ),
                                      )),
                      )
                    ],
                  ),
          ),
        ));
  }

  Container _itemCommon(BuildContext context, ItemModel itemModel, int index) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4), // Màu của shadow và độ mờ
          spreadRadius: 1, // Độ lan rộng của shadow
          blurRadius: 3, // Độ mờ của shadow
          offset: const Offset(0, 1), // Độ dịch chuyển của shadow
        ),
      ]),
      child: GestureDetector(
        onTap: () async {
          // await controller.getTaskDetail(taskModel);
          Get.toNamed(Routes.BUDGET_DETAIL,
              arguments: {"itemID": itemModel.item!.id, "taskID": itemModel.id, "statusTask": itemModel.status == 'CONFIRM' ? true : false});
        },
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                UtilsReponsive.height(10, context),
              ),
            ),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      Expanded(
                        child: Text(
                          itemModel.title!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(20, context),
                            fontWeight: FontWeight.w700,
                            // decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      Row(
                        children: [
                          Text(
                            'Tổng tiền được giao:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(15, context),
                              fontWeight: FontWeight.w800,
                              // decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(
                            width: UtilsReponsive.width(5, context),
                          ),
                          Text(
                            '${controller.formatCurrency((itemModel.item!.plannedAmount! * itemModel.item!.plannedPrice! * ((itemModel.item!.percentage!) / 100)).toInt())} VNĐ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: ColorsManager.primary,
                              fontSize: UtilsReponsive.height(15, context),
                              fontWeight: FontWeight.w800,
                              // decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            )),
      ),
    );
  }
}
