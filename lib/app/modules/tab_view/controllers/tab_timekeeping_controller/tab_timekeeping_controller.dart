import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/modal_attendance.dart';
import 'package:intl/intl.dart';
import 'package:safe_device/safe_device.dart';

class TabTimeKeepingController extends BaseController {
  final isRangeDate = true.obs;
  RxList<ModelTestAttendance> listAttendanceSum = <ModelTestAttendance>[
    ModelTestAttendance(type: "Tổng", number: 15),
    ModelTestAttendance(type: "Có mặt", number: 7),
    ModelTestAttendance(type: "Trễ", number: 4),
    ModelTestAttendance(type: "Vắng mặt", number: 4),
  ].obs;

  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  RxList<DateTime?> listDateTime = <DateTime?>[
    DateTime.now(),
  ].obs;
  Rx<DateTime> currentTime = Rx<DateTime>(DateTime.now());
  final isCheckedIn = false.obs;
  final isLoading = true.obs;
  Position? currentPossion;
  double latCompany = 10.8428;
  double lngCompany = 106.8287;

  RxString vietNamTime = ''.obs;

  String convertUtcToVietnamTime(DateTime dateTime) {
    final vietnamTimeDate = dateTime.toLocal().add(Duration(hours: 7));
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(vietnamTimeDate);
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now().toUtc();
      currentTime.value = now;
      vietNamTime.value = convertUtcToVietnamTime(now);
    });
    await getCurrrentPossion();

    isLoading(false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void saveTime() {}
  void getTimeRange(List<DateTime?> listTime) {
    listDateTime(listTime);
  }

  changeTypeChooseDate(bool value) {
    listDateTime([DateTime.now()]);
    isRangeDate(value);
  }

  getCurrrentPossion() async {
    try {
      currentPossion = await _determinePosition();
      if (currentPossion!.isMocked) {
        Get.snackbar("Thông báo", "Vị trí giả");
      }
    } catch (e) {
      Get.snackbar('Thông báo', 'Chưa lấy được vị trí');
    }
  }

  Future<void> checkInOut() async {
    //check real phone
    bool isRealDevice = await SafeDevice.isRealDevice;
    currentPossion = await _determinePosition();
    //  if(isRealDevice){
    if (Geolocator.distanceBetween(latCompany, lngCompany,
            currentPossion!.latitude, currentPossion!.longitude) <
        100) {
      //Check In
      //kiểm 1 số logic nữa để dêtect checkout
      isCheckedIn(true);
      Get.snackbar("Thông báo", "Check in thành công");
    } else {
      Get.snackbar("Thông báo", "Chưa đủ gần để check in/out");
    }
    //  }else{
    //     Get.snackbar("Thông báo", "Thiết bị không phù hợp");
    //  }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Quyền vị trí bị từ chối');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
