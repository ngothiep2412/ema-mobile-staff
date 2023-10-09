import 'package:flutter/material.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_notification_controller/tab_notification_controller.dart';

class TabNotificationView extends BaseView<TabNotificationController> {
  const TabNotificationView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('notification'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Setting is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
