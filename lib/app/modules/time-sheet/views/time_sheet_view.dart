import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/time-sheet/views/timsheet_model.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';

import '../controllers/time_sheet_controller.dart';

class TimeSheetView extends BaseView<TimeSheetController> {
  const TimeSheetView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    List<TimeSheetModelTest> listTest = [
TimeSheetModelTest(title: "Tổng công hưởng lương", time: 40.5),
TimeSheetModelTest(title: "Tổng  giờ làm thêm", time: 1.0),
TimeSheetModelTest(title: "Tổng  số lần đi muộn, về sớm", time: 4.0),
TimeSheetModelTest(title: "Tổng  số ngày nghỉ", time: 2.0)
    ];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: _header(context),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            UtilsReponsive.height(10, context)),
                        color: Colors.blue.withOpacity(0.2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Thời hạn xác nhận lương',
                                style: GetTextStyle.getTextStyle(
                                    UtilsReponsive.height(
                                        UtilsReponsive.height(14, context),
                                        context),
                                    'Roboto',
                                    FontWeight.w400,
                                    Colors.black)),
                            Text('1/12/2023 17:30',
                                style: GetTextStyle.getTextStyle(
                                    UtilsReponsive.height(
                                        UtilsReponsive.height(14, context),
                                        context),
                                    'Roboto',
                                    FontWeight.w800,
                                    Colors.black))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: UtilsReponsive.height(15, context),
                            horizontal: UtilsReponsive.height(30, context),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                UtilsReponsive.height(10, context)),
                            color: Colors.blue,
                          ),
                          child: Text('Xác nhận',
                              style: GetTextStyle.getTextStyle(
                                  UtilsReponsive.height(
                                      UtilsReponsive.height(14, context),
                                      context),
                                  'Roboto',
                                  FontWeight.w800,
                                  Colors.white)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: UtilsReponsive.height(15, context),),
                  Container(
                   padding: EdgeInsets.symmetric(
                            vertical: UtilsReponsive.height(15, context),
                            horizontal: UtilsReponsive.height(30, context),
                          ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            UtilsReponsive.height(10, context)),
                        color: Colors.white
                        ),
                        child: ListView.separated(
                          shrinkWrap:true,
                          itemBuilder: (context, index) => _itemTimeSheet(listTest[index], context), separatorBuilder: (context, index) => SizedBox(height: UtilsReponsive.height(15, context),), itemCount: listTest.length)
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  Row _itemTimeSheet(TimeSheetModelTest e, BuildContext context) {
    return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(e.title,
                              style: GetTextStyle.getTextStyle(
                                  UtilsReponsive.height(
                                      UtilsReponsive.height(14, context),
                                      context),
                                  'Roboto',
                                  FontWeight.w800,
                                  Colors.black)),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(e.time.toString(),
                              style: GetTextStyle.getTextStyle(
                                  UtilsReponsive.height(
                                      UtilsReponsive.height(14, context),
                                      context),
                                  'Roboto',
                                  FontWeight.w800,
                                  Colors.black)),
                                  Icon(Icons.arrow_forward_ios,color:Colors.grey,)
                                ],
                              ),
                            )
                          ],
                        );
  }

  Row _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
              child: Text('Bảng lương tháng 10/2023',
                  style: GetTextStyle.getTextStyle(
                      UtilsReponsive.height(
                          UtilsReponsive.height(22, context), context),
                      'Roboto',
                      FontWeight.w800,
                      Colors.blue))),
        ),
        Expanded(child: SizedBox())
      ],
    );
  }
}
