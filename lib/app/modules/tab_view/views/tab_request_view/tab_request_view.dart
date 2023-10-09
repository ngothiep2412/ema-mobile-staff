import 'package:flutter/material.dart';
import 'package:hrea_mobile_staff/app/base/base_view.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';

class TabRequestView extends BaseView<TabRequestController> {
  const TabRequestView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('request'),
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
