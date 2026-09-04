class ReferralResponse {
  ReferralResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  final bool success;
  final String message;
  final List<Referral> data;
  final Meta meta;

  factory ReferralResponse.fromJson(Map<String, dynamic> json) =>
      ReferralResponse(
        success: json['success'] as bool,
        message: json['message'] as String,
        data: (json['data'] as List<dynamic>)
            .map((e) => Referral.fromJson(e as Map<String, dynamic>))
            .toList(),
        meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
        'meta': meta.toJson(),
      };

  @override
  String toString() =>
      'ReferralResponse(success: $success, message: $message, data: $data, meta: $meta)';
}

class Referral {
  Referral({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.roleName,
    required this.earning,
    required this.currencySymbol,
    required this.createdAt,
    required this.referralStatus,
  });

  final int id;
  final String name;
  final String profilePicture;
  final String roleName;
  final int earning;
  final String currencySymbol;
  final String createdAt;
  final String referralStatus;

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        id: json['id'] as int,
        name: json['name'] as String,
        profilePicture: json['profile_picture'] as String,
        roleName: json['role_name'] as String,
        earning: json['earning'] as int,
        currencySymbol: json['currency_symbol'] as String,
        createdAt: (json['credited_at'] ?? '') as String,
        referralStatus: json['referral_status'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profile_picture': profilePicture,
        'role_name': roleName,
        'earning': earning,
        'currency_symbol': currencySymbol,
        'credited_at': createdAt,
        'referral_status': referralStatus,
      };

  @override
  String toString() =>
      'Referral(id: $id, name: $name, profilePicture: $profilePicture, roleName: $roleName, earning: $earning, currencySymbol: $currencySymbol, createdAt: $createdAt, referralStatus: $referralStatus)';
}

class Meta {
  Meta({
    required this.pagination,
  });

  final Pagination pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination:
            Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'pagination': pagination.toJson(),
      };

  @override
  String toString() => 'Meta(pagination: $pagination)';
}

class Pagination {
  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.links,
  });

  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int totalPages;
  final Map<String, dynamic> links;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json['total'] as int,
        count: json['count'] as int,
        perPage: json['per_page'] as int,
        currentPage: json['current_page'] as int,
        totalPages: json['total_pages'] as int,
        links: (json['links'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'count': count,
        'per_page': perPage,
        'current_page': currentPage,
        'total_pages': totalPages,
        'links': links,
      };

  @override
  String toString() =>
      'Pagination(total: $total, count: $count, perPage: $perPage, currentPage: $currentPage, totalPages: $totalPages, links: $links)';
}
