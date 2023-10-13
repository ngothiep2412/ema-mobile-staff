import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:intl/intl.dart';

class TaskOverallViewController extends BaseController {
  //TODO: Implement TaskOverallViewController

  final count = 0.obs;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  RxList<TaskModel> listEventModel = <TaskModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    listEventModel.value = [
      TaskModel(
          title:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
          image:
              'https://www.shutterstock.com/image-vector/events-colorful-typography-banner-260nw-1356206768.jpg',
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          isParent: true,
          status: 'INPROGRESS',
          totalTask: 3,
          index: 0),
      TaskModel(
          title: 'Lorem Ipsum is simply dummy text',
          image: '',
          startTime: DateTime.now(),
          status: 'DONE',
          endTime: DateTime.now(),
          isParent: false,
          totalTask: 3,
          index: 1),
      TaskModel(
          title: 'Lorem Ipsum is simply dummy text',
          image: '',
          startTime: null,
          status: 'INPROGRESS',
          endTime: null,
          isParent: false,
          totalTask: 3,
          index: 2),
      TaskModel(
          title: 'Lorem Ipsum is simply dummy text',
          image: '',
          status: 'CANCEL',
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          isParent: false,
          totalTask: 3,
          index: 3),
    ];
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
}
