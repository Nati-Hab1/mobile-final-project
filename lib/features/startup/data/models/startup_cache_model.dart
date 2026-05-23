import '../../domain/entities/startup.dart';

class StartupCacheModel {
  static const String tableName = 'cached_startups';
  static const String columnId = 'id';
  static const String columnData = 'data';
  static const String columnCachedAt = 'cached_at';
  static const String columnExpiresAt = 'expires_at';

  final int id;
  final String data;
  final DateTime cachedAt;
  final DateTime expiresAt;

  StartupCacheModel({
    required this.id,
    required this.data,
    required this.cachedAt,
    required this.expiresAt,
  });

  factory StartupCacheModel.fromJson(Map<String, dynamic> json) {
    return StartupCacheModel(
      id: json['id'],
      data: json['data'],
      cachedAt: DateTime.parse(json['cached_at']),
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'cached_at': cachedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
