import 'package:flutter/material.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_timekeeping_controller/tab_timekeeping_controller.dart';

class TabTimeKeepingView extends BaseView<TabTimeKeepingController> {
  const TabTimeKeepingView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TImekeeping'),
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
