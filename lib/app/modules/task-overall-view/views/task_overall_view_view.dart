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
import 'package:line_icons/line_icons.dart';
import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewView extends BaseView<TaskOverallViewController> {
  const TaskOverallViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.backgroundBlackGrey,
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
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
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
                                  color: Colors.white,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10)), // Đây là phần quan trọng để làm cho các góc bo tròn
                                          color: Colors
                                              .white, // Màu nền của container
                                        ),
                                        height:
                                            UtilsReponsive.height(500, context),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: UtilsReponsive.height(
                                                  10, context)),
                                          child: Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () => Get.back(),
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    color:
                                                        ColorsManager.textColor,
                                                  ),
                                                ),
                                                Text(
                                                  'Bộ lọc',
                                                  style:
                                                      GetTextStyle.getTextStyle(
                                                          16,
                                                          'Roboto',
                                                          FontWeight.w600,
                                                          ColorsManager
                                                              .textColor),
                                                ),
                                                Text(
                                                  'Bỏ lọc',
                                                  style:
                                                      GetTextStyle.getTextStyle(
                                                          16,
                                                          'Roboto',
                                                          FontWeight.w600,
                                                          ColorsManager
                                                              .primary),
                                                ),
                                              ],
                                            )
                                          ]),
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {
                                controller.refreshPage();
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
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
                                          ColorsManager.backgroundWhite),
                                    ),
                                  )
                                : Obx(
                                    () => RefreshIndicator(
                                      onRefresh: controller.refreshPage,
                                      child: ListView.separated(
                                          padding: UtilsReponsive.paddingAll(
                                              context,
                                              padding: 20),
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
          border: Border.all(
            width: 0.5,
            color: ColorsManager.primary,
          )),
      child: ExpansionTile(
          // backgroundColor: Colors.blue,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  print('id ${taskModel.id!}');
                  controller.getTaskDetail(taskModel.id!);
                },
                child: Icon(
                  Icons.info_rounded,
                  color: ColorsManager.primary,
                ),
              ),
              SizedBox(
                width: UtilsReponsive.width(10, context),
              ),
              taskModel.status == Status.DONE ||
                      taskModel.status == Status.CONFIRM
                  ? Text(
                      taskModel.title!.length > 20
                          ? '${taskModel.title!.substring(0, 20)}...'
                          : taskModel.title!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        letterSpacing: 1.5,
                        color: ColorsManager.textColor,
                        fontSize: UtilsReponsive.height(18, context),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  : Text(
                      taskModel.title!.length > 20
                          ? '${taskModel.title!.substring(0, 20)}...'
                          : taskModel.title!,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.bold),
                    )
            ],
          ),
          subtitle: Column(
            children: [
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: ColorsManager.calendar,
                      radius: UtilsReponsive.height(15, context),
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 15,
                      )),
                  SizedBox(
                    width: UtilsReponsive.width(10, context),
                  ),
                  taskModel.startDate != null
                      ? Text(
                          controller.dateFormat.format(taskModel.startDate!),
                          style: GetTextStyle.getTextStyle(
                            14,
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
                          ),
                        )
                      : const SizedBox(),
                  taskModel.endDate != null
                      ? Text(
                          ' - ${controller.dateFormat.format(taskModel.endDate!)}',
                          style: GetTextStyle.getTextStyle(
                            14,
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
                      size: 25,
                    ),
                  ),
                  SizedBox(
                    width: UtilsReponsive.width(10, context),
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
                        14,
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
          "endDate": controller.listTask[index].endDate
        });
      },
      child: Padding(
        padding: UtilsReponsive.paddingAll(context, padding: 5),
        child: Container(
          // margin: EdgeInsets.only(bottom: UtilsReponsive.height(15, context)),
          width: double.infinity,
          // height: double.infinity,
          // padding: UtilsReponsive.paddingHorizontal(context, padding: 10),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(UtilsReponsive.height(5, context))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            // Container(
            //   width: double.infinity,
            //   height: UtilsReponsive.height(30, context),
            //   decoration: BoxDecoration(
            //     boxShadow: [
            //       BoxShadow(
            //         color: taskModel.status == 'DONE'
            //             ? Colors.green
            //             : taskModel.status == 'INPROGRESS'
            //                 ? Colors.blue
            //                 : Colors.red, // Màu của đổ bóng
            //         spreadRadius: 0.5, // Độ dài của đổ bóng
            //         blurRadius: 7, // Độ mờ của đổ bóng
            //         offset: Offset(0, 3), // Độ tịnh tiến của đổ bóng
            //       ),
            //     ],
            //     color: taskModel.status == 'DONE'
            //         ? Colors.green.withOpacity(0.7)
            //         : taskModel.status == 'INPROGRESS'
            //             ? Colors.blue.withOpacity(0.7)
            //             : Colors.red.withOpacity(0.7),
            //     // borderRadius: BorderRadius.circular(
            //     //     UtilsReponsive.height(5, context))),
            //   ),
            //   child: Center(
            //       child: Text(taskModel.status.toString(),
            //           style: TextStyle(
            //               fontFamily: 'Roboto',
            //               letterSpacing: 1.2,
            //               color: Colors.white,
            //               fontSize: UtilsReponsive.height(14, context),
            //               fontWeight: FontWeight.bold))),
            // ),

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
                                  taskModel.title!.length > 28
                                      ? '${taskModel.title!.substring(0, 28)}...'
                                      : taskModel.title!,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    letterSpacing: 1.5,
                                    color: ColorsManager.textColor,
                                    fontSize:
                                        UtilsReponsive.height(16, context),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              : Text(
                                  taskModel.title!.length > 28
                                      ? '${taskModel.title!.substring(0, 28)}...'
                                      : taskModel.title!,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 1.5,
                                      color: ColorsManager.textColor,
                                      fontSize:
                                          UtilsReponsive.height(16, context),
                                      fontWeight: FontWeight.bold),
                                ),
                          SizedBox(
                            height: UtilsReponsive.height(10, context),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: ColorsManager.calendar,
                                  radius: UtilsReponsive.height(15, context),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                    size: 15,
                                  )),
                              SizedBox(
                                width: UtilsReponsive.width(10, context),
                              ),
                              taskModel.endDate == null
                                  ? Text(
                                      'Hạn hoàn thành',
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontFamily: 'Roboto',
                                          color: ColorsManager.textColor2,
                                          fontSize: UtilsReponsive.height(
                                              16, context),
                                          fontWeight: FontWeight.bold),
                                    )
                                  : taskModel.startDate != null &&
                                          taskModel.endDate != null
                                      ? Text(
                                          " ${controller.dateFormat.format(taskModel.startDate!)} - ${controller.dateFormat.format(taskModel.endDate!)}",
                                          style: GetTextStyle.getTextStyle(
                                            14,
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
                                                14,
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
                                                    14,
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
                            height: UtilsReponsive.height(10, context),
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
                                              : taskModel.status! ==
                                                      Status.OVERDUE
                                                  ? ColorsManager.red
                                                  : Colors.purpleAccent,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(10, context),
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
                                    14,
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
                              CircleAvatar(
                                radius: UtilsReponsive.height(20, context),
                                backgroundColor: Colors
                                    .transparent, // Đảm bảo nền trong suốt
                                child: ClipOval(
                                  child: Image.network(
                                    taskModel
                                        .assignTasks![0].user!.profile!.avatar!,
                                    fit: BoxFit.cover,
                                    width: UtilsReponsive.widthv2(context, 45),
                                    height:
                                        UtilsReponsive.heightv2(context, 50),
                                  ),
                                ),
                              ),
                              Container(
                                width: UtilsReponsive.height(30, context),
                                height: UtilsReponsive.height(30, context),
                                decoration: const BoxDecoration(
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
                                CircleAvatar(
                                  radius: UtilsReponsive.height(18, context),
                                  backgroundColor: Colors
                                      .transparent, // Đảm bảo nền trong suốt
                                  child: ClipOval(
                                    child: Image.network(
                                      taskModel.assignTasks![0].user!.profile!
                                          .avatar!,
                                      fit: BoxFit.cover,
                                      width:
                                          UtilsReponsive.widthv2(context, 45),
                                      height:
                                          UtilsReponsive.heightv2(context, 50),
                                    ),
                                  ),
                                ),
                              ])
                            : Row(
                                children: [
                                  SizedBox(
                                    width: UtilsReponsive.width(20, context),
                                  ),
                                  CircleAvatar(
                                    radius: UtilsReponsive.height(18, context),
                                    backgroundColor: ColorsManager
                                        .textColor2, // Đảm bảo nền trong suốt
                                    child: ClipOval(
                                      child: Image.network(
                                        "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                        fit: BoxFit.cover,
                                        width:
                                            UtilsReponsive.widthv2(context, 25),
                                        height: UtilsReponsive.heightv2(
                                            context, 30),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                  ),
                ],
              ),
              // taskModel.taskFiles!.isEmpty
              //     ? SizedBox(
              //         height: UtilsReponsive.height(30, context),
              //       )
              //     : SizedBox(
              //         height: UtilsReponsive.height(150, context),
              //         child: CachedNetworkImage(
              //           fit: BoxFit.fill,
              //           imageUrl: taskModel.taskFiles![0].toString(),
              //           progressIndicatorBuilder:
              //               (context, url, downloadProgress) => Container(
              //             padding: EdgeInsets.all(
              //                 UtilsReponsive.height(10, context)),
              //             height: UtilsReponsive.height(20, context),
              //             width: UtilsReponsive.height(20, context),
              //             child: CircularProgressIndicator(
              //               color: ColorsManager.primary,
              //             ),
              //           ),
              //           errorWidget: (context, url, error) => Icon(Icons.error),
              //         ),
              //       ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     const Icon(
              //       Icons.account_tree_rounded,
              //       color: Colors.grey,
              //       size: 15,
              //     ),
              //     SizedBox(
              //       width: UtilsReponsive.width(5, context),
              //     ),
              //     Text('$index / $length')
              //   ],
              // ),
              // isLastItem != true
              //     ? Divider(
              //         color: ColorsManager.primary,
              //         thickness: 1,
              //       )
              //     : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
