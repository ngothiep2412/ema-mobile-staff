import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/profile/api/profile_api.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends BaseController {
  TextEditingController? fullNameController;
  // TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? addressController;
  TextEditingController? dateController;
  RxString imageUrl = ''.obs;

  ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  XFile? file;
  String? userForm;
  UserModel? userModel;
  ResponseApi? responseApi;
  RxString selectImagePath = ''.obs;
  RxString selectImageSize = ''.obs;

  var selectedDate = DateTime.now().obs;
  var user = GetStorage().read('user');
  RxBool errorUpdateProfile = false.obs;
  RxString errorUpdateProfileText = ''.obs;
  RxBool isLoading = false.obs;

  final genderList = ["Nam", "Nữ"];
  RxString selectedGenderVal = ''.obs;

  @override
  void onInit() async {
    try {
      print('user ${user}');
      Map<String, dynamic> userMap = jsonDecode(GetStorage().read('user'));
      userModel = UserModel.fromJson(userMap);
      print('userForm ${userModel!.result!.fullName}');

      dateController = TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(userModel!.result!.dob!));
      fullNameController =
          TextEditingController(text: userModel!.result!.fullName);
      // emailController = TextEditingController(text: userModel!.result!.email);
      addressController =
          TextEditingController(text: userModel!.result!.address);
      phoneController =
          TextEditingController(text: userModel!.result!.phoneNumber);
      imageUrl.value = userModel!.result!.avatar!;
      selectedGenderVal.value = userModel!.result!.gender!;
    } catch (e) {
      print('Error parsing JSON: $e');
    }

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

  void updateProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (fullNameController!.text == '') {
      print(fullNameController!.text);
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value = "Vui lòng nhập họ và tên";
      isLoading.value = false;
    } else if (phoneController!.text == '') {
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value = "Vui lòng nhập số điện thoại";
      isLoading.value = false;
    } else if (isValidPhoneNumber(phoneController!.text) == false) {
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value = "Số điện thoại không hợp lệ";
      isLoading.value = false;
    } else if (isDateValid(dateController!.text) != true) {
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value =
          "Ngày sinh không hợp lệ, nhập đúng định dạng dd/mm/yyyy";
      isLoading.value = false;
    } else {
      try {
        String? jwtToken = pref.getString('JWT');
        if (jwtToken != null) {
          if (imageFile == null) {
            responseApi = await ProfileApi.updateProfile(
                phoneController!.text,
                fullNameController!.text,
                dateController!.text,
                addressController!.text,
                userModel!.result!.avatar!,
                selectedGenderVal.value,
                jwtToken);
            if (responseApi!.statusCode == 200 ||
                responseApi!.statusCode == 201) {
              errorUpdateProfile.value = false;
            } else {}
          } else {
            ResponseApi responseApi =
                await ProfileApi.uploadFile(jwtToken, file!);
            if (responseApi.statusCode == 200 ||
                responseApi.statusCode == 201) {
              errorUpdateProfile.value = false;
              print('upload file thành công');
            } else {
              errorUpdateProfile.value = true;
              errorUpdateProfileText.value =
                  "Kích thước file phải nhỏ hơn 10mb";
            }
          }
          isLoading.value = false;
        }
      } catch (e) {
        log(e.toString());
        errorUpdateProfile.value = true;
        isLoading.value = false;
        errorUpdateProfileText.value = "Có lỗi xảy ra";
      }
    }
  }

  Future selectImage(ImageSource source) async {
    file = await imagePicker.pickImage(source: source);
    if (file != null) {
      imageFile = File(file!.path);
      selectImagePath.value = file!.path;
      selectImageSize.value =
          "${((File(selectImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)}Mb";
    } else {
      Get.snackbar('Lỗi', 'Không thể lấy hình ảnh',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      //initialEntryMode: DatePickerEntryMode.input,
      // initialDatePickerMode: DatePickerMode.year,
      helpText: 'Chọn ngày sinh',
      cancelText: 'Đóng',
      confirmText: 'Xác nhận',
      errorFormatText: 'Nhập ngày hợp lệ',
      errorInvalidText: 'Nhập phạm vi ngày hợp lệ',
      fieldLabelText: 'Ngày Sinh',
      fieldHintText: 'Ngày/Tháng/Năm',
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      dateController!.text =
          DateFormat('dd/MM/yyyy').format(selectedDate.value).toString();
      print(' dateController!.text ${dateController!.text}');
    }
  }

  // bool disableDate(DateTime day) {
  //   if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
  //       day.isBefore(DateTime.now().add(const Duration(days: 5))))) {
  //     return true;
  //   }
  //   return false;
  // }

  bool isDateValid(String date) {
    // Định dạng kiểm tra ngày: dd/MM/yyyy
    const pattern = r'^\d{2}/\d{2}/\d{4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(date)) {
      // Chuỗi ngày không khớp với định dạng
      return false;
    }

    // Tiếp theo, kiểm tra xem ngày có hợp lệ không
    final parts = date.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      // Ngày, tháng hoặc năm không phải là số hợp lệ
      return false;
    }

    if (month < 1 || month > 12) {
      // Tháng không hợp lệ
      return false;
    }

    if (day < 1 || day > 31) {
      // Ngày không hợp lệ
      return false;
    }

    return true;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^(0|\+84)[1-9]\d{8,9}$');
    if (!regex.hasMatch(phoneNumber)) {
      return false;
    }
    return true;
  }

  setGender(String value) {
    selectedGenderVal.value = value;
  }
}
