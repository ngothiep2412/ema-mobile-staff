import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';

import '../controllers/event_detail_controller.dart';

class EventDetailView extends BaseView<EventDetailController> {
  const EventDetailView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.backgroundContainer,
        appBar: _appBar(context),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: UtilsReponsive.height(400, context),
                child: Image.network(
                  "https://blog.topcv.vn/wp-content/uploads/2021/07/sk2uEvents_Page_Header_2903ed9c-40c1-4f6c-9a69-70bb8415295b.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              scroll(),
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
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 1.0,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(UtilsReponsive.height(20, context)),
                  topRight:
                      Radius.circular(UtilsReponsive.height(20, context))),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Cacao Maca Walnut Milk",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        wordSpacing: 1.2,
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(24, context),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Food .60 min",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        wordSpacing: 1.2,
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(20, context),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
