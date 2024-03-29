import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/transaction_detail_controller.dart';

class TransactionDetailBinding extends BaseBindings {
  String transactionID = '';
  bool isNotiNavigate = false;
  @override
  void injectService() {
    transactionID = Get.arguments["transactionID"] as String;
    isNotiNavigate = Get.arguments["isNotiNavigate"] as bool;
    Get.lazyPut<TransactionDetailController>(
      () => TransactionDetailController(transactionID: transactionID, isNotiNavigate: isNotiNavigate),
    );
  }
}
