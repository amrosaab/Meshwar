import 'dart:convert';

GoodsTypeModel goodsTypeModelFromJson(String str) =>
    GoodsTypeModel.fromJson(json.decode(str));

class GoodsTypeModel {
  bool success;
  String message;
  List<GoodsTypeData> data;

  GoodsTypeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GoodsTypeModel.fromJson(Map<String, dynamic> json) => GoodsTypeModel(
        success: json["success"],
        message: json["message"],
        data: List<GoodsTypeData>.from(
            json["data"].map((x) => GoodsTypeData.fromJson(x))),
      );
}

class GoodsTypeData {
  int id;
  String goodsTypeName;
  String goodsTypesFor;
  dynamic companyKey;
  int active;
  String createdAt;
  String updatedAt;

  GoodsTypeData({
    required this.id,
    required this.goodsTypeName,
    required this.goodsTypesFor,
    required this.companyKey,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoodsTypeData.fromJson(Map<String, dynamic> json) => GoodsTypeData(
        id: json["id"] ?? 0,
        goodsTypeName: json["goods_type_name"] ?? '',
        goodsTypesFor: json["goods_types_for"] ?? '',
        companyKey: json["company_key"] ?? '',
        active: json["active"] ?? 0,
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
      );
}
