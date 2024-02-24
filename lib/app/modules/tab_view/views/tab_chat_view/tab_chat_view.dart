import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_chat_controller/tab_chat_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';
import 'package:hrea_mobile_staff/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_staff/app/resources/style_manager.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';

class TabChatView extends BaseView<TabChatController> {
  const TabChatView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Đoạn chat',
                  style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w600, ColorsManager.primary),
                ),
              ),
            ),
            // Icon(
            //   Icons.filter_alt_outlined,
            //   color: ColorsManager.primary,
            // ),
            // SizedBox(
            //   width: UtilsReponsive.width(10, context),
            // ),
          ],
        ),
        SizedBox(
          height: UtilsReponsive.height(20, context),
        ),
        Expanded(
          flex: 2,
          child: RefreshIndicator(
              onRefresh: controller.refreshpage,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     blurRadius: 5,
                      //     spreadRadius: 2,
                      //     offset: Offset(0, 3),
                      //   )
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.search,
                          color: Color(0xFF113953),
                        ),
                        Container(
                          width: 200,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Tìm kiếm",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(20, context),
                  ),
                  SizedBox(
                    height: 80, // Adjust the height as needed
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        width: UtilsReponsive.height(20, context),
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: 10, // Provide the item count
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                // User avatar
                                CircleAvatar(
                                  radius: 26,
                                  backgroundImage: CachedNetworkImageProvider(
                                      'https://images.immediate.co.uk/production/volatile/sites/3/2023/08/2023.06.28-06.20-boundingintocomics-649c79f009cdf-Cropped-8d74232.png?resize=768,574'),
                                  backgroundColor: Theme.of(context).cardColor,
                                ),
                                // Status indicator positioned relative to the avatar
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green, // Màu nền là màu xanh
                                        border: Border.all(color: Colors.white, width: 2), // Viền trắng xung quanh
                                      ),
                                    )),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Thiệp',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 0.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return chatUsersList(
                        text: 'hi',
                        secondaryText: "hihiii",
                        image: "https://upload.wikimedia.org/wikipedia/vi/thumb/8/88/Vegeta_Dragon_Ball.jpg/220px-Vegeta_Dragon_Ball.jpg",
                        time: '10:20',
                        isMessageRead: (index == 0 || index == 3) ? true : false,
                      );
                    },
                  ),
                ],
              )),
        ),
      ]),
    ));
  }
}

Widget chatUsersList(
    {required String text, required String secondaryText, required String image, required String time, required bool isMessageRead}) {
  return GestureDetector(
    onTap: () {
      Get.toNamed('/chat-detail');
    },
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 10, top: 0, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Stack(children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(image),
                    maxRadius: 25,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: isMessageRead
                          ? Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green, // Màu nền là màu xanh
                                border: Border.all(color: Colors.white, width: 2), // Viền trắng xung quanh
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Colors.white, // Màu nền là màu xanh
                                // Viền trắng xung quanh
                              ),
                              child: Text(
                                '6 phút',
                                style: TextStyle(fontSize: 12, color: Colors.green),
                              ),
                            )),
                ]),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(text,
                            style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: isMessageRead ? FontWeight.bold : FontWeight.normal)),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Bạn: ${secondaryText}',
                          style: TextStyle(
                              fontSize: 14,
                              color: !isMessageRead ? Colors.grey.shade500 : Colors.black,
                              fontWeight: isMessageRead ? FontWeight.bold : FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isMessageRead
              ? Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(color: Color(0xff007FFF), shape: BoxShape.circle),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 14, color: isMessageRead ? Colors.pink : Colors.grey.shade500),
                    ),
                  ],
                )
              : Text(
                  time,
                  style: TextStyle(fontSize: 12, color: isMessageRead ? Colors.pink : Colors.grey.shade500),
                ),
        ],
      ),
    ),
  );
}
