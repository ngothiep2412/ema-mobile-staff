import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:intl/intl.dart';

class TaskScheduleController extends BaseController {
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    dateTimeString.value = dateFormat.format(dateTime).toString();
    if (dateTimeString == dateFormat.format(DateTime.now().toUtc().add(const Duration(hours: 7))).toString()) {
      dateTimeString.value = 'Hôm nay';
    } else {
      dateTimeString.value = dateFormat.format(dateTime).toString();
    }
  }

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  DateTime dateTime = DateTime.now().toUtc().add(const Duration(hours: 7));

  RxString dateTimeString = ''.obs;

  RxBool isLoading = false.obs;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void check(DateTime value) {
    dateTime = value;
    String newDate = dateFormat.format(DateTime.now().toUtc().add(const Duration(hours: 7)));
    if (newDate == dateFormat.format(value).toString()) {
      dateTimeString.value = 'Hôm nay';
    } else {
      dateTimeString.value = dateFormat.format(value).toString();
    }
  }
}
