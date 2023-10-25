import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hrea_mobile_staff/app/utils/calculate_time_difference.dart';
import 'package:line_icons/line_icons.dart';
import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewView extends BaseView<TaskOverallViewController> {
  const TaskOverallViewView({Key? key}) : super(key: key);
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
                      // size: 30.0,
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
                                Icons.arrow_back,
                                color: ColorsManager.primary,
                              )),
                          SizedBox(
                            width: UtilsReponsive.width(5, context),
                          ),
                          Expanded(
                            child: Text(
                              controller.eventName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ColorsManager.primary,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.bottomSheet(Container(
                                  height: UtilsReponsive.height(280, context),
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          UtilsReponsive.width(280, context)),
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal:
                                          UtilsReponsive.width(15, context),
                                      vertical:
                                          UtilsReponsive.height(20, context)),
                                  decoration: BoxDecoration(
                                    color: ColorsManager.backgroundWhite,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            UtilsReponsive.height(20, context)),
                                        topRight: Radius.circular(
                                            UtilsReponsive.height(
                                                20, context))),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            UtilsReponsive.height(10, context)),
                                    child: Column(children: [
                                      Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              'Bộ lọc',
                                              style: GetTextStyle.getTextStyle(
                                                  18,
                                                  'Roboto',
                                                  FontWeight.bold,
                                                  ColorsManager.primary),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                        () => Expanded(
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: controller
                                                    .filterList.length,
                                                separatorBuilder: (context,
                                                        index) =>
                                                    SizedBox(
                                                      height:
                                                          UtilsReponsive.height(
                                                              10, context),
                                                    ),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding: UtilsReponsive
                                                          .paddingAll(context,
                                                              padding: 8),
                                                      child: Text(controller
                                                          .filterList[index]),
                                                    ),
                                                  );
                                                })),
                                      )
                                    ]),
                                  ),
                                ));
                              },
                              icon: Icon(
                                Icons.filter_alt_outlined,
                                color: ColorsManager.primary,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.info_outline,
                                color: ColorsManager.primary,
                              )),
                          IconButton(
                              onPressed: () {
                                controller.refreshPage();
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: ColorsManager.primary,
                              ))
                        ],
                      )),
                      Obx(
                        () => Expanded(
                            flex: 10,
                            child: controller.listTask.isEmpty
                                ? Center(
                                    child: Text(
                                      'Event này hiện chưa có công việc dành cho bạn',
                                      style: GetTextStyle.getTextStyle(
                                          16,
                                          'Roboto',
                                          FontWeight.w600,
                                          ColorsManager.primary),
                                    ),
                                  )
                                : Obx(
                                    () => RefreshIndicator(
                                      onRefresh: controller.refreshPage,
                                      child: ListView.separated(
                                          padding: UtilsReponsive.paddingAll(
                                              context,
                                              padding: 15),
                                          itemBuilder: (context, index) =>
                                              _taskCommon(
                                                  context,
                                                  controller.listTask[index],
                                                  index),
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                height: UtilsReponsive.height(
                                                    15, context),
                                              ),
                                          itemCount:
                                              controller.listTask.length),
                                    ),
                                  )),
                      )
                    ],
                  ),
          ),
        ));
  }

  Container _taskCommon(BuildContext context, TaskModel taskModel, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          UtilsReponsive.height(10, context),
        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.grey,
        //     blurRadius: 0.5,
        //     // spreadRadius: 1.0,
        //     // offset: Offset(0, 4),
        //   ),
        // ],
      ),
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
                    backgroundColor: ColorsManager.primary.withOpacity(0.8),
                    radius: UtilsReponsive.height(15, context),
                    child: const Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: UtilsReponsive.width(10, context),
                ),
                taskModel.status == Status.DONE ||
                        taskModel.status == Status.CONFIRM
                    ? Text(
                        taskModel.title!.length > 25
                            ? '${taskModel.title!.substring(0, 25)}...'
                            : taskModel.title!,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(22, context),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : Text(
                        taskModel.title!.length > 25
                            ? '${taskModel.title!.substring(0, 25)}...'
                            : taskModel.title!,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: ColorsManager.textColor,
                            fontSize: UtilsReponsive.height(22, context),
                            fontWeight: FontWeight.w600),
                      )
              ],
            ),
            subtitle: Column(
              children: [
                SizedBox(
                  height: UtilsReponsive.height(10, context),
                ),
                Row(children: [
                  const Icon(
                    Icons.priority_high,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: UtilsReponsive.width(15, context),
                  ),
                  Text(
                      taskModel.priority! == Priority.LOW
                          ? "Thấp"
                          : taskModel.priority! == Priority.MEDIUM
                              ? "Trung bình"
                              : "Cao",
                      style: GetTextStyle.getTextStyle(
                          16,
                          'Roboto',
                          FontWeight.w600,
                          taskModel.priority! == Priority.LOW
                              ? Colors.grey
                              : taskModel.priority! == Priority.MEDIUM
                                  ? ColorsManager.orange
                                  : ColorsManager.green)),
                  SizedBox(
                    width: UtilsReponsive.width(15, context),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorsManager.backgroundGrey,
                        radius: UtilsReponsive.height(15, context),
                        child: Icon(
                          Icons.check_circle,
                          color: taskModel.status! == Status.PENDING
                              ? Colors.grey
                              : taskModel.status! == Status.PROCESSING
                                  ? ColorsManager.primary
                                  : taskModel.status! == Status.DONE
                                      ? ColorsManager.green
                                      : taskModel.status! == Status.OVERDUE
                                          ? ColorsManager.red
                                          : Colors.purpleAccent,
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(5, context),
                      ),
                      Text(
                          taskModel.status! == Status.PENDING
                              ? "Đang kiểm thực"
                              : taskModel.status! == Status.PROCESSING
                                  ? "Đang thực hiện"
                                  : taskModel.status! == Status.DONE
                                      ? "Hoàn thành"
                                      : taskModel.status == Status.OVERDUE
                                          ? 'Quá hạn'
                                          : "Đã xác thực",
                          style: GetTextStyle.getTextStyle(
                            16,
                            'Roboto',
                            FontWeight.w600,
                            taskModel.status! == Status.PENDING
                                ? Colors.grey
                                : taskModel.status! == Status.PROCESSING
                                    ? ColorsManager.primary
                                    : taskModel.status! == Status.DONE
                                        ? ColorsManager.green
                                        : taskModel.status! == Status.OVERDUE
                                            ? ColorsManager.red
                                            : Colors.purpleAccent,
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
                          ? Colors.grey
                          : taskModel.status! == Status.PROCESSING
                              ? ColorsManager.primary
                              : taskModel.status! == Status.DONE
                                  ? ColorsManager.green
                                  : taskModel.status! == Status.OVERDUE
                                      ? ColorsManager.red
                                      : Colors.purpleAccent,
                      size: 20,
                    ),
                    SizedBox(
                      width: UtilsReponsive.width(15, context),
                    ),
                    taskModel.endDate != null
                        ? Text(
                            '${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)} ',
                            style: GetTextStyle.getTextStyle(
                              16,
                              'Roboto',
                              FontWeight.w600,
                              taskModel.status! == Status.PENDING
                                  ? Colors.grey
                                  : taskModel.status! == Status.PROCESSING
                                      ? ColorsManager.primary
                                      : taskModel.status! == Status.DONE
                                          ? ColorsManager.green
                                          : taskModel.status! == Status.OVERDUE
                                              ? ColorsManager.red
                                              : Colors.purpleAccent,
                            ))
                        : const SizedBox(),
                  ],
                ),
                SizedBox(
                  height: UtilsReponsive.height(10, context),
                ),
                //   Row(
                //     children: [
                //       CircleAvatar(
                //         backgroundColor: ColorsManager.backgroundGrey,
                //         radius: UtilsReponsive.height(15, context),
                //         child: Icon(
                //           Icons.check_circle,
                //           color: taskModel.status! == Status.PENDING
                //               ? Colors.grey
                //               : taskModel.status! == Status.PROCESSING
                //                   ? ColorsManager.primary
                //                   : taskModel.status! == Status.DONE
                //                       ? ColorsManager.green
                //                       : taskModel.status! == Status.OVERDUE
                //                           ? ColorsManager.red
                //                           : Colors.purpleAccent,
                //           size: 20,
                //         ),
                //       ),
                //       SizedBox(
                //         width: UtilsReponsive.width(5, context),
                //       ),
                //       Text(
                //           taskModel.status! == Status.PENDING
                //               ? "Đang kiểm thực"
                //               : taskModel.status! == Status.PROCESSING
                //                   ? "Đang thực hiện"
                //                   : taskModel.status! == Status.DONE
                //                       ? "Hoàn thành"
                //                       : taskModel.status == Status.OVERDUE
                //                           ? 'Quá hạn'
                //                           : "Đã xác thực",
                //           style: GetTextStyle.getTextStyle(
                //             14,
                //             'Roboto',
                //             FontWeight.w600,
                //             taskModel.status! == Status.PENDING
                //                 ? Colors.grey
                //                 : taskModel.status! == Status.PROCESSING
                //                     ? ColorsManager.primary
                //                     : taskModel.status! == Status.DONE
                //                         ? ColorsManager.green
                //                         : taskModel.status! == Status.OVERDUE
                //                             ? ColorsManager.red
                //                             : Colors.purpleAccent,
                //           ))
                //     ],
                //   ),
              ],
            ),
            children: taskModel.subTask!.isNotEmpty
                ? taskModel.subTask!.asMap().entries.map((entry) {
                    TaskModel taskModel = TaskModel();
                    if (taskModel.status != Status.CANCEL) {
                      taskModel = entry.value;
                    }
                    // int index = entry.key;

                    return _itemTask(
                        context: context, taskModel: taskModel, index: index);
                  }).toList()
                : []),
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
          "endDate": controller.listTask[index].endDate,
          "startDate": controller.listTask[index].startDate
        });
      },
      child: Padding(
        padding: UtilsReponsive.paddingAll(context, padding: 10),
        child: Container(
          // margin: EdgeInsets.only(bottom: UtilsReponsive.height(15, context)),
          width: double.infinity,
          // height: double.infinity,
          // padding: UtilsReponsive.paddingHorizontal(context, padding: 10),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                ),
              ],
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(UtilsReponsive.height(5, context))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: UtilsReponsive.width(15, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          taskModel.status == Status.DONE ||
                                  taskModel.status == Status.CONFIRM
                              ? Text(
                                  taskModel.title!.length > 25
                                      ? '${taskModel.title!.substring(0, 25)}...'
                                      : taskModel.title!,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    letterSpacing: 1.5,
                                    color: ColorsManager.textColor,
                                    fontSize:
                                        UtilsReponsive.height(17, context),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              : Text(
                                  taskModel.title!.length > 25
                                      ? '${taskModel.title!.substring(0, 25)}...'
                                      : taskModel.title!,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 1.5,
                                      color: ColorsManager.textColor,
                                      fontSize:
                                          UtilsReponsive.height(17, context),
                                      fontWeight: FontWeight.bold),
                                ),
                          SizedBox(
                            height: UtilsReponsive.height(5, context),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: taskModel.status! == Status.PENDING
                                    ? Colors.grey
                                    : taskModel.status! == Status.PROCESSING
                                        ? ColorsManager.primary
                                        : taskModel.status! == Status.DONE
                                            ? ColorsManager.green
                                            : taskModel.status! ==
                                                    Status.OVERDUE
                                                ? ColorsManager.red
                                                : Colors.purpleAccent,
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
                                          fontFamily: 'Roboto',
                                          color: ColorsManager.textColor2,
                                          fontSize: UtilsReponsive.height(
                                              15, context),
                                          fontWeight: FontWeight.bold),
                                    )
                                  : taskModel.startDate != null &&
                                          taskModel.endDate != null
                                      ? Text(
                                          " ${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)}",
                                          style: GetTextStyle.getTextStyle(
                                            15,
                                            'Roboto',
                                            FontWeight.w600,
                                            taskModel.status! == Status.PENDING
                                                ? Colors.grey
                                                : taskModel.status! ==
                                                        Status.PROCESSING
                                                    ? ColorsManager.primary
                                                    : taskModel.status! ==
                                                            Status.DONE
                                                        ? ColorsManager.green
                                                        : taskModel.status! ==
                                                                Status.OVERDUE
                                                            ? ColorsManager.red
                                                            : Colors
                                                                .purpleAccent,
                                          ),
                                        )
                                      : taskModel.startDate != null
                                          ? Text(
                                              controller.dateFormat
                                                  .format(taskModel.startDate!),
                                              style: GetTextStyle.getTextStyle(
                                                15,
                                                'Roboto',
                                                FontWeight.w600,
                                                taskModel.status! ==
                                                        Status.PENDING
                                                    ? Colors.grey
                                                    : taskModel.status! ==
                                                            Status.PROCESSING
                                                        ? ColorsManager.primary
                                                        : taskModel.status! ==
                                                                Status.DONE
                                                            ? ColorsManager
                                                                .green
                                                            : taskModel.status! ==
                                                                    Status
                                                                        .OVERDUE
                                                                ? ColorsManager
                                                                    .red
                                                                : ColorsManager
                                                                    .orange,
                                              ),
                                            )
                                          : taskModel.endDate != null
                                              ? Text(
                                                  controller.dateFormat.format(
                                                      taskModel.endDate!),
                                                  style:
                                                      GetTextStyle.getTextStyle(
                                                    15,
                                                    'Roboto',
                                                    FontWeight.w600,
                                                    taskModel.status! ==
                                                            Status.PENDING
                                                        ? Colors.grey
                                                        : taskModel.status! ==
                                                                Status
                                                                    .PROCESSING
                                                            ? ColorsManager
                                                                .primary
                                                            : taskModel.status! ==
                                                                    Status.DONE
                                                                ? ColorsManager
                                                                    .green
                                                                : taskModel.status! ==
                                                                        Status
                                                                            .OVERDUE
                                                                    ? ColorsManager
                                                                        .red
                                                                    : ColorsManager
                                                                        .orange,
                                                  ),
                                                )
                                              : const SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(5, context),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: taskModel.status! == Status.PENDING
                                    ? Colors.grey
                                    : taskModel.status! == Status.PROCESSING
                                        ? ColorsManager.primary
                                        : taskModel.status! == Status.DONE
                                            ? ColorsManager.green
                                            : taskModel.status! ==
                                                    Status.OVERDUE
                                                ? ColorsManager.red
                                                : Colors.purpleAccent,
                                size: 20,
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                  taskModel.status! == Status.PENDING
                                      ? "Đang kiểm thực"
                                      : taskModel.status! == Status.PROCESSING
                                          ? "Đang thực hiện"
                                          : taskModel.status! == Status.DONE
                                              ? "Hoàn thành"
                                              : taskModel.status ==
                                                      Status.OVERDUE
                                                  ? "Quá hạn"
                                                  : "Đã xác nhận",
                                  style: GetTextStyle.getTextStyle(
                                    15,
                                    'Roboto',
                                    FontWeight.w600,
                                    taskModel.status! == Status.PENDING
                                        ? Colors.grey
                                        : taskModel.status! == Status.PROCESSING
                                            ? ColorsManager.primary
                                            : taskModel.status! == Status.DONE
                                                ? ColorsManager.green
                                                : taskModel.status! ==
                                                        Status.OVERDUE
                                                    ? ColorsManager.red
                                                    : Colors.purpleAccent,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: taskModel.assignTasks!.isNotEmpty &&
                            taskModel.assignTasks!.length > 1
                        ? Row(
                            children: [
                              CachedNetworkImage(
                                // fit: BoxFit.contain,
                                imageUrl: taskModel
                                    .assignTasks![0].user!.profile!.avatar!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        width:
                                            UtilsReponsive.width(35, context),
                                        height:
                                            UtilsReponsive.height(35, context),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    ColorsManager.textColor2),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: const Offset(0, 10))
                                            ],
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider))),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                  padding: EdgeInsets.all(
                                      UtilsReponsive.height(10, context)),
                                  height: UtilsReponsive.height(5, context),
                                  width: UtilsReponsive.height(5, context),
                                  child: CircularProgressIndicator(
                                    color: ColorsManager.primary,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Container(
                                width: UtilsReponsive.height(35, context),
                                height: UtilsReponsive.height(35, context),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: ColorsManager.textColor2),
                                  color: Colors.blueGrey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '...',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            ],
                          )
                        : taskModel.assignTasks!.isNotEmpty &&
                                taskModel.assignTasks!.length == 1
                            ? Row(children: [
                                SizedBox(
                                  width: UtilsReponsive.width(20, context),
                                ),
                                CachedNetworkImage(
                                  // fit: BoxFit.contain,
                                  imageUrl: taskModel
                                      .assignTasks![0].user!.profile!.avatar!,

                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                          width:
                                              UtilsReponsive.width(35, context),
                                          height: UtilsReponsive.height(
                                              35, context),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      ColorsManager.textColor2),
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 2,
                                                    blurRadius: 10,
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    offset: const Offset(0, 10))
                                              ],
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: imageProvider))),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Container(
                                    padding: EdgeInsets.all(
                                        UtilsReponsive.height(10, context)),
                                    height: UtilsReponsive.height(5, context),
                                    width: UtilsReponsive.height(5, context),
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primary,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ])
                            : Row(
                                children: [
                                  SizedBox(
                                    width: UtilsReponsive.width(20, context),
                                  ),
                                  CachedNetworkImage(
                                    // fit: BoxFit.contain,
                                    imageUrl:
                                        "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                            width: UtilsReponsive.width(
                                                35, context),
                                            height: UtilsReponsive.height(
                                                35, context),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: ColorsManager
                                                        .textColor2),
                                                boxShadow: [
                                                  BoxShadow(
                                                      spreadRadius: 2,
                                                      blurRadius: 10,
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset:
                                                          const Offset(0, 10))
                                                ],
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: imageProvider))),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                      padding: EdgeInsets.all(
                                          UtilsReponsive.height(10, context)),
                                      height: UtilsReponsive.height(5, context),
                                      width: UtilsReponsive.height(5, context),
                                      child: CircularProgressIndicator(
                                        color: ColorsManager.primary,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
