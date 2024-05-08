import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return Obx(
      () => Scaffold(
          backgroundColor: ColorsManager.backgroundContainer,
          appBar: _appBar(context),
          body: Obx(
            () => controller.isLoading.value
                ? Center(
                    child: SpinKitFadingCircle(
                      color: ColorsManager.primary,
                    ),
                  )
                : controller.taskModel.value.status == null || controller.checkView.value == false
                    ? SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => _header(
                                          context: context, objectTask: controller.taskModel.value.title!, taskModel: controller.taskModel.value),
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
                                                fontFamily: 'Nunito',
                                                color: ColorsManager.textColor,
                                                fontSize: UtilsReponsive.height(18, context),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${controller.taskModel.value.parent!.title}',
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                color: Colors.blue,
                                                fontSize: UtilsReponsive.height(18, context),
                                                fontWeight: FontWeight.w800,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Get.toNamed(Routes.TASK_DETAIL_VIEW, arguments: {
                                                    "taskID": controller.taskModel.value.parent!.id,
                                                    "isNavigateOverall": false,
                                                    "isNavigateNotification": false,
                                                    "isNavigateSchedule": false
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
                                    Obx(
                                      () => Row(
                                        children: [
                                          Text(
                                            'Độ ưu tiên',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: ColorsManager.textColor2,
                                              fontSize: UtilsReponsive.height(18, context),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          controller.taskModel.value.priority == null
                                              ? priorityBuilder(
                                                  context: context,
                                                  taskModel: controller.taskModel.value,
                                                  objectStatusTask: "--",
                                                  taskID: controller.taskModel.value.id!)
                                              : priorityBuilder(
                                                  context: context,
                                                  taskModel: controller.taskModel.value,
                                                  objectStatusTask: controller.taskModel.value.priority! == Priority.LOW
                                                      ? "Thấp"
                                                      : controller.taskModel.value.priority! == Priority.MEDIUM
                                                          ? "Trung bình"
                                                          : "Cao",
                                                  taskID: controller.taskModel.value.id!)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.height(15, context),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          'Trạng thái',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            color: ColorsManager.textColor2,
                                            fontSize: UtilsReponsive.height(18, context),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        _statusBuilder(
                                          taskID: controller.taskModel.value.id,
                                          context: context,
                                          taskModel: controller.taskModel.value,
                                          objectStatusTask: controller.taskModel.value.status == Status.PENDING
                                              ? "Đang chuẩn bị"
                                              : controller.taskModel.value.status! == Status.PROCESSING
                                                  ? "Đang thực hiện"
                                                  : controller.taskModel.value.status! == Status.DONE
                                                      ? "Hoàn thành"
                                                      : controller.taskModel.value.status! == Status.CONFIRM
                                                          ? "Đã xác thực"
                                                          : "Quá hạn",
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: UtilsReponsive.height(15, context),
                                    ),
                                    Obx(
                                      () => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (controller.taskModel.value.parent!.status != Status.CONFIRM) {
                                              _showDateTimePicker(context, controller.taskModel.value.id!);
                                            }
                                          },
                                          child: controller.taskModel.value.endDate != null
                                              ? _timeBuilder(
                                                  context: context,
                                                  startTime: controller.dateFormat.format(controller.taskModel.value.startDate!.toLocal()),
                                                  endTime: controller.dateFormat.format(controller.taskModel.value.endDate!.toLocal()))
                                              : Row(children: [
                                                  Icon(
                                                      size: UtilsReponsive.width(25, context),
                                                      Icons.calendar_month,
                                                      color: Colors.grey.withOpacity(0.8)),
                                                  SizedBox(
                                                    width: UtilsReponsive.width(15, context),
                                                  ),
                                                  Text(
                                                    'Hạn: ---',
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: Colors.grey.withOpacity(0.8),
                                                        fontSize: UtilsReponsive.height(16, context),
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ]),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.width(10, context),
                                    ),
                                    // Obx(
                                    //   () => Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //       horizontal: UtilsReponsive.height(10, context),
                                    //     ),
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(8),
                                    //       color: Colors.white,
                                    //     ),
                                    //     child: Row(
                                    //       children: [
                                    //         Row(
                                    //           children: [
                                    //             Text('Ước tính (giờ):',
                                    //                 style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w800, ColorsManager.textColor)),
                                    //             SizedBox(
                                    //               width: UtilsReponsive.width(5, context),
                                    //             ),
                                    //             TextButton(
                                    //                 style: TextButton.styleFrom(
                                    //                   backgroundColor: ColorsManager.backgroundContainer,
                                    //                   side: BorderSide(color: ColorsManager.primary, width: 1),
                                    //                 ),
                                    //                 onPressed: () {
                                    //                   showDialog(
                                    //                       context: context,
                                    //                       builder: (BuildContext context) {
                                    //                         return AlertDialog(
                                    //                           title: Text('Nhập con số thời gian ước tính',
                                    //                               style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                    //                           content: TextField(
                                    //                             keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    //                             inputFormatters: <TextInputFormatter>[
                                    //                               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                    //                             ],
                                    //                             onChanged: (value) => {controller.estController.text = value},
                                    //                             controller: controller.estController,
                                    //                           ),
                                    //                           actions: [
                                    //                             TextButton(
                                    //                               child: Text('Hủy',
                                    //                                   style: GetTextStyle.getTextStyle(
                                    //                                       16, 'Nunito', FontWeight.w700, ColorsManager.textColor2)),
                                    //                               onPressed: () {
                                    //                                 Navigator.of(context).pop();
                                    //                               },
                                    //                             ),
                                    //                             TextButton(
                                    //                               child: Text('Lưu',
                                    //                                   style:
                                    //                                       GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                    //                               onPressed: () async {
                                    //                                 if (controller.estController.text.isEmpty) {
                                    //                                   Get.snackbar('Lỗi', 'Không được để trống thời gian ước lượng',
                                    //                                       snackPosition: SnackPosition.TOP,
                                    //                                       backgroundColor: Colors.transparent,
                                    //                                       colorText: ColorsManager.textColor);
                                    //                                 } else {
                                    //                                   await controller.updateEstimateTime(
                                    //                                       controller.taskModel.value.id!, double.parse(controller.estController.text));
                                    //                                   Navigator.of(Get.context!).pop();
                                    //                                 }
                                    //                               },
                                    //                             ),
                                    //                           ],
                                    //                         );
                                    //                       });
                                    //                 },
                                    //                 child: Text(controller.est.toString(),
                                    //                     style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary))),
                                    //           ],
                                    //         ),
                                    //         SizedBox(
                                    //           width: UtilsReponsive.width(10, context),
                                    //         ),
                                    //         Row(
                                    //           children: [
                                    //             Text('Công sức (giờ):',
                                    //                 style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w800, ColorsManager.textColor)),
                                    //             SizedBox(
                                    //               width: UtilsReponsive.width(5, context),
                                    //             ),
                                    //             TextButton(
                                    //                 style: TextButton.styleFrom(
                                    //                   backgroundColor: ColorsManager.backgroundContainer,
                                    //                   side: BorderSide(color: ColorsManager.primary, width: 1),
                                    //                 ),
                                    //                 onPressed: () {
                                    //                   showDialog(
                                    //                       context: context,
                                    //                       builder: (BuildContext context) {
                                    //                         return AlertDialog(
                                    //                           title: Text('Nhập con số thời gian công sức',
                                    //                               style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                    //                           content: TextField(
                                    //                             keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    //                             inputFormatters: <TextInputFormatter>[
                                    //                               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                    //                             ],
                                    //                             onChanged: (value) => {controller.effortController.text = value},
                                    //                             controller: controller.effortController,
                                    //                           ),
                                    //                           actions: [
                                    //                             TextButton(
                                    //                               child: Text('Hủy',
                                    //                                   style: GetTextStyle.getTextStyle(
                                    //                                       16, 'Nunito', FontWeight.w700, ColorsManager.textColor2)),
                                    //                               onPressed: () {
                                    //                                 Navigator.of(context).pop();
                                    //                               },
                                    //                             ),
                                    //                             TextButton(
                                    //                               child: Text('Lưu',
                                    //                                   style:
                                    //                                       GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                    //                               onPressed: () async {
                                    //                                 if (controller.effortController.text.isEmpty) {
                                    //                                   Get.snackbar('Lỗi', 'Không được để trống thời gian công sức',
                                    //                                       snackPosition: SnackPosition.TOP,
                                    //                                       backgroundColor: Colors.transparent,
                                    //                                       colorText: ColorsManager.textColor);
                                    //                                 } else {
                                    //                                   await controller.updateEffort(
                                    //                                       controller.taskModel.value.id!, double.parse(controller.effortController.text));

                                    //                                   Navigator.of(Get.context!).pop();
                                    //                                 }
                                    //                               },
                                    //                             ),
                                    //                           ],
                                    //                         );
                                    //                       });
                                    //                 },
                                    //                 child: Text(controller.effort.toString(),
                                    //                     style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary))),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: UtilsReponsive.width(10, context),
                                    // ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            // fit: BoxFit.contain,
                                            imageUrl: controller.taskModel.value.avatarAssigner!,
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
                                            progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                              padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                              height: UtilsReponsive.height(5, context),
                                              width: UtilsReponsive.height(5, context),
                                              child: CircularProgressIndicator(
                                                color: ColorsManager.primary,
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => CircleAvatar(
                                              radius: UtilsReponsive.height(20, context),
                                              child: Text(
                                                getTheAbbreviation(controller.taskModel.value.nameAssigner!),
                                                style: TextStyle(
                                                    letterSpacing: 1,
                                                    color: ColorsManager.textColor,
                                                    fontSize: UtilsReponsive.height(17, context),
                                                    fontWeight: FontWeight.w800),
                                              ),
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
                                                controller.taskModel.value.parent!.assignTasks![0].user!.profile!.fullName!,
                                                style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    color: ColorsManager.textColor,
                                                    fontSize: UtilsReponsive.height(18, context),
                                                    fontWeight: FontWeight.w800),
                                              ),
                                              Text(
                                                "Người giao việc",
                                                style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    color: ColorsManager.primary,
                                                    fontSize: UtilsReponsive.height(16, context),
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.height(10, context),
                                    ),
                                    Obx(() => controller.taskModel.value.assignTasks!.isEmpty
                                        ? Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.white,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (controller.taskModel.value.startDate == null || controller.taskModel.value.endDate == null) {
                                                      Get.snackbar('Lỗi', 'Xin vui lòng chọn Ngày giao việc trước',
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: Colors.redAccent,
                                                          colorText: Colors.white);
                                                    } else {
                                                      await controller.getAllEmployee();
                                                      _showBottomLeader(context: Get.context!, taskModel: controller.taskModel.value);
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: UtilsReponsive.width(40, context),
                                                            height: UtilsReponsive.height(45, context),
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
                                                          ),
                                                          SizedBox(
                                                            width: UtilsReponsive.width(10, context),
                                                          ),
                                                          Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Người chịu trách nhiệm',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Nunito',
                                                                      color: ColorsManager.primary,
                                                                      fontSize: UtilsReponsive.height(16, context),
                                                                      fontWeight: FontWeight.w700),
                                                                ),
                                                              ])
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: UtilsReponsive.width(10, context),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.white,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (controller.taskModel.value.assignTasks!.isEmpty) {
                                                      Get.snackbar('Lỗi', 'Xin vui lòng chọn Người chịu trách nhiệm trước',
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: Colors.redAccent,
                                                          colorText: Colors.white);
                                                    } else {
                                                      await controller.getEmployeeSupport();
                                                      _showBottomAddMore(context: Get.context!, taskModel: controller.taskModel.value);
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: UtilsReponsive.width(40, context),
                                                            height: UtilsReponsive.height(45, context),
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
                                                          ),
                                                          SizedBox(
                                                            width: UtilsReponsive.width(10, context),
                                                          ),
                                                          Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Những người tham gia khác',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Nunito',
                                                                      color: ColorsManager.primary,
                                                                      fontSize: UtilsReponsive.height(16, context),
                                                                      fontWeight: FontWeight.w700),
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
                                        : controller.taskModel.value.assignTasks!.length > 1
                                            ? Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await controller.getAllEmployee();
                                                            _showBottomLeader(context: Get.context!, taskModel: controller.taskModel.value);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              CachedNetworkImage(
                                                                // fit: BoxFit.contain,
                                                                imageUrl: controller.taskModel.value.assignTasks![0].user!.profile!.avatar!,
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                    width: UtilsReponsive.width(40, context),
                                                                    height: UtilsReponsive.height(45, context),
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
                                                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                                  padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                                                  height: UtilsReponsive.height(5, context),
                                                                  width: UtilsReponsive.height(5, context),
                                                                  child: CircularProgressIndicator(
                                                                    color: ColorsManager.primary,
                                                                  ),
                                                                ),
                                                                errorWidget: (context, url, error) => CircleAvatar(
                                                                  radius: UtilsReponsive.height(20, context),
                                                                  child: Text(
                                                                    getTheAbbreviation(
                                                                        controller.taskModel.value.assignTasks![0].user!.profile!.fullName!),
                                                                    style: TextStyle(
                                                                        letterSpacing: 1.5,
                                                                        color: ColorsManager.primary,
                                                                        fontSize: UtilsReponsive.height(17, context),
                                                                        fontWeight: FontWeight.w800),
                                                                  ),
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
                                                                    controller.taskModel.value.assignTasks![0].user!.profile!.fullName!,
                                                                    style: TextStyle(
                                                                        fontFamily: 'Nunito',
                                                                        color: ColorsManager.textColor,
                                                                        fontSize: UtilsReponsive.height(17, context),
                                                                        fontWeight: FontWeight.w800),
                                                                  ),
                                                                  Text(
                                                                    'Người chịu trách nhiệm',
                                                                    style: TextStyle(
                                                                        fontFamily: 'Nunito',
                                                                        color: ColorsManager.primary,
                                                                        fontSize: UtilsReponsive.height(16, context),
                                                                        fontWeight: FontWeight.w700),
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
                                                    height: UtilsReponsive.height(10, context),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: GestureDetector(
                                                            onTap: () async {
                                                              await controller.getEmployeeSupportView();
                                                              _showBottomAssign(context: Get.context!);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                controller.taskModel.value.assignTasks!.length == 1
                                                                    ? Container(
                                                                        width: UtilsReponsive.width(40, context),
                                                                        height: UtilsReponsive.height(45, context),
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
                                                                    : CachedNetworkImage(
                                                                        // fit: BoxFit.contain,
                                                                        imageUrl: controller.taskModel.value.assignTasks![1].user!.profile!.avatar!,
                                                                        imageBuilder: (context, imageProvider) => Container(
                                                                            width: UtilsReponsive.width(40, context),
                                                                            height: UtilsReponsive.height(45, context),
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
                                                                        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                                          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                                                          height: UtilsReponsive.height(5, context),
                                                                          width: UtilsReponsive.height(5, context),
                                                                          child: CircularProgressIndicator(
                                                                            color: ColorsManager.primary,
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context, url, error) => CircleAvatar(
                                                                          radius: UtilsReponsive.height(20, context),
                                                                          child: Text(
                                                                            getTheAbbreviation(
                                                                                controller.taskModel.value.assignTasks![1].user!.profile!.fullName!),
                                                                            style: TextStyle(
                                                                                letterSpacing: 1,
                                                                                color: ColorsManager.primary,
                                                                                fontSize: UtilsReponsive.height(17, context),
                                                                                fontWeight: FontWeight.w800),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                SizedBox(
                                                                  width: UtilsReponsive.width(10, context),
                                                                ),
                                                                Flexible(
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      controller.taskModel.value.assignTasks!.length == 1
                                                                          ? const SizedBox()
                                                                          : Text(
                                                                              controller.taskModel.value.assignTasks![1].user!.profile!.fullName!,
                                                                              overflow: TextOverflow.clip,
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Nunito',
                                                                                  color: ColorsManager.textColor,
                                                                                  fontSize: UtilsReponsive.height(17, context),
                                                                                  fontWeight: FontWeight.w800),
                                                                            ),
                                                                      controller.taskModel.value.assignTasks!.length >= 3
                                                                          ? Text(
                                                                              "${controller.taskModel.value.assignTasks![1].user!.profile!.fullName!.split(' ').last} và ${controller.taskModel.value.assignTasks!.length - 2} thành viên khác",
                                                                              overflow: TextOverflow.clip,
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Nunito',
                                                                                  color: ColorsManager.primary,
                                                                                  fontSize: UtilsReponsive.height(16, context),
                                                                                  fontWeight: FontWeight.w700),
                                                                            )
                                                                          : Text(
                                                                              'Người tham gia',
                                                                              style: TextStyle(
                                                                                  overflow: TextOverflow.clip,
                                                                                  fontFamily: 'Nunito',
                                                                                  color: ColorsManager.primary,
                                                                                  fontSize: UtilsReponsive.height(16, context),
                                                                                  fontWeight: FontWeight.w700),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: TextButton(
                                                            onPressed: () async {
                                                              if (controller.taskModel.value.assignTasks!.isEmpty) {
                                                                Get.snackbar('Lỗi', 'Xin vui lòng chọn Người chịu trách nhiệm trước',
                                                                    snackPosition: SnackPosition.BOTTOM,
                                                                    backgroundColor: Colors.redAccent,
                                                                    colorText: Colors.white);
                                                              } else {
                                                                await controller.getEmployeeSupport();
                                                                _showBottomAddMore(context: Get.context!, taskModel: controller.taskModel.value);
                                                              }
                                                            },
                                                            child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                                                ? Text(
                                                                    "Thêm người",
                                                                    style: TextStyle(
                                                                        fontFamily: 'Nunito',
                                                                        color: ColorsManager.primary,
                                                                        fontSize: UtilsReponsive.height(17, context),
                                                                        fontWeight: FontWeight.w700),
                                                                  )
                                                                : SizedBox(),
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
                                                        horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await controller.getAllEmployee();
                                                            // controller.listEmployeeChoose
                                                            //     .value = [];
                                                            _showBottomLeader(context: Get.context!, taskModel: controller.taskModel.value);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              CachedNetworkImage(
                                                                // fit: BoxFit.contain,
                                                                imageUrl: controller.taskModel.value.assignTasks![0].user!.profile!.avatar!,
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                    width: UtilsReponsive.width(40, context),
                                                                    height: UtilsReponsive.height(45, context),
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
                                                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                                  padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                                                  height: UtilsReponsive.height(5, context),
                                                                  width: UtilsReponsive.height(5, context),
                                                                  child: CircularProgressIndicator(
                                                                    color: ColorsManager.primary,
                                                                  ),
                                                                ),
                                                                errorWidget: (context, url, error) => CircleAvatar(
                                                                  radius: UtilsReponsive.height(20, context),
                                                                  child: Text(
                                                                    getTheAbbreviation(
                                                                        controller.taskModel.value.assignTasks![0].user!.profile!.fullName!),
                                                                    style: TextStyle(
                                                                        letterSpacing: 1.5,
                                                                        color: ColorsManager.primary,
                                                                        fontSize: UtilsReponsive.height(17, context),
                                                                        fontWeight: FontWeight.w800),
                                                                  ),
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
                                                                    controller.taskModel.value.assignTasks![0].user!.profile!.fullName!,
                                                                    style: TextStyle(
                                                                        fontFamily: 'Nunito',
                                                                        color: ColorsManager.textColor,
                                                                        fontSize: UtilsReponsive.height(17, context),
                                                                        fontWeight: FontWeight.w800),
                                                                  ),
                                                                  Text(
                                                                    'Người chịu trách nhiệm',
                                                                    style: TextStyle(
                                                                        fontFamily: 'Nunito',
                                                                        color: ColorsManager.primary,
                                                                        fontSize: UtilsReponsive.height(16, context),
                                                                        fontWeight: FontWeight.w700),
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
                                                    height: UtilsReponsive.height(10, context),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (controller.taskModel.value.assignTasks!.isEmpty) {
                                                              Get.snackbar('Lỗi', 'Xin vui lòng chọn Người chịu trách nhiệm trước',
                                                                  snackPosition: SnackPosition.BOTTOM,
                                                                  backgroundColor: Colors.redAccent,
                                                                  colorText: Colors.white);
                                                            } else {
                                                              await controller.getEmployeeSupport();
                                                              _showBottomAddMore(context: Get.context!, taskModel: controller.taskModel.value);
                                                            }
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: UtilsReponsive.width(40, context),
                                                                    height: UtilsReponsive.height(45, context),
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
                                                                  ),
                                                                  SizedBox(
                                                                    width: UtilsReponsive.width(10, context),
                                                                  ),
                                                                  Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'Những người tham gia khác',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              color: ColorsManager.primary,
                                                                              fontSize: UtilsReponsive.height(16, context),
                                                                              fontWeight: FontWeight.w700),
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
                            controller.taskModel.value.parent!.status != Status.CONFIRM
                                ? Obx(
                                    () => controller.isCheckEditComment.value
                                        ? const SizedBox()
                                        : Positioned(
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
                                                            height: UtilsReponsive.height(170, context),
                                                            padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                                            child: ListView.separated(
                                                              scrollDirection: Axis.horizontal,
                                                              itemCount: controller.filePicker.length,
                                                              separatorBuilder: (context, index) =>
                                                                  SizedBox(width: UtilsReponsive.width(15, context)),
                                                              itemBuilder: (context, index) {
                                                                return attchfileComment(controller.filePicker[index], context, index);
                                                              },
                                                            ),
                                                          ),
                                                          TextField(
                                                            onChanged: (value) => {controller.commentController.text = value},
                                                            controller: controller.commentController,
                                                            focusNode: controller.focusNodeComment,
                                                            keyboardType: TextInputType.text,
                                                            maxLines: 5,
                                                            minLines: 1,
                                                            cursorColor: Colors.black,
                                                            decoration: InputDecoration(
                                                              prefixIcon: IconButton(
                                                                  onPressed: () async {
                                                                    await controller.selectFileComment();
                                                                  },
                                                                  icon: const Icon(Icons.attach_file_outlined)),
                                                              suffixIcon: controller.isLoadingComment.value != true
                                                                  ? IconButton(
                                                                      onPressed: () async {
                                                                        await controller.createComment();
                                                                      },
                                                                      icon: const Icon(Icons.double_arrow_sharp))
                                                                  : Container(
                                                                      width: 10,
                                                                      height: 10,
                                                                      child: SpinKitFadingCircle(
                                                                        color: ColorsManager.primary,
                                                                        size: 20,
                                                                      ),
                                                                    ),
                                                              // IconButton(
                                                              //     onPressed: () async {
                                                              //       await controller.createComment();
                                                              //     },
                                                              //     icon: const Icon(Icons.double_arrow_sharp)),
                                                              contentPadding: EdgeInsets.all(UtilsReponsive.width(15, context)),
                                                              hintText: 'Nhập bình luận',
                                                              focusedBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField được chọn
                                                              ),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField không được chọn
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
                                                            onChanged: (value) => {controller.commentController.text = value},
                                                            controller: controller.commentController,
                                                            focusNode: controller.focusNodeComment,
                                                            keyboardType: TextInputType.text,
                                                            maxLines: 5,
                                                            minLines: 1,
                                                            cursorColor: Colors.black,
                                                            decoration: InputDecoration(
                                                              prefixIcon: IconButton(
                                                                  onPressed: () async {
                                                                    await controller.selectFileComment();
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.attach_file_outlined,
                                                                  )),
                                                              suffixIcon: controller.isLoadingComment.value != true
                                                                  ? IconButton(
                                                                      onPressed: () async {
                                                                        await controller.createComment();
                                                                      },
                                                                      icon: const Icon(Icons.double_arrow_sharp))
                                                                  : Container(
                                                                      width: 10,
                                                                      height: 10,
                                                                      child: SpinKitFadingCircle(
                                                                        color: ColorsManager.primary,
                                                                        size: 20,
                                                                      ),
                                                                    ),
                                                              //  IconButton(
                                                              //     onPressed: () async {
                                                              //       await controller.createComment();
                                                              //     },
                                                              //     icon: const Icon(Icons.double_arrow_sharp)),
                                                              contentPadding: EdgeInsets.all(UtilsReponsive.width(15, context)),
                                                              hintText: 'Nhập bình luận',
                                                              focusedBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField được chọn
                                                              ),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField không được chọn
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
          )),
    );
  }

  Container _header({required BuildContext context, required String objectTask, required TaskModel taskModel}) {
    return Container(
      // padding: UtilsReponsive.paddingAll(context, padding: 5),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (taskModel.parent!.status != Status.CONFIRM) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Thay đổi tiêu đề công việc con',
                          style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                        ),
                        content: TextField(
                          onChanged: (value) => {controller.titleSubTaskController.text = value},
                          controller: controller.titleSubTaskController,
                        ),
                        actions: [
                          TextButton(
                            child: Text('Hủy', style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                            onPressed: () {
                              // Navigator.of(context).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Lưu', style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              if (controller.titleSubTaskController.text.isEmpty) {
                                Get.snackbar('Thông báo', 'Tên công việc con không được rỗng',
                                    snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
                              } else {
                                await controller.updateTitleTask(controller.titleSubTaskController.text, controller.taskModel.value.id!);
                                // Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(
                objectTask,
                style: const TextStyle(
                    letterSpacing: 1, fontFamily: 'Nunito', color: ColorsManager.textColor, fontSize: 26, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBuilder({required BuildContext context, required TaskModel taskModel, required String objectStatusTask, required taskID}) {
    return GestureDetector(
      onTap: () {
        if (taskModel.parent!.status != Status.CONFIRM) {
          _showBottomSheetStatus(context, taskID);
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
        padding: controller.taskModel.value.status! != Status.CONFIRM
            ? EdgeInsets.symmetric(horizontal: UtilsReponsive.width(10, context), vertical: UtilsReponsive.width(5, context))
            : EdgeInsets.symmetric(horizontal: UtilsReponsive.width(20, context), vertical: UtilsReponsive.width(5, context)),
        decoration: BoxDecoration(
          color: controller.taskModel.value.status == Status.PENDING
              ? ColorsManager.grey
              : controller.taskModel.value.status! == Status.PROCESSING
                  ? ColorsManager.blue
                  : controller.taskModel.value.status! == Status.DONE
                      ? ColorsManager.green
                      : controller.taskModel.value.status! == Status.CONFIRM
                          ? ColorsManager.purple
                          : ColorsManager.red,
          borderRadius: BorderRadius.circular(UtilsReponsive.height(8, context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              objectStatusTask,
              style: TextStyle(letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(16, context), fontWeight: FontWeight.w800),
            ),
            controller.taskModel.value.parent!.status! != Status.CONFIRM
                ? Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.white,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  void _showBottomSheetStatus(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(10, context), vertical: UtilsReponsive.height(10, context)),
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          // "Đang chuẩn bị",
          "Đang thực hiện",
          "Hoàn thành",
          "Đã xác thực",
          // "Quá hạn",
        ]
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    if (e == "Đang thực hiện") {
                      controller.updateStatusTask("PROCESSING", taskID);
                      Navigator.of(context).pop();
                    } else if (e == "Hoàn thành") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Xác nhận",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            content: const Text(
                              "Bạn có muốn đổi trạng thái công việc này là hoàn thành",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                },
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  // await controller.updateStatusTask("DONE", taskID);
                                  controller.updateStatusTask("DONE", taskID);
                                  // Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Có",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (e == "Đã xác thực") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Xác nhận",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            content: const Text(
                              "Bạn có muốn đổi trạng thái công việc này là đã xác thực",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                },
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  // await controller.updateStatusTask("DONE", taskID);
                                  controller.updateStatusTask("CONFIRM", taskID);
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Có",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: e == "Đang chuẩn bị"
                            ? ColorsManager.grey
                            : e == "Đang thực hiện"
                                ? ColorsManager.primary
                                : e == "Hoàn thành"
                                    ? ColorsManager.green
                                    : e == "Đã xác thực"
                                        ? ColorsManager.purple
                                        : ColorsManager.red,
                        child: Text(e[0],
                            style: TextStyle(
                                letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(18, context), fontWeight: FontWeight.w800)),
                      ),
                      title: Text(
                        e,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            letterSpacing: 1,
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(18, context),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }

  Widget priorityBuilder({required BuildContext context, required TaskModel taskModel, required String objectStatusTask, required String taskID}) {
    return GestureDetector(
      onTap: () {
        if (taskModel.parent!.status != Status.CONFIRM) {
          _showBottomSheetPriority(context, taskID);
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.width(10, context), vertical: UtilsReponsive.width(3, context)),
          decoration: controller.taskModel.value.priority != null
              ? BoxDecoration(
                  color: controller.taskModel.value.priority! == Priority.LOW
                      ? ColorsManager.green
                      : controller.taskModel.value.priority! == Priority.MEDIUM
                          ? ColorsManager.yellow
                          : ColorsManager.red,
                  borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context)),
                )
              : BoxDecoration(
                  color: ColorsManager.grey,
                  borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context)),
                ),
          margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.taskModel.value.priority != null
                  ? Text(
                      objectStatusTask,
                      style: TextStyle(
                          letterSpacing: 1,
                          fontFamily: 'Nunito',
                          color: Colors.white,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w800),
                    )
                  : Text(
                      '--',
                      style: TextStyle(
                          letterSpacing: 1,
                          fontFamily: 'Nunito',
                          color: Colors.white,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w800),
                    ),
              controller.taskModel.value.priority != null
                  ? controller.taskModel.value.parent!.status != Status.CONFIRM
                      ? const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white,
                        )
                      : const SizedBox()
                  : const SizedBox()
            ],
          )),
    );
  }

  void _showBottomSheetPriority(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(10, context), vertical: UtilsReponsive.height(10, context)),
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.height(400, context)),
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
                          ? ColorsManager.green
                          : e == "Trung bình"
                              ? ColorsManager.yellow
                              : ColorsManager.red,
                      child: Text(e[0],
                          style: TextStyle(
                              letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(18, context), fontWeight: FontWeight.w800)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          letterSpacing: 1,
                          color: ColorsManager.textColor2,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }

  Row _timeBuilder({required BuildContext context, required String startTime, required String endTime}) {
    return Row(
      children: [
        Icon(
          size: UtilsReponsive.width(25, context),
          Icons.calendar_month,
          color: controller.taskModel.value.status == Status.PENDING
              ? ColorsManager.grey
              : controller.taskModel.value.status! == Status.PROCESSING
                  ? ColorsManager.blue
                  : controller.taskModel.value.status! == Status.DONE
                      ? ColorsManager.green
                      : controller.taskModel.value.status! == Status.CONFIRM
                          ? ColorsManager.purple
                          : ColorsManager.red,
        ),
        Expanded(
          child: Container(
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
              '$startTime ${getCurrentTime(controller.taskModel.value.startDate!.toLocal())} - $endTime ${getCurrentTime(controller.taskModel.value.endDate!.toLocal())}',
              style: TextStyle(
                  // letterSpacing: 1,
                  fontFamily: 'Nunito',
                  overflow: TextOverflow.clip,
                  color: controller.taskModel.value.status == Status.PENDING
                      ? ColorsManager.grey
                      : controller.taskModel.value.status! == Status.PROCESSING
                          ? ColorsManager.blue
                          : controller.taskModel.value.status! == Status.DONE
                              ? ColorsManager.green
                              : controller.taskModel.value.status! == Status.CONFIRM
                                  ? ColorsManager.purple
                                  : ColorsManager.red,
                  // fontSize: UtilsReponsive.height(5, context),
                  fontWeight: FontWeight.w800),
            ),
          ),
        )
      ],
    );
  }

  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
      context: context,
      currentDate: DateTime.now().toUtc().add(const Duration(hours: 7)),
      initialDate: controller.taskModel.value.endDate!.toLocal(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTimeStartDate(BuildContext context) => showTimePicker(
      context: context,
      cancelText: 'Hủy chọn giờ bắt đầu',
      initialTime: TimeOfDay(
          hour: controller.taskModel.value.startDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).hour
              : controller.taskModel.value.startDate!.toLocal().hour,
          minute: controller.taskModel.value.startDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).minute
              : controller.taskModel.value.startDate!.toLocal().minute));

  Future<TimeOfDay?> pickTimeEndDate(BuildContext context) => showTimePicker(
      context: context,
      cancelText: 'Hủy chọn giờ kết thúc',
      initialTime: TimeOfDay(
          hour: controller.taskModel.value.endDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).hour
              : controller.taskModel.value.endDate!.toLocal().hour,
          minute: controller.taskModel.value.endDate == null
              ? DateTime.now().toUtc().add(const Duration(hours: 7)).minute
              : controller.taskModel.value.endDate!.toLocal().minute));

  _showBottomLeader({required BuildContext context, required TaskModel taskModel}) {
    Get.bottomSheet(Container(
      height: UtilsReponsive.height(700, context),
      // constraints: BoxConstraints(maxHeight: UtilsReponsive.width(450, context)),
      padding: EdgeInsetsDirectional.symmetric(horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(20, context)), topRight: Radius.circular(UtilsReponsive.height(20, context))),
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
                  border: Border.all(color: ColorsManager.primary), // Màu của border
                ),
                child: TextFormField(
                  // controller: controller.textSearchController,
                  decoration: InputDecoration(
                    // contentPadding: UtilsReponsive.paddingAll(context,
                    //     padding: 2), // Điều chỉnh padding cho icon và text
                    icon: Padding(
                      padding: EdgeInsets.only(left: UtilsReponsive.width(8, context)), // Điều chỉnh khoảng cách từ border đến icon
                      child: Icon(
                        Icons.search,
                        color: ColorsManager.primary,
                      ),
                    ),
                    hintText: 'Tìm kiếm', // Đặt hint text
                    border: InputBorder.none, // Loại bỏ border bên trong TextFormField
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
                    if (controller.employeeLeader.value.totalTask! > 1) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Cảnh báo',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.primary,
                                    fontSize: UtilsReponsive.height(20, context),
                                    fontWeight: FontWeight.w800)),
                            content: Text(
                              'Bạn vẫn muốn chọn nhân viên này để thực hiện công việc?',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.w800),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(Get.context!).pop();
                                  Get.back();
                                  await controller.assignLeader(
                                      controller.taskID, controller.employeeLeader.value, controller.employeeLeader.value.id!);
                                },
                                child: Text('Xác nhận',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.blue,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.w800)),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Đóng hộp thoại mà không xóa
                                  Navigator.of(context).pop();
                                },
                                child: Text('Hủy',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.grey,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Get.back();
                      await controller.assignLeader(controller.taskID, controller.employeeLeader.value, controller.employeeLeader.value.id!);
                    }
                  },
                  child: taskModel.parent!.status != Status.CONFIRM
                      ? Text(
                          'Lưu',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              letterSpacing: 1,
                              color: ColorsManager.primary,
                              fontSize: UtilsReponsive.height(20, context),
                              fontWeight: FontWeight.w800),
                        )
                      : SizedBox(),
                ),
              )
            ],
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(() {
            // controller.listEmployee;
            return controller.isLoadingFetchUser.value
                ? Center(
                    child: SizedBox(
                      height: UtilsReponsive.height(40, context),
                      width: UtilsReponsive.width(40, context),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : Obx(
                    () => Expanded(
                      child: controller.listEmployee.isEmpty
                          ? Center(
                              child: Text(
                                'Không tìm thấy nhân viên',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    letterSpacing: 1,
                                    color: ColorsManager.textColor,
                                    fontSize: UtilsReponsive.height(16, context),
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: controller.getAllEmployee,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.listEmployee.length,
                                  separatorBuilder: (context, index) => SizedBox(
                                        height: UtilsReponsive.height(10, context),
                                      ),
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          {
                                            if (controller.employeeLeader.value.id == null) {
                                              controller.employeeLeader.value = controller.listEmployee[index];
                                            } else {
                                              if (!controller.employeeLeader.value.id!.contains(controller.listEmployee[index].id!)) {
                                                // controller.listEmployeeChoose
                                                //     .add(controller.listEmployee[index]);
                                                controller.employeeLeader.value = controller.listEmployee[index];
                                                print('  controller.listEmployeeChoose ${controller.listEmployeeChoose.length}');
                                              } else {
                                                controller.employeeLeader.value = EmployeeModel();
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: UtilsReponsive.height(10, context),
                                            horizontal: UtilsReponsive.width(15, context),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: controller.employeeLeader.value.id != null &&
                                                    controller.employeeLeader.value.id!.contains(controller.listEmployee[index].id!)
                                                ? Colors.blue.shade100
                                                : Colors.white,
                                            border: Border.all(
                                              color: controller.employeeLeader.value.id != null &&
                                                      controller.employeeLeader.value.id!.contains(controller.listEmployee[index].id!)
                                                  ? Colors.white
                                                  : Colors.blue.shade100, // Đặt màu border xung quanh Container
                                              width: 1.0, // Đặt độ dày của border
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: CircleAvatar(
                                                  radius: UtilsReponsive.height(20, context),
                                                  backgroundColor: Colors.transparent,
                                                  child: controller.listEmployee[index].profile!.avatar == null ||
                                                          controller.listEmployee[index].profile!.avatar == ''
                                                      ? Container(
                                                          width: UtilsReponsive.width(60, context),
                                                          height: UtilsReponsive.height(60, context),
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
                                                      : ClipOval(
                                                          child: Image.network(
                                                            controller.listEmployee[index].profile!.avatar!,
                                                            fit: BoxFit.cover,
                                                            width: UtilsReponsive.widthv2(context, 60),
                                                            height: UtilsReponsive.heightv2(context, 60),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(width: UtilsReponsive.width(10, context)),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.toNamed(Routes.PROFILE_CHAT,
                                                                arguments: {"idUserChat": controller.listEmployee[index].id});
                                                          },
                                                          child: Text(
                                                            controller.listEmployee[index].profile!.fullName!.length > 15
                                                                ? '${controller.listEmployee[index].profile!.fullName!.substring(0, 15)}...'
                                                                : controller.listEmployee[index].profile!.fullName!,
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              letterSpacing: 1,
                                                              color: ColorsManager.textColor,
                                                              fontSize: UtilsReponsive.height(17, context),
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: UtilsReponsive.width(10, context)), // Khoảng cách giữa
                                                        Container(
                                                          width: UtilsReponsive.width(14, context),
                                                          height: UtilsReponsive.height(14, context),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: controller.listEmployee[index].isFree == true
                                                                ? Colors.green
                                                                : Colors.orange, // Màu nền là màu xanh
                                                            // Viền trắng xung quanh
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      controller.listEmployee[index].email!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: ColorsManager.blue.withOpacity(0.8),
                                                        fontSize: UtilsReponsive.height(16, context),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: 'Tổng số công việc: ',
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              wordSpacing: 1.2,
                                                              color: ColorsManager.textColor2,
                                                              fontSize: UtilsReponsive.height(17, context),
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '${controller.listEmployee[index].totalTask}',
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              color: Colors.blue,
                                                              fontSize: UtilsReponsive.height(17, context),
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: UtilsReponsive.height(10, context)),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.toNamed('/task-calendar-month', arguments: {
                                                              'userID': controller.listEmployee[index].id,
                                                              'userName': controller.listEmployee[index].profile!.fullName,
                                                              'startDate':
                                                                  controller.dateFormatv2.format(controller.taskModel.value.startDate!.toLocal()),
                                                              'endDate':
                                                                  controller.dateFormatv2.format(controller.taskModel.value.endDate!.toLocal()),
                                                            });
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
                                                              padding: EdgeInsets.all(UtilsReponsive.height(6, context)),
                                                              child: Text(
                                                                'Xem lịch trình',
                                                                style: TextStyle(
                                                                  fontFamily: 'Nunito',
                                                                  color: Colors.white,
                                                                  fontSize: UtilsReponsive.height(16, context),
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              )), // Biểu tượng mũi tên right
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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

  _showBottomAddMore({required BuildContext context, required TaskModel taskModel}) {
    Get.bottomSheet(Container(
      height: UtilsReponsive.height(700, context),
      // constraints: BoxConstraints(maxHeight: UtilsReponsive.height(700, context)),
      padding: EdgeInsetsDirectional.symmetric(horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(20, context)), topRight: Radius.circular(UtilsReponsive.height(20, context))),
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
                  border: Border.all(color: ColorsManager.primary), // Màu của border
                ),
                child: TextFormField(
                  // controller: controller.textSearchController,
                  decoration: InputDecoration(
                    // contentPadding: UtilsReponsive.paddingAll(context,
                    //     padding: 2), // Điều chỉnh padding cho icon và text
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Điều chỉnh khoảng cách từ border đến icon
                      child: Icon(
                        Icons.search,
                        color: ColorsManager.primary,
                      ),
                    ),
                    hintText: 'Tìm kiếm', // Đặt hint text
                    border: InputBorder.none, // Loại bỏ border bên trong TextFormField
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
                    bool checkEmployees = false;
                    for (int i = 0; i < controller.listEmployeeChoose.length; i++) {
                      if (controller.listEmployeeChoose[i].totalTask! > 1) {
                        checkEmployees = true;
                        break;
                      }
                    }
                    if (controller.employeeLeader.value.id == null || controller.employeeLeader.value.id == '') {
                      Get.snackbar('Lỗi', 'Xin vui lòng chọn Người chịu trách nhiệm trước',
                          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
                    } else if (checkEmployees) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Cảnh báo',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.primary,
                                    fontSize: UtilsReponsive.height(20, context),
                                    fontWeight: FontWeight.w800)),
                            content: Text(
                              'Bạn vẫn muốn chọn những nhân viên này để thực hiện công việc?',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.w800),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(Get.context!).pop();
                                  Get.back();
                                  await controller.assignSupporter(
                                      controller.taskID, controller.listEmployeeChoose, controller.employeeLeader.value.id!);
                                },
                                child: Text('Xác nhận',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.blue,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.w800)),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Đóng hộp thoại mà không xóa
                                  Navigator.of(context).pop();
                                },
                                child: Text('Hủy',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.grey,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Get.back();
                      // Navigator.of(Get.context!).pop();
                      await controller.assignSupporter(controller.taskID, controller.listEmployeeChoose, controller.employeeLeader.value.id!);
                    }
                    // Get.back();
                  },
                  child: taskModel.parent!.status != Status.CONFIRM
                      ? Text(
                          'Lưu',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              letterSpacing: 1,
                              color: ColorsManager.primary,
                              fontSize: UtilsReponsive.height(20, context),
                              fontWeight: FontWeight.w800),
                        )
                      : SizedBox(),
                ),
              )
            ],
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(() {
            // controller.listEmployee;
            return controller.isLoadingFetchUser.value
                ? Center(
                    child: SizedBox(
                      height: UtilsReponsive.height(40, context),
                      width: UtilsReponsive.width(40, context),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : Obx(
                    () => Expanded(
                      child: controller.listEmployee.isEmpty
                          ? Center(
                              child: Text(
                                'Không tìm thấy nhân viên',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    letterSpacing: 1,
                                    color: Colors.black,
                                    fontSize: UtilsReponsive.height(16, context),
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: controller.getEmployeeSupport,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.listEmployee.length,
                                  separatorBuilder: (context, index) => SizedBox(
                                        height: UtilsReponsive.height(10, context),
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

                                            if (!controller.listEmployeeChoose.contains(controller.listEmployee[index])) {
                                              controller.listEmployeeChoose.add(controller.listEmployee[index]);
                                            } else {
                                              controller.listEmployeeChoose.remove(controller.listEmployee[index]);
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: UtilsReponsive.height(10, context), horizontal: UtilsReponsive.height(15, context)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context)),
                                            color: controller.listEmployeeChoose.contains(controller.listEmployee[index])
                                                ? Colors.blue.shade100
                                                : Colors.white,
                                            border: Border.all(
                                              color: controller.listEmployeeChoose.contains(controller.listEmployee[index])
                                                  ? Colors.white
                                                  : Colors.blue.shade100, // Đặt màu border xung quanh Container
                                              width: 1.0, // Đặt độ dày của border
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: CircleAvatar(
                                                  radius: UtilsReponsive.height(20, context),
                                                  backgroundColor: Colors.transparent,
                                                  child: controller.listEmployee[index].profile!.avatar == null ||
                                                          controller.listEmployee[index].profile!.avatar == ''
                                                      ? Container(
                                                          width: UtilsReponsive.width(60, context),
                                                          height: UtilsReponsive.height(60, context),
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
                                                      : ClipOval(
                                                          child: Image.network(
                                                            controller.listEmployee[index].profile!.avatar!,
                                                            fit: BoxFit.cover,
                                                            width: UtilsReponsive.widthv2(context, 60),
                                                            height: UtilsReponsive.heightv2(context, 60),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(width: UtilsReponsive.width(10, context)),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.toNamed(Routes.PROFILE_CHAT,
                                                                arguments: {"idUserChat": controller.listEmployee[index].id});
                                                          },
                                                          child: Text(
                                                            controller.listEmployee[index].profile!.fullName!.length > 15
                                                                ? '${controller.listEmployee[index].profile!.fullName!.substring(0, 15)}...'
                                                                : controller.listEmployee[index].profile!.fullName!,
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              letterSpacing: 1,
                                                              color: ColorsManager.textColor,
                                                              fontSize: UtilsReponsive.height(17, context),
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: UtilsReponsive.width(10, context)), // Khoảng cách giữa
                                                        Container(
                                                          width: 14,
                                                          height: 14,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: controller.listEmployee[index].isFree == true
                                                                ? Colors.green
                                                                : Colors.orange, // Màu nền là màu xanh
                                                            // Viền trắng xung quanh
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      controller.listEmployee[index].email!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: ColorsManager.blue.withOpacity(0.8),
                                                        fontSize: UtilsReponsive.height(16, context),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: 'Tổng số công việc: ',
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              wordSpacing: 1.2,
                                                              color: ColorsManager.textColor2,
                                                              fontSize: UtilsReponsive.height(17, context),
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '${controller.listEmployee[index].totalTask}',
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              color: Colors.blue,
                                                              fontSize: UtilsReponsive.height(17, context),
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: UtilsReponsive.height(10, context)),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.toNamed('/task-calendar-month', arguments: {
                                                              'userID': controller.listEmployee[index].id,
                                                              'userName': controller.listEmployee[index].profile!.fullName,
                                                              'startDate':
                                                                  controller.dateFormatv2.format(controller.taskModel.value.startDate!.toLocal()),
                                                              'endDate':
                                                                  controller.dateFormatv2.format(controller.taskModel.value.endDate!.toLocal()),
                                                            });
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
                                                              padding: EdgeInsets.all(UtilsReponsive.height(6, context)),
                                                              child: Text(
                                                                'Xem lịch trình',
                                                                style: TextStyle(
                                                                  fontFamily: 'Nunito',
                                                                  color: Colors.white,
                                                                  fontSize: UtilsReponsive.height(16, context),
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              )), // Biểu tượng mũi tên right
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
      confirm: GestureDetector(
          onTap: () async {
            bool isErrorStartDate = true;
            bool isErrorEndDate = true;

            bool isStartDateCancel = false;
            bool isEndDateCancel = false;

            DateTime newStartDate = DateTime(
              controller.listChange.first!.year,
              controller.listChange.first!.month,
              controller.listChange.first!.day,
            );
            DateTime newEndDate = DateTime(
              controller.listChange.last!.year,
              controller.listChange.first!.month,
              controller.listChange.last!.day,
            );

            // while (isErrorEndDate) {
            //   if (newEndDate.toLocal().isAfter(controller.startDateTaskParent.toLocal())) {
            //     Get.snackbar(
            //       'Thông báo',
            //       'Ngày của công việc nhỏ phải nằm trong khoảng ngày bắt đầu ${controller.dateFormat.format(controller.startDateTaskParent.toLocal())} ${getCurrentTime(controller.startDateTaskParent.toLocal())} của công việc lớn',
            //       snackPosition: SnackPosition.TOP,
            //       margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
            //       backgroundColor: ColorsManager.backgroundGrey,
            //       colorText: ColorsManager.textColor2,
            //       duration: const Duration(seconds: 4),
            //     );
            //     isErrorEndDate = true;
            //   } else {
            //     isErrorEndDate = false;
            //   }
            // }

            while (isErrorStartDate) {
              TimeOfDay? timeStartDate = await pickTimeStartDate(Get.context!);
              if (timeStartDate == null) {
                isStartDateCancel = true;
                return;
              }
              final newDate = DateTime(controller.listChange.first!.year, controller.listChange.first!.month, controller.listChange.first!.day,
                  timeStartDate.hour, timeStartDate.minute);
              newStartDate = newDate;

              // if (!newDate.toLocal().isAfter(controller.endDate.value.toLocal())) {
              //   Get.snackbar(
              //     'Thông báo',
              //     'Giờ bắt đầu của công việc nhỏ phải nhỏ hơn giờ kết thúc ${controller.dateFormat.format(controller.endDate.value.toLocal())} ${getCurrentTime(controller.endDate.value.toLocal())} của công việc nhỏ',
              //     snackPosition: SnackPosition.TOP,
              //     margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
              //     backgroundColor: ColorsManager.backgroundGrey,
              //     colorText: ColorsManager.textColor2,
              //     duration: const Duration(seconds: 4),
              //   );

              //   isErrorStartDate = true;
              // }
              //  else if (newDate //23/10 0202
              //     .toLocal()
              //     .isAfter(controller.endDateTaskParent.toLocal())) {
              //   //23/10/1231
              //   Get.snackbar(
              //     'Thông báo 2',
              //     'Giờ bắt đầu của công việc nhỏ phải nhỏ hơn giờ kết thúc ${controller.dateFormat.format(controller.endDateTaskParent.toLocal())} ${getCurrentTime(controller.endDateTaskParent.toLocal())} của công việc lớn',
              //     snackPosition: SnackPosition.TOP,
              //     margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
              //     backgroundColor: ColorsManager.backgroundGrey,
              //     colorText: ColorsManager.textColor2,
              //     duration: const Duration(seconds: 4),
              //   );
              //   isErrorEndDate = true;
              // }

              // else {
              isErrorStartDate = false;
              // }
            }

            while (isErrorEndDate) {
              TimeOfDay? timeEndDate = await pickTimeEndDate(Get.context!);
              if (timeEndDate == null) {
                isEndDateCancel = true;
                return;
              }
              final newDate = DateTime(controller.listChange.first!.year, controller.listChange.first!.month, controller.listChange.first!.day,
                  timeEndDate.hour, timeEndDate.minute);

              print(newDate);
              newEndDate = newDate;

              if (newDate.toLocal().isBefore(newStartDate.toLocal())) {
                Get.snackbar(
                  'Thông báo',
                  'Giờ kết thúc của công việc nhỏ phải lớn hơn giờ bắt đầu ${controller.dateFormat.format(newStartDate.toLocal())} ${getCurrentTime(newStartDate.toLocal())} của công việc nhỏ',
                  snackPosition: SnackPosition.TOP,
                  margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                  backgroundColor: Colors.redAccent,
                  colorText: ColorsManager.backgroundWhite,
                  duration: const Duration(seconds: 4),
                );
                isErrorEndDate = true;
              }
              //  else if (newStartDate.isAfter(newEndDate)) {
              //   Get.snackbar(
              //     'Thông báo',
              //     'Ngày kết thúc của công việc nhỏ phải lớn hơn giờ bắt đầu ${controller.dateFormat.format(newStartDate)} ${getCurrentTime(newStartDate)} của công việc nhỏ',
              //     snackPosition: SnackPosition.TOP,
              //     margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
              //     backgroundColor: ColorsManager.backgroundGrey,
              //     colorText: ColorsManager.textColor2,
              //     duration: const Duration(seconds: 4),
              //   );
              //   isErrorEndDate = true;
              //   }
              //   else

              else if (newEndDate.difference(newStartDate).inMinutes < 15) {
                print(newEndDate);
                print(newStartDate);
                Get.snackbar(
                  'Thông báo',
                  'Giờ kết thúc của công việc nhỏ phải lớn hơn 15 phút so với giờ bắt ${controller.dateFormat.format(newStartDate.toLocal())} ${getCurrentTime(newStartDate.toLocal())} của công việc nhỏ ',
                  snackPosition: SnackPosition.TOP,
                  margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                  backgroundColor: Colors.redAccent,
                  colorText: ColorsManager.backgroundWhite,
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

            if (isErrorEndDate == false) {
              controller.startDate.value = newStartDate;
              controller.endDate.value = newEndDate;
              Get.back();
              await controller.updateDateTime(taskID, controller.startDate.value, controller.endDate.value);
              controller.errorUpdateSubTask.value ? _errorMessage(context) : _successMessage(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Điều chỉnh độ cong của góc (có thể thay đổi giá trị)
              color: Colors.blue, // Màu nền của container
            ),
            child: Text(
              'Xác nhận',
              style: TextStyle(
                fontFamily: 'Nunito',
                letterSpacing: 1,
                color: Colors.white, // Màu chữ bên trong container
                fontSize: UtilsReponsive.height(18, context),
                fontWeight: FontWeight.w800,
              ),
            ),
          )),
      title: 'Chọn ngày',
      content: SizedBox(
        height: UtilsReponsive.height(300, context),
        width: UtilsReponsive.height(300, context),
        child: CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            // firstDate: controller.startDateTaskParent.toUtc().toLocal().add(const Duration(hours: 7)),
            firstDate: controller.startDateTaskParent.toUtc().toLocal(),
            // lastDate: controller.endDateTaskParent.toUtc().toLocal().add(const Duration(hours: 7)),
            lastDate: controller.endDateTaskParent.toUtc().toLocal(),
            currentDate: controller.taskModel.value.startDate ??
                // controller.startDateTaskParent.toUtc().toLocal().add(const Duration(hours: 7)),
                controller.startDateTaskParent.toUtc().toLocal(),
            calendarType: CalendarDatePicker2Type.range,
            centerAlignModePicker: true,
            selectedDayTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
      height: UtilsReponsive.height(700, context),
      // constraints: BoxConstraints(maxHeight: UtilsReponsive.width(250, context)),
      padding: EdgeInsetsDirectional.symmetric(horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(10, context)), topRight: Radius.circular(UtilsReponsive.height(10, context))),
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
                padding: EdgeInsets.symmetric(vertical: UtilsReponsive.height(10, context), horizontal: UtilsReponsive.height(15, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context)),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue.shade100, // Đặt màu border xung quanh Container
                    width: 1.0, // Đặt độ dày của border
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: UtilsReponsive.height(20, context),
                        backgroundColor: Colors.transparent,
                        child: controller.listEmployeeSupportView[index].profile!.avatar == null ||
                                controller.listEmployeeSupportView[index].profile!.avatar == ''
                            ? Container(
                                width: UtilsReponsive.width(60, context),
                                height: UtilsReponsive.height(60, context),
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
                            : ClipOval(
                                child: Image.network(
                                  controller.listEmployeeSupportView[index].profile!.avatar!,
                                  fit: BoxFit.cover,
                                  width: UtilsReponsive.widthv2(context, 60),
                                  height: UtilsReponsive.heightv2(context, 60),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: UtilsReponsive.width(10, context)),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.PROFILE_CHAT, arguments: {"idUserChat": controller.listEmployeeSupportView[index].id});
                                },
                                child: Text(
                                  controller.listEmployeeSupportView[index].profile!.fullName!.length > 15
                                      ? '${controller.listEmployeeSupportView[index].profile!.fullName!.substring(0, 15)}...'
                                      : controller.listEmployeeSupportView[index].profile!.fullName!,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    letterSpacing: 1,
                                    color: ColorsManager.textColor,
                                    fontSize: UtilsReponsive.height(17, context),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: UtilsReponsive.width(10, context)), // Khoảng cách giữa
                              Container(
                                width: UtilsReponsive.width(14, context),
                                height: UtilsReponsive.height(14, context),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      controller.listEmployeeSupportView[index].isFree == true ? Colors.green : Colors.orange, // Màu nền là màu xanh
                                  // Viền trắng xung quanh
                                ),
                              ),
                            ],
                          ),
                          Text(
                            controller.listEmployeeSupportView[index].email!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              letterSpacing: 1,
                              color: ColorsManager.blue.withOpacity(0.8),
                              fontSize: UtilsReponsive.height(17, context),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Tổng số công việc: ',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.textColor2,
                                    fontSize: UtilsReponsive.height(17, context),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: '${controller.listEmployeeSupportView[index].totalTask}',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    color: Colors.blue,
                                    fontSize: UtilsReponsive.height(17, context),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: UtilsReponsive.height(10, context)),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/task-calendar-month', arguments: {
                                    'userID': controller.listEmployeeSupportView[index].id,
                                    'userName': controller.listEmployeeSupportView[index].profile!.fullName,
                                    'startDate': controller.dateFormatv2.format(controller.taskModel.value.startDate!.toLocal()),
                                    'endDate': controller.dateFormatv2.format(controller.taskModel.value.endDate!.toLocal()),
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(UtilsReponsive.height(6, context)),
                                    child: Text(
                                      'Xem lịch trình',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: Colors.white,
                                        fontSize: UtilsReponsive.height(16, context),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )), // Biểu tượng mũi tên right
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
          // controller.onDelete();
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: ColorsManager.primary,
        ),
      ),
      actions: controller.checkView.value == false
          ? []
          : controller.checkView.value == true && controller.taskModel.value.parent!.status != Status.CONFIRM
              ? [
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
                                      fontFamily: 'Nunito',
                                      wordSpacing: 1.2,
                                      color: ColorsManager.primary,
                                      fontSize: UtilsReponsive.height(20, context),
                                      fontWeight: FontWeight.w800)),
                              content: Text(
                                'Bạn có muốn xóa công việc này?',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.textColor2,
                                    fontSize: UtilsReponsive.height(18, context),
                                    fontWeight: FontWeight.w800),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(Get.context!).pop();
                                    await controller.deleteTask("CANCEL", controller.taskID);
                                  },
                                  child: Text('Xóa',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          wordSpacing: 1.2,
                                          color: ColorsManager.red,
                                          fontSize: UtilsReponsive.height(18, context),
                                          fontWeight: FontWeight.w800)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Đóng hộp thoại mà không xóa
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hủy',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          wordSpacing: 1.2,
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(18, context),
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (choice == 'progress') {
                        controller.progressView.value = controller.progress.value;
                        _showProgress(context: context, taskModel: controller.taskModel.value);
                      } else if (choice == 'viewReassign') {
                        Get.toNamed(Routes.TIMELINE_REASSIGN, arguments: {"taskID": controller.taskModel.value.id});
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'progress',
                          child: Obx(
                            () => Text(
                              'Tiến độ ${controller.progress.value}',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            'Xóa công việc này',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                wordSpacing: 1.2,
                                color: ColorsManager.textColor2,
                                fontSize: UtilsReponsive.height(18, context),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'viewReassign',
                          child: Text(
                            'Xem lịch sử giao việc',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                wordSpacing: 1.2,
                                color: ColorsManager.textColor2,
                                fontSize: UtilsReponsive.height(18, context),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        // Các mục menu khác nếu cần
                      ];
                    },
                  ),
                ]
              : [
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: ColorsManager.primary,
                    ),
                    onSelected: (choice) {
                      if (choice == 'progress') {
                        controller.progressView.value = controller.progress.value;
                        _showProgress(context: context, taskModel: controller.taskModel.value);
                      } else if (choice == 'viewReassign') {
                        Get.toNamed(Routes.TIMELINE_REASSIGN, arguments: {"taskID": controller.taskModel.value.id});
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'progress',
                          child: Obx(
                            () => Text(
                              'Tiến độ ${controller.progress.value}',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'viewReassign',
                          child: Text(
                            'Xem lịch sử giao việc',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                wordSpacing: 1.2,
                                color: ColorsManager.textColor2,
                                fontSize: UtilsReponsive.height(18, context),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        // Các mục menu khác nếu cần
                      ];
                    },
                  ),
                ],
    );
  }

  _showProgress({required BuildContext context, required TaskModel taskModel}) {
    Get.bottomSheet(Container(
      height: UtilsReponsive.height(200, context),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(200, context)),
      padding: EdgeInsetsDirectional.symmetric(horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(20, context)), topRight: Radius.circular(UtilsReponsive.height(20, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            // controller.listEmployee;
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            wordSpacing: 1.2,
                            fontSize: UtilsReponsive.height(24, context),
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Tiến độ: ',
                              style: TextStyle(
                                color: ColorsManager.textColor,
                              ),
                            ),
                            TextSpan(
                              text: '${controller.progressView.value} %',
                              style: TextStyle(
                                color: ColorsManager.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.updateProgress(controller.progressView.value);
                          Navigator.of(context).pop();
                        },
                        child: taskModel.parent!.status != Status.CONFIRM
                            ? Text(
                                'Lưu',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.primary,
                                    fontSize: UtilsReponsive.height(24, context),
                                    fontWeight: FontWeight.w700),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Slider(
                      value: controller.progressView.value,
                      max: 100,
                      divisions: 10,
                      label: controller.progressView.value.round().toString(),
                      onChanged: (value) {
                        controller.progressView.value = value;
                      }),
                ],
              ),
            );
          })
        ],
      ),
    ));
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
          borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: UtilsReponsive.height(10, context)),
            child: Text('Bình luận',
                style: TextStyle(
                    fontFamily: 'Nunito',
                    wordSpacing: 1.2,
                    color: Colors.black,
                    fontSize: UtilsReponsive.height(18, context),
                    fontWeight: FontWeight.w800)),
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(
            () => controller.listComment.isNotEmpty
                ? Container(
                    padding: EdgeInsets.only(left: UtilsReponsive.height(10, context)),
                    margin: EdgeInsets.only(top: UtilsReponsive.height(10, context)),
                    child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.listComment.length,
                        separatorBuilder: (context, index) => SizedBox(height: UtilsReponsive.height(30, context)),
                        itemBuilder: (context, index) {
                          return comment(controller.listComment[index], context, index);
                        }),
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(controller.focusNodeComment);
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
                              style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.primary),
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

  StatefulBuilder comment(CommentModel commentModel, BuildContext context, int index) {
    // bool isEditComment = false;
    TextEditingController commentTextController = TextEditingController(text: commentModel.text);
    List<PlatformFile> filePickerEditCommentFile = [];
    return StatefulBuilder(builder: (context, setStateX) {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: UtilsReponsive.height(20, context),
                    backgroundColor: Colors.transparent, // Đảm bảo nền trong suốt
                    child: commentModel.user!.profile!.avatar == null || commentModel.user!.profile!.avatar == ''
                        ? Container(
                            width: UtilsReponsive.width(60, context),
                            height: UtilsReponsive.height(60, context),
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
                          fontFamily: 'Nunito',
                          letterSpacing: 1,
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(17, context),
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: UtilsReponsive.width(5, context)),
                    Text(
                      calculateTimeDifference(commentModel.createdAt.toString()),
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          letterSpacing: 1,
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(14, context),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: UtilsReponsive.height(10, context)),
            Obx(
              () => controller.isLoadingDeleteComment.value
                  ? SpinKitFadingCircle(
                      color: ColorsManager.primary,
                      // size: 50.0,
                    )
                  : commentModel.commentFiles!.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: UtilsReponsive.height(8, context)),
                          height: UtilsReponsive.height(150, context),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: commentModel.commentFiles!.length,
                            separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                            itemBuilder: (context, index) {
                              return _filesComment(
                                commentModel.commentFiles![index],
                                context,
                                controller.listComment[index].isEditComment!,
                              );
                            },
                          ),
                        )
                      : SizedBox(),
            ),
            filePickerEditCommentFile.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: UtilsReponsive.height(15, context),
                      ),
                      Text(
                        'Tệp đã thêm',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            letterSpacing: 1,
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(14, context),
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: UtilsReponsive.height(8, context)),
                        height: UtilsReponsive.height(150, context),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: filePickerEditCommentFile.length,
                          separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                          itemBuilder: (context, index) {
                            return editFileComment(filePickerEditCommentFile[index], context, index, controller.listComment[index].isEditComment!,
                                setStateX, filePickerEditCommentFile);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            SizedBox(height: UtilsReponsive.height(10, context)),
            controller.listComment[index].isEditComment == true
                ? Container(
                    constraints: BoxConstraints(maxHeight: UtilsReponsive.height(300, context), minHeight: UtilsReponsive.height(100, context)),
                    child: FormFieldWidget(
                      setValueFunc: (value) {
                        commentTextController.text = value;
                      },
                      // controllerEditting: controller.commentTextController,
                      maxLine: 4,
                      initValue: commentModel.text,
                    ),
                  )
                : Text(
                    commentModel.text!,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        letterSpacing: 1,
                        color: ColorsManager.textColor,
                        fontSize: UtilsReponsive.height(18, context),
                        fontWeight: FontWeight.w700),
                  ),
            SizedBox(height: UtilsReponsive.width(10, context)),
            controller.listComment[index].isEditComment == false
                ? Row(
                    children: [
                      InkWell(
                          onTap: () {
                            controller.isCheckEditComment.value = true;
                            setStateX(() {
                              controller.listComment[index].isEditComment = true;
                            });
                          },
                          child: commentModel.user!.id == controller.idUser
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                      ? Text(
                                          'Chỉnh sửa',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                        )
                                      : SizedBox())
                              : const SizedBox()),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      commentModel.user!.id == controller.idUser
                          ? InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Xác nhận xóa bình luận',
                                          style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                        ),
                                        content: Text(
                                          'Xóa một bình luận là vĩnh viễn. Không có cách hoàn tác',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Hủy',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Xác nhận',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.red),
                                            ),
                                            onPressed: () {
                                              controller.deleteComment(commentModel);
                                              setStateX(() {
                                                controller.listComment[index].isEditComment = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                      ? Text(
                                          'Xóa',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.red),
                                        )
                                      : SizedBox()))
                          : const SizedBox(),
                    ],
                  )
                : Row(
                    children: [
                      InkWell(
                          onTap: () async {
                            if (commentTextController.text == "") {
                              Get.snackbar(
                                'Thông báo',
                                'Bạn phải nhập ít nhất 1 kí tự',
                                snackPosition: SnackPosition.TOP,
                                margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                                backgroundColor: ColorsManager.backgroundGrey,
                                colorText: ColorsManager.textColor2,
                                duration: const Duration(seconds: 4),
                              );
                            } else {
                              await controller.editComment(commentModel, commentTextController.text, commentModel.id!, filePickerEditCommentFile);
                              setStateX(() {
                                controller.listComment[index].isEditComment = false;
                              });
                              controller.isCheckEditComment.value = false;
                            }
                          },
                          child: Obx(
                            () => Align(
                                alignment: Alignment.topLeft,
                                child: controller.isLoadingCommentV2.value
                                    ? Container(
                                        width: 30,
                                        height: 30,
                                        child: SpinKitFadingCircle(
                                          color: ColorsManager.primary,
                                          size: 20,
                                        ),
                                      )
                                    : Text(
                                        'Lưu',
                                        style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                      )),
                          )),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      InkWell(
                          onTap: () async {
                            await controller.cancel(commentModel.id!);
                            filePickerEditCommentFile.clear();
                            setStateX(() {
                              controller.listComment[index].isEditComment = false;
                            });
                            controller.isCheckEditComment.value = false;
                          },
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Hủy',
                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.red),
                              ))),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      InkWell(
                          onTap: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'pdf', 'doc', 'xlsx', 'docx', 'png', 'jpeg'],
                            );
                            if (result == null) {
                              return;
                            }

                            final file = result.files.first;
                            double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;
                            if (fileLength > 10) {
                              Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
                                  snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);

                              return;
                            }
                            setStateX(() {
                              filePickerEditCommentFile.add(file);
                            });
                          },
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Thêm tệp',
                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                              ))),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                    ],
                  )
          ],
        ),
      );
    });
  }

  Obx _documentV2(BuildContext context) {
    return Obx(
      () => Container(
          // height: controller.listAttachment.isEmpty
          //     ? 50
          //     : UtilsReponsive.height(200, context),
          // padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                children: [
                  Text('Tài liệu',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          wordSpacing: 1.2,
                          color: Colors.black,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w800)),
                  SizedBox(
                    width: UtilsReponsive.width(5, context),
                  ),
                  controller.listAttachment.isNotEmpty
                      ? CircleAvatar(
                          radius: controller.listAttachment.length >= 100
                              ? 15
                              : controller.listAttachment.length >= 10
                                  ? 15
                                  : 10,
                          child: Text(
                            controller.listAttachment.length.toString(),
                            style: TextStyle(
                                letterSpacing: 1,
                                color: ColorsManager.backgroundWhite,
                                fontSize: UtilsReponsive.height(15, context),
                                fontWeight: FontWeight.w800),
                          ),
                        )
                      : const SizedBox(),
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
                                if (controller.taskModel.value.parent!.status != Status.CONFIRM) {
                                  await controller.selectFile();
                                }
                              },
                              child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                  ? Text(
                                      '+  Thêm tệp',
                                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                    )
                                  : SizedBox(),
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
                              separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(10, context)),
                              itemBuilder: (context, index) {
                                return _files(controller.listAttachment[index], context);
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
                                    if (controller.taskModel.value.parent!.status != Status.CONFIRM) {
                                      await controller.selectFile();
                                    }
                                  },
                                  child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                      ? Text(
                                          '+  Thêm tệp',
                                          style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                        )
                                      : SizedBox(),
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

  void _showOptionsDocumentPopup(BuildContext context, AttachmentModel attachmentModel, int mode) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  if (mode != 2) {
                    _showDeleteDocumentConfirmation(context, attachmentModel, _popupContext);
                  } else {
                    Get.snackbar(
                      'Thông báo',
                      'Bạn khổng thể xóa tệp tài liệu của bình luận',
                      snackPosition: SnackPosition.TOP,
                      margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
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

  void _showDeleteDocumentConfirmation(BuildContext context, AttachmentModel attachmentModel, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
                await controller.deleteTaskFile(attachmentModel);
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsFileCommentPopup(BuildContext context, CommentFile commentFile) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteFileCommentConfirmation(context, commentFile, _popupContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteFileCommentConfirmation(BuildContext context, CommentFile commentFile, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteCommentFile(commentFile);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
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
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmation(context, index, _popupContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAttachmentCommentConfirmation(BuildContext context, int index, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteAttachmentCommentFile(index);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsAttachmentCommentPopupV2(BuildContext context, int index, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    BuildContext popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmationV2(context, index, popupContext, setStateX, filePickerEditCommentFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAttachmentCommentConfirmationV2(
      BuildContext context, int index, BuildContext popupContext, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                setStateX(() => {filePickerEditCommentFile.removeAt(index)});
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  InkWell attchfileComment(PlatformFile attachCommentFile, BuildContext context, int index) {
    final fileName = attachCommentFile.path!.split('/').last;
    final kb = attachCommentFile.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
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
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    flex: 4,
                    // child: Text('hiii'),
                    child: fileName.length > 35
                        ? Text(
                            fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                            style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                          )
                        : Text(
                            fileName,
                            style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                          ),
                  ),
                  Expanded(
                      child: Text(
                    fileSize,
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                  )),
                ]),
              ),
            ),
    );
  }

  InkWell editFileComment(
      PlatformFile attachCommentFile, BuildContext context, int index, bool isEditComment, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    final fileName = attachCommentFile.path!.split('/').last;
    final kb = attachCommentFile.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = attachCommentFile.extension;
    return InkWell(
      onTap: () {
        controller.openFile(attachCommentFile);
      },
      onLongPress: () {
        if (isEditComment) {
          _showOptionsAttachmentCommentPopupV2(context, index, setStateX, filePickerEditCommentFile);
        }
      },
      child: extension == 'jpg' || extension == 'png' || extension == 'jpeg'
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
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
              width: UtilsReponsive.width(125, context),
              padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  flex: 4,
                  // child: Text('hiii'),
                  child: fileName.length > 35
                      ? Text(
                          fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                        )
                      : Text(
                          fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                        ),
                ),
                Expanded(
                    child: Text(
                  fileSize,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                )),
              ]),
            ),
    );
  }

  InkWell _filesComment(CommentFile commentFile, BuildContext context, bool isEditComment) {
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
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
          padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: commentFile.fileName!.length > 35
                  ? Text(
                      commentFile.fileName!.length > 35 ? '${commentFile.fileName!.substring(0, 35)}...' : commentFile.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    )
                  : Text(
                      commentFile.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    ),
            ),
            // const Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Text(
            //         'Kích thước',
            //         style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
            //       ),
            //     ],
            //   ),
            // ),
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
        _showOptionsDocumentPopup(context, attachmentModel, attachmentModel.mode!);
      },
      child: CachedNetworkImage(
        imageUrl: attachmentModel.fileUrl!,
        imageBuilder: (context, imageProvider) => Container(
            width: UtilsReponsive.width(110, context),
            padding: UtilsReponsive.paddingAll(context, padding: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
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
          padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 2,
              // child: Text('hiii'),
              child: attachmentModel.fileName!.length > 35
                  ? Text(
                      attachmentModel.fileName!.length > 35 ? '${attachmentModel.fileName!.substring(0, 35)}...' : attachmentModel.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    )
                  : Text(
                      attachmentModel.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    ),
            ),
            // const Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Text(
            //         'Kích thước',
            //         style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
            //       ),
            //     ],
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }

  Quil.QuillProvider _description(BuildContext context) {
    return Quil.QuillProvider(
      configurations: Quil.QuillConfigurations(controller: controller.quillController.value),
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
                  fontFamily: 'Nunito',
                  wordSpacing: 1.2,
                  color: ColorsManager.textColor,
                  fontSize: UtilsReponsive.height(18, context),
                  fontWeight: FontWeight.w800),
            ),
            children: [
              controller.taskModel.value.description != null &&
                      controller.taskModel.value.description != '' &&
                      controller.taskModel.value.description!.trim() != '[{\"insert\":\"\\n\"}]'
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context), vertical: UtilsReponsive.height(10, context)),
                      child: InkWell(
                          onTap: () {
                            if (controller.taskModel.value.parent!.status != Status.CONFIRM) {
                              controller.onTapEditDescription();
                            }
                          },
                          child: IgnorePointer(
                              ignoring: true,
                              child: Quil.QuillEditor.basic(
                                // controller: controller,
                                configurations: const Quil.QuillEditorConfigurations(autoFocus: false, readOnly: false),

                                // embedBuilders: FlutterQuillEmbeds.builders(),
                              ))),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context), vertical: UtilsReponsive.height(10, context)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (controller.taskModel.value.parent!.status != Status.CONFIRM) {
                                controller.onTapEditDescription();
                              }
                            },
                            child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                ? Text(
                                    'Thêm mô tả...',
                                    style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  )
                                : SizedBox(),
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
          decoration: const BoxDecoration(color: Color.fromARGB(255, 81, 146, 83), borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Cập nhật trạng thái thành công',
                  style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, Colors.white),
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
          decoration: const BoxDecoration(color: Color.fromARGB(255, 219, 90, 90), borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.errorUpdateSubTaskText.value,
                      style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, Colors.white),
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
