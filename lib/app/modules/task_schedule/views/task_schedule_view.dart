import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
// import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/calendar_custom.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import '../controllers/task_schedule_controller.dart';

class TaskScheduleView extends BaseView<TaskScheduleController> {
  const TaskScheduleView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value == true
              ? Center(
                  child: SpinKitFadingCircle(
                    color: ColorsManager.primary,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: ColorsManager.primary,
                              )),
                          SizedBox(
                            width: UtilsReponsive.width(5, context),
                          ),
                          Expanded(
                            child: Text(
                              'Lịch thực hiện công việc',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  letterSpacing: 0.5,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(26, context),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     _showDateTimePicker(context);
                              //   },
                              //   child: Obx(
                              //     () => Text(
                              //       controller.dateTimeString.toString(),
                              //       style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w800, color: ColorsManager.primary),
                              //     ),
                              //   ),
                              // ),

                              Container(
                                height: 70,
                                child: HorizontalCalendar(
                                  date: controller.dateTime,
                                  initialDate: controller.dateTime,
                                  textColor: ColorsManager.textColor,
                                  backgroundColor: Colors.blueAccent,
                                  selectedColor: Colors.blueGrey,
                                  showMonth: true,
                                  locale: Localizations.localeOf(context),
                                  onDateSelected: (date) {},
                                ),
                              ),
                              // child: Obx(
                              //   () => DatePicker(
                              //     controller.dateTime,
                              //     controller: controller.datePickerController.value,
                              //     locale: "vi_VN",
                              //     height: 80,
                              //     width: 60,
                              //     initialSelectedDate: controller.dateTime,
                              //     selectionColor: Colors.blue,
                              //     selectedTextColor: Colors.white,
                              //     dayTextStyle: TextStyle(
                              //       color: Get.isDarkMode ? Colors.white : Colors.black,
                              //     ),
                              //     dateTextStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
                              //     monthTextStyle: TextStyle(
                              //       color: Get.isDarkMode ? Colors.white : Colors.black,
                              //     ),
                              //     onDateChange: (value) {
                              //       var selecteddate = value.toString().split(' ');
                              //       print(selecteddate[0]);

                              //       // todocontroller.onchangeselectedate(selecteddate[0]);
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) {
    showDatePicker(context: context, initialDate: controller.dateTime, firstDate: DateTime(2000), lastDate: DateTime(2030))
        .then((value) => controller.check(value!));
  }
}
