// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) => EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  String? id;
  String? email;
  Profile? profile;
  Role? role;
  List<ListEvent>? listEvent;
  int? totalTask;
  bool? isFree;
  bool? check;

  EmployeeModel({
    this.id,
    this.email,
    this.profile,
    this.role,
    this.listEvent,
    this.totalTask,
    this.isFree,
    this.check,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        email: json["email"],
        profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        listEvent: json["listEvent"] == null ? [] : List<ListEvent>.from(json["listEvent"]!.map((x) => ListEvent.fromJson(x))),
        totalTask: json["totalTask"],
        isFree: json["isFree"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "profile": profile?.toJson(),
        "role": role?.toJson(),
        "listEvent": listEvent == null ? [] : List<dynamic>.from(listEvent!.map((x) => x.toJson())),
        "totalTask": totalTask,
        "isFree": isFree,
      };
}

class ListEvent {
  String? eventId;
  String? eventName;
  List<ListTask>? listTask;
  int? totalTaskInEvent;

  ListEvent({
    this.eventId,
    this.eventName,
    this.listTask,
    this.totalTaskInEvent,
  });

  factory ListEvent.fromJson(Map<String, dynamic> json) => ListEvent(
        eventId: json["eventID"],
        eventName: json["eventName"],
        listTask: json["listTask"] == null ? [] : List<ListTask>.from(json["listTask"]!.map((x) => ListTask.fromJson(x))),
        totalTaskInEvent: json["totalTaskInEvent"],
      );

  Map<String, dynamic> toJson() => {
        "eventID": eventId,
        "eventName": eventName,
        "listTask": listTask == null ? [] : List<dynamic>.from(listTask!.map((x) => x.toJson())),
        "totalTaskInEvent": totalTaskInEvent,
      };
}

class ListTask {
  String? id;
  String? title;
  String? startDate;
  String? endDate;
  String? priority;
  String? status;

  ListTask({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.priority,
    this.status,
  });

  factory ListTask.fromJson(Map<String, dynamic> json) => ListTask(
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

class Profile {
  String? fullName;
  String? avatar;

  Profile({
    this.fullName,
    this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        fullName: json["fullName"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "avatar": avatar,
      };
}

class Role {
  String? roleName;

  Role({
    this.roleName,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleName: json["roleName"],
      );

  Map<String, dynamic> toJson() => {
        "roleName": roleName,
      };
}
