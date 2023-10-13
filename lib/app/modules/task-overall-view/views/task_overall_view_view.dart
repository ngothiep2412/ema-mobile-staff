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
                    height: UtilsReponsive.height(context, 50),
                    width: UtilsReponsive.height(context, 50),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(
                            UtilsReponsive.height(context, 15))),
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
                          fontSize: UtilsReponsive.height(context, 16),
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
                            height: UtilsReponsive.height(context, 10),
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
              BorderRadius.circular(UtilsReponsive.height(context, 10))),
      child: ExpansionTile(
        title: Text(
          'Task lớn đầu tiên',
          style: TextStyle(
              letterSpacing: 1.5,
              color: Colors.black,
              fontSize: UtilsReponsive.height(context, 16),
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
        margin: EdgeInsets.only(bottom: UtilsReponsive.height(context, 15)),
        width: double.infinity,
        // padding: EdgeInsets.all(UtilsReponsive.height(context, 15)),
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
                BorderRadius.circular(UtilsReponsive.height(context, 5))),
        child: Column(
          children: [
            taskModel.isParent
                ? SizedBox()
                : Container(
                    width: double.infinity,
                    height: UtilsReponsive.height(context, 30),
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
                            UtilsReponsive.height(context, 5))),
                    child: Center(
                        child: Text(taskModel.status,
                            style: TextStyle(
                                letterSpacing: 1.2,
                                color: Colors.white,
                                fontSize: UtilsReponsive.height(context, 14),
                                fontWeight: FontWeight.bold))),
                  ),
            Padding(
              padding: EdgeInsets.all(UtilsReponsive.height(context, 20)),
              child: Column(
                children: [
                  SizedBox(
                    height: UtilsReponsive.height(context, 20),
                  ),
                  Text(taskModel.title,
                      style: TextStyle(
                          fontSize: UtilsReponsive.height(context, 14),
                          fontWeight: FontWeight.bold)),
                  taskModel.image.isEmpty
                      ? SizedBox(
                          height: UtilsReponsive.height(context, 30),
                        )
                      : SizedBox(
                          height: UtilsReponsive.height(context, 150),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: taskModel.image,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              padding: EdgeInsets.all(
                                  UtilsReponsive.height(context, 10)),
                              height: UtilsReponsive.height(context, 20),
                              width: UtilsReponsive.height(context, 20),
                              child: CircularProgressIndicator(
                                color: ColorsManager.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                  SizedBox(
                    height: UtilsReponsive.height(context, 15),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: UtilsReponsive.height(context, 15),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'NV',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(context, 10),
                      ),
                      CircleAvatar(
                          backgroundColor: Colors.blueGrey.shade500,
                          radius: UtilsReponsive.height(context, 15),
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 15,
                          )),
                      SizedBox(
                        width: UtilsReponsive.width(context, 10),
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
                        width: UtilsReponsive.width(context, 5),
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
