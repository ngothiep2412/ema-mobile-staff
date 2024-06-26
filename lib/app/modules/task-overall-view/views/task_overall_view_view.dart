import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hrea_mobile_staff/app/utils/calculate_time_difference.dart';
import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewView extends BaseView<TaskOverallViewController> {
  const TaskOverallViewView({Key? key}) : super(key: key);
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
                              Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                            },
                            child: Text(
                              controller.eventName,
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
                        padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
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
                                    Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                                  },
                                  child: Text(
                                    controller.eventName,
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
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: ColorsManager.backgroundWhite,
                                      radius: UtilsReponsive.height(20, context),
                                      child: IconButton(
                                          onPressed: () {
                                            Get.bottomSheet(Container(
                                              constraints: BoxConstraints(maxHeight: UtilsReponsive.width(250, context)),
                                              padding: EdgeInsetsDirectional.symmetric(
                                                  horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
                                              decoration: BoxDecoration(
                                                color: ColorsManager.backgroundWhite,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(UtilsReponsive.height(20, context)),
                                                    topRight: Radius.circular(UtilsReponsive.height(20, context))),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(10, context)),
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          'Bộ lọc',
                                                          style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: UtilsReponsive.height(20, context),
                                                  ),
                                                  Obx(
                                                    () => Expanded(
                                                        child: ListView.separated(
                                                            shrinkWrap: true,
                                                            itemCount: controller.filterList.length,
                                                            separatorBuilder: (context, index) => SizedBox(
                                                                  height: UtilsReponsive.height(10, context),
                                                                ),
                                                            itemBuilder: (context, index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  if (!controller.filterChoose.contains(controller.filterList[index])) {
                                                                    controller.filter(controller.filterList[index]);
                                                                  } else {
                                                                    controller.filter('');
                                                                  }

                                                                  Get.back();
                                                                },
                                                                child: Padding(
                                                                  padding: UtilsReponsive.paddingAll(context, padding: 8),
                                                                  child: Text(
                                                                    controller.filterList[index],
                                                                    style: TextStyle(
                                                                      color: controller.filterChoose.contains(controller.filterList[index])
                                                                          ? ColorsManager.primary
                                                                          : ColorsManager.textColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            })),
                                                  )
                                                ]),
                                              ),
                                            ));
                                          },
                                          icon: Icon(
                                            Icons.filter_alt_rounded,
                                            color: ColorsManager.primary,
                                            size: 15,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(10, context),
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
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                    color: Colors.green,
                                  ),
                                  child: Text(
                                    'Ngân sách công việc',
                                    style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(10, context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Độ ưu tiên: ",
                            style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 10,
                                width: 50,
                                color: ColorsManager.green.withOpacity(0.7),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Thấp',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(10, context),
                              ),
                              Container(
                                height: 10,
                                width: 50,
                                color: Colors.orangeAccent,
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Trung bình',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(10, context),
                              ),
                              Container(
                                height: 10,
                                width: 50,
                                color: ColorsManager.red.withOpacity(0.7),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Cao',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Obx(
                      () => controller.isLoading.value == true
                          ? Expanded(
                              flex: 4,
                              child: Container(
                                padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
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
                              flex: 4,
                              child: controller.listTask.isEmpty
                                  ? Container(
                                      padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
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
                                              ImageAssets.noTask,
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'Không có công việc trong ngày này',
                                              style: GetTextStyle.getTextStyle(17, 'Nunito', FontWeight.w800, Colors.blueAccent),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Obx(
                                      () => Container(
                                        padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
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
                                              itemBuilder: (context, index) => _taskCommon(context, controller.listTask[index], index),
                                              separatorBuilder: (context, index) => SizedBox(
                                                    height: UtilsReponsive.height(15, context),
                                                  ),
                                              itemCount: controller.listTask.length),
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

  Container _taskCommon(BuildContext context, TaskModel taskModel, int index) {
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
                  controller.getTaskDetail(taskModel.id!);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: UtilsReponsive.height(15, context),
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: UtilsReponsive.height(28, context),
                  ),
                ),
              ),
              SizedBox(
                width: UtilsReponsive.width(10, context),
              ),
              Expanded(
                child: taskModel.status == Status.CONFIRM
                    ? Text(
                        taskModel.title!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(20, context),
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : Text(
                        taskModel.title!,
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
            children: [
              SizedBox(
                height: UtilsReponsive.height(12, context),
              ),
              Row(children: [
                Row(
                  children: [
                    taskModel.status! == Status.CONFIRM
                        ? CircleAvatar(
                            backgroundColor: ColorsManager.backgroundWhite.withOpacity(0.7),
                            radius: UtilsReponsive.height(13, context),
                            child: Icon(
                              Icons.check_circle,
                              color: ColorsManager.purple,
                              size: UtilsReponsive.height(28, context),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: taskModel.status! == Status.PENDING
                                ? ColorsManager.grey.withOpacity(0.7)
                                : taskModel.status! == Status.PROCESSING
                                    ? ColorsManager.blue.withOpacity(0.7)
                                    : taskModel.status! == Status.OVERDUE
                                        ? ColorsManager.red.withOpacity(0.7)
                                        : ColorsManager.green.withOpacity(0.7),
                            radius: UtilsReponsive.height(13, context),
                          ),
                    SizedBox(
                      width: UtilsReponsive.width(15, context),
                    ),
                    Text(
                        taskModel.status! == Status.PENDING
                            ? "Đang chuẩn bị"
                            : taskModel.status! == Status.PROCESSING
                                ? "Đang thực hiện"
                                : taskModel.status! == Status.DONE
                                    ? "Hoàn thành"
                                    : taskModel.status == Status.OVERDUE
                                        ? 'Quá hạn'
                                        : "Đã xác thực",
                        style: GetTextStyle.getTextStyle(
                          16,
                          'Nunito',
                          FontWeight.w600,
                          taskModel.status! == Status.PENDING
                              ? ColorsManager.grey
                              : taskModel.status! == Status.PROCESSING
                                  ? ColorsManager.blue
                                  : taskModel.status! == Status.DONE
                                      ? ColorsManager.green
                                      : taskModel.status! == Status.OVERDUE
                                          ? ColorsManager.red
                                          : ColorsManager.purple,
                        ))
                  ],
                ),
              ]),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: taskModel.status! == Status.PENDING
                        ? ColorsManager.grey
                        : taskModel.status! == Status.PROCESSING
                            ? ColorsManager.blue
                            : taskModel.status! == Status.DONE
                                ? ColorsManager.green
                                : taskModel.status! == Status.OVERDUE
                                    ? ColorsManager.red
                                    : ColorsManager.purple,
                    size: 22,
                  ),
                  SizedBox(
                    width: UtilsReponsive.width(10, context),
                  ),
                  taskModel.endDate != null
                      ? Expanded(
                          child: Text(
                              'Hạn: ${controller.dateFormat.format(taskModel.startDate!.toLocal())} - ${controller.dateFormat.format(taskModel.endDate!.toLocal())}',
                              overflow: TextOverflow.clip
                              // ${getCurrentTime(taskModel.startDate!)} - ${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)}'
                              ,
                              style: GetTextStyle.getTextStyle(
                                15,
                                'Nunito',
                                FontWeight.w700,
                                taskModel.status! == Status.PENDING
                                    ? ColorsManager.grey
                                    : taskModel.status! == Status.PROCESSING
                                        ? ColorsManager.blue
                                        : taskModel.status! == Status.DONE
                                            ? ColorsManager.green
                                            : taskModel.status! == Status.OVERDUE
                                                ? ColorsManager.red
                                                : ColorsManager.purple,
                              )),
                        )
                      : const SizedBox(),
                ],
              ),
              SizedBox(
                height: UtilsReponsive.height(12, context),
              ),
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: taskModel.priority! == Priority.LOW
                      ? ColorsManager.green
                      : taskModel.priority! == Priority.MEDIUM
                          ? ColorsManager.yellow
                          : ColorsManager.red,
                ),
              )
            ],
          ),
          children: taskModel.subTask!.isNotEmpty
              ? () {
                  var subTasks = taskModel.subTask!.where((subTask) => subTask.status != Status.CANCEL).toList();
                  subTasks.sort((a, b) {
                    if (a.startDate == null && b.startDate == null) {
                      return 0;
                    }
                    if (a.startDate == null) {
                      return 1;
                    }
                    if (b.startDate == null) {
                      return -1;
                    }
                    // So sánh ngày nếu cả hai đều không phải là null
                    int dateComparison = a.startDate!.compareTo(b.startDate!);
                    if (dateComparison != 0) {
                      return dateComparison; // Trả về kết quả nếu ngày không giống nhau.
                    } else {
                      // Sắp xếp theo độ ưu tiên nếu ngày giống nhau
                      final priorityOrder = {Priority.HIGH: 0, Priority.MEDIUM: 1, Priority.LOW: 2};
                      final priorityA = priorityOrder[a.priority] ?? 2;
                      final priorityB = priorityOrder[b.priority] ?? 2;
                      return priorityA.compareTo(priorityB);
                    }
                  });

                  return subTasks.asMap().entries.map((entry) {
                    return _itemTask(context: context, taskModel: entry.value, index: index);
                  }).toList();
                }()
              : [],
        ),
      ),
    );
  }

  Widget _itemTask({
    required BuildContext context,
    required TaskModel taskModel,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
          "taskID": taskModel.id,
          "isNavigateDetail": false,
          "isNavigateOverall": true,
          "endDate": controller.listTask[index].endDate,
          "startDate": controller.listTask[index].startDate
        });
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
                      color: taskModel.status! == Status.PENDING
                          ? ColorsManager.grey
                          : taskModel.status! == Status.PROCESSING
                              ? ColorsManager.blue
                              : taskModel.status! == Status.DONE
                                  ? ColorsManager.green
                                  : taskModel.status! == Status.OVERDUE
                                      ? ColorsManager.red
                                      : ColorsManager.purple,
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                    ),
                  ],
                  color: taskModel.status! == Status.PENDING
                      ? ColorsManager.grey
                      : taskModel.status! == Status.PROCESSING
                          ? ColorsManager.blue
                          : taskModel.status! == Status.DONE
                              ? ColorsManager.green
                              : taskModel.status! == Status.OVERDUE
                                  ? ColorsManager.red
                                  : ColorsManager.purple,
                ),
                child: Center(
                    child: Text(
                        taskModel.status! == Status.PENDING
                            ? "Đang chuẩn bị"
                            : taskModel.status! == Status.PROCESSING
                                ? "Đang thực hiện"
                                : taskModel.status! == Status.DONE
                                    ? "Hoàn thành"
                                    : taskModel.status == Status.OVERDUE
                                        ? "Quá hạn"
                                        : "Đã xác nhận",
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
                          taskModel.status == Status.CONFIRM
                              ? Text(
                                  taskModel.title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: ColorsManager.textColor,
                                      fontSize: UtilsReponsive.height(16, context),
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.lineThrough),
                                )
                              : Text(
                                  taskModel.title!,
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
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: taskModel.status! == Status.PENDING
                                    ? ColorsManager.grey
                                    : taskModel.status! == Status.PROCESSING
                                        ? ColorsManager.blue
                                        : taskModel.status! == Status.DONE
                                            ? ColorsManager.green
                                            : taskModel.status! == Status.OVERDUE
                                                ? ColorsManager.red
                                                : ColorsManager.purple,
                                size: 20,
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              taskModel.endDate == null
                                  ? Text(
                                      'Hạn hoàn thành',
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontFamily: 'Nunito',
                                          color: ColorsManager.textColor2,
                                          fontSize: UtilsReponsive.height(14, context),
                                          fontWeight: FontWeight.w700),
                                    )
                                  : taskModel.startDate != null && taskModel.endDate != null
                                      ? Column(
                                          children: [
                                            Text(
                                                // '${controller.dateFormat.format(taskModel.startDate!)} ${getCurrentTime(taskModel.startDate!)} - ${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)}'
                                                '${controller.dateFormat.format(taskModel.startDate!.toLocal())} ${getCurrentTime(taskModel.startDate!.toLocal())}',
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.w700,
                                                  color: taskModel.status! == Status.PENDING
                                                      ? ColorsManager.grey
                                                      : taskModel.status! == Status.PROCESSING
                                                          ? ColorsManager.blue
                                                          : taskModel.status! == Status.DONE
                                                              ? ColorsManager.green
                                                              : taskModel.status! == Status.OVERDUE
                                                                  ? ColorsManager.red
                                                                  : ColorsManager.purple,
                                                )),
                                            Text(
                                                // '${controller.dateFormat.format(taskModel.startDate!)} ${getCurrentTime(taskModel.startDate!)} - ${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)}'
                                                '- ${controller.dateFormat.format(taskModel.endDate!.toLocal())} ${getCurrentTime(taskModel.endDate!.toLocal())}',
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.w700,
                                                  color: taskModel.status! == Status.PENDING
                                                      ? ColorsManager.grey
                                                      : taskModel.status! == Status.PROCESSING
                                                          ? ColorsManager.blue
                                                          : taskModel.status! == Status.DONE
                                                              ? ColorsManager.green
                                                              : taskModel.status! == Status.OVERDUE
                                                                  ? ColorsManager.red
                                                                  : ColorsManager.purple,
                                                )),
                                          ],
                                        )
                                      : taskModel.startDate != null
                                          ? Text(
                                              controller.dateFormat.format(taskModel.startDate!.toLocal()),
                                              style: GetTextStyle.getTextStyle(
                                                14,
                                                'Nunito',
                                                FontWeight.w700,
                                                taskModel.status! == Status.PENDING
                                                    ? ColorsManager.grey
                                                    : taskModel.status! == Status.PROCESSING
                                                        ? ColorsManager.blue
                                                        : taskModel.status! == Status.DONE
                                                            ? ColorsManager.green
                                                            : taskModel.status! == Status.OVERDUE
                                                                ? ColorsManager.red
                                                                : ColorsManager.orange,
                                              ),
                                            )
                                          : taskModel.endDate != null
                                              ? Text(
                                                  controller.dateFormat.format(taskModel.endDate!.toLocal()),
                                                  style: GetTextStyle.getTextStyle(
                                                    14,
                                                    'Nunito',
                                                    FontWeight.w700,
                                                    taskModel.status! == Status.PENDING
                                                        ? ColorsManager.grey
                                                        : taskModel.status! == Status.PROCESSING
                                                            ? ColorsManager.primary
                                                            : taskModel.status! == Status.DONE
                                                                ? ColorsManager.green
                                                                : taskModel.status! == Status.OVERDUE
                                                                    ? ColorsManager.red
                                                                    : ColorsManager.orange,
                                                  ),
                                                )
                                              : const SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(5, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: taskModel.assignTasks!.isNotEmpty &&
                            taskModel.assignTasks != null &&
                            taskModel.assignTasks!.where((item) => item.status == "active").toList().length > 1
                        ? Row(
                            children: [
                              CachedNetworkImage(
                                // fit: BoxFit.contain,
                                imageUrl: taskModel.assignTasks![0].user!.profile!.avatar!,
                                imageBuilder: (context, imageProvider) => Container(
                                    width: UtilsReponsive.width(35, context),
                                    height: UtilsReponsive.height(35, context),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: ColorsManager.textColor2),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                  padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                  height: UtilsReponsive.height(5, context),
                                  width: UtilsReponsive.height(5, context),
                                  child: CircularProgressIndicator(
                                    color: ColorsManager.primary,
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                              Container(
                                width: UtilsReponsive.height(35, context),
                                height: UtilsReponsive.height(35, context),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '+${taskModel.assignTasks!.where((assign) => assign.status == "active").length - 1}',
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          )
                        : taskModel.assignTasks!.isNotEmpty && taskModel.assignTasks!.where((item) => item.status == "active").toList().length == 1
                            ? Row(children: [
                                SizedBox(
                                  width: UtilsReponsive.width(20, context),
                                ),
                                CachedNetworkImage(
                                  // fit: BoxFit.contain,
                                  imageUrl: taskModel.assignTasks![0].user!.profile!.avatar!,
                                  imageBuilder: (context, imageProvider) => Container(
                                      width: UtilsReponsive.width(35, context),
                                      height: UtilsReponsive.height(35, context),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: ColorsManager.textColor2),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                    padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                    height: UtilsReponsive.height(5, context),
                                    width: UtilsReponsive.height(5, context),
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primary,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ])
                            : Row(
                                children: [
                                  SizedBox(
                                    width: UtilsReponsive.width(20, context),
                                  ),
                                  Container(
                                    width: UtilsReponsive.width(35, context),
                                    height: UtilsReponsive.height(35, context),
                                    decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 0.5,
                                        )
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                    clipBehavior: Clip.antiAlias, // Đây là dòng quan trọng
                                    child: Image.asset(ImageAssets.noUser, fit: BoxFit.fill),
                                  )
                                ],
                              ),
                  ),
                ],
              ),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                  color: taskModel.priority! == Priority.LOW
                      ? ColorsManager.green
                      : taskModel.priority! == Priority.MEDIUM
                          ? ColorsManager.yellow
                          : ColorsManager.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
