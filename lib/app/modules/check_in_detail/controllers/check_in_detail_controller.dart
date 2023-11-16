import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/check_in_detail/api/check_in_detail_api.dart';
import 'package:hrea_mobile_staff/app/modules/check_in_detail/model/timesheet_model.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CheckInDetailController extends BaseController {
  CheckInDetailController({required this.eventID});
  String eventID = '';
  String jwt = '';
  String idUser = '';

  RxBool isLoading = false.obs;
  RxList<TimesheetModel> listTimesheet = <TimesheetModel>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> getEventDetail() async {
    isLoading.value = true;
    try {
      checkToken();

      listTimesheet.value =
          await CheckInDetailApi.getListTimeSheet(jwt, eventID);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }
}
