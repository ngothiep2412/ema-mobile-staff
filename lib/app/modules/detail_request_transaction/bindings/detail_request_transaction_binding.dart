import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/detail_request_transaction_controller.dart';

class DetailRequestTransactionBinding extends BaseBindings {
  String transactionID = '';
  bool isNotiNavigate = false;
  @override
  void injectService() {
    transactionID = Get.arguments["transactionID"] as String;
    isNotiNavigate = Get.arguments["isNotiNavigate"] as bool;

    Get.lazyPut<DetailRequestTransactionController>(
      () => DetailRequestTransactionController(transactionID: transactionID, isNotiNavigate: isNotiNavigate),
    );
  }
}
