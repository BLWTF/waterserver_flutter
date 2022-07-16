import 'package:equatable/equatable.dart';

class MysqlSettings extends Equatable {
  final String? database;
  final String? host;
  final String? user;
  final int? port;
  final String? password;
  final int? maxConnections;
  final bool? secure;
  final String? prefix;
  final bool? pool;
  final String? collation;

  static const empty = MysqlSettings();

  const MysqlSettings({
    this.database,
    this.host,
    this.user,
    this.port,
    this.password,
    this.maxConnections,
    this.secure,
    this.prefix,
    this.pool,
    this.collation,
  });

  bool get isEmpty => this == MysqlSettings.empty;

  bool get isNotEmpty => this != MysqlSettings.empty;

  MysqlSettings.fromJson(Map<String, dynamic> json)
      : database = json['db'],
        host = json['host'],
        user = json['user'],
        port = json['port'],
        password = json['password'],
        secure = json['secure'],
        collation = json['collation'] ?? 'utf8mb4_general_ci',
        maxConnections = json['maxConnections'] ?? 10,
        prefix = json['prefix'] ?? '',
        pool = json['pool'] ?? false;

  Map<String, dynamic> toJson() => {
        'db': database,
        'port': port,
        'user': user,
        'password': password,
        'host': host,
        'maxConnections': maxConnections ?? 10,
        'secure': secure ?? false,
        'pool': pool ?? false,
        'prefix': prefix ?? '',
        'collation': collation ?? 'utf8mb4_general_ci',
      };

  @override
  List<Object?> get props => [
        database,
        user,
        port,
        user,
        host,
        maxConnections,
        pool,
        prefix,
        collation
      ];
}
