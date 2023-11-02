import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_notification_controller/tab_notification_controller.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/utils/calculate_time_difference.dart';

class TabNotificationView extends BaseView<TabNotificationController> {
  const TabNotificationView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return SafeArea(
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
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            margin:
                                UtilsReponsive.paddingOnly(context, left: 55),
                            child: Text(
                              'Thông báo',
                              style: GetTextStyle.getTextStyle(20, 'Roboto',
                                  FontWeight.w600, ColorsManager.primary),
                            ),
                          ),
                        ),
                      ),
                      // Icon(
                      //   Icons.filter_alt_outlined,
                      //   color: ColorsManager.primary,
                      // ),
                      // SizedBox(
                      //   width: UtilsReponsive.width(10, context),
                      // ),
                      IconButton(
                        onPressed: () {
                          controller.markAllRead();
                        },
                        icon: Icon(
                          Icons.mark_as_unread_rounded,
                          color: ColorsManager.textColor2,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.refreshPage,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                                height: UtilsReponsive.height(20, context),
                              ),
                          shrinkWrap: false,
                          padding: const EdgeInsets.all(8),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: controller.mark.value
                                      ? Colors.white
                                      : Colors.blue.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: UtilsReponsive.paddingAll(context,
                                    padding: 10),
                                child: Row(children: [
                                  Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        radius:
                                            UtilsReponsive.height(25, context),
                                        child: ClipOval(
                                          child: Image.network(
                                            'https://img.freepik.com/premium-photo/cartoon-esports-logo-gaming-brand_902820-461.jpg',
                                            fit: BoxFit.cover,
                                            width: UtilsReponsive.height(50,
                                                context), // Đảm bảo hình ảnh là hình tròn
                                            height: UtilsReponsive.height(50,
                                                context), // Đảm bảo hình ảnh là hình tròn
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    width: UtilsReponsive.width(10, context),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () => Text(
                                                'Nguyên Vũ đã thêm dự án/nhóm hh',
                                                style:
                                                    GetTextStyle.getTextStyle(
                                                        14,
                                                        'Roboto',
                                                        FontWeight.w700,
                                                        controller
                                                                .mark.value
                                                            ? ColorsManager
                                                                .textColor2
                                                            : ColorsManager
                                                                .textInput)),
                                          ),
                                          SizedBox(
                                            height: UtilsReponsive.height(
                                                10, context),
                                          ),
                                          Text(
                                              calculateTimeDifference(controller
                                                  .createdAt
                                                  .toString()),
                                              style: GetTextStyle.getTextStyle(
                                                  12,
                                                  'Roboto',
                                                  FontWeight.w600,
                                                  ColorsManager.textColor)),
                                        ],
                                      ))
                                ]),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
      ),
    ));
  }
}
