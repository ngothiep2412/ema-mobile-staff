import 'dart:convert';
import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/form_field_widget.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';

import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewView extends BaseView<TaskDetailViewController> {
  const TaskDetailViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: Obx(
          () => controller.isLoading.value
              ? SizedBox()
              : Container(
                  height: double.infinity,
                  color: Colors.red.shade50,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding:
                            EdgeInsets.all(UtilsReponsive.height(15, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _header(
                                context: context,
                                objectTask: 'Task Lớn đầu tiên'),
                            _statusBuilder(
                                context: context,
                                objectStatusTask: 'INPROGRESS'),
                            SizedBox(
                              height: UtilsReponsive.height(30, context),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDateTimePicker(context);
                              },
                              child: Obx(() => _timeBuilder(
                                  context: context,
                                  startTime: controller.dateFormat
                                      .format(controller.startDate.value),
                                  endTime: controller.dateFormat
                                      .format(controller.endDate.value))),
                            ),
                            SizedBox(
                              height: UtilsReponsive.width(10, context),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: UtilsReponsive.height(15, context),
                                  child: Text(
                                    'NC',
                                    style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                        fontSize:
                                            UtilsReponsive.height(16, context),
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
                                      "Nguyễn Văn C",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: UtilsReponsive.height(
                                              16, context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Người assign"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: UtilsReponsive.width(20, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showBottomAssign(context: context);
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius:
                                            UtilsReponsive.height(15, context),
                                        child: Text(
                                          'NC',
                                          style: TextStyle(
                                              letterSpacing: 1.5,
                                              color: Colors.white,
                                              fontSize: UtilsReponsive.height(
                                                  16, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            UtilsReponsive.width(10, context),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nguyễn Văn C",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: UtilsReponsive.height(
                                                    16, context),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("Leader và 18 thành viên"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _showBottomAddMore(context: context);
                                  },
                                  child: Text(
                                    "Thêm người",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(30, context),
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
                            _documentV1(context),
                            SizedBox(
                              height: UtilsReponsive.height(15, context),
                            ),
                            _documentV2(context),
                            SizedBox(
                              height: UtilsReponsive.height(15, context),
                            ),
                            _subTask(context),
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
        Icon(Icons.calendar_month),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: UtilsReponsive.width(10, context),
              vertical: UtilsReponsive.height(5, context)),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(5, context)),
          ),
          margin: EdgeInsets.only(left: UtilsReponsive.width(15, context)),
          child: Text(
            '$startTime - $endTime',
            style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.black,
                fontSize: UtilsReponsive.height(14, context),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  void _showBottomSheetStatus(BuildContext context) {
    Get.bottomSheet(Container(
      color: Colors.white,
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: ["Inprogress", "Done", "Cancel"]
            .map(
              (e) => Card(
                child: Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e[0] == 'I'
                          ? Colors.blue
                          : e[0] == 'D'
                              ? Colors.green
                              : Colors.red,
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
                          letterSpacing: 1.5,
                          color: Colors.black,
                          fontSize: UtilsReponsive.height(16, context),
                          fontWeight: FontWeight.bold),
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
          color: Colors.blue.shade400,
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
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Container _header(
      {required BuildContext context, required String objectTask}) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              objectTask,
              style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.black,
                  fontSize: UtilsReponsive.height(16, context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              _showBottomAssign(context: context);
            },
            child: CircleAvatar(
              radius: UtilsReponsive.height(20, context),
              child: Text(
                'NV',
                style: TextStyle(
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontSize: UtilsReponsive.height(16, context),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
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
        title: 'Picker time',
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
        ));
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
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            Get.back();
            controller.onDelete();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          )),
      actions: [
        Icon(
          Icons.file_present_rounded,
          color: Colors.black,
        ),
        SizedBox(
          width: UtilsReponsive.width(15, context),
        ),
        Icon(
          Icons.more_vert,
          color: Colors.black,
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
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(10, context))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bình luận',
              style: TextStyle(
                  wordSpacing: 1.2,
                  color: Colors.black,
                  fontSize: UtilsReponsive.height(16, context),
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
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(10, context))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Công việc',
                  style: TextStyle(
                      wordSpacing: 1.2,
                      color: Colors.black,
                      fontSize: UtilsReponsive.height(16, context),
                      fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: UtilsReponsive.height(22, context),
                ),
              )
            ],
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
          Column(
            children: ['Công việc 1', 'Công việc 2', 'Công việc 3']
                .map((e) => Card(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: UtilsReponsive.height(5, context),
                          bottom: UtilsReponsive.height(5, context),
                          left: UtilsReponsive.height(5, context),
                        ),
                        width: double.infinity,
                        height: UtilsReponsive.height(40, context),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(e)),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheetStatus(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          UtilsReponsive.height(5, context),
                                      horizontal:
                                          UtilsReponsive.height(5, context)),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade400,
                                    borderRadius: BorderRadius.circular(
                                        UtilsReponsive.height(5, context)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Inprogress',
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            color: Colors.white,
                                            fontSize: UtilsReponsive.height(
                                                12, context),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
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
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
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
                      wordSpacing: 1.2,
                      color: Colors.black,
                      fontSize: UtilsReponsive.height(16, context),
                      fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: UtilsReponsive.height(22, context),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: UtilsReponsive.height(10, context)),
            height: UtilsReponsive.height(60, context),
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
                    width: UtilsReponsive.width(60, context),
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
      padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(10, context))),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mô tả',
                      style: TextStyle(
                          wordSpacing: 1.2,
                          color: Colors.black,
                          fontSize: UtilsReponsive.height(16, context),
                          fontWeight: FontWeight.bold)),
                  !controller.isEditDescription.value
                      ? IconButton(
                          onPressed: () {
                            controller.onTapEditDescription();
                          },
                          icon: Icon(Icons.edit))
                      : Wrap(
                          children: [
                            IconButton(
                                onPressed: () {
                                  // controller.onTapEditDescription();
                                  //Thêm hàm save vô
                                  controller.saveDescription();
                                },
                                icon: Icon(Icons.save)),
                            IconButton(
                                onPressed: () {
                                  controller.discardDescription();
                                },
                                icon: Icon(Icons.close))
                          ],
                        )
                ],
              ),
              !controller.isEditDescription.value
                  ? SizedBox()
                  : Quil.QuillToolbar.basic(
                      embedButtons: FlutterQuillEmbeds.buttons(),
                      showDividers: false,
                      showFontFamily: false,
                      showFontSize: true,
                      showBoldButton: true,
                      showItalicButton: true,
                      showSmallButton: false,
                      showUnderLineButton: true,
                      showStrikeThrough: false,
                      showInlineCode: false,
                      showColorButton: true,
                      showBackgroundColorButton: false,
                      showClearFormat: false,
                      showAlignmentButtons: true,
                      showLeftAlignment: true,
                      showCenterAlignment: true,
                      showRightAlignment: true,
                      showJustifyAlignment: true,
                      showHeaderStyle: false,
                      showListNumbers: false,
                      showListBullets: false,
                      showListCheck: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showIndent: false,
                      showLink: false,
                      showUndo: true,
                      showRedo: true,
                      showDirection: false,
                      showSearchButton: false,
                      showSubscript: false,
                      showSuperscript: false,
                      multiRowsDisplay: true,
                      controller: controller.quillController.value),
              Quil.QuillEditor.basic(
                focusNode: controller.focusNodeDetail,
                autoFocus: false,
                expands: false,
                controller: controller.quillController.value,
                readOnly: !controller
                    .isEditDescription.value, // true for view only mode
              )
            ],
          )),
    );
  }
}
