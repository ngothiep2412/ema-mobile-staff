// To parse this JSON data, do
//
//     final budgetTransactionModel = budgetTransactionModelFromJson(jsonString);

import 'dart:convert';

List<BudgetTransactionModel> budgetTransactionModelFromJson(String str) =>
    List<BudgetTransactionModel>.from(json.decode(str).map((x) => BudgetTransactionModel.fromJson(x)));

String budgetTransactionModelToJson(List<BudgetTransactionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BudgetTransactionModel {
  String? taskId;
  dynamic taskCode;
  String? taskTitle;
  dynamic parentTask;
  List<TransactionV2>? transactions;

  BudgetTransactionModel({
    this.taskId,
    this.taskCode,
    this.taskTitle,
    this.parentTask,
    this.transactions,
  });

  factory BudgetTransactionModel.fromJson(Map<String, dynamic> json) => BudgetTransactionModel(
        taskId: json["taskId"],
        taskCode: json["taskCode"],
        taskTitle: json["taskTitle"],
        parentTask: json["parentTask"],
        transactions: json["transactions"] == null ? [] : List<TransactionV2>.from(json["transactions"]!.map((x) => TransactionV2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "taskCode": taskCode,
        "taskTitle": taskTitle,
        "parentTask": parentTask,
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class TransactionV2 {
  String? id;
  String? transactionName;
  String? transactionCode;
  String? description;
  int? amount;
  String? rejectNote;
  String? status;
  ProcessedBy? processedBy;
  DateTime? createdAt;
  String? createdBy;
  DateTime? updatedAt;
  String? updatedBy;

  TransactionV2({
    this.id,
    this.transactionName,
    this.transactionCode,
    this.description,
    this.amount,
    this.rejectNote,
    this.status,
    this.processedBy,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory TransactionV2.fromJson(Map<String, dynamic> json) => TransactionV2(
        id: json["id"],
        transactionName: json["transactionName"],
        transactionCode: json["transactionCode"],
        description: json["description"],
        amount: json["amount"],
        rejectNote: json["rejectNote"],
        status: json["status"],
        processedBy: json["processedBy"] == null ? null : ProcessedBy.fromJson(json["processedBy"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        createdBy: json["createdBy"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionName": transactionName,
        "transactionCode": transactionCode,
        "description": description,
        "amount": amount,
        "rejectNote": rejectNote,
        "status": status,
        "processedBy": processedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "createdBy": createdBy,
        "updatedAt": updatedAt?.toIso8601String(),
        "updatedBy": updatedBy,
      };
}

class ProcessedBy {
  String? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  DateTime? dob;
  String? avatar;

  ProcessedBy({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dob,
    this.avatar,
  });

  factory ProcessedBy.fromJson(Map<String, dynamic> json) => ProcessedBy(
        id: json["id"],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "dob": dob?.toIso8601String(),
        "avatar": avatar,
      };
}
