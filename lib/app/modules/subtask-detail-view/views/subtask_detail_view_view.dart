import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/form_field_widget.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/utils/calculate_time_difference.dart';

import '../controllers/subtask_detail_view_controller.dart';

class SubtaskDetailViewView extends BaseView<SubtaskDetailViewController> {
  const SubtaskDetailViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
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
                  color: ColorsManager.backgroundBlackGrey,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding:
                            EdgeInsets.all(UtilsReponsive.height(15, context)),
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
                              height: UtilsReponsive.height(20, context),
                            ),
                            _statusBuilder(
                              context: context,
                              objectStatusTask: controller
                                          .taskModel.value.status ==
                                      Status.PENDING
                                  ? "Chưa bắt đầu"
                                  : controller.taskModel.value.status! ==
                                          Status.PROCESSING
                                      ? "Đang làm"
                                      : controller.taskModel.value.status! ==
                                              Status.DONE
                                          ? "Đã hoàn thành"
                                          : "Chưa hoàn thành",
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(30, context),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDateTimePicker(context);
                              },
                              child: Obx(
                                () => controller.taskModel.value.endDate != null
                                    ? _timeBuilder(
                                        context: context,
                                        startTime: controller.dateFormat.format(
                                            controller
                                                .taskModel.value.startDate!),
                                        endTime: controller.dateFormat.format(
                                            controller
                                                .taskModel.value.endDate!))
                                    : Text(
                                        'Hạn hoàn thành',
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: UtilsReponsive.height(
                                                16, context),
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: UtilsReponsive.width(15, context),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  Icon(
                                    Icons.timelapse,
                                    color: ColorsManager.primary,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            UtilsReponsive.width(15, context),
                                        vertical:
                                            UtilsReponsive.height(10, context)),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.taskModel.value.status ==
                                                  Status.PENDING
                                              ? Colors.grey
                                              : controller.taskModel.value
                                                          .status! ==
                                                      Status.PROCESSING
                                                  ? ColorsManager.orange
                                                  : controller.taskModel.value
                                                              .status! ==
                                                          Status.DONE
                                                      ? ColorsManager.green
                                                      : ColorsManager.red,
                                      borderRadius: BorderRadius.circular(
                                          UtilsReponsive.height(5, context)),
                                    ),
                                    margin: EdgeInsets.only(
                                        left:
                                            UtilsReponsive.width(15, context)),
                                    child: controller.taskModel.value.endDate !=
                                            null
                                        ? Text(
                                            '${controller.dateFormat.format(controller.taskModel.value.endDate!)} - ${getCurrentTime(controller.taskModel.value.endDate!)}',
                                            style: TextStyle(
                                                letterSpacing: 1.5,
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: UtilsReponsive.height(
                                                    16, context),
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            '--',
                                            style: TextStyle(
                                                letterSpacing: 1.5,
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: UtilsReponsive.height(
                                                    16, context),
                                                fontWeight: FontWeight.bold),
                                          ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: UtilsReponsive.width(15, context),
                            ),
                            Row(
                              children: [
                                controller.taskModel.value.avatarAssigner!
                                        .isNotEmpty
                                    ? CircleAvatar(
                                        radius:
                                            UtilsReponsive.height(20, context),
                                        backgroundColor: Colors
                                            .transparent, // Đảm bảo nền trong suốt
                                        child: ClipOval(
                                          child: Image.network(
                                            controller.taskModel.value
                                                .avatarAssigner!,
                                            fit: BoxFit.cover,
                                            width: UtilsReponsive.widthv2(
                                                context, 45),
                                            height: UtilsReponsive.heightv2(
                                                context, 50),
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius:
                                            UtilsReponsive.height(20, context),
                                        child: Text(
                                          getTheAbbreviation(controller
                                              .taskModel.value.nameAssigner!),
                                          style: TextStyle(
                                              letterSpacing: 1.5,
                                              color: Colors.white,
                                              fontSize: UtilsReponsive.height(
                                                  16, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                SizedBox(
                                  width: UtilsReponsive.width(10, context),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.taskModel.value.nameAssigner!,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: UtilsReponsive.height(
                                              18, context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Người giao việc",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(
                                              17, context),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: UtilsReponsive.width(20, context),
                            ),
                            controller.taskModel.value.assignTasks!.isEmpty
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showBottomAddMore(context: context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: UtilsReponsive.height(
                                                      20, context),
                                                  backgroundColor: Colors
                                                      .transparent, // Đảm bảo nền trong suốt
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                      fit: BoxFit.cover,
                                                      width: UtilsReponsive
                                                          .widthv2(context, 45),
                                                      height: UtilsReponsive
                                                          .heightv2(
                                                              context, 50),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: UtilsReponsive.width(
                                                      10, context),
                                                ),
                                                Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Người thực hiện',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: ColorsManager
                                                                .primary,
                                                            fontSize:
                                                                UtilsReponsive
                                                                    .height(17,
                                                                        context),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ])
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            UtilsReponsive.width(20, context),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: UtilsReponsive.height(
                                                      20, context),
                                                  backgroundColor: Colors
                                                      .transparent, // Đảm bảo nền trong suốt
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                      fit: BoxFit.cover,
                                                      width: UtilsReponsive
                                                          .widthv2(context, 45),
                                                      height: UtilsReponsive
                                                          .heightv2(
                                                              context, 50),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: UtilsReponsive.width(
                                                      10, context),
                                                ),
                                                Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Người liên quan',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: ColorsManager
                                                                .primary,
                                                            fontSize:
                                                                UtilsReponsive
                                                                    .height(17,
                                                                        context),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ])
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // _showBottomAssign(context: context);
                                            },
                                            child: Row(
                                              children: [
                                                controller
                                                        .taskModel
                                                        .value
                                                        .assignTasks![0]
                                                        .user!
                                                        .profile!
                                                        .avatar!
                                                        .isNotEmpty
                                                    ? CircleAvatar(
                                                        radius: UtilsReponsive
                                                            .height(
                                                                20, context),
                                                        backgroundColor: Colors
                                                            .transparent, // Đảm bảo nền trong suốt
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            controller
                                                                .taskModel
                                                                .value
                                                                .assignTasks![0]
                                                                .user!
                                                                .profile!
                                                                .avatar!,
                                                            fit: BoxFit.cover,
                                                            width:
                                                                UtilsReponsive
                                                                    .widthv2(
                                                                        context,
                                                                        45),
                                                            height:
                                                                UtilsReponsive
                                                                    .heightv2(
                                                                        context,
                                                                        50),
                                                          ),
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        radius: UtilsReponsive
                                                            .height(
                                                                20, context),
                                                        child: Text(
                                                          getTheAbbreviation(
                                                              controller
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
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  UtilsReponsive
                                                                      .height(
                                                                          16,
                                                                          context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: UtilsReponsive.width(
                                                      10, context),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .taskModel
                                                          .value
                                                          .assignTasks![0]
                                                          .user!
                                                          .profile!
                                                          .fullName!,
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: ColorsManager
                                                              .backgroundWhite,
                                                          fontSize:
                                                              UtilsReponsive
                                                                  .height(18,
                                                                      context),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Người thực hiện',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: ColorsManager
                                                              .primary,
                                                          fontSize:
                                                              UtilsReponsive
                                                                  .height(17,
                                                                      context),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _showBottomAddMore(
                                                  context: context);
                                            },
                                            child: Text(
                                              "Thêm người",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ColorsManager.primary,
                                                  fontSize:
                                                      UtilsReponsive.height(
                                                          18, context),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // _showBottomAssign(context: context);
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
                                                        radius: UtilsReponsive
                                                            .height(
                                                                20, context),
                                                        backgroundColor: Colors
                                                            .transparent, // Đảm bảo nền trong suốt
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                                            fit: BoxFit.cover,
                                                            width:
                                                                UtilsReponsive
                                                                    .widthv2(
                                                                        context,
                                                                        45),
                                                            height:
                                                                UtilsReponsive
                                                                    .heightv2(
                                                                        context,
                                                                        50),
                                                          ),
                                                        ),
                                                      )
                                                    : controller
                                                            .taskModel
                                                            .value
                                                            .assignTasks![1]
                                                            .user!
                                                            .profile!
                                                            .avatar!
                                                            .isNotEmpty
                                                        ? CircleAvatar(
                                                            radius:
                                                                UtilsReponsive
                                                                    .height(20,
                                                                        context),
                                                            backgroundColor: Colors
                                                                .transparent, // Đảm bảo nền trong suốt
                                                            child: ClipOval(
                                                              child:
                                                                  Image.network(
                                                                controller
                                                                    .taskModel
                                                                    .value
                                                                    .assignTasks![
                                                                        1]
                                                                    .user!
                                                                    .profile!
                                                                    .avatar!,
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: UtilsReponsive
                                                                    .widthv2(
                                                                        context,
                                                                        45),
                                                                height: UtilsReponsive
                                                                    .heightv2(
                                                                        context,
                                                                        50),
                                                              ),
                                                            ),
                                                          )
                                                        : CircleAvatar(
                                                            radius:
                                                                UtilsReponsive
                                                                    .height(20,
                                                                        context),
                                                            child: Text(
                                                              getTheAbbreviation(
                                                                  controller
                                                                      .taskModel
                                                                      .value
                                                                      .assignTasks![
                                                                          1]
                                                                      .user!
                                                                      .profile!
                                                                      .fullName!),
                                                              style: TextStyle(
                                                                  letterSpacing:
                                                                      1.5,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: UtilsReponsive
                                                                      .height(
                                                                          16,
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                SizedBox(
                                                  width: UtilsReponsive.width(
                                                      10, context),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // for(var item in controller.taskModel.value.assignTasks!) {

                                                    // }
                                                    // controller.taskModel.value.assignTasks[0].
                                                    controller
                                                                .taskModel
                                                                .value
                                                                .assignTasks!
                                                                .length ==
                                                            1
                                                        ? SizedBox()
                                                        : Text(
                                                            controller
                                                                .taskModel
                                                                .value
                                                                .assignTasks![1]
                                                                .user!
                                                                .profile!
                                                                .fullName!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: ColorsManager
                                                                    .backgroundWhite,
                                                                fontSize:
                                                                    UtilsReponsive
                                                                        .height(
                                                                            18,
                                                                            context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                    controller
                                                                .taskModel
                                                                .value
                                                                .assignTasks!
                                                                .length >=
                                                            3
                                                        ? Text(
                                                            "${controller.taskModel.value.assignTasks![1].user!.profile!.fullName!} và ${controller.taskModel.value.assignTasks!.length} thành viên",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color:
                                                                    ColorsManager
                                                                        .primary,
                                                                fontSize:
                                                                    UtilsReponsive
                                                                        .height(
                                                                            17,
                                                                            context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        : Text(
                                                            'Người thực hiện',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color:
                                                                    ColorsManager
                                                                        .primary,
                                                                fontSize:
                                                                    UtilsReponsive
                                                                        .height(
                                                                            17,
                                                                            context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _showBottomAddMore(
                                                  context: context);
                                            },
                                            child: Text(
                                              "Thêm người",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ColorsManager.primary,
                                                  fontSize:
                                                      UtilsReponsive.height(
                                                          18, context),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: UtilsReponsive.height(20, context),
                            ),
                            _description(context),
                            // ExpandableText(
                            //              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',

                            //   expandText: 'show more',
                            //   maxLines: 2,
                            //   linkColor: Colors.blue,
                            //   animation: true,
                            //   collapseOnTextTap: true,
                            //   prefixText: 'Mô tả:',
                            //   onPrefixTap: () {},
                            //   prefixStyle: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: UtilsReponsive.height(13,context),
                            //       fontWeight: FontWeight.bold),
                            //   hashtagStyle: TextStyle(
                            //     color: Color(0xFF30B6F9),
                            //   ),
                            //   mentionStyle: TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            //   urlStyle: TextStyle(
                            //     decoration: TextDecoration.underline,
                            //   ),
                            //   style: TextStyle(
                            //       height: 1.6,
                            //       wordSpacing: 1.2,
                            //       color: Colors.black,
                            //       fontSize: UtilsReponsive.height(13,context),
                            //       fontWeight: FontWeight.w400),
                            // ),
                            // _documentV1(context),
                            SizedBox(
                              height: UtilsReponsive.height(15, context),
                            ),
                            _documentV2(context),
                            SizedBox(
                              height: UtilsReponsive.height(15, context),
                            ),
                            // _subTask(context),
                            SizedBox(
                              height: UtilsReponsive.height(15, context),
                            ),
                            _commentList(context),
                            SizedBox(
                              height: UtilsReponsive.height(50, context),
                            ),
                          ],
                        ),
                      ),
                      controller.isEditDescription.value
                          ? SizedBox()
                          : Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    TextField(
                                      focusNode: controller.focusNodeComment,
                                      keyboardType: TextInputType.text,
                                      maxLines: 5,
                                      minLines: 1,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: const Icon(
                                                Icons.double_arrow_sharp)),
                                        contentPadding: EdgeInsets.all(
                                            UtilsReponsive.width(10, context)),
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
                            )
                    ],
                  ),
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
          Icons.calendar_month,
          color: Color(0xffC2B280),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: UtilsReponsive.width(15, context),
              vertical: UtilsReponsive.height(10, context)),
          decoration: BoxDecoration(
            color: controller.taskModel.value.status == Status.PENDING
                ? Colors.grey
                : controller.taskModel.value.status! == Status.PROCESSING
                    ? ColorsManager.orange
                    : controller.taskModel.value.status! == Status.DONE
                        ? ColorsManager.green
                        : ColorsManager.red,
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(5, context)),
          ),
          margin: EdgeInsets.only(left: UtilsReponsive.width(15, context)),
          child: Text(
            '$startTime - $endTime',
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

  void _showBottomSheetStatus(BuildContext context) {
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
          "Chưa bắt đầu",
          "Đang làm",
          "Hoàn thành",
          "Chưa hoàn thành",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () {
                  // if (e == "Chưa bắt đầu") {
                  //   controller.updateStatusTask("PENDING");
                  //   Navigator.of(context).pop();
                  // } else if (e == "Đang làm") {
                  //   controller.updateStatusTask("PROCESSING");
                  //   Navigator.of(context).pop();
                  // } else if (e == "Hoàn thành") {
                  //   controller.updateStatusTask("DONE");
                  //   Navigator.of(context).pop();
                  // } else if (e == "Chưa hoàn thành") {
                  //   controller.updateStatusTask("OVERDUE");
                  //   Navigator.of(context).pop();
                  // }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Chưa bắt đầu"
                          ? Colors.grey
                          : e == "Đang làm"
                              ? ColorsManager.orange
                              : e == "Hoàn thành"
                                  ? ColorsManager.green
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

  Widget _statusBuilder(
      {required BuildContext context, required String objectStatusTask}) {
    return GestureDetector(
      onTap: () {
        _showBottomSheetStatus(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UtilsReponsive.width(20, context),
            vertical: UtilsReponsive.width(5, context)),
        decoration: BoxDecoration(
          color: controller.taskModel.value.status == Status.PENDING
              ? Colors.grey
              : controller.taskModel.value.status! == Status.PROCESSING
                  ? ColorsManager.orange
                  : controller.taskModel.value.status! == Status.DONE
                      ? ColorsManager.green
                      : ColorsManager.red,
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(10, context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              objectStatusTask,
              style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontSize: UtilsReponsive.height(14, context),
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
                      title: const Text('Thay đổi tiêu đề task'),
                      content: TextField(
                        controller: TextEditingController(text: objectTask),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel',
                              style: GetTextStyle.getTextStyle(16, 'Roboto',
                                  FontWeight.w500, ColorsManager.primary)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Save',
                              style: GetTextStyle.getTextStyle(16, 'Roboto',
                                  FontWeight.w500, ColorsManager.primary)),
                          onPressed: () {
                            Navigator.of(context).pop();
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
                    color: ColorsManager.backgroundWhite,
                    fontSize: UtilsReponsive.height(20, context),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     _showBottomAssign(context: context);
          //   },
          //   child: CircleAvatar(
          //     radius: UtilsReponsive.height(20, context),
          //     child: Text(
          //       'NV',
          //       style: TextStyle(
          //           letterSpacing: 1.5,
          //           color: Colors.white,
          //           fontSize: UtilsReponsive.height(16, context),
          //           fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  _showBottomAddMore({required BuildContext context}) {
    Get.bottomSheet(Container(
      height: 400,
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: UtilsReponsive.width(15, context),
          vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(10, context)),
            topRight: Radius.circular(UtilsReponsive.height(10, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: FormFieldWidget(
                      controllerEditting: controller.textSearchController,
                      icon: Icon(Icons.search),
                      radiusBorder: 15,
                      setValueFunc: (value) async {
                        await controller.testController();
                      })),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(onPressed: () {}, child: Text('Save')),
              )
            ],
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(() => Container(
                constraints: BoxConstraints(
                    maxHeight: UtilsReponsive.height(30, context)),
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: controller.listFind.value
                      .map((element) => Chip(
                          onDeleted: () {
                            controller.listFind.remove(element);
                          },
                          label: Text(element)))
                      .toList(),
                ),
              )),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(() {
            controller.listFind.value;
            return controller.isLoadingFetchUser.value
                ? Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.testList.value,
                        separatorBuilder: (context, index) => SizedBox(
                              height: UtilsReponsive.height(10, context),
                            ),
                        itemBuilder: (context, index) {
                          String text = 'Nguyễn Văn A $index';
                          return GestureDetector(
                            onTap: () {
                              if (!controller.listFind.contains(text)) {
                                controller.addData(text);
                              } else {
                                controller.listFind.remove(text);
                              }
                            },
                            child: Card(
                              child: Container(
                                color: controller.listFind.contains(text)
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text('N/A'),
                                  ),
                                  title: Text(
                                    text,
                                    style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.black,
                                        fontSize:
                                            UtilsReponsive.height(16, context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('Người phụ'),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
          })
        ],
      ),
    ));
  }

  _showDateTimePicker(BuildContext context) async {
    await Get.defaultDialog(
      confirm: TextButton(
          onPressed: () {
            controller.saveTime();
            Get.back();
          },
          child: Text('Save')),
      title: 'Chọn ngày',
      content: Container(
        height: UtilsReponsive.height(300, context),
        width: UtilsReponsive.height(300, context),
        child: CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            currentDate: DateTime.now(),
            firstDate: DateTime.now(),
            calendarType: CalendarDatePicker2Type.range,
            centerAlignModePicker: true,
            selectedDayTextStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
          BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: UtilsReponsive.width(15, context),
          vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(10, context)),
            topRight: Radius.circular(UtilsReponsive.height(10, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: controller.dataAssign.length,
            separatorBuilder: (context, index) => SizedBox(
              height: UtilsReponsive.height(10, context),
            ),
            itemBuilder: (context, index) => Card(
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('N/A'),
                  ),
                  title: Text(
                    controller.dataAssign[index],
                    style: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Người phụ'),
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
      backgroundColor: ColorsManager.backgroundBlackGrey,
      leading: IconButton(
          onPressed: () {
            Get.back();
            controller.onDelete();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          )),
      actions: [
        const Icon(
          Icons.file_present_rounded,
          color: Colors.white,
        ),
        SizedBox(
          width: UtilsReponsive.width(15, context),
        ),
        const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        SizedBox(
          width: UtilsReponsive.width(15, context),
        ),
      ],
    );
  }

  ExpansionTile _documentV1(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Tài liệu',
        style: TextStyle(
            height: 1.6,
            wordSpacing: 1.2,
            color: Colors.black,
            fontSize: UtilsReponsive.height(13, context),
            fontWeight: FontWeight.bold),
      ),
      children: [
        Container(
          height: UtilsReponsive.height(80, context),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (context, index) =>
                  SizedBox(width: UtilsReponsive.width(20, context)),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(
                        UtilsReponsive.height(10, context)),
                  ),
                  height: UtilsReponsive.height(80, context),
                  width: UtilsReponsive.width(60, context),
                  child: Icon(index == 3 ? Icons.add : Icons.file_present),
                );
              }),
        )
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
          Text('Bình luận',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  wordSpacing: 1.2,
                  color: Colors.black,
                  fontSize: UtilsReponsive.height(18, context),
                  fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.only(top: UtilsReponsive.height(10, context)),
            child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: 2,
                separatorBuilder: (context, index) =>
                    SizedBox(height: UtilsReponsive.height(20, context)),
                itemBuilder: (context, index) {
                  bool isEditComment = false;
                  bool isReplyComment = false;
                  return StatefulBuilder(
                    builder: (context, setStateX) {
                      return SizedBox(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: UtilsReponsive.height(20, context),
                                  child: Text(
                                    'NV',
                                    style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                        fontSize:
                                            UtilsReponsive.height(16, context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                    width: UtilsReponsive.width(10, context)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nguyễn Văn A",
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          color: Colors.black,
                                          fontSize: UtilsReponsive.height(
                                              16, context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                        height:
                                            UtilsReponsive.width(5, context)),
                                    Text(
                                      "3 phút trước",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: Colors.black,
                                          fontSize: UtilsReponsive.height(
                                              12, context),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: UtilsReponsive.width(10, context)),
                            isEditComment
                                ? Container(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            UtilsReponsive.height(300, context),
                                        minHeight: UtilsReponsive.height(
                                            100, context)),
                                    child: FormFieldWidget(
                                      setValueFunc: (value) {},
                                      maxLine: 4,
                                      initValue:
                                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                                    ),
                                  )
                                : Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
                            SizedBox(height: UtilsReponsive.width(10, context)),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setStateX(() {
                                        isEditComment = true;
                                        isReplyComment = false;
                                      });
                                    },
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Chỉnh sửa',
                                          style: TextStyle(color: Colors.blue),
                                        ))),
                                SizedBox(
                                  width: 10,
                                ),
                                isEditComment
                                    ? SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          setStateX(() {
                                            isReplyComment = true;
                                          });
                                        },
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Trả lời',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ))),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  Container _subTask(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Công việc',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    wordSpacing: 1.2,
                    color: Colors.black,
                    fontSize: UtilsReponsive.height(18, context),
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thêm công việc con'),
                        content: TextField(
                            // controller: ,
                            ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel',
                                style: GetTextStyle.getTextStyle(16, 'Roboto',
                                    FontWeight.w500, ColorsManager.primary)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Save',
                                style: GetTextStyle.getTextStyle(16, 'Roboto',
                                    FontWeight.w500, ColorsManager.primary)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.add,
                  color: ColorsManager.primary,
                  size: UtilsReponsive.height(30, context),
                ),
              )
            ],
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            height: UtilsReponsive.height(10, context),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius:
                  BorderRadius.circular(UtilsReponsive.height(5, context)),
            ),
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Column(
            children: [
              'Công việc 1',
              'Công việc 2',
              'Công việc 3',
            ]
                .map((e) => Card(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: UtilsReponsive.height(5, context),
                          bottom: UtilsReponsive.height(5, context),
                          left: UtilsReponsive.height(5, context),
                        ),
                        width: double.infinity,
                        height: UtilsReponsive.height(60, context),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 1.5,
                                      color: ColorsManager.textColor,
                                      fontSize:
                                          UtilsReponsive.height(18, context),
                                      fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheetStatus(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          UtilsReponsive.height(5, context)),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade400,
                                    borderRadius: BorderRadius.circular(
                                        UtilsReponsive.height(5, context)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Chưa diễn ra',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            letterSpacing: 1.5,
                                            color: Colors.white,
                                            fontSize: UtilsReponsive.height(
                                                14, context),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  Container _documentV2(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tài liệu',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      wordSpacing: 1.2,
                      color: Colors.black,
                      fontSize: UtilsReponsive.height(18, context),
                      fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.add,
                  color: ColorsManager.primary,
                  size: UtilsReponsive.height(30, context),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: UtilsReponsive.height(8, context)),
            height: UtilsReponsive.height(80, context),
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                separatorBuilder: (context, index) =>
                    SizedBox(width: UtilsReponsive.width(20, context)),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(
                          UtilsReponsive.height(10, context)),
                    ),
                    height: UtilsReponsive.height(80, context),
                    width: UtilsReponsive.width(80, context),
                    child: Icon(Icons.file_present),
                  );
                }),
          )
        ],
      ),
    );
  }

  Container _description(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: UtilsReponsive.height(15, context)),
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
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mô tả',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      wordSpacing: 1.2,
                      color: Colors.black,
                      fontSize: UtilsReponsive.height(20, context),
                      fontWeight: FontWeight.bold),
                ),
                // !controller.isEditDescription.value
                // ?
                IconButton(
                    onPressed: () {
                      controller.onTapEditDescription();
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: ColorsManager.primary,
                    ))
                // : Wrap(
                //     children: [
                //       IconButton(
                //           onPressed: () {
                //             // controller.onTapEditDescription();
                //             //Thêm hàm save vô
                //             controller.saveDescription();
                //           },
                //           icon: Icon(Icons.save)),
                //       IconButton(
                //           onPressed: () {
                //             controller.discardDescription();
                //           },
                //           icon: const Icon(Icons.close))
                //     ],
                //   )
              ],
            ),
            // !controller.isEditDescription.value
            //     ? SizedBox()
            //     : Quil.QuillToolbar.basic(
            //         embedButtons: FlutterQuillEmbeds.buttons(),
            //         showDividers: false,
            //         showFontFamily: false,
            //         showFontSize: true,
            //         showBoldButton: true,
            //         showItalicButton: true,
            //         showSmallButton: false,
            //         showUnderLineButton: true,
            //         showStrikeThrough: false,
            //         showInlineCode: false,
            //         showColorButton: true,
            //         showBackgroundColorButton: false,
            //         showClearFormat: false,
            //         showAlignmentButtons: true,
            //         showLeftAlignment: true,
            //         showCenterAlignment: true,
            //         showRightAlignment: true,
            //         showJustifyAlignment: true,
            //         showHeaderStyle: false,
            //         showListNumbers: false,
            //         showListBullets: false,
            //         showListCheck: false,
            //         showCodeBlock: false,
            //         showQuote: false,
            //         showIndent: false,
            //         showLink: false,
            //         showUndo: true,
            //         showRedo: true,
            //         showDirection: false,
            //         showSearchButton: false,
            //         showSubscript: false,
            //         showSuperscript: false,
            //         multiRowsDisplay: true,
            //         controller: controller.quillController.value),
            // Container(
            //   child: Stack(children: [
            //     !controller.isEditDescription.value
            IgnorePointer(
              // ignoring: true,
              child: Quil.QuillProvider(
                configurations: Quil.QuillConfigurations(
                    controller: controller.quillController.value),
                child: Quil.QuillEditor.basic(
                  // controller: controller,
                  focusNode: controller.focusNodeDetail,
                  autoFocus: false,
                  expands: false,

                  // controller: controller.quillController.value,
                  readOnly: !controller.isEditDescription.value,
                ),
              ),
              //  Quil.QuillEditor.basic(
              //   // true for view only mode
              // ),
            ),

            //         : Quil.QuillEditor.basic(
            //             focusNode: controller.focusNodeDetail,
            //             autoFocus: false,
            //             expands: false,
            //             controller: controller.quillController.value,
            //             readOnly: !controller
            //                 .isEditDescription.value, // true for view only mode
            //           ),
            // Container(
            //   height: 300,
            //   width: 300,
            //   child: SizedBox(),
            // ),
            //   ]),
            // )
          ],
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
