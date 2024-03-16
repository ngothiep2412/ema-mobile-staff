import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/subtask-detail-view/model/employee_model.dart';
import 'package:hrea_mobile_staff/app/modules/task_calendar_month/api/task_calendar_month_api.dart';
import 'package:hrea_mobile_staff/app/modules/task_calendar_month/model/task_item.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskCalendarMonthController extends BaseController {
  TaskCalendarMonthController({required this.userID, required this.userName, required this.startDate, required this.endDate});
  String userID = '';
  String userName = '';
  String startDate = '';
  String endDate = '';

  final count = 0.obs;

  var dateStarTask = DateTime.now().obs;
  RxBool checkInView = true.obs;

  void onDaySelected(DateTime day, DateTime focusesDay) {
    dateStarTask.value = day;
    getTask(focusesDay);
  }

  DateFormat dateFormat = DateFormat('yyyy-MM-DD', 'vi');

  var calendarFormat = CalendarFormat.month.obs;
  var focusedDay = DateTime.now().obs;

  var selectedDay;
  // var today = DateTime.now().toLocal().add(const Duration(hours: 7)).obs;
  // Map<DateTime, List<TaskItem>> tasks = {};

  // late ValueNotifier<List<TaskItem>> selectedTasks;

  var tasks = <DateTime, List<TaskItem>>{}.obs;

  // {
  //   DateTime(2024, 2, 27): [TaskItem("Task 1"), TaskItem("Task 2"), TaskItem("Task special event")],
  //   DateTime(2024, 2, 28): [TaskItem("Task 3"), TaskItem("Task 4")],
  // }.obs;

  RxList<TaskItem> taskShow = <TaskItem>[].obs;
  String jwt = '';
  String idUser = '';
  @override
  Future<void> onInit() async {
    super.onInit();
    // selectedDay = focusedDay.value;

    dateStarTask.value = DateTime.parse(convertDateFormat(startDate));
    await getDetailEmployee();
    onDaySelected(dateStarTask.value.add(const Duration(hours: 7)), dateStarTask.value.add(const Duration(hours: 7)));
    print('startDate ${dateStarTask}');
    // selectedTasks = ValueNotifier(getTasksForDay(selectedDay!));
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  String convertDateFormat(String dateString) {
    // Định dạng ban đầu của ngày
    final originalFormat = DateFormat('yyyy-MM-dd');

    // Định dạng bạn muốn chuyển đổi sang
    final desiredFormat = DateFormat('yyyy-MM-dd');

    // Parse ngày từ định dạng ban đầu
    final date = originalFormat.parse(dateString);

    // Format lại ngày theo định dạng mong muốn
    return desiredFormat.format(date);
  }

  String convertDateFormatV2(String dateString) {
    // Định dạng ban đầu của ngày
    final originalFormat = DateFormat('yyyy-MM-dd');

    // Định dạng bạn muốn chuyển đổi sang
    final desiredFormat = DateFormat('dd-MM-yyyy');

    // Parse ngày từ định dạng ban đầu
    final date = originalFormat.parse(dateString);

    // Format lại ngày theo định dạng mong muốn
    return desiredFormat.format(date);
  }

  Future<void> getDetailEmployee() async {
    try {
      checkToken();
      // tasks.clear();
      EmployeeModel employeeModel = EmployeeModel();
      List<EmployeeModel> employeesList = await TaskCalendarMonthApi.getAllEmployee(jwt, userID, startDate, endDate);
      if (employeesList.isNotEmpty) {
        for (var employee in employeesList) {
          if (employee.id == userID) {
            employeeModel = employee;
            break;
          }
        }

        for (var event in employeeModel.listEvent!) {
          // Lặp qua mỗi nhiệm vụ trong sự kiện
          event.listTask!.forEach((task) {
            String startDateString = task.startDate!;
            String endDateString = task.endDate!;

            // Parse ngày bắt đầu và kết thúc từ string thành DateTime
            var startDate = DateTime.parse(startDateString).add(const Duration(hours: 7));
            var endDate = DateTime.parse(endDateString).add(const Duration(hours: 7));
            // Thêm nhiệm vụ vào danh sách tasks cho mỗi ngày từ startDate đến endDate
            for (var date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
              tasks.putIfAbsent(date, () => []).add(TaskItem(
                    id: task.id,
                    title: task.title,
                    startDate: task.startDate,
                    endDate: task.endDate,
                    priority: task.priority,
                    status: task.status,
                  ));
            }
          });
        }
        print('test ngay: $tasks');
      }
    } catch (e) {
      print(e);
      checkInView.value = false;
    }
  }

  List<TaskItem> getTasksForDay(DateTime day) {
    // DateTime dateTime = DateTime(2024, 2, 28);
    DateTime dateTime = day.toLocal();
    print('${tasks[dateTime]}');
    // getDetailEmployee();
    return tasks[dateTime] ?? [];
  }

  void getTask(DateTime day) {
    DateTime dateTime = day.toLocal();
    List<TaskItem> taskItems = tasks[dateTime] ?? [];
    // Nếu dateTime có trong tasks thì trả về danh sách TaskItem, nếu không trả về danh sách trống
    // taskShow.clear();
    taskShow.value = taskItems;
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
