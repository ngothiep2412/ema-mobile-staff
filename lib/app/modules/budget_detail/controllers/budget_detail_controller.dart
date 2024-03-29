import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/budget_detail/api/budget_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/budget_detail/model/budget_item_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class BudgetDetailController extends BaseController {
  BudgetDetailController({required this.itemID, required this.taskID, required this.statusTask});
  String itemID = '';
  String taskID = '';

  bool statusTask;
  Rx<BudgetItemModel> budgetItemModel = BudgetItemModel().obs;
  RxList<Task> taskView = <Task>[].obs;

  String jwt = '';
  String idUser = '';
  RxBool errorUpdateBudget = false.obs;
  RxString errorUpdateBudgetText = ''.obs;

  RxBool isLoading = false.obs;
  RxBool checkView = true.obs;

  RxString nameItem = ''.obs;

  DateFormat dateFormat = DateFormat('dd-MM-yyyy, HH:mm', 'vi_VN');

  RxDouble progress = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getBudgetDetail(itemID);
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

    await getBudgetDetail(itemID);
  }

  Future<void> getBudgetDetail(String itemID) async {
    isLoading.value = true;
    double totalRecieve = 0.0;
    try {
      checkToken();
      BudgetItemModel budgetModel = await BudgetDetailApi.getBudgetDetail(itemID, jwt);

      for (var i = 0; i < budgetModel.itemExisted!.tasks!.length; i++) {
        int totalPriceTransaction = 0;
        for (var transaction in budgetModel.itemExisted!.tasks![i].transactions!) {
          if (transaction.status == "ACCEPTED" || transaction.status == "SUCCESS") {
            totalPriceTransaction = totalPriceTransaction + transaction.amount!;
          }
        }
        budgetModel.itemExisted!.tasks![i].totalPriceTransaction = totalPriceTransaction;
      }
      budgetItemModel.value = budgetModel;
      nameItem.value = budgetItemModel.value.itemExisted!.itemName!;
      taskView.value = budgetModel.itemExisted!.tasks!;
      totalRecieve = budgetItemModel.value.itemExisted!.plannedAmount! *
          budgetItemModel.value.itemExisted!.plannedPrice! *
          ((budgetItemModel.value.itemExisted!.percentage!) / 100);
      progress.value = budgetModel.totalTransactionUsed! / totalRecieve;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }
}
