// To parse this JSON data, do
//
//     final faqResponseModel = faqResponseModelFromJson(jsonString);

import 'dart:convert';

FaqResponseModel faqResponseModelFromJson(String str) =>
    FaqResponseModel.fromJson(json.decode(str));

class FaqResponseModel {
  bool success;
  String message;
  List<FaqData> data;
  Meta meta;

  FaqResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) =>
      FaqResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<FaqData>.from(json["data"].map((x) => FaqData.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );
}

class FaqData {
  String id;
  String serviceLocationId;
  String question;
  String answer;
  String userType;
  bool active;

  FaqData({
    required this.id,
    required this.serviceLocationId,
    required this.question,
    required this.answer,
    required this.userType,
    required this.active,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
        id: json["id"] ?? '',
        serviceLocationId: json["service_location_id"] ?? '',
        question: json["question"] ?? '',
        answer: json["answer"] ?? '',
        userType: json["user_type"] ?? '',
        active: json["active"] ?? false,
      );
}

class Meta {
  Pagination pagination;

  Meta({
    required this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );
}

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;
  Links links;

  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.links,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"] ?? 0,
        count: json["count"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
        links: Links.fromJson(json["links"]),
      );
}

class Links {
  Links();

  factory Links.fromJson(Map<String, dynamic> json) => Links();
}
