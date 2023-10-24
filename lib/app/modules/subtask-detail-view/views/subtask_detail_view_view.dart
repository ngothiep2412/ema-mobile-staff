import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/subtask-detail-view/model/attachment_model.dart';
import 'package:hrea_mobile_staff/app/modules/subtask-detail-view/model/employee_model.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_staff/app/resources/assets_manager.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/form_field_widget.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:hrea_mobile_staff/app/utils/calculate_time_difference.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/subtask_detail_view_controller.dart';

class SubtaskDetailViewView extends BaseView<SubtaskDetailViewController> {
  const SubtaskDetailViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.backgroundContainer,
        appBar: _appBar(context),
        body: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: SpinKitFadingCircle(
                    color: ColorsManager.primary,
                    // size: 50.0,
                  ),
                )
              : Container(
                  height: double.infinity,
                  color: ColorsManager.backgroundContainer,
                  child: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: controller.refreshPage,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(
                              UtilsReponsive.height(15, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => _header(
                                    context: context,
                                    objectTask:
                                        controller.taskModel.value.title!),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(15, context),
                              ),
                              Obx(
                                () => Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Task con của ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          wordSpacing: 1.2,
                                          color: ColorsManager.textColor,
                                          fontSize: UtilsReponsive.height(
                                              18, context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${controller.taskModel.value.parent!.title}',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          wordSpacing: 1.2,
                                          color: Colors.blue, // Màu xanh
                                          fontSize: UtilsReponsive.height(
                                              18, context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(Routes.TASK_DETAIL_VIEW,
                                                arguments: {
                                                  "taskID": controller.taskModel
                                                      .value.parent!.id
                                                });
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(15, context),
                              ),
                              _statusBuilder(
                                taskID: controller.taskModel.value.id,
                                context: context,
                                objectStatusTask: controller
                                            .taskModel.value.status ==
                                        Status.PENDING
                                    ? "Đang kiểm thực"
                                    : controller.taskModel.value.status! ==
                                            Status.PROCESSING
                                        ? "Đang thực hiện"
                                        : controller.taskModel.value.status! ==
                                                Status.DONE
                                            ? "Hoàn thành"
                                            : controller.taskModel.value
                                                        .status! ==
                                                    Status.CONFIRM
                                                ? "Đã xác thực"
                                                : "Quá hạn",
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(15, context),
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    Icon(
                                      Icons.priority_high,
                                      color: ColorsManager.primary,
                                    ),
                                    controller.taskModel.value.priority == null
                                        ? priorityBuilder(
                                            context: context,
                                            objectStatusTask: "--",
                                            taskID:
                                                controller.taskModel.value.id!)
                                        : priorityBuilder(
                                            context: context,
                                            objectStatusTask: controller
                                                        .taskModel
                                                        .value
                                                        .priority! ==
                                                    Priority.LOW
                                                ? "Thấp"
                                                : controller.taskModel.value
                                                            .priority! ==
                                                        Priority.MEDIUM
                                                    ? "Trung bình"
                                                    : "Cao",
                                            taskID:
                                                controller.taskModel.value.id!)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(15, context),
                              ),
                              Obx(
                                () => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          UtilsReponsive.height(5, context),
                                      vertical:
                                          UtilsReponsive.height(10, context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showDateTimePicker(context,
                                          controller.taskModel.value.id!);
                                    },
                                    child: controller.taskModel.value.endDate !=
                                            null
                                        ? _timeBuilder(
                                            context: context,
                                            startTime: controller.dateFormat
                                                .format(controller.taskModel
                                                    .value.startDate!),
                                            endTime: controller.dateFormat
                                                .format(controller
                                                    .taskModel.value.endDate!))
                                        : Row(children: [
                                            const Icon(
                                              Icons.calendar_month,
                                              color: Color(0xffC2B280),
                                            ),
                                            SizedBox(
                                              width: UtilsReponsive.width(
                                                  15, context),
                                            ),
                                            Text(
                                              'Hạn hoàn thành',
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontFamily: 'Roboto',
                                                  color:
                                                      ColorsManager.textColor,
                                                  fontSize:
                                                      UtilsReponsive.height(
                                                          16, context),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: UtilsReponsive.width(10, context),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        UtilsReponsive.height(5, context),
                                    vertical:
                                        UtilsReponsive.height(10, context)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      // fit: BoxFit.contain,
                                      imageUrl: controller
                                          .taskModel.value.avatarAssigner!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                              width: UtilsReponsive.width(
                                                  40, context),
                                              height: UtilsReponsive.height(
                                                  45, context),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      spreadRadius: 0.5,
                                                      blurRadius: 0.5,
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                    )
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
                                        height:
                                            UtilsReponsive.height(5, context),
                                        width:
                                            UtilsReponsive.height(5, context),
                                        child: CircularProgressIndicator(
                                          color: ColorsManager.primary,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius:
                                            UtilsReponsive.height(20, context),
                                        child: Text(
                                          getTheAbbreviation(controller
                                              .taskModel.value.nameAssigner!),
                                          style: TextStyle(
                                              letterSpacing: 1.5,
                                              color: ColorsManager.textColor,
                                              fontSize: UtilsReponsive.height(
                                                  17, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: UtilsReponsive.width(10, context),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .taskModel
                                              .value
                                              .parent!
                                              .assignTasks![0]
                                              .user!
                                              .profile!
                                              .fullName!,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: ColorsManager.textColor,
                                              fontSize: UtilsReponsive.height(
                                                  17, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Người giao việc",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: ColorsManager.primary,
                                              fontSize: UtilsReponsive.height(
                                                  16, context),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: UtilsReponsive.width(10, context),
                              ),
                              Obx(
                                  () =>
                                      controller.taskModel.value.assignTasks!
                                              .isEmpty
                                          ? Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          UtilsReponsive.height(
                                                              5, context),
                                                      vertical:
                                                          UtilsReponsive.height(
                                                              10, context)),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await controller
                                                          .getAllEmployee();
                                                      _showBottomLeader(
                                                          context:
                                                              Get.context!);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CachedNetworkImage(
                                                              // fit: BoxFit.contain,
                                                              imageUrl:
                                                                  "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                              imageBuilder: (context,
                                                                      imageProvider) =>
                                                                  Container(
                                                                      width: UtilsReponsive.width(
                                                                          40,
                                                                          context),
                                                                      height: UtilsReponsive
                                                                          .height(
                                                                              45,
                                                                              context),
                                                                      decoration: BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 0.5,
                                                                            )
                                                                          ],
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: imageProvider))),
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      Container(
                                                                padding: EdgeInsets.all(
                                                                    UtilsReponsive
                                                                        .height(
                                                                            10,
                                                                            context)),
                                                                height: UtilsReponsive
                                                                    .height(5,
                                                                        context),
                                                                width: UtilsReponsive
                                                                    .height(5,
                                                                        context),
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: ColorsManager
                                                                      .primary,
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                            SizedBox(
                                                              width: UtilsReponsive
                                                                  .width(10,
                                                                      context),
                                                            ),
                                                            Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Người chịu trách nhiệm',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ColorsManager
                                                                            .primary,
                                                                        fontSize: UtilsReponsive.height(
                                                                            16,
                                                                            context),
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ])
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: UtilsReponsive.width(
                                                      10, context),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          UtilsReponsive.height(
                                                              5, context),
                                                      vertical:
                                                          UtilsReponsive.height(
                                                              10, context)),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if (controller
                                                          .taskModel
                                                          .value
                                                          .assignTasks!
                                                          .isEmpty) {
                                                        Get.snackbar('Lỗi',
                                                            'Xin vui lòng chọn Người chịu trách nhiệm trước',
                                                            snackPosition:
                                                                SnackPosition
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            colorText:
                                                                Colors.white);
                                                      } else {
                                                        await controller
                                                            .getEmployeeSupport();
                                                        _showBottomAddMore(
                                                            context:
                                                                Get.context!);
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CachedNetworkImage(
                                                              // fit: BoxFit.contain,
                                                              imageUrl:
                                                                  "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                              imageBuilder: (context,
                                                                      imageProvider) =>
                                                                  Container(
                                                                      width: UtilsReponsive.width(
                                                                          40,
                                                                          context),
                                                                      height: UtilsReponsive
                                                                          .height(
                                                                              45,
                                                                              context),
                                                                      decoration: BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 0.5,
                                                                            )
                                                                          ],
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: imageProvider))),
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      Container(
                                                                padding: EdgeInsets.all(
                                                                    UtilsReponsive
                                                                        .height(
                                                                            10,
                                                                            context)),
                                                                height: UtilsReponsive
                                                                    .height(5,
                                                                        context),
                                                                width: UtilsReponsive
                                                                    .height(5,
                                                                        context),
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: ColorsManager
                                                                      .primary,
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                            SizedBox(
                                                              width: UtilsReponsive
                                                                  .width(10,
                                                                      context),
                                                            ),
                                                            Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Những người tham gia khác',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ColorsManager
                                                                            .primary,
                                                                        fontSize: UtilsReponsive.height(
                                                                            16,
                                                                            context),
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ])
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : controller.taskModel.value
                                                      .assignTasks!.length >
                                                  1
                                              ? Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              UtilsReponsive
                                                                  .height(5,
                                                                      context),
                                                          vertical:
                                                              UtilsReponsive
                                                                  .height(10,
                                                                      context)),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await controller
                                                                  .getAllEmployee();
                                                              _showBottomLeader(
                                                                  context: Get
                                                                      .context!);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                CachedNetworkImage(
                                                                  // fit: BoxFit.contain,
                                                                  imageUrl: controller
                                                                      .taskModel
                                                                      .value
                                                                      .assignTasks![
                                                                          0]
                                                                      .user!
                                                                      .profile!
                                                                      .avatar!,
                                                                  imageBuilder: (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                          width: UtilsReponsive.width(
                                                                              40,
                                                                              context),
                                                                          height: UtilsReponsive.height(
                                                                              45,
                                                                              context),
                                                                          decoration: BoxDecoration(
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  spreadRadius: 0.5,
                                                                                  blurRadius: 0.5,
                                                                                  color: Colors.black.withOpacity(0.1),
                                                                                )
                                                                              ],
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                                                  progressIndicatorBuilder: (context,
                                                                          url,
                                                                          downloadProgress) =>
                                                                      Container(
                                                                    padding: EdgeInsets.all(
                                                                        UtilsReponsive.height(
                                                                            10,
                                                                            context)),
                                                                    height: UtilsReponsive
                                                                        .height(
                                                                            5,
                                                                            context),
                                                                    width: UtilsReponsive
                                                                        .height(
                                                                            5,
                                                                            context),
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: ColorsManager
                                                                          .primary,
                                                                    ),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      CircleAvatar(
                                                                    radius: UtilsReponsive
                                                                        .height(
                                                                            20,
                                                                            context),
                                                                    child: Text(
                                                                      getTheAbbreviation(controller
                                                                          .taskModel
                                                                          .value
                                                                          .assignTasks![
                                                                              0]
                                                                          .user!
                                                                          .profile!
                                                                          .fullName!),
                                                                      style: TextStyle(
                                                                          letterSpacing:
                                                                              1.5,
                                                                          color: ColorsManager
                                                                              .primary,
                                                                          fontSize: UtilsReponsive.height(
                                                                              17,
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: UtilsReponsive
                                                                      .width(10,
                                                                          context),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      controller
                                                                          .taskModel
                                                                          .value
                                                                          .assignTasks![
                                                                              0]
                                                                          .user!
                                                                          .profile!
                                                                          .fullName!,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ColorsManager
                                                                              .textColor,
                                                                          fontSize: UtilsReponsive.height(
                                                                              17,
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      'Người chịu trách nhiệm',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ColorsManager
                                                                              .primary,
                                                                          fontSize: UtilsReponsive.height(
                                                                              16,
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          UtilsReponsive.height(
                                                              10, context),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              UtilsReponsive
                                                                  .height(5,
                                                                      context),
                                                          vertical:
                                                              UtilsReponsive
                                                                  .height(10,
                                                                      context)),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await controller
                                                                  .getEmployeeSupportView();
                                                              _showBottomAssign(
                                                                  context: Get
                                                                      .context!);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                controller
                                                                            .taskModel
                                                                            .value
                                                                            .assignTasks!
                                                                            .length ==
                                                                        1
                                                                    ? CircleAvatar(
                                                                        radius: UtilsReponsive.height(
                                                                            20,
                                                                            context),
                                                                        backgroundColor:
                                                                            Colors.transparent, // Đảm bảo nền trong suốt
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              Image.network(
                                                                            "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                UtilsReponsive.widthv2(context, 45),
                                                                            height:
                                                                                UtilsReponsive.heightv2(context, 40),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        // fit: BoxFit.contain,
                                                                        imageUrl: controller
                                                                            .taskModel
                                                                            .value
                                                                            .assignTasks![1]
                                                                            .user!
                                                                            .profile!
                                                                            .avatar!,
                                                                        imageBuilder: (context, imageProvider) => Container(
                                                                            width: UtilsReponsive.width(40, context),
                                                                            height: UtilsReponsive.height(45, context),
                                                                            decoration: BoxDecoration(boxShadow: [
                                                                              BoxShadow(
                                                                                spreadRadius: 0.5,
                                                                                blurRadius: 0.5,
                                                                                color: Colors.black.withOpacity(0.1),
                                                                              )
                                                                            ], shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                                                        progressIndicatorBuilder: (context,
                                                                                url,
                                                                                downloadProgress) =>
                                                                            Container(
                                                                          padding: EdgeInsets.all(UtilsReponsive.height(
                                                                              10,
                                                                              context)),
                                                                          height: UtilsReponsive.height(
                                                                              5,
                                                                              context),
                                                                          width: UtilsReponsive.height(
                                                                              5,
                                                                              context),
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                ColorsManager.primary,
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            CircleAvatar(
                                                                          radius: UtilsReponsive.height(
                                                                              20,
                                                                              context),
                                                                          child:
                                                                              Text(
                                                                            getTheAbbreviation(controller.taskModel.value.assignTasks![1].user!.profile!.fullName!),
                                                                            style: TextStyle(
                                                                                letterSpacing: 1.5,
                                                                                color: ColorsManager.primary,
                                                                                fontSize: UtilsReponsive.height(17, context),
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                SizedBox(
                                                                  width: UtilsReponsive
                                                                      .width(10,
                                                                          context),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    controller.taskModel.value.assignTasks!.length ==
                                                                            1
                                                                        ? SizedBox()
                                                                        : Text(
                                                                            controller.taskModel.value.assignTasks![1].user!.profile!.fullName!,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Roboto',
                                                                                color: ColorsManager.textColor,
                                                                                fontSize: UtilsReponsive.height(17, context),
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                    controller.taskModel.value.assignTasks!.length >=
                                                                            3
                                                                        ? Text(
                                                                            "${controller.taskModel.value.assignTasks![1].user!.profile!.fullName!.split(' ').last} và ${controller.taskModel.value.assignTasks!.length - 1} thành viên",
                                                                            style: TextStyle(
                                                                                fontFamily: 'Roboto',
                                                                                color: ColorsManager.primary,
                                                                                fontSize: UtilsReponsive.height(16, context),
                                                                                fontWeight: FontWeight.w600),
                                                                          )
                                                                        : Text(
                                                                            'Những người tham gia khác',
                                                                            style: TextStyle(
                                                                                fontFamily: 'Roboto',
                                                                                color: ColorsManager.primary,
                                                                                fontSize: UtilsReponsive.height(16, context),
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              if (controller
                                                                  .taskModel
                                                                  .value
                                                                  .assignTasks!
                                                                  .isEmpty) {
                                                                Get.snackbar(
                                                                    'Lỗi',
                                                                    'Xin vui lòng chọn Người chịu trách nhiệm trước',
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .redAccent,
                                                                    colorText:
                                                                        Colors
                                                                            .white);
                                                              } else {
                                                                await controller
                                                                    .getEmployeeSupport();
                                                                _showBottomAddMore(
                                                                    context: Get
                                                                        .context!);
                                                              }
                                                            },
                                                            child: Text(
                                                              "Thêm người",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ColorsManager
                                                                      .primary,
                                                                  fontSize: UtilsReponsive
                                                                      .height(
                                                                          17,
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              UtilsReponsive
                                                                  .height(5,
                                                                      context),
                                                          vertical:
                                                              UtilsReponsive
                                                                  .height(10,
                                                                      context)),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await controller
                                                                  .getAllEmployee();
                                                              // controller.listEmployeeChoose
                                                              //     .value = [];
                                                              _showBottomLeader(
                                                                  context: Get
                                                                      .context!);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                CachedNetworkImage(
                                                                  // fit: BoxFit.contain,
                                                                  imageUrl: controller
                                                                      .taskModel
                                                                      .value
                                                                      .assignTasks![
                                                                          0]
                                                                      .user!
                                                                      .profile!
                                                                      .avatar!,
                                                                  imageBuilder: (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                          width: UtilsReponsive.width(
                                                                              40,
                                                                              context),
                                                                          height: UtilsReponsive.height(
                                                                              45,
                                                                              context),
                                                                          decoration: BoxDecoration(
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  spreadRadius: 0.5,
                                                                                  blurRadius: 0.5,
                                                                                  color: Colors.black.withOpacity(0.1),
                                                                                )
                                                                              ],
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                                                  progressIndicatorBuilder: (context,
                                                                          url,
                                                                          downloadProgress) =>
                                                                      Container(
                                                                    padding: EdgeInsets.all(
                                                                        UtilsReponsive.height(
                                                                            10,
                                                                            context)),
                                                                    height: UtilsReponsive
                                                                        .height(
                                                                            5,
                                                                            context),
                                                                    width: UtilsReponsive
                                                                        .height(
                                                                            5,
                                                                            context),
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: ColorsManager
                                                                          .primary,
                                                                    ),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      CircleAvatar(
                                                                    radius: UtilsReponsive
                                                                        .height(
                                                                            20,
                                                                            context),
                                                                    child: Text(
                                                                      getTheAbbreviation(controller
                                                                          .taskModel
                                                                          .value
                                                                          .assignTasks![
                                                                              0]
                                                                          .user!
                                                                          .profile!
                                                                          .fullName!),
                                                                      style: TextStyle(
                                                                          letterSpacing:
                                                                              1.5,
                                                                          color: ColorsManager
                                                                              .primary,
                                                                          fontSize: UtilsReponsive.height(
                                                                              17,
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: UtilsReponsive
                                                                      .width(10,
                                                                          context),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      controller
                                                                          .taskModel
                                                                          .value
                                                                          .assignTasks![
                                                                              0]
                                                                          .user!
                                                                          .profile!
                                                                          .fullName!,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ColorsManager
                                                                              .textColor,
                                                                          fontSize: UtilsReponsive.height(
                                                                              17,
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      'Người chịu trách nhiệm',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ColorsManager
                                                                              .primary,
                                                                          fontSize: UtilsReponsive.height(
                                                                              16,
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          UtilsReponsive.height(
                                                              10, context),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              UtilsReponsive
                                                                  .height(5,
                                                                      context),
                                                          vertical:
                                                              UtilsReponsive
                                                                  .height(10,
                                                                      context)),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (controller
                                                                  .taskModel
                                                                  .value
                                                                  .assignTasks!
                                                                  .isEmpty) {
                                                                Get.snackbar(
                                                                    'Lỗi',
                                                                    'Xin vui lòng chọn Người chịu trách nhiệm trước',
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .redAccent,
                                                                    colorText:
                                                                        Colors
                                                                            .white);
                                                              } else {
                                                                await controller
                                                                    .getEmployeeSupport();
                                                                _showBottomAddMore(
                                                                    context: Get
                                                                        .context!);
                                                              }
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    CachedNetworkImage(
                                                                      // fit: BoxFit.contain,
                                                                      imageUrl:
                                                                          "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                          width: UtilsReponsive.width(40, context),
                                                                          height: UtilsReponsive.height(45, context),
                                                                          decoration: BoxDecoration(boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 0.5,
                                                                            )
                                                                          ], shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Container(
                                                                        padding: EdgeInsets.all(UtilsReponsive.height(
                                                                            10,
                                                                            context)),
                                                                        height: UtilsReponsive.height(
                                                                            5,
                                                                            context),
                                                                        width: UtilsReponsive.height(
                                                                            5,
                                                                            context),
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              ColorsManager.primary,
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                    ),
                                                                    SizedBox(
                                                                      width: UtilsReponsive
                                                                          .width(
                                                                              10,
                                                                              context),
                                                                    ),
                                                                    Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize
                                                                                .min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Những người tham gia khác',
                                                                            style: TextStyle(
                                                                                fontFamily: 'Roboto',
                                                                                color: ColorsManager.primary,
                                                                                fontSize: UtilsReponsive.height(16, context),
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ])
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                              SizedBox(
                                height: UtilsReponsive.height(10, context),
                              ),
                              Obx(() => _description(context)),
                              SizedBox(
                                height: UtilsReponsive.height(15, context),
                              ),
                              _documentV2(context),
                              SizedBox(
                                height: UtilsReponsive.height(15, context),
                              ),
                              _commentList(context),
                              Obx(
                                () => SizedBox(
                                  height: controller.filePicker.isNotEmpty
                                      ? UtilsReponsive.height(70 + 200, context)
                                      : UtilsReponsive.height(70, context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Obx(
                          () => controller.filePicker.isNotEmpty
                              ? Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorsManager.textColor,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            UtilsReponsive.height(170, context),
                                        padding: EdgeInsets.all(
                                            UtilsReponsive.height(10, context)),
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              controller.filePicker.length,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                  width: UtilsReponsive.width(
                                                      15, context)),
                                          itemBuilder: (context, index) {
                                            return attchfileComment(
                                                controller.filePicker[index],
                                                context,
                                                index);
                                          },
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) => {
                                          controller.commentController.text =
                                              value
                                        },
                                        controller:
                                            controller.commentController,
                                        focusNode: controller.focusNodeComment,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                        minLines: 1,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                              onPressed: () async {
                                                await controller
                                                    .selectFileComment();
                                              },
                                              icon: const Icon(
                                                  Icons.attach_file_outlined)),
                                          suffixIcon: IconButton(
                                              onPressed: () async {
                                                await controller
                                                    .createComment();
                                              },
                                              icon: const Icon(
                                                  Icons.double_arrow_sharp)),
                                          contentPadding: EdgeInsets.all(
                                              UtilsReponsive.width(
                                                  15, context)),
                                          hintText: 'Nhập bình luận',
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .grey), // Màu gạch dưới khi TextField được chọn
                                          ),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .grey), // Màu gạch dưới khi TextField không được chọn
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      TextField(
                                        onChanged: (value) => {
                                          controller.commentController.text =
                                              value
                                        },
                                        controller:
                                            controller.commentController,
                                        focusNode: controller.focusNodeComment,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                        minLines: 1,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                              onPressed: () async {
                                                await controller
                                                    .selectFileComment();
                                              },
                                              icon: const Icon(
                                                Icons.attach_file_outlined,
                                              )),
                                          suffixIcon: IconButton(
                                              onPressed: () async {
                                                await controller
                                                    .createComment();
                                              },
                                              icon: const Icon(
                                                  Icons.double_arrow_sharp)),
                                          contentPadding: EdgeInsets.all(
                                              UtilsReponsive.width(
                                                  15, context)),
                                          hintText: 'Nhập bình luận',
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .grey), // Màu gạch dưới khi TextField được chọn
                                          ),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .grey), // Màu gạch dưới khi TextField không được chọn
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }

  Container _header(
      {required BuildContext context, required String objectTask}) {
    return Container(
      padding: UtilsReponsive.paddingAll(context, padding: 5),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Thay đổi tiêu đề task',
                        style: GetTextStyle.getTextStyle(18, 'Roboto',
                            FontWeight.w500, ColorsManager.primary),
                      ),
                      content: TextField(
                        onChanged: (value) =>
                            {controller.titleSubTaskController.text = value},
                        controller: controller.titleSubTaskController,
                      ),
                      actions: [
                        TextButton(
                          child: Text('Hủy',
                              style: GetTextStyle.getTextStyle(16, 'Roboto',
                                  FontWeight.w500, ColorsManager.primary)),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Lưu',
                              style: GetTextStyle.getTextStyle(16, 'Roboto',
                                  FontWeight.w500, ColorsManager.primary)),
                          onPressed: () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            await controller.updateTitleTask(
                                controller.titleSubTaskController.text,
                                controller.taskModel.value.id!);
                            // Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                objectTask,
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontFamily: 'Roboto',
                    color: ColorsManager.textColor,
                    fontSize: UtilsReponsive.height(24, context),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBuilder(
      {required BuildContext context,
      required String objectStatusTask,
      required taskID}) {
    return GestureDetector(
      onTap: () {
        _showBottomSheetStatus(context, taskID);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UtilsReponsive.width(10, context),
            vertical: UtilsReponsive.width(5, context)),
        decoration: BoxDecoration(
          color: controller.taskModel.value.status == Status.PENDING
              ? Colors.grey.withOpacity(0.8)
              : controller.taskModel.value.status! == Status.PROCESSING
                  ? ColorsManager.primary
                  : controller.taskModel.value.status! == Status.DONE
                      ? ColorsManager.green
                      : ColorsManager.red,
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(8, context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              objectStatusTask,
              style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontSize: UtilsReponsive.height(16, context),
                  fontWeight: FontWeight.bold),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheetStatus(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          "Đang kiểm thực",
          "Đang thực hiện",
          "Hoàn thành",
          "Đã xác thực",
          "Quá hạn",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () {
                  if (e == "Đang kiểm thực") {
                    controller.updateStatusTask("PENDING", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Đang thực hiện") {
                    controller.updateStatusTask("PROCESSING", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Hoàn thành") {
                    controller.updateStatusTask("DONE", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Đã xác thực") {
                    controller.updateStatusTask("CONFIRM", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Quá hạn") {
                    controller.updateStatusTask("OVERDUE", taskID);
                    Navigator.of(context).pop();
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Đang kiểm thực"
                          ? Colors.grey.withOpacity(0.8)
                          : e == "Đang thực hiện"
                              ? ColorsManager.primary
                              : e == "Hoàn thành"
                                  ? ColorsManager.green
                                  : e == "Đã xác thực"
                                      ? Colors.purpleAccent
                                      : ColorsManager.red,
                      child: Text(e[0],
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontSize: UtilsReponsive.height(16, context),
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(16, context),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }

  Widget priorityBuilder(
      {required BuildContext context,
      required String objectStatusTask,
      required String taskID}) {
    return GestureDetector(
      onTap: () {
        _showBottomSheetPriority(context, taskID);
      },
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: UtilsReponsive.width(10, context),
              vertical: UtilsReponsive.height(2, context)),
          decoration: controller.taskModel.value.priority != null
              ? BoxDecoration(
                  color: controller.taskModel.value.priority! == Priority.LOW
                      ? Colors.grey.withOpacity(0.8)
                      : controller.taskModel.value.priority! == Priority.MEDIUM
                          ? ColorsManager.orange
                          : ColorsManager.red,
                  borderRadius:
                      BorderRadius.circular(UtilsReponsive.height(5, context)),
                )
              : BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  borderRadius:
                      BorderRadius.circular(UtilsReponsive.height(5, context)),
                ),
          margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.taskModel.value.priority != null
                  ? Text(
                      objectStatusTask,
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      '--',
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.bold),
                    ),
              controller.taskModel.value.priority != null
                  ? const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.white,
                    )
                  : SizedBox()
            ],
          )),
    );
  }

  void _showBottomSheetPriority(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          "Thấp",
          "Trung bình",
          "Cao",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () {
                  if (e == "Thấp") {
                    controller.updatePriority("LOW", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Trung bình") {
                    controller.updatePriority("MEDIUM", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Cao") {
                    controller.updatePriority("HIGH", taskID);
                    Navigator.of(context).pop();
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Thấp"
                          ? Colors.grey
                          : e == "Trung bình"
                              ? ColorsManager.orange
                              : ColorsManager.red,
                      child: Text(e[0],
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontSize: UtilsReponsive.height(16, context),
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          color: ColorsManager.textColor2,
                          fontSize: UtilsReponsive.height(16, context),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }

  Row _timeBuilder(
      {required BuildContext context,
      required String startTime,
      required String endTime}) {
    return Row(
      children: [
        const Icon(
          size: 25,
          Icons.calendar_month,
          color: Color(0xffC2B280),
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
            '$startTime ${getCurrentTime(controller.taskModel.value.startDate!)} - $endTime ${getCurrentTime(controller.taskModel.value.endDate!)}',
            style: TextStyle(
                letterSpacing: 1.5,
                fontFamily: 'Roboto',
                color: controller.taskModel.value.status == Status.PENDING
                    ? Colors.grey.withOpacity(0.8)
                    : controller.taskModel.value.status! == Status.PROCESSING
                        ? ColorsManager.primary
                        : controller.taskModel.value.status! == Status.DONE
                            ? ColorsManager.green
                            : controller.taskModel.value.status! ==
                                    Status.CONFIRM
                                ? Colors.purpleAccent
                                : ColorsManager.red,
                fontSize: UtilsReponsive.height(17, context),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
      context: context,
      currentDate: DateTime.now().toUtc().add(const Duration(hours: 7)),
      initialDate: controller.taskModel.value.endDate ??
          DateTime.now().toUtc().add(const Duration(hours: 7)),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTimeStartDate(BuildContext context) => showTimePicker(
      context: context,
      cancelText: 'Hủy chọn giờ bắt đầu',
      initialTime: TimeOfDay(
          hour: controller.taskModel.value.endDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).hour
              : controller.taskModel.value.endDate!.hour,
          minute: controller.taskModel.value.endDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).minute
              : controller.taskModel.value.endDate!.minute));

  Future<TimeOfDay?> pickTimeEndDate(BuildContext context) => showTimePicker(
      context: context,
      cancelText: 'Hủy chọn giờ kết thúc',
      initialTime: TimeOfDay(
          hour: controller.taskModel.value.endDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).hour
              : controller.taskModel.value.endDate!.hour,
          minute: controller.taskModel.value.endDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).minute
              : controller.taskModel.value.endDate!.minute));

  _showBottomLeader({required BuildContext context}) {
    Get.bottomSheet(Container(
      height: UtilsReponsive.height(400, context),
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: UtilsReponsive.width(15, context),
          vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(20, context)),
            topRight: Radius.circular(UtilsReponsive.height(20, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: ColorsManager.backgroundGrey,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: ColorsManager.primary), // Màu của border
                ),
                child: TextFormField(
                  // controller: controller.textSearchController,
                  decoration: InputDecoration(
                    // contentPadding: UtilsReponsive.paddingAll(context,
                    //     padding: 2), // Điều chỉnh padding cho icon và text
                    icon: Padding(
                      padding: const EdgeInsets.only(
                          left:
                              8.0), // Điều chỉnh khoảng cách từ border đến icon
                      child: Icon(
                        Icons.search,
                        color: ColorsManager.primary,
                      ),
                    ),
                    hintText: 'Tìm kiếm', // Đặt hint text
                    border: InputBorder
                        .none, // Loại bỏ border bên trong TextFormField
                  ),
                  onChanged: (value) async {
                    await controller.searchEmployee(value);
                  },
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () async {
                      Get.back();
                      await controller.assignLeader(
                          controller.taskID,
                          controller.employeeLeader.value,
                          controller.employeeLeader.value.id!);
                    },
                    child: Text(
                      'Lưu',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          color: ColorsManager.primary,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(() {
            // controller.listEmployee;
            return controller.isLoadingFetchUser.value
                ? const Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Obx(
                    () => Expanded(
                      child: controller.listEmployee.isEmpty
                          ? Center(
                              child: Text(
                                'Không tìm thấy nhân viên',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    letterSpacing: 1.5,
                                    color: ColorsManager.textColor,
                                    fontSize:
                                        UtilsReponsive.height(16, context),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: controller.getAllEmployee,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.listEmployee.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height:
                                            UtilsReponsive.height(10, context),
                                      ),
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          // if (!controller.listEmployee[index].id .contains('a')) {
                                          //   controller.addData('a');
                                          // } else {
                                          //   controller.listEmployee.remove(text);
                                          // }
                                          // if (controller.employeeLeader.value.id !=
                                          //     controller.listEmployee[index].id) {
                                          //   controller.employeeLeader.value.id =
                                          //       controller.listEmployee[index].id;
                                          // } else {
                                          //   controller.employeeLeader.value =
                                          //       EmployeeModel();
                                          // }
                                          {
                                            // if (controller.listEmployeeChoose.length >
                                            //     1) {
                                            //   Get.snackbar('Lỗi',
                                            //       'Xin vui lòng chọn khoảng ngày hoàn thành trước',
                                            //       snackPosition: SnackPosition.BOTTOM,
                                            //       backgroundColor: Colors.redAccent,
                                            //       colorText: Colors.white);
                                            // }

                                            // if (!controller.listEmployeeChoose.contains(
                                            //         controller.listEmployee[index]) &&
                                            //     controller.listEmployeeChoose.isEmpty) {
                                            //   controller.listEmployeeChoose
                                            //       .add(controller.listEmployee[index]);
                                            //   print(
                                            //       '  controller.listEmployeeChoose ${controller.listEmployeeChoose.length}');
                                            // } else if (!controller.listEmployeeChoose
                                            //         .contains(
                                            //             controller.listEmployee[index]) &&
                                            //     controller
                                            //         .listEmployeeChoose.isNotEmpty) {
                                            //   controller.listEmployeeChoose.removeAt(0);
                                            //   controller.listEmployeeChoose
                                            //       .add(controller.listEmployee[index]);
                                            // } else {
                                            //   controller.listEmployeeChoose
                                            //       .remove(controller.listEmployee[index]);
                                            // }

                                            if (controller
                                                    .employeeLeader.value.id ==
                                                null) {
                                              controller.employeeLeader.value =
                                                  controller
                                                      .listEmployee[index];
                                            } else {
                                              if (!controller
                                                  .employeeLeader.value.id!
                                                  .contains(controller
                                                      .listEmployee[index]
                                                      .id!)) {
                                                // controller.listEmployeeChoose
                                                //     .add(controller.listEmployee[index]);
                                                controller
                                                        .employeeLeader.value =
                                                    controller
                                                        .listEmployee[index];
                                                print(
                                                    '  controller.listEmployeeChoose ${controller.listEmployeeChoose.length}');
                                              } else {
                                                controller.employeeLeader
                                                    .value = EmployeeModel();
                                              }
                                            }

                                            print(
                                                'controller.listEmployeeChoose ${controller.listEmployeeChoose.length}');
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: controller.employeeLeader
                                                            .value.id !=
                                                        null &&
                                                    controller.employeeLeader
                                                        .value.id!
                                                        .contains(controller
                                                            .listEmployee[index]
                                                            .id!)
                                                ? Colors.blue.shade100
                                                : Colors.white,
                                            border: Border.all(
                                              color: controller.employeeLeader
                                                              .value.id !=
                                                          null &&
                                                      controller.employeeLeader
                                                          .value.id!
                                                          .contains(controller
                                                              .listEmployee[
                                                                  index]
                                                              .id!)
                                                  ? Colors.white
                                                  : Colors.blue
                                                      .shade100, // Đặt màu border xung quanh Container
                                              width:
                                                  1.0, // Đặt độ dày của border
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius: UtilsReponsive.height(
                                                    20, context),
                                                backgroundColor: Colors
                                                    .transparent, // Đảm bảo nền trong suốt
                                                child: controller
                                                                .listEmployee[
                                                                    index]
                                                                .avatar ==
                                                            null ||
                                                        controller
                                                                .listEmployee[
                                                                    index]
                                                                .avatar ==
                                                            ''
                                                    ? ClipOval(
                                                        child: Image.network(
                                                          "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                          fit: BoxFit.cover,
                                                          width: UtilsReponsive
                                                              .widthv2(
                                                                  context, 60),
                                                          height: UtilsReponsive
                                                              .heightv2(
                                                                  context, 60),
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: Image.network(
                                                          controller
                                                              .listEmployee[
                                                                  index]
                                                              .avatar!,
                                                          fit: BoxFit.cover,
                                                          width: UtilsReponsive
                                                              .widthv2(
                                                                  context, 60),
                                                          height: UtilsReponsive
                                                              .heightv2(
                                                                  context, 60),
                                                        ),
                                                      )),
                                            title: Text(
                                              controller.listEmployee[index]
                                                  .fullName!,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  letterSpacing: 1.5,
                                                  color:
                                                      ColorsManager.textColor,
                                                  fontSize:
                                                      UtilsReponsive.height(
                                                          17, context),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Text(
                                              '${controller.listEmployee[index].email}',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  letterSpacing: 1.5,
                                                  color:
                                                      ColorsManager.textColor2,
                                                  fontSize:
                                                      UtilsReponsive.height(
                                                          15, context),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                    ),
                  );
          })
        ],
      ),
    ));
  }

  _showBottomAddMore({required BuildContext context}) {
    Get.bottomSheet(Container(
      height: UtilsReponsive.height(400, context),
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: UtilsReponsive.width(15, context),
          vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(20, context)),
            topRight: Radius.circular(UtilsReponsive.height(20, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: ColorsManager.backgroundGrey,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: ColorsManager.primary), // Màu của border
                ),
                child: TextFormField(
                  // controller: controller.textSearchController,
                  decoration: InputDecoration(
                    // contentPadding: UtilsReponsive.paddingAll(context,
                    //     padding: 2), // Điều chỉnh padding cho icon và text
                    icon: Padding(
                      padding: const EdgeInsets.only(
                          left:
                              8.0), // Điều chỉnh khoảng cách từ border đến icon
                      child: Icon(
                        Icons.search,
                        color: ColorsManager.primary,
                      ),
                    ),
                    hintText: 'Tìm kiếm', // Đặt hint text
                    border: InputBorder
                        .none, // Loại bỏ border bên trong TextFormField
                  ),
                  onChanged: (value) async {
                    await controller.searchEmployeeSupport(value);
                  },
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () async {
                      Get.back();
                      if (controller.employeeLeader.value.id == null ||
                          controller.employeeLeader.value.id == '') {
                        Get.snackbar('Lỗi',
                            'Xin vui lòng chọn Người chịu trách nhiệm trước',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                      } else {
                        await controller.assignSupporter(
                            controller.taskID,
                            controller.listEmployeeChoose,
                            controller.employeeLeader.value.id!);
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          color: ColorsManager.primary,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(() {
            // controller.listEmployee;
            return controller.isLoadingFetchUser.value
                ? const Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Obx(
                    () => Expanded(
                      child: controller.listEmployee.isEmpty
                          ? Center(
                              child: Text(
                                'Không tìm thấy nhân viên',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    letterSpacing: 1.5,
                                    color: Colors.black,
                                    fontSize:
                                        UtilsReponsive.height(16, context),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: controller.getEmployeeSupport,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.listEmployee.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height:
                                            UtilsReponsive.height(10, context),
                                      ),
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          // if (!controller.listEmployee[index].id .contains('a')) {
                                          //   controller.addData('a');
                                          // } else {
                                          //   controller.listEmployee.remove(text);
                                          // }
                                          // if (controller.employeeLeader.value.id !=
                                          //     controller.listEmployee[index].id) {
                                          //   controller.employeeLeader.value.id =
                                          //       controller.listEmployee[index].id;
                                          // } else {
                                          //   controller.employeeLeader.value =
                                          //       EmployeeModel();
                                          // }
                                          {
                                            // if (controller.listEmployeeChoose.length >
                                            //     1) {
                                            //   Get.snackbar('Lỗi',
                                            //       'Xin vui lòng chọn khoảng ngày hoàn thành trước',
                                            //       snackPosition: SnackPosition.BOTTOM,
                                            //       backgroundColor: Colors.redAccent,
                                            //       colorText: Colors.white);
                                            // }

                                            if (!controller.listEmployeeChoose
                                                .contains(controller
                                                    .listEmployee[index])) {
                                              controller.listEmployeeChoose.add(
                                                  controller
                                                      .listEmployee[index]);
                                            } else {
                                              controller.listEmployeeChoose
                                                  .remove(controller
                                                      .listEmployee[index]);
                                            }

                                            print(
                                                'controller.listEmployeeChoose ${controller.listEmployeeChoose.length}');
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: controller.listEmployeeChoose
                                                    .contains(controller
                                                        .listEmployee[index])
                                                ? Colors.blue.shade100
                                                : Colors.white,
                                            border: Border.all(
                                              color: controller
                                                      .listEmployeeChoose
                                                      .contains(controller
                                                          .listEmployee[index])
                                                  ? Colors.white
                                                  : Colors.blue
                                                      .shade100, // Đặt màu border xung quanh Container
                                              width:
                                                  1.0, // Đặt độ dày của border
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius: UtilsReponsive.height(
                                                    20, context),
                                                backgroundColor: Colors
                                                    .transparent, // Đảm bảo nền trong suốt
                                                child: controller
                                                                .listEmployee[
                                                                    index]
                                                                .avatar ==
                                                            null ||
                                                        controller
                                                                .listEmployee[
                                                                    index]
                                                                .avatar ==
                                                            ''
                                                    ? ClipOval(
                                                        child: Image.network(
                                                          "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                          fit: BoxFit.cover,
                                                          width: UtilsReponsive
                                                              .widthv2(
                                                                  context, 60),
                                                          height: UtilsReponsive
                                                              .heightv2(
                                                                  context, 60),
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: Image.network(
                                                          controller
                                                              .listEmployee[
                                                                  index]
                                                              .avatar!,
                                                          fit: BoxFit.cover,
                                                          width: UtilsReponsive
                                                              .widthv2(
                                                                  context, 60),
                                                          height: UtilsReponsive
                                                              .heightv2(
                                                                  context, 60),
                                                        ),
                                                      )),
                                            title: Text(
                                              controller.listEmployee[index]
                                                  .fullName!,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  letterSpacing: 1.5,
                                                  color:
                                                      ColorsManager.textColor,
                                                  fontSize:
                                                      UtilsReponsive.height(
                                                          17, context),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              '${controller.listEmployee[index].email}',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  letterSpacing: 1.5,
                                                  color:
                                                      ColorsManager.textColor2,
                                                  fontSize:
                                                      UtilsReponsive.height(
                                                          15, context),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                    ),
                  );
          })
        ],
      ),
    ));
  }

  _showDateTimePicker(BuildContext context, String taskID) async {
    await Get.defaultDialog(
      confirm: TextButton(
          onPressed: () async {
            bool isErrorStartDate = true;
            bool isErrorEndDate = true;

            bool isStartDateCancel = false;
            bool isEndDateCancel = false;

            DateTime newStartDate =
                DateTime.now().toUtc().add(const Duration(hours: 7));
            DateTime newEndDate =
                DateTime.now().toUtc().add(const Duration(hours: 7));

            while (isErrorStartDate) {
              TimeOfDay? timeStartDate = await pickTimeStartDate(Get.context!);
              if (timeStartDate == null) {
                isStartDateCancel = true;
                return;
              }
              final newDate = DateTime(
                  controller.listChange.first!.year,
                  controller.listChange.first!.month,
                  controller.listChange.first!.day,
                  timeStartDate.hour,
                  timeStartDate.minute);
              newStartDate = newDate;

              if (newDate
                  .toLocal()
                  .isAfter(controller.startDateTaskParent.toLocal())) {
                Get.snackbar(
                  'Thông báo',
                  'Giờ bắt đầu của công việc nhỏ phải nhỏ hơn giờ bắt đầu ${controller.dateFormat.format(controller.startDateTaskParent.toLocal())} ${getCurrentTime(controller.startDateTaskParent.toLocal())} của công việc lớn',
                  snackPosition: SnackPosition.TOP,
                  margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                  backgroundColor: ColorsManager.backgroundGrey,
                  colorText: ColorsManager.textColor2,
                  duration: const Duration(seconds: 4),
                );

                isErrorStartDate = true;
              } else if (newDate
                  .toLocal()
                  .isAfter(controller.endDateTaskParent.toLocal())) {
                Get.snackbar(
                  'Thông báo',
                  'Giờ bắt đầu của công việc nhỏ phải nhỏ hơn giờ kết thúc ${controller.dateFormat.format(controller.endDateTaskParent.toLocal())} ${getCurrentTime(controller.endDateTaskParent.toLocal())} của công việc lớn',
                  snackPosition: SnackPosition.TOP,
                  margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                  backgroundColor: ColorsManager.backgroundGrey,
                  colorText: ColorsManager.textColor2,
                  duration: const Duration(seconds: 4),
                );
                isErrorEndDate = true;
              } else {
                isErrorStartDate = false;
              }
            }

            while (isErrorEndDate) {
              TimeOfDay? timeEndDate = await pickTimeEndDate(Get.context!);
              if (timeEndDate == null) {
                isEndDateCancel = true;
                return;
              }
              final newDate = DateTime(
                  controller.listChange.last!.year,
                  controller.listChange.last!.month,
                  controller.listChange.last!.day,
                  timeEndDate.hour,
                  timeEndDate.minute);
              newEndDate = newDate;

              if (newDate
                  .toLocal()
                  .isAfter(controller.endDateTaskParent.toLocal())) {
                Get.snackbar(
                  'Thông báo',
                  'Giờ kết thúc của công việc nhỏ phải nhỏ hơn giờ kết thúc ${controller.dateFormat.format(controller.endDateTaskParent.toLocal())} ${getCurrentTime(controller.endDateTaskParent.toLocal())} của công việc lớn',
                  snackPosition: SnackPosition.TOP,
                  margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                  backgroundColor: ColorsManager.backgroundGrey,
                  colorText: ColorsManager.textColor2,
                  duration: const Duration(seconds: 4),
                );
                isErrorEndDate = true;
              } else if (newStartDate.isAfter(newEndDate)) {
                Get.snackbar(
                  'Thông báo',
                  'Giờ kết thúc của công việc nhỏ phải lớn hơn giờ bắt đầu ${controller.dateFormat.format(newStartDate)} ${getCurrentTime(newStartDate)} của công việc nhỏ',
                  snackPosition: SnackPosition.TOP,
                  margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                  backgroundColor: ColorsManager.backgroundGrey,
                  colorText: ColorsManager.textColor2,
                  duration: const Duration(seconds: 4),
                );
                isErrorEndDate = true;
              } else {
                isErrorEndDate = false;
              }
            }

            if (isEndDateCancel == true || isStartDateCancel == true) {
              Get.back();
            }

            if (isErrorEndDate == false && isErrorEndDate == false) {
              controller.startDate.value = newStartDate;
              controller.endDate.value = newEndDate;
              Get.back();
              await controller.updateDateTime(
                  taskID, controller.startDate.value, controller.endDate.value);
              controller.errorUpdateSubTask.value
                  ? _errorMessage(context)
                  : _successMessage(context);
            }
          },
          child: Text(
            'Tiếp tục',
            style: TextStyle(
                fontFamily: 'Roboto',
                letterSpacing: 1.5,
                color: ColorsManager.primary,
                fontSize: UtilsReponsive.height(18, context),
                fontWeight: FontWeight.bold),
          )),
      title: 'Chọn ngày',
      content: Container(
        height: UtilsReponsive.height(300, context),
        width: UtilsReponsive.height(300, context),
        child: CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            currentDate: controller.endDateTaskParent
                .toUtc()
                .add(const Duration(hours: 7)),
            // firstDate: DateTime.now().toUtc().add(const Duration(hours: 7)),
            calendarType: CalendarDatePicker2Type.range,
            centerAlignModePicker: true,
            selectedDayTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
            selectedDayHighlightColor: Colors.blue,
          ),
          onValueChanged: (value) {
            controller.getTimeRange(value);
          },
          value: [controller.startDate.value, controller.endDate.value],
        ),
      ),
    );
  }

  _showBottomAssign({required BuildContext context}) {
    Get.bottomSheet(Container(
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(250, context)),
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: UtilsReponsive.width(15, context),
          vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(10, context)),
            topRight: Radius.circular(UtilsReponsive.height(10, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: controller.listEmployeeSupportView.length,
              separatorBuilder: (context, index) => SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors
                        .blue.shade100, // Đặt màu border xung quanh Container
                    width: 1.0, // Đặt độ dày của border
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                      radius: UtilsReponsive.height(20, context),
                      backgroundColor:
                          Colors.transparent, // Đảm bảo nền trong suốt
                      child: controller.listEmployeeSupportView[index].avatar ==
                                  null ||
                              controller
                                      .listEmployeeSupportView[index].avatar ==
                                  ''
                          ? ClipOval(
                              child: Image.network(
                                "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                fit: BoxFit.cover,
                                width: UtilsReponsive.widthv2(context, 60),
                                height: UtilsReponsive.heightv2(context, 60),
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                controller
                                    .listEmployeeSupportView[index].avatar!,
                                fit: BoxFit.cover,
                                width: UtilsReponsive.widthv2(context, 60),
                                height: UtilsReponsive.heightv2(context, 60),
                              ),
                            )),
                  title: Text(
                    controller.listEmployeeSupportView[index].fullName!,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        letterSpacing: 1.5,
                        color: ColorsManager.textColor,
                        fontSize: UtilsReponsive.height(17, context),
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${controller.listEmployeeSupportView[index].email}',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        letterSpacing: 1.5,
                        color: ColorsManager.textColor2,
                        fontSize: UtilsReponsive.height(15, context),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
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
      actions: [
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: ColorsManager.primary,
          ),
          onSelected: (choice) {
            if (choice == 'delete') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Xác nhận xóa',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            wordSpacing: 1.2,
                            color: ColorsManager.primary,
                            fontSize: UtilsReponsive.height(20, context),
                            fontWeight: FontWeight.bold)),
                    content: Text(
                      'Bạn có muốn xóa công việc này?',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          wordSpacing: 1.2,
                          color: ColorsManager.textColor2,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Xóa',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                wordSpacing: 1.2,
                                color: ColorsManager.red,
                                fontSize: UtilsReponsive.height(18, context),
                                fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          // Đóng hộp thoại mà không xóa
                          Navigator.of(context).pop();
                        },
                        child: Text('Hủy',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                wordSpacing: 1.2,
                                color: ColorsManager.primary,
                                fontSize: UtilsReponsive.height(18, context),
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                },
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Xóa công việc này',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      wordSpacing: 1.2,
                      color: ColorsManager.textColor2,
                      fontSize: UtilsReponsive.height(18, context),
                      fontWeight: FontWeight.w500),
                ),
              ),
              // Các mục menu khác nếu cần
            ];
          },
        ),
      ],
    );
  }

  Container _commentList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
      decoration: BoxDecoration(
          color: Colors.white,
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.white,
          //     spreadRadius: 0.5,
          //     blurRadius: 7,
          //     offset: Offset(0, 3),
          //   ),
          // ],
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(10, context))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: UtilsReponsive.height(10, context)),
            child: Text('Bình luận',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    wordSpacing: 1.2,
                    color: Colors.black,
                    fontSize: UtilsReponsive.height(18, context),
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(
            () => controller.listComment.isNotEmpty
                ? Container(
                    padding: EdgeInsets.only(
                        left: UtilsReponsive.height(10, context)),
                    margin: EdgeInsets.only(
                        top: UtilsReponsive.height(10, context)),
                    child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.listComment.length,
                        separatorBuilder: (context, index) => SizedBox(
                            height: UtilsReponsive.height(30, context)),
                        itemBuilder: (context, index) {
                          return comment(
                              controller.listComment[index], context);
                        }),
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context)
                          .requestFocus(controller.focusNodeComment);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              ImageAssets.comments,
                              fit: BoxFit.contain,
                              width: UtilsReponsive.widthv2(context, 100),
                              height: UtilsReponsive.heightv2(context, 120),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(10, context),
                            ),
                            Text(
                              'Để lại bình luận đầu tiên',
                              style: GetTextStyle.getTextStyle(14, 'Roboto',
                                  FontWeight.w500, ColorsManager.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  StatefulBuilder comment(CommentModel commentModel, BuildContext context) {
    bool isEditComment = false;
    return StatefulBuilder(
      builder: (context, setStateX) {
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: UtilsReponsive.height(20, context),
                      backgroundColor:
                          Colors.transparent, // Đảm bảo nền trong suốt
                      child: commentModel.user!.profile!.avatar == null ||
                              commentModel.user!.profile!.avatar == ''
                          ? ClipOval(
                              child: Image.network(
                                "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                fit: BoxFit.cover,
                                width: UtilsReponsive.widthv2(context, 60),
                                height: UtilsReponsive.heightv2(context, 60),
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                commentModel.user!.profile!.avatar!,
                                fit: BoxFit.cover,
                                width: UtilsReponsive.widthv2(context, 60),
                                height: UtilsReponsive.heightv2(context, 60),
                              ),
                            )),
                  SizedBox(width: UtilsReponsive.width(10, context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commentModel.user!.profile!.fullName!,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            letterSpacing: 1.5,
                            color: ColorsManager.textColor,
                            fontSize: UtilsReponsive.height(17, context),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: UtilsReponsive.width(5, context)),
                      Text(
                        calculateTimeDifference(
                            commentModel.createdAt.toString()),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            letterSpacing: 1,
                            color: ColorsManager.textColor,
                            fontSize: UtilsReponsive.height(14, context),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: UtilsReponsive.height(10, context)),
              commentModel.commentFiles!.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                          top: UtilsReponsive.height(8, context)),
                      height: UtilsReponsive.height(150, context),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: commentModel.commentFiles!.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: UtilsReponsive.width(15, context)),
                        itemBuilder: (context, index) {
                          return _filesComment(
                              commentModel.commentFiles![index],
                              context,
                              isEditComment);
                        },
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: UtilsReponsive.height(10, context)),
              isEditComment == true
                  ? Container(
                      constraints: BoxConstraints(
                          maxHeight: UtilsReponsive.height(300, context),
                          minHeight: UtilsReponsive.height(100, context)),
                      child: FormFieldWidget(
                        setValueFunc: (value) {},
                        maxLine: 4,
                        initValue: commentModel.text,
                      ),
                    )
                  : Text(
                      commentModel.text!,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1,
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w500),
                    ),
              SizedBox(height: UtilsReponsive.width(10, context)),
              isEditComment == false
                  ? Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setStateX(() {
                              isEditComment = true;
                            });
                          },
                          child: commentModel.user!.id == controller.idUser
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Chỉnh sửa',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        wordSpacing: 1.2,
                                        color: Colors.blue,
                                        fontSize:
                                            UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.bold),
                                  ))
                              : SizedBox(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        InkWell(
                            onTap: () {
                              setStateX(() {
                                isEditComment = false;
                              });
                            },
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Lưu',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      wordSpacing: 1.2,
                                      color: Colors.blue,
                                      fontSize:
                                          UtilsReponsive.height(18, context),
                                      fontWeight: FontWeight.bold),
                                ))),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              setStateX(() {
                                isEditComment = false;
                              });
                            },
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Hủy',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      wordSpacing: 1.2,
                                      color: Colors.blue,
                                      fontSize:
                                          UtilsReponsive.height(18, context),
                                      fontWeight: FontWeight.bold),
                                ))),
                      ],
                    )
            ],
          ),
        );
      },
    );
  }

  Obx _documentV2(BuildContext context) {
    return Obx(
      () => Container(
          // height: controller.listAttachment.isEmpty
          //     ? 50
          //     : UtilsReponsive.height(200, context),
          // padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(UtilsReponsive.height(10, context))),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                children: [
                  Text('Tài liệu',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          wordSpacing: 1.2,
                          color: Colors.black,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: UtilsReponsive.width(5, context),
                  ),
                  controller.listAttachment.isNotEmpty
                      ? CircleAvatar(
                          radius: UtilsReponsive.height(10, context),
                          child: Text(
                            controller.listAttachment.length.toString(),
                            style: TextStyle(
                                letterSpacing: 1.5,
                                color: ColorsManager.backgroundWhite,
                                fontSize: UtilsReponsive.height(15, context),
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              children: [
                controller.listAttachment.isEmpty
                    ? Container(
                        padding: EdgeInsets.only(
                            left: UtilsReponsive.height(20, context),
                            right: UtilsReponsive.height(15, context),
                            bottom: UtilsReponsive.height(10, context)),
                        // height: UtilsReponsive.height(120, context),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                await controller.selectFile();
                              },
                              child: Text(
                                '+  Thêm tệp',
                                style: GetTextStyle.getTextStyle(15, 'Roboto',
                                    FontWeight.w500, ColorsManager.primary),
                              ),
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
                            height: UtilsReponsive.height(120, context),
                            child: ListView.separated(
                              primary: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.listAttachment.length,
                              separatorBuilder: (context, index) => SizedBox(
                                  width: UtilsReponsive.width(10, context)),
                              itemBuilder: (context, index) {
                                return _files(
                                    controller.listAttachment[index], context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(10, context),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: UtilsReponsive.height(20, context),
                                right: UtilsReponsive.height(15, context),
                                bottom: UtilsReponsive.height(10, context)),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await controller.selectFile();
                                  },
                                  child: Text(
                                    '+  Thêm tệp',
                                    style: GetTextStyle.getTextStyle(
                                        15,
                                        'Roboto',
                                        FontWeight.w500,
                                        ColorsManager.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          )),
    );
  }

  void _showOptionsDocumentPopup(
      BuildContext context, AttachmentModel attachmentModel, int mode) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Xóa',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: ColorsManager.red),
                ),
                onTap: () {
                  if (mode != 2) {
                    _showDeleteDocumentConfirmation(
                        context, attachmentModel, _popupContext);
                  } else {
                    Get.snackbar(
                      'Thông báo',
                      'Bạn khổng thể xóa tệp tài liệu của bình luận',
                      snackPosition: SnackPosition.TOP,
                      margin:
                          UtilsReponsive.paddingAll(Get.context!, padding: 10),
                      backgroundColor: ColorsManager.backgroundGrey,
                      colorText: ColorsManager.textColor2,
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDocumentConfirmation(BuildContext context,
      AttachmentModel attachmentModel, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteTaskFile(attachmentModel);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: const Text(
                "Xóa",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsFileCommentPopup(
      BuildContext context, CommentFile commentFile) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Xóa',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteFileCommentConfirmation(
                      context, commentFile, _popupContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteFileCommentConfirmation(BuildContext context,
      CommentFile commentFile, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteCommentFile(commentFile);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: const Text(
                "Xóa",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsAttachmentCommentPopup(BuildContext context, int index) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Xóa',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmation(
                      context, index, _popupContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAttachmentCommentConfirmation(
      BuildContext context, int index, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteAttachmentCommentFile(index);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: const Text(
                "Xóa",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  InkWell attchfileComment(
      PlatformFile attachCommentFile, BuildContext context, int index) {
    final fileName = attachCommentFile.path!.split('/').last;
    final kb = attachCommentFile.size / 1024;
    final mb = kb / 1024;
    final fileSize =
        mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = attachCommentFile.extension;
    return InkWell(
      onTap: () {
        controller.openFile(attachCommentFile);
      },
      onLongPress: () {
        _showOptionsAttachmentCommentPopup(context, index);
      },
      child: extension == 'jpg' || extension == 'png' || extension == 'jpeg'
          ? Container(
              color: ColorsManager.backgroundGrey,
              width: UtilsReponsive.width(120, context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(attachCommentFile.path!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(120, context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        // child: Text('hiii'),
                        child: fileName.length > 35
                            ? Text(
                                fileName.length > 35
                                    ? '${fileName.substring(0, 35)}...'
                                    : fileName,
                                style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsManager.textColor),
                              )
                            : Text(
                                fileName,
                                style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsManager.textColor),
                              ),
                      ),
                      Expanded(
                          child: Text(
                        fileSize,
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorsManager.textColor2),
                      )),
                    ]),
              ),
            ),
    );
  }

  InkWell _filesComment(
      CommentFile commentFile, BuildContext context, bool isEditComment) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(commentFile.fileUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      onLongPress: () {
        if (isEditComment) {
          _showOptionsFileCommentPopup(context, commentFile);
        }
      },
      child: CachedNetworkImage(
        imageUrl: commentFile.fileUrl!,
        imageBuilder: (context, imageProvider) => Container(
            width: UtilsReponsive.width(110, context),
            padding: UtilsReponsive.paddingAll(context, padding: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image:
                    DecorationImage(fit: BoxFit.cover, image: imageProvider))),
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          height: UtilsReponsive.height(5, context),
          width: UtilsReponsive.height(5, context),
          child: CircularProgressIndicator(
            color: ColorsManager.primary,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.backgroundGrey,
          ),
          width: UtilsReponsive.width(120, context),
          padding: UtilsReponsive.paddingOnly(context,
              top: 10, left: 10, bottom: 5, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: commentFile.fileName!.length > 35
                  ? Text(
                      commentFile.fileName!.length > 35
                          ? '${commentFile.fileName!.substring(0, 35)}...'
                          : commentFile.fileName!,
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.textColor),
                    )
                  : Text(
                      commentFile.fileName!,
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.textColor),
                    ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Kích thước',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorsManager.textColor2),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  InkWell _files(AttachmentModel attachmentModel, BuildContext context) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(attachmentModel.fileUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      onLongPress: () {
        _showOptionsDocumentPopup(
            context, attachmentModel, attachmentModel.mode!);
      },
      child: CachedNetworkImage(
        imageUrl: attachmentModel.fileUrl!,
        imageBuilder: (context, imageProvider) => Container(
            width: UtilsReponsive.width(110, context),
            padding: UtilsReponsive.paddingAll(context, padding: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image:
                    DecorationImage(fit: BoxFit.cover, image: imageProvider))),
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          height: UtilsReponsive.height(5, context),
          width: UtilsReponsive.height(5, context),
          child: CircularProgressIndicator(
            color: ColorsManager.primary,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.backgroundGrey,
          ),
          width: UtilsReponsive.width(110, context),
          padding: UtilsReponsive.paddingOnly(context,
              top: 10, left: 10, bottom: 5, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 2,
              // child: Text('hiii'),
              child: attachmentModel.fileName!.length > 35
                  ? Text(
                      attachmentModel.fileName!.length > 35
                          ? '${attachmentModel.fileName!.substring(0, 35)}...'
                          : attachmentModel.fileName!,
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.textColor),
                    )
                  : Text(
                      attachmentModel.fileName!,
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.textColor),
                    ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Kích thước',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorsManager.textColor2),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Quil.QuillProvider _description(BuildContext context) {
    return Quil.QuillProvider(
      configurations: Quil.QuillConfigurations(
          controller: controller.quillController.value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            UtilsReponsive.height(10, context),
          ),
        ),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Mô tả',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  wordSpacing: 1.2,
                  color: ColorsManager.textColor,
                  fontSize: UtilsReponsive.height(18, context),
                  fontWeight: FontWeight.bold),
            ),
            children: [
              controller.taskModel.value.description != null &&
                      controller.taskModel.value.description != '' &&
                      controller.taskModel.value.description!.trim() !=
                          '[{\"insert\":\"\\n\"}]'
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: UtilsReponsive.height(20, context),
                          vertical: UtilsReponsive.height(10, context)),
                      child: InkWell(
                          onTap: () {
                            controller.onTapEditDescription();
                          },
                          child: IgnorePointer(
                              ignoring: true,
                              child: Quil.QuillEditor.basic(
                                // controller: controller,
                                configurations:
                                    const Quil.QuillEditorConfigurations(
                                        readOnly: false),
                                autoFocus: false,
                                // embedBuilders: FlutterQuillEmbeds.builders(),
                              ))),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: UtilsReponsive.height(20, context),
                          vertical: UtilsReponsive.height(10, context)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.onTapEditDescription();
                            },
                            child: Text(
                              'Thêm mô tả...',
                              style: GetTextStyle.getTextStyle(15, 'Roboto',
                                  FontWeight.w500, ColorsManager.textColor2),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _successMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          height: UtilsReponsive.heightv2(context, 80),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 81, 146, 83),
              borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  style: GetTextStyle.getTextStyle(
                      18, 'Roboto', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Thay đổi thông tin cá nhân thành công',
                  style: GetTextStyle.getTextStyle(
                      12, 'Roboto', FontWeight.w500, Colors.white),
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
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 219, 90, 90),
              borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    style: GetTextStyle.getTextStyle(
                        18, 'Roboto', FontWeight.w800, Colors.white),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.errorUpdateSubTaskText.value,
                      style: GetTextStyle.getTextStyle(
                          12, 'Roboto', FontWeight.w500, Colors.white),
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
}
