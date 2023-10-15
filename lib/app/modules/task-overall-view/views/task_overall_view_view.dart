import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';

import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewView extends BaseView<TaskOverallViewController> {
  const TaskOverallViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red.shade50,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back)),
                  Container(
                    height: UtilsReponsive.height(50,context),
                    width: UtilsReponsive.height(50,context),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(
                            UtilsReponsive.height(15,context))),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      'Lễ kỷ niệm 10 năm',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: UtilsReponsive.height(16,context),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.info_outline)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
                ],
              )),
              Expanded(
                  flex: 10,
                  child: ListView.separated(
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) => _taskCommon(context),
                      separatorBuilder: (context, index) => SizedBox(
                            height: UtilsReponsive.height(10,context),
                          ),
                      itemCount: 4))
            ],
          ),
        ));
  }

  Container _taskCommon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(10,context))),
      child: ExpansionTile(
        title: Text(
          'Task lớn đầu tiên',
          style: TextStyle(
              letterSpacing: 1.5,
              color: Colors.black,
              fontSize: UtilsReponsive.height(16,context),
              fontWeight: FontWeight.bold),
        ),
        children: controller.listEventModel
            .map((taskModel) =>
                _itemTask(context: context, taskModel: taskModel))
            .toList(),
      ),
    );
  }

  Widget _itemTask(
      {required BuildContext context, required TaskModel taskModel}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.TASK_DETAIL_VIEW);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: UtilsReponsive.height(15,context)),
        width: double.infinity,
        // padding: EdgeInsets.all(UtilsReponsive.height(15,context)),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Màu của đổ bóng
                spreadRadius: 0.5, // Độ dài của đổ bóng
                blurRadius: 7, // Độ mờ của đổ bóng
                offset: Offset(0, 3), // Độ tịnh tiến của đổ bóng
              ),
            ],
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(5,context))),
        child: Column(
          children: [
            taskModel.isParent
                ? SizedBox()
                : Container(
                    width: double.infinity,
                    height: UtilsReponsive.height(30,context),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: taskModel.status == 'DONE'
                                ? Colors.green
                                : taskModel.status == 'INPROGRESS'
                                    ? Colors.blue
                                    : Colors.red, // Màu của đổ bóng
                            spreadRadius: 0.5, // Độ dài của đổ bóng
                            blurRadius: 7, // Độ mờ của đổ bóng
                            offset: Offset(0, 3), // Độ tịnh tiến của đổ bóng
                          ),
                        ],
                        color: taskModel.status == 'DONE'
                            ? Colors.green.withOpacity(0.7)
                            : taskModel.status == 'INPROGRESS'
                                ? Colors.blue.withOpacity(0.7)
                                : Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(
                            UtilsReponsive.height(5,context))),
                    child: Center(
                        child: Text(taskModel.status,
                            style: TextStyle(
                                letterSpacing: 1.2,
                                color: Colors.white,
                                fontSize: UtilsReponsive.height(14,context),
                                fontWeight: FontWeight.bold))),
                  ),
            Padding(
              padding: EdgeInsets.all(UtilsReponsive.height(20,context)),
              child: Column(
                children: [
                  SizedBox(
                    height: UtilsReponsive.height(20,context),
                  ),
                  Text(taskModel.title,
                      style: TextStyle(
                          fontSize: UtilsReponsive.height(14,context),
                          fontWeight: FontWeight.bold)),
                  taskModel.image.isEmpty
                      ? SizedBox(
                          height: UtilsReponsive.height(30,context),
                        )
                      : SizedBox(
                          height: UtilsReponsive.height(150,context),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: taskModel.image,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              padding: EdgeInsets.all(
                                  UtilsReponsive.height(10,context)),
                              height: UtilsReponsive.height(20,context),
                              width: UtilsReponsive.height(20,context),
                              child: CircularProgressIndicator(
                                color: ColorsManager.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                  SizedBox(
                    height: UtilsReponsive.height(15,context),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: UtilsReponsive.height(15,context),
                        child:const FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'NV',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(10,context),
                      ),
                      CircleAvatar(
                          backgroundColor: Colors.blueGrey.shade500,
                          radius: UtilsReponsive.height(15,context),
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 15,
                          )),
                      SizedBox(
                        width: UtilsReponsive.width(10,context),
                      ),
                      taskModel.startTime != null
                          ? Text(controller.dateFormat
                              .format(taskModel.startTime!))
                          : SizedBox(),
                      taskModel.endTime != null
                          ? Text(' - ' +
                              controller.dateFormat
                                  .format(taskModel.startTime!))
                          : SizedBox(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.account_tree_rounded,
                        color: Colors.grey,
                        size: 15,
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(5,context),
                      ),
                      Text('${taskModel.index}/${taskModel.totalTask}')
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
