import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/task_calendar_month/model/task_item.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/task_calendar_month_controller.dart';

class TaskCalendarMonthView extends BaseView<TaskCalendarMonthController> {
  const TaskCalendarMonthView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.9),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return SafeArea(
      child: Column(
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
                      color: ColorsManager.backgroundWhite,
                    )),
                SizedBox(
                  width: UtilsReponsive.width(5, context),
                ),
                Expanded(
                  child: Text(
                    'Lịch của ${controller.userName}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        letterSpacing: 0.5,
                        color: ColorsManager.backgroundWhite,
                        fontSize: UtilsReponsive.height(26, context),
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Obx(
                () => TableCalendar(
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    locale: "vi_VN",
                    headerStyle: const HeaderStyle(
                        // leftChevronVisible: false,
                        // rightChevronVisible: false,
                        formatButtonVisible: false,
                        // titleCentered: true,
                        // titleTextFormatter: ,
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: ColorsManager.textColor,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: ColorsManager.textColor,
                        ),
                        titleTextStyle: TextStyle(
                          color: ColorsManager.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                    availableGestures: AvailableGestures.all,
                    focusedDay: controller.dateStarTask.value,
                    selectedDayPredicate: ((day) => isSameDay(
                          day,
                          controller.dateStarTask.value,
                        )),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 10, 16),
                    onDaySelected: controller.onDaySelected,
                    // eventLoader: controller.getTasksForDay,
                    daysOfWeekStyle: const DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.white)),
                    calendarBuilders: CalendarBuilders(markerBuilder: (context, day, int) {
                      return getWidgetCellMarker(day, context, controller.tasks);
                    }),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                      markerDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.blue),
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekNumberTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                    ),
                    onFormatChanged: (format) => {
                          if (controller.calendarFormat.value != format) {controller.calendarFormat.value = format}
                        },
                    onPageChanged: (focusedDay) {
                      controller.taskShow.value = [];
                      // controller.focusedDay.value = focusedDay;
                      // controller.getDetailEmployee();
                    }),
              ),
            ),
          ),
          Obx(
            () => Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: controller.taskShow.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Color(0xffFAFAFA),
                ),
                child: controller.taskShow.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: UtilsReponsive.height(20, context),
                        ),
                        itemCount: controller.taskShow.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(16, context)),
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return itemTask(index: index, context: context, taskModel: controller.taskShow[index]);
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: UtilsReponsive.height(150, context),
                            width: UtilsReponsive.width(100, context),
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                              imageUrl:
                                  'https://cdni.iconscout.com/illustration/premium/thumb/businessman-completed-tasks-5037983-4202464.png?f=webp',
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Center(
                            child: Text(
                              'Không có công việc trong ngày này',
                              style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.textColor2),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemTask({required int index, required BuildContext context, required TaskItem taskModel}) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
        //   "taskID": taskModel.id,
        //   "isNavigateDetail": true,
        //   "endDate": DateTime.parse(controller.convertDateFormat(taskModel.endDate!)),
        //   "startDate": DateTime.parse(controller.convertDateFormat(taskModel.startDate!)),
        // });
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Màu của shadow và độ mờ
            spreadRadius: 2, // Độ lan rộng của shadow
            blurRadius: 5, // Độ mờ của shadow
            offset: const Offset(0, 1), // Độ dịch chuyển của shadow
          ),
        ]),
        height: 65,
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 45,
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: taskModel.priority! == Priority.LOW
                      ? ColorsManager.green
                      : taskModel.priority! == Priority.MEDIUM
                          ? ColorsManager.yellow
                          : ColorsManager.red,
                ),
              ),
              SizedBox(
                width: UtilsReponsive.width(10, context),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskModel.title!,
                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                    ),
                    Row(
                      children: [
                        Icon(
                          size: 20,
                          Icons.calendar_month,
                          color: taskModel.status == Status.PENDING
                              ? ColorsManager.grey
                              : taskModel.status! == Status.PROCESSING
                                  ? ColorsManager.blue
                                  : taskModel.status! == Status.DONE
                                      ? ColorsManager.green
                                      : taskModel.status! == Status.CONFIRM
                                          ? ColorsManager.purple
                                          : ColorsManager.red,
                        ),
                        Container(
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: UtilsReponsive.width(5, context),
                          //     vertical: UtilsReponsive.height(10, context)),
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius:
                          //       BorderRadius.circular(UtilsReponsive.height(5, context)),
                          // ),
                          margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
                          child: Text(
                            // '$startTime ${getCurrentTime(controller.taskModel.value.startDate!)} - $endTime ${getCurrentTime(controller.taskModel.value.endDate!)}',
                            'Hạn: ${controller.convertDateFormatV2(taskModel.startDate!)} - ${controller.convertDateFormatV2(taskModel.endDate!)}',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Nunito',
                                color: taskModel.status == Status.PENDING
                                    ? ColorsManager.grey
                                    : taskModel.status! == Status.PROCESSING
                                        ? ColorsManager.blue
                                        : taskModel.status! == Status.DONE
                                            ? ColorsManager.green
                                            : taskModel.status! == Status.CONFIRM
                                                ? ColorsManager.purple
                                                : ColorsManager.red,
                                // fontSize: UtilsReponsive.height(5, context),
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    taskModel.status! == Status.DONE
                        ? CircleAvatar(
                            backgroundColor: ColorsManager.grey.withOpacity(0.7),
                            radius: UtilsReponsive.height(20, context),
                            child: Icon(
                              Icons.check_circle,
                              color: ColorsManager.green.withOpacity(0.7),
                              size: 20,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: taskModel.status! == Status.PENDING
                                ? ColorsManager.grey.withOpacity(0.7)
                                : taskModel.status! == Status.PROCESSING
                                    ? ColorsManager.blue.withOpacity(0.7)
                                    : taskModel.status! == Status.OVERDUE
                                        ? ColorsManager.red.withOpacity(0.7)
                                        : ColorsManager.purple.withOpacity(0.7),
                            radius: UtilsReponsive.height(20, context),
                          ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget getWidgetCellMarker(DateTime day, BuildContext context, Map<DateTime, List<TaskItem>> tasks) {
    // Kiểm tra xem ngày có trong tasks không
    bool hasTasks = tasks.containsKey(day.toLocal());

    // Màu sắc mặc định cho BoxShape
    Color boxColor = Colors.transparent;

    // Nếu ngày có trong tasks, thiết lập màu sắc cho BoxShape
    if (hasTasks) {
      boxColor = Colors.red; // Thay đổi màu sắc tùy thuộc vào yêu cầu của bạn
    }

    return Obx(
      () => Container(
        padding: EdgeInsets.all(
          UtilsReponsive.height(2, context),
        ),
        margin: EdgeInsets.only(bottom: UtilsReponsive.height(2, context), left: UtilsReponsive.height(0, context)),
        height: 18,
        width: 14,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tasks[day.toLocal()] != null ? Colors.redAccent : Colors.transparent, // Thiết lập màu sắc cho BoxShape
        ),
      ),
    );
  }
}
