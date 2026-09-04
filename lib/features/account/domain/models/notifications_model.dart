import 'dart:convert';

NotificationResponseModel notificationResponseModelFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

class NotificationResponseModel {
  bool success;
  String message;
  List<NotificationData> data;
  NotificationPagination meta;

  NotificationResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<NotificationData>.from(
            json["data"].map((x) => NotificationData.fromJson(x))),
        meta: NotificationPagination.fromJson(json["meta"]),
      );
}

class NotificationData {
  String id;
  String title;
  String body;
  dynamic image;
  String convertedCreatedAt;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.convertedCreatedAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        image: json["image"],
        convertedCreatedAt: json["converted_created_at"],
      );
}

class NotificationPagination {
  dynamic pagination;

  NotificationPagination({
    required this.pagination,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) =>
      NotificationPagination(
          pagination: (json["pagination"] != null)
              ? Pagination.fromJson(json["pagination"])
              : null);
}

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;
  dynamic links;

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
        links: (json["links"] != null) ? Links.fromJson(json["links"]) : null,
      );
}

class Links {
  Links();

  factory Links.fromJson(Map<String, dynamic> json) => Links();
}
