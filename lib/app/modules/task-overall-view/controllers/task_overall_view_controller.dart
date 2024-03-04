import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/task-overall-view/api/task_overall_api.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TaskOverallViewController extends BaseController {
  TaskOverallViewController({required this.eventID, required this.eventName});

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  String eventID = '';
  String eventName = '';

  RxList<TaskModel> listTask = <TaskModel>[].obs;

  RxBool isLoading = false.obs;

  RxList<String> filterList = <String>[
    "Không chọn",
    "Ngày tạo (Tăng dần)",
    "Ngày tạo (Giảm dần)",
    "Hạn hoàn thành (Tăng dần)",
    "Hạn hoàn thành (Giảm dần)",
    "Mức độ ưu tiên (Tăng dần)",
    "Mức độ ưu tiên (Giảm dần)",
  ].obs;

  RxString filterChoose = ''.obs;
  String jwt = '';

  Future<void> refreshPage() async {
    listTask.clear();
    jwt = GetStorage().read('JWT');
    isLoading.value = true;
    await getListTask();
    isLoading.value = false;
  }

  Future<void> getTaskDetail(String taskID) async {
    Get.toNamed(Routes.TASK_DETAIL_VIEW, arguments: {"taskID": taskID});
  }

  Future<void> getListTask() async {
    String jwt = GetStorage().read('JWT');
    isLoading.value = true;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    listTask.clear();
    List<TaskModel> list = [];
    list = await TaskOverallApi.getTask(jwt, eventID);
    if (list.isNotEmpty) {
      for (var item in list) {
        if (item.assignTasks!.isNotEmpty) {
          if (item.parent == null && item.status != Status.CANCEL && item.assignTasks![0].user!.id == decodedToken['id']) {
            listTask.add(item);
          }
        }
      }
      // listTask.sort((a, b) => a.endDate!.compareTo(b.endDate!));

      filterChoose.value = '';
    }
    isLoading.value = false;
  }

  filter(String value) {
    filterChoose.value = value;
    isLoading.value = true;
    if (filterChoose.value.contains("Không chọn")) {
      listTask.value = List.from(listTask)..sort((a, b) => a.endDate!.compareTo(b.endDate!));
    } else if (filterChoose.value.contains("Ngày tạo (Tăng dần)")) {
      listTask.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    } else if (filterChoose.value.contains("Ngày tạo (Giảm dần)")) {
      listTask.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } else if (filterChoose.value.contains("Hạn hoàn thành (Tăng dần)")) {
      listTask.sort((a, b) => a.endDate!.compareTo(b.endDate!));
    } else if (filterChoose.value.contains("Hạn hoàn thành (Giảm dần)")) {
      listTask.sort((a, b) => b.endDate!.compareTo(a.endDate!));
    } else if (filterChoose.value.contains("Mức độ ưu tiên (Giảm dần)")) {
      listTask.sort((a, b) {
        final priorityOrder = {Priority.HIGH: 0, Priority.MEDIUM: 1, Priority.LOW: 2};

        final priorityA = priorityOrder[a.priority] ?? 2;
        final priorityB = priorityOrder[b.priority] ?? 2;

        return priorityA.compareTo(priorityB);
      });
    } else if (filterChoose.value.contains("Mức độ ưu tiên (Tăng dần)")) {
      listTask.sort((a, b) {
        final priorityOrder = {Priority.LOW: 0, Priority.MEDIUM: 1, Priority.HIGH: 2};

        final priorityA = priorityOrder[a.priority] ?? 2;
        final priorityB = priorityOrder[b.priority] ?? 2;
        return priorityA.compareTo(priorityB);
      });
    } else if (filterChoose.value == '') {
      listTask.value = List.from(listTask)..sort((a, b) => a.endDate!.compareTo(b.endDate!));
    }
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getListTask();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
