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
      padding: EdgeInsets.all(UtilsReponsive.height(20,context)),
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
            padding: EdgeInsets.all(UtilsReponsive.width(8, context)),
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
        height: UtilsReponsive.height(50,context),
        width: UtilsReponsive.width(150,context),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(UtilsReponsive.height(15,context))),
        child: Padding(
          padding: EdgeInsets.all(UtilsReponsive.height(10,context)),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                height: UtilsReponsive.height(80, context),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(
                        UtilsReponsive.height(15,context))),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: eventModel.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                    padding: EdgeInsets.all(UtilsReponsive.height(10,context)),
                    height: UtilsReponsive.height(20,context),
                    width: UtilsReponsive.height(20,context),
                    child: CircularProgressIndicator(
                      color: ColorsManager.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(10,context),
              ),
              Expanded(
                child: Text(
                  eventModel.title,
                  style: TextStyle(fontSize: UtilsReponsive.height(16, context)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
