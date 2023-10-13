import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';

class TabHomeView extends BaseView<TabHomeController> {
  const TabHomeView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(UtilsReponsive.height(context, 20)),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.black,
              )
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                'Xem báo cáo',
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(UtilsReponsive.width(context, 8)),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.listEvent.value.length,
              itemBuilder: (context, index) {
                return _itemEvent(
                    context: context, eventModel: controller.listEvent[index]);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _itemEvent(
      {required BuildContext context, required EventModel eventModel}) {
    return GestureDetector(
      onTap: () {
        controller.onTapEvent(idEvent: eventModel.id);
      },
      child: Container(
        height: UtilsReponsive.height(context, 50),
        width: UtilsReponsive.width(context, 150),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(context, 15))),
        child: Padding(
          padding: EdgeInsets.all(UtilsReponsive.height(context, 10)),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                height: UtilsReponsive.height(context, 80),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(
                        UtilsReponsive.height(context, 15))),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: eventModel.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                    padding: EdgeInsets.all(UtilsReponsive.height(context, 10)),
                    height: UtilsReponsive.height(context, 20),
                    width: UtilsReponsive.height(context, 20),
                    child: CircularProgressIndicator(
                      color: ColorsManager.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(context, 10),
              ),
              Expanded(
                child: Text(
                  eventModel.title,
                  style: TextStyle(fontSize: UtilsReponsive.height(context, 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
