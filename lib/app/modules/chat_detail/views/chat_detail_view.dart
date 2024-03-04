import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/modules/chat_detail/models/chat_message.dart';
import 'package:hrea_mobile_staff/app/resources/color_manager.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Stack(children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          'https://images.immediate.co.uk/production/volatile/sites/3/2023/08/2023.06.28-06.20-boundingintocomics-649c79f009cdf-Cropped-8d74232.png?resize=768,574'),
                      maxRadius: 20,
                    ),
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
                  ]),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Jane Russel",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Online",
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.phone_solid,
                      color: ColorsManager.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.video_camera_solid,
                      color: ColorsManager.primary,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.chatMessage.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return chatBubble(
                  chatMessage: controller.chatMessage[index],
                  index: index,
                );
              },
            ),
          ),
          Container(
            height: 60,
            padding: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextFormField(
                      controller: controller.textEditingController,
                      onChanged: (val) {},
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Type something...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ColorsManager.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.primary.withOpacity(0.3),
                        spreadRadius: 8,
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Material(
                      color: ColorsManager.primary,
                      child: InkWell(
                        splashColor: Colors.green,
                        onTap: () {},
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.send_rounded,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showModal({required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: controller.menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: controller.menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              controller.menuItems[index].icons,
                              size: 20,
                              color: controller.menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(controller.menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget chatBubble({required ChatMessage chatMessage, required int index}) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.showTime.value = !controller.showTime.value;
          controller.indexChat.value = index;
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Column(children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: (controller.showTime.value && controller.indexChat.value == index) ? 20 : 0,
              child: Opacity(
                opacity: (controller.showTime.value && controller.indexChat.value == index) ? 1 : 0,
                child: Text(
                  "10:25",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            // SizedBox(height: 5),
            Align(
              alignment: (chatMessage.type == MessageType.Receiver ? Alignment.topLeft : Alignment.topRight),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: (chatMessage.type == MessageType.Receiver ? Colors.white : Colors.grey.shade200),
                ),
                padding: EdgeInsets.all(16),
                child: Text(chatMessage.message),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
