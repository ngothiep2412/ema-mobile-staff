import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_controller.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_staff/app/routes/app_pages.dart';

class TabHomeController extends BaseController {
  //TODO: Implement TabViewController

  final count = 0.obs;
  RxList<EventModel> listEvent = <EventModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    listEvent.value = [
      EventModel(id:'1',image: 'https://www.shutterstock.com/image-vector/events-colorful-typography-banner-260nw-1356206768.jpg',title: 'Công việc cá nhân'),
      EventModel(id:'2',image: 'https://www.adobe.com/content/dam/www/us/en/events/overview-page/eventshub_evergreen_opengraph_1200x630_2x.jpg',title: 'Lễ kỉ niệm 10 năm')
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
  void onTapEvent({required String idEvent}){
    Get.toNamed(Routes.TASK_OVERALL_VIEW);
  }
}
