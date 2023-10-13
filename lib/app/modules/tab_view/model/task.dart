class TaskModel {
  String title;
  String image;
  DateTime? startTime;
  DateTime? endTime;
  bool isParent;
  int totalTask;
  int index;
  String status;
  TaskModel(
      {required this.title,
      required this.image,
       this.startTime,
       this.endTime,
      required this.isParent,
      required this.totalTask,
      required this.index,
      required this.status
      });
}
