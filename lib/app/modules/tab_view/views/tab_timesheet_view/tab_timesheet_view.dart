import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_timekeeping_controller/tab_timekeeping_controller.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:intl/intl.dart';

class TabTimeKeepingView extends BaseView<TabTimeKeepingController> {
  const TabTimeKeepingView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.indigo.shade50,
        child: Padding(
          padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
          child: Obx(
            () => controller.isLoading.value
                ? Center(
                    child: SpinKitFadingCircle(
                      color: ColorsManager.primary,
                      // size: 50.0,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Text(
                                'Lịch sử chấm công',
                                style: GetTextStyle.getTextStyle(
                                    UtilsReponsive.height(
                                        UtilsReponsive.height(30, context),
                                        context),
                                    'Roboto',
                                    FontWeight.w800,
                                    ColorsManager.primary),
                              ),
                            ),
                            Container(
                              height: UtilsReponsive.height(50, context),
                              width: UtilsReponsive.height(50, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsManager.primary,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.work_history,
                                      color: ColorsManager.backgroundWhite),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(
                                  UtilsReponsive.height(10, context)),
                              decoration: BoxDecoration(
                                  color: Colors.indigo.shade500,
                                  borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tháng này',
                                      style: GetTextStyle.getTextStyle(
                                          UtilsReponsive.height(
                                              UtilsReponsive.height(
                                                  18, context),
                                              context),
                                          'Roboto',
                                          FontWeight.w500,
                                          Colors.white)),
                                  SizedBox(
                                    height: UtilsReponsive.height(10, context),
                                  ),
                                  Row(
                                      children: controller.listAttendanceSum
                                          .map((e) => Expanded(
                                                  child: Column(
                                                children: [
                                                  Text(e.number.toString(),
                                                      style: GetTextStyle.getTextStyle(
                                                          UtilsReponsive.height(
                                                              UtilsReponsive
                                                                  .height(22,
                                                                      context),
                                                              context),
                                                          'Roboto',
                                                          FontWeight.w900,
                                                          Colors.white)),
                                                  Text(e.type,
                                                      style: GetTextStyle.getTextStyle(
                                                          UtilsReponsive.height(
                                                              UtilsReponsive
                                                                  .height(14,
                                                                      context),
                                                              context),
                                                          'Roboto',
                                                          FontWeight.w500,
                                                          Colors.white))
                                                ],
                                              )))
                                          .toList()),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(20, context),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                  UtilsReponsive.height(10, context)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Điểm danh',
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontFamily: 'Roboto',
                                            color: Colors.black,
                                            fontSize: UtilsReponsive.height(
                                                16, context),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat('EE dd MM', 'vi').format(
                                            DateTime.now()
                                                .toUtc()
                                                .toLocal()
                                                .add(Duration(hours: 7))),
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontFamily: 'Roboto',
                                            color: Colors.grey,
                                            fontSize: UtilsReponsive.height(
                                                16, context),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Obx(() => Text(
                                            controller.vietNamTime.value,
                                            style: TextStyle(
                                                letterSpacing: 1.5,
                                                fontFamily: 'Roboto',
                                                color: Colors.black,
                                                fontSize: UtilsReponsive.height(
                                                    16, context),
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: UtilsReponsive.width(10, context),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.checkInOut();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: UtilsReponsive.height(
                                              20, context)),
                                      decoration: BoxDecoration(
                                          color: !controller.isCheckedIn.value
                                              ? Colors.blue
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      padding: EdgeInsets.all(
                                          UtilsReponsive.height(10, context)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: UtilsReponsive.width(
                                                10, context),
                                          ),
                                          Text(
                                            controller.isCheckedIn.value
                                                ? "Tan ca"
                                                : "Vào ca",
                                            style: TextStyle(
                                                letterSpacing: 1.5,
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: UtilsReponsive.height(
                                                    16, context),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: UtilsReponsive.width(10, context),
                                  ),
                                  _itemTime(
                                      context: context,
                                      time: '09:00:00',
                                      color: Colors.blue),
                                  SizedBox(
                                    height: UtilsReponsive.width(10, context),
                                  ),
                                  _itemTime(
                                      context: context,
                                      time: '17:00:00',
                                      color: Colors.red),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(20, context),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _showDateTimePicker(context);
                                },
                                child: Obx(
                                  () => _timeBuilder(
                                      context: context,
                                      startTime: controller.dateFormat.format(
                                          controller.listDateTime.first!),
                                      endTime: controller.dateFormat.format(
                                          controller.listDateTime.last!)),
                                )),
                            Expanded(
                                child: ListView.separated(
                                    padding: EdgeInsets.all(
                                        UtilsReponsive.height(10, context)),
                                    itemBuilder: (context, index) =>
                                        _itemData(context),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: UtilsReponsive.height(
                                              10, context),
                                        ),
                                    itemCount: 100))
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Card _itemData(BuildContext context) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          height: UtilsReponsive.height(60, context),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Container(
              //   padding: EdgeInsets.all(UtilsReponsive.height(5, context)),
              //   height: UtilsReponsive.height(50, context),
              //   width: UtilsReponsive.height(50, context),
              //   decoration:
              //       BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
              //   child: CircleAvatar(
              //     foregroundColor: Colors.blue,
              //     backgroundColor: Colors.blue,
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vào ca",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "9:00:00",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tan ca",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "17:00:00",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          )),
    );
  }

  Row _itemTime(
      {required BuildContext context,
      required String time,
      required Color color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.directions_walk,
              color: color,
            ),
            SizedBox(
              width: UtilsReponsive.width(10, context),
            ),
            Text(
              time,
              style: TextStyle(
                  letterSpacing: 1.5,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                  fontSize: UtilsReponsive.height(16, context),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          "Địa điểm công ty",
          style: TextStyle(
              letterSpacing: 1.5,
              fontFamily: 'Roboto',
              color: Colors.grey,
              fontSize: UtilsReponsive.height(16, context),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Row _timeBuilder(
      {required BuildContext context,
      required String startTime,
      required String endTime}) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_month,
          color: Color(0xffC2B280),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: UtilsReponsive.width(15, context),
              vertical: UtilsReponsive.height(10, context)),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(5, context)),
          ),
          margin: EdgeInsets.only(left: UtilsReponsive.width(15, context)),
          child: Text(
            '$startTime ${endTime != startTime ? '- $endTime' : ''}',
            style: TextStyle(
                letterSpacing: 1.5,
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: UtilsReponsive.height(16, context),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  _showDateTimePicker(BuildContext context) async {
    await Get.defaultDialog(
      confirm: TextButton(
          onPressed: () {
            //gọi api call danh sach theo ngay
            Get.back();
          },
          child: Text('Chọn')),
      title: 'Chọn ngày',
      content: Container(
        height: UtilsReponsive.height(300, context),
        width: UtilsReponsive.height(300, context),
        child: Column(
          children: [
            // Obx(() => Row(
            //       children: [
            //         Text('Chọn khoảng ngày'),
            //         Switch(
            //           value: controller.isRangeDate.value,
            //           onChanged: (bool value) {
            //             controller.changeTypeChooseDate(value);
            //           },
            //         )
            //       ],
            //     )),
            Expanded(
              child: Obx(() => CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    currentDate: DateTime.now(),
                    //
                    firstDate: DateTime(DateTime.now().year - 10, 1),
                    calendarType: controller.isRangeDate.value
                        ? CalendarDatePicker2Type.range
                        : CalendarDatePicker2Type.single,
                    centerAlignModePicker: true,
                    selectedDayTextStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    selectedDayHighlightColor: Colors.blue,
                  ),
                  onValueChanged: (value) {
                    log('isSingleDate ${controller.isRangeDate}');
                    controller.getTimeRange(value);
                  },
                  value: controller.listDateTime)),
            ),
          ],
        ),
      ),
    );
  }
}
