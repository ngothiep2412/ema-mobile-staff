import 'dart:developer';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/resources/form_field_widget.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';

import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewView extends GetView<TaskDetailViewController> {
  const TaskDetailViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Quil.QuillController controllerA = Quil.QuillController.basic();
    return Scaffold(
        appBar: _appBar(context),
        body: Container(
          height: double.infinity,
          color: Colors.red.shade50,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(UtilsReponsive.height(context, 15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    _statusBuilder(context),
                    SizedBox(
                      height: UtilsReponsive.height(context, 30),
                    ),
                    _timeBuilder(
                        context: context,
                        startTime: '08/11/2023',
                        endTime: '12/11/2023'),
                    SizedBox(
                      height: UtilsReponsive.width(context, 10),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: UtilsReponsive.height(context, 15),
                          child: Text(
                            'NC',
                            style: TextStyle(
                                letterSpacing: 1.5,
                                color: Colors.white,
                                fontSize: UtilsReponsive.height(context, 16),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: UtilsReponsive.width(context, 10),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nguyễn Văn C",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: UtilsReponsive.height(context, 16),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text("Người assign"),
                          ],
                        ),
                      ],
                    ),
                     SizedBox(
                          height: UtilsReponsive.width(context, 20),
                        ),
                     GestureDetector(
                      onTap: () {
                         _showBottomAssign(context: context);
                      },
                       child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: UtilsReponsive.height(context, 15),
                                child: Text(
                                  'NC',
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                      fontSize: UtilsReponsive.height(context, 16),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(context, 10),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nguyễn Văn C",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: UtilsReponsive.height(context, 16),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Leader và 18 thành viên"),
                                ],
                              ),
                            ],
                          ),
                          Text("Thêm người",style:TextStyle(color: Colors.blue),)
                        ],
                                         ),
                     ),
                    SizedBox(
                      height: UtilsReponsive.height(context, 30),
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
                    //       fontSize: UtilsReponsive.height(context, 13),
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
                    //       fontSize: UtilsReponsive.height(context, 13),
                    //       fontWeight: FontWeight.w400),
                    // ),
                    _documentV1(context),
                    SizedBox(
                      height: UtilsReponsive.height(context, 15),
                    ),
                    _documentV2(context),
                    SizedBox(
                      height: UtilsReponsive.height(context, 15),
                    ),
                    _commentList(context),
                    SizedBox(
                      height: UtilsReponsive.height(context, 50),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        minLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.double_arrow_sharp)),
                          contentPadding:
                              EdgeInsets.all(UtilsReponsive.width(context, 10)),
                          hintText: 'Nhập bình luận',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .grey), // Màu gạch dưới khi TextField được chọn
                          ),
                          enabledBorder: UnderlineInputBorder(
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
              horizontal: UtilsReponsive.width(context, 10),
              vertical: UtilsReponsive.height(context, 5)),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(context, 5)),
          ),
          margin: EdgeInsets.only(left: UtilsReponsive.width(context, 15)),
          child: Text(
            '$startTime - $endTime',
            style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.black,
                fontSize: UtilsReponsive.height(context, 14),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _statusBuilder(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(Container(
          color: Colors.white,
          constraints:
              BoxConstraints(maxHeight: UtilsReponsive.width(context, 400)),
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
                                  fontSize: UtilsReponsive.height(context, 16),
                                  fontWeight: FontWeight.bold)),
                        ),
                        title: Text(
                          e,
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.black,
                              fontSize: UtilsReponsive.height(context, 16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UtilsReponsive.width(context, 20),
            vertical: UtilsReponsive.width(context, 5)),
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(context, 10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'INPROGRESS',
              style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontSize: UtilsReponsive.height(context, 14),
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Task Lớn đầu tiên',
              style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.black,
                  fontSize: UtilsReponsive.height(context, 16),
                  fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              _showBottomAssign(context: context);
            },
            child: CircleAvatar(
              radius: UtilsReponsive.height(context, 20),
              child: Text(
                'NV',
                style: TextStyle(
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontSize: UtilsReponsive.height(context, 16),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showBottomAssign({required BuildContext context}) {
    Get.bottomSheet(Container(
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.width(context, 400)),
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: UtilsReponsive.width(context, 15),
          vertical: UtilsReponsive.height(context, 20)),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(context, 10)),
            topRight: Radius.circular(UtilsReponsive.height(context, 10))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row(children: [
          //   Expanded(child: FormFieldWidget(
          //     icon:Icon(Icons.search),
          //     radiusBorder: 15,
          //     setValueFunc: (value){})),
          // ],),
          ListView.separated(
            shrinkWrap: true,
            itemCount: 2,
            separatorBuilder: (context, index) => SizedBox(
              height: UtilsReponsive.height(context, 10),
            ),
            itemBuilder: (context, index) => Card(
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('N/A'),
                  ),
                  title: Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black,
                        fontSize: UtilsReponsive.height(context, 16),
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
          width: UtilsReponsive.width(context, 15),
        ),
        Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        SizedBox(
          width: UtilsReponsive.width(context, 15),
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
            fontSize: UtilsReponsive.height(context, 13),
            fontWeight: FontWeight.bold),
      ),
      children: [
        Container(
          height: UtilsReponsive.height(context, 80),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (context, index) =>
                  SizedBox(width: UtilsReponsive.width(context, 20)),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(
                        UtilsReponsive.height(context, 10)),
                  ),
                  height: UtilsReponsive.height(context, 80),
                  width: UtilsReponsive.width(context, 60),
                  child: Icon(index == 3 ? Icons.add : Icons.file_present),
                );
              }),
        )
      ],
    );
  }

  Container _commentList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UtilsReponsive.height(context, 10)),
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
              BorderRadius.circular(UtilsReponsive.height(context, 10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bình luận',
              style: TextStyle(
                  wordSpacing: 1.2,
                  color: Colors.black,
                  fontSize: UtilsReponsive.height(context, 16),
                  fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.only(top: UtilsReponsive.height(context, 10)),
            child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: 2,
                separatorBuilder: (context, index) =>
                    SizedBox(height: UtilsReponsive.height(context, 20)),
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: UtilsReponsive.height(context, 20),
                              child: Text(
                                'NV',
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    color: Colors.white,
                                    fontSize:
                                        UtilsReponsive.height(context, 16),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: UtilsReponsive.width(context, 10)),
                            Text(
                              "Nguyễn Văn A",
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  color: Colors.black,
                                  fontSize: UtilsReponsive.height(context, 16),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(height: UtilsReponsive.width(context, 10)),
                        Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.')
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Container _documentV2(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UtilsReponsive.height(context, 10)),
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
              BorderRadius.circular(UtilsReponsive.height(context, 10))),
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
                      fontSize: UtilsReponsive.height(context, 16),
                      fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: UtilsReponsive.height(context, 22),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: UtilsReponsive.height(context, 10)),
            height: UtilsReponsive.height(context, 60),
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                separatorBuilder: (context, index) =>
                    SizedBox(width: UtilsReponsive.width(context, 20)),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(
                          UtilsReponsive.height(context, 10)),
                    ),
                    height: UtilsReponsive.height(context, 80),
                    width: UtilsReponsive.width(context, 60),
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
      constraints:
          BoxConstraints(maxHeight: UtilsReponsive.height(context, 200)),
      padding: EdgeInsets.all(UtilsReponsive.height(context, 10)),
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
              BorderRadius.circular(UtilsReponsive.height(context, 10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mô tả',
              style: TextStyle(
                  wordSpacing: 1.2,
                  color: Colors.black,
                  fontSize: UtilsReponsive.height(context, 16),
                  fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
          ))
        ],
      ),
    );
  }
}
