import 'package:flutter/material.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';

class TabSettingView extends BaseView<TabSettingController> {
  const TabSettingView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
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
