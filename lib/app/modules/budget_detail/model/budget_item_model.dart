// To parse this JSON data, do
//
//     final budgetItemModel = budgetItemModelFromJson(jsonString);

import 'dart:convert';

BudgetItemModel budgetItemModelFromJson(String str) => BudgetItemModel.fromJson(json.decode(str));

String budgetItemModelToJson(BudgetItemModel data) => json.encode(data.toJson());

class BudgetItemModel {
  int? totalTransactionUsed;
  ItemExisted? itemExisted;

  BudgetItemModel({
    this.totalTransactionUsed,
    this.itemExisted,
  });

  factory BudgetItemModel.fromJson(Map<String, dynamic> json) => BudgetItemModel(
        totalTransactionUsed: json["totalTransactionUsed"],
        itemExisted: json["itemExisted"] == null ? null : ItemExisted.fromJson(json["itemExisted"]),
      );

  Map<String, dynamic> toJson() => {
        "totalTransactionUsed": totalTransactionUsed,
        "itemExisted": itemExisted?.toJson(),
      };
}

class ItemExisted {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? itemName;
  String? description;
  int? plannedAmount;
  int? plannedPrice;
  String? plannedUnit;
  int? priority;
  int? percentage;
  String? createdBy;
  dynamic updatedBy;
  List<Task>? tasks;

  ItemExisted({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.itemName,
    this.description,
    this.plannedAmount,
    this.plannedPrice,
    this.plannedUnit,
    this.priority,
    this.percentage,
    this.createdBy,
    this.updatedBy,
    this.tasks,
  });

  factory ItemExisted.fromJson(Map<String, dynamic> json) => ItemExisted(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        itemName: json["itemName"],
        description: json["description"],
        plannedAmount: json["plannedAmount"],
        plannedPrice: json["plannedPrice"],
        plannedUnit: json["plannedUnit"],
        priority: json["priority"],
        percentage: json["percentage"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        tasks: json["tasks"] == null ? [] : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "itemName": itemName,
        "description": description,
        "plannedAmount": plannedAmount,
        "plannedPrice": plannedPrice,
        "plannedUnit": plannedUnit,
        "priority": priority,
        "percentage": percentage,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
      };
}

class Task {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  dynamic code;
  DateTime? startDate;
  DateTime? endDate;
  String? description;
  String? priority;
  String? parentTask;
  int? progress;
  String? status;
  dynamic estimationTime;
  dynamic effort;
  String? createdBy;
  String? modifiedBy;
  dynamic approvedBy;
  bool? isTemplate;
  List<Transaction>? transactions;
  int? totalPriceTransaction;

  Task({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.code,
    this.startDate,
    this.endDate,
    this.description,
    this.priority,
    this.parentTask,
    this.progress,
    this.status,
    this.estimationTime,
    this.effort,
    this.createdBy,
    this.modifiedBy,
    this.approvedBy,
    this.isTemplate,
    this.transactions,
    this.totalPriceTransaction,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        title: json["title"],
        code: json["code"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        description: json["description"],
        priority: json["priority"],
        parentTask: json["parentTask"],
        progress: json["progress"],
        status: json["status"],
        estimationTime: json["estimationTime"],
        effort: json["effort"],
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        approvedBy: json["approvedBy"],
        isTemplate: json["isTemplate"],
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "title": title,
        "code": code,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "description": description,
        "priority": priority,
        "parentTask": parentTask,
        "progress": progress,
        "status": status,
        "estimationTime": estimationTime,
        "effort": effort,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "approvedBy": approvedBy,
        "isTemplate": isTemplate,
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Transaction {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? transactionCode;
  String? transactionName;
  String? description;
  int? amount;
  String? processedBy;
  dynamic rejectNote;
  String? status;
  String? createdBy;
  String? updatedBy;
  List<Evidence>? evidences;

  Transaction({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.transactionCode,
    this.transactionName,
    this.description,
    this.amount,
    this.processedBy,
    this.rejectNote,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.evidences,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        transactionCode: json["transactionCode"],
        transactionName: json["transactionName"],
        description: json["description"],
        amount: json["amount"],
        processedBy: json["processedBy"],
        rejectNote: json["rejectNote"],
        status: json["status"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        evidences: json["evidences"] == null ? [] : List<Evidence>.from(json["evidences"]!.map((x) => Evidence.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "transactionCode": transactionCode,
        "transactionName": transactionName,
        "description": description,
        "amount": amount,
        "processedBy": processedBy,
        "rejectNote": rejectNote,
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "evidences": evidences == null ? [] : List<dynamic>.from(evidences!.map((x) => x.toJson())),
      };
}

class Evidence {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? evidenceFileName;
  int? evidenceFileSize;
  String? evidenceFileType;
  String? evidenceUrl;
  String? createdBy;

  Evidence({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.evidenceFileName,
    this.evidenceFileSize,
    this.evidenceFileType,
    this.evidenceUrl,
    this.createdBy,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) => Evidence(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        evidenceFileName: json["evidenceFileName"],
        evidenceFileSize: json["evidenceFileSize"],
        evidenceFileType: json["evidenceFileType"],
        evidenceUrl: json["evidenceUrl"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "evidenceFileName": evidenceFileName,
        "evidenceFileSize": evidenceFileSize,
        "evidenceFileType": evidenceFileType,
        "evidenceUrl": evidenceUrl,
        "createdBy": createdBy,
      };
}
