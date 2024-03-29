import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/budget_detail/controllers/budget_detail_controller.dart';
import 'package:hrea_mobile_staff/app/modules/budget_detail/model/budget_item_model.dart';
import 'package:hrea_mobile_staff/app/modules/transaction_detail/api/transaction_detail_api.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TransactionDetailController extends BaseController {
  TransactionDetailController({
    required this.transactionID,
    required this.isNotiNavigate,
  });
  String transactionID = '';

  Rx<Transaction> transactionView = Transaction().obs;
  RxList<Evidence> listAttachmentEvidence = <Evidence>[].obs;

  DateFormat dateFormat = DateFormat('dd-MM-yyyy, HH:mm', 'vi_VN');

  String jwt = '';
  String idUser = '';
  bool isNotiNavigate = false;
  RxBool errorUpdateBudget = false.obs;
  RxString errorUpdateBudgetText = ''.obs;

  RxBool isLoading = false.obs;
  RxBool checkView = true.obs;

  RxList<PlatformFile> filePicker = <PlatformFile>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getBudgetDetail(transactionID);
    print(transactionID);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String formatCurrency(int amount) {
    String formattedAmount = amount.toString();
    final length = formattedAmount.length;

    if (length > 3) {
      for (var i = length - 3; i > 0; i -= 3) {
        formattedAmount = formattedAmount.replaceRange(i, i, ',');
      }
    }

    return formattedAmount;
  }

  void checkToken() {
    DateTime now = DateTime.now().toLocal();
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      print('decodedToken ${decodedToken}');
      print('now ${now}');

      DateTime expTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      print(expTime.toLocal());
      idUser = decodedToken['id'];
      // if (JwtDecoder.isExpired(jwt)) {
      //   Get.offAllNamed(Routes.LOGIN);
      //   return;
      // }
      if (expTime.toLocal().isBefore(now)) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
  }

  Future<void> refreshPage() async {
    checkView.value = true;
    print('transactionID ${transactionID}');
    await getBudgetDetail(transactionID);
  }

  Future<void> getBudgetDetail(String transactionID) async {
    isLoading.value = true;
    try {
      checkToken();
      Transaction transaction = await TransactionDetailApi.getBudgetDetail(transactionID, jwt);
      transactionView.value = transaction;
      if (transaction.evidences!.isNotEmpty) {
        listAttachmentEvidence.value = transactionView.value.evidences!;
      }
      isLoading.value = false;
    } catch (e) {
      checkView.value = false;
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> updateStatusTransaction(String status, String text) async {
    isLoading.value = true;
    try {
      checkToken();
      ResponseApi responseApi = await TransactionDetailApi.updateStatusTransaction(transactionID, jwt, status, text);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        if (isNotiNavigate == false) {
          Get.find<BudgetDetailController>().refreshPage();
        }
        await getBudgetDetail(transactionID);
      } else {
        checkView.value = false;
      }
      isLoading.value = false;
    } catch (e) {
      checkView.value = false;
      isLoading.value = false;
      print(e);
    }
  }
}
