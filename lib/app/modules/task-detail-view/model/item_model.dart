// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

List<ItemModel> itemModelFromJson(String str) => List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  String? id;
  String? title;
  dynamic code;
  dynamic parentTask;
  String? status;
  Item? item;

  ItemModel({
    this.id,
    this.title,
    this.code,
    this.parentTask,
    this.status,
    this.item,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"],
        title: json["title"],
        code: json["code"],
        parentTask: json["parentTask"],
        status: json["status"],
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "code": code,
        "parentTask": parentTask,
        "status": status,
        "item": item?.toJson(),
      };
}

class Item {
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
  String? updatedBy;
  int? totalPriceUsed;

  Item({
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
    this.totalPriceUsed,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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
        totalPriceUsed: json["totalPriceUsed"],
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
        "totalPriceUsed": totalPriceUsed,
      };
}
