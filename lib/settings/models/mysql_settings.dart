class MysqlSettings {
  final String db;
  final String host;
  final String user;
  final int port;
  final String root;
  final String password;
  final int? maxConnections;
  final bool secure;
  final String? prefix;
  final bool pool;
  final MysqlCollation? collation;

  MysqlSettings({
    required this.db,
    required this.host,
    required this.user,
    required this.port,
    required this.root,
    required this.password,
    this.maxConnections = 10,
    required this.secure,
    this.prefix = '',
    required this.pool,
    this.collation = MysqlCollation.utf8mb4_general_ci,
  });

  MysqlSettings.fromJson(Map<String, dynamic> json)
      : db = json['db'],
        host = json['host'],
        user = json['user'],
        port = json['port'],
        root = json['root'],
        password = json['password'],
        secure = json['secure'],
        collation = json['collation'],
        maxConnections = json['maxConnections'],
        prefix = json['prefix'],
        pool = json['pool'];

  Map<String, dynamic> toJson() => {
        'db': db,
        'port': port,
        'user': user,
        'password': password,
        'host': host,
        'maxConnections': maxConnections,
        'secure': secure,
        'pool': pool,
        'prefix': prefix,
        'collation': collation.toString(),
      };
}

enum MysqlCollation { utf8mb4_general_ci }
