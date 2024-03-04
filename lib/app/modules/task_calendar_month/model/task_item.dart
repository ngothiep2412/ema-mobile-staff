// To parse this JSON data, do
//
//     final taskItem = taskItemFromJson(jsonString);

import 'dart:convert';

TaskItem taskItemFromJson(String str) => TaskItem.fromJson(json.decode(str));

String taskItemToJson(TaskItem data) => json.encode(data.toJson());

class TaskItem {
  String? id;
  String? title;
  String? startDate;
  String? endDate;
  String? priority;
  String? status;

  TaskItem({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.priority,
    this.status,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        id: json["id"],
        title: json["title"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        priority: json["priority"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "startDate": startDate,
        "endDate": endDate,
        "priority": priority,
        "status": status,
      };
}
