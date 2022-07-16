import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/settings/settings.dart';

class MysqlSettingsFormState extends Equatable with FormzMixin {
  final Host host;
  final Port port;
  final User user;
  final Password password;
  final Database database;

  const MysqlSettingsFormState({
    this.host = const Host.pure(),
    this.port = const Port.pure(),
    this.user = const User.pure(),
    this.password = const Password.pure(),
    this.database = const Database.pure(),
  });

  bool get isEmpty => this == const MysqlSettingsFormState();

  bool get isNotEmpty => this != const MysqlSettingsFormState();

  factory MysqlSettingsFormState.fromModel(MysqlSettings mysqlSettings) =>
      MysqlSettingsFormState(
        host: Host.dirty(
          mysqlSettings.host!,
        ),
        database: Database.dirty(
          mysqlSettings.database!,
        ),
        user: User.dirty(
          mysqlSettings.user!,
        ),
        password: Password.dirty(
          mysqlSettings.password!,
        ),
        port: Port.dirty(
          mysqlSettings.port!.toString(),
        ),
      );

  MysqlSettingsFormState copyWith({
    Host? host,
    Port? port,
    User? user,
    Password? password,
    Database? database,
  }) =>
      MysqlSettingsFormState(
        host: host ?? this.host,
        port: port ?? this.port,
        user: user ?? this.user,
        password: password ?? this.password,
        database: database ?? this.database,
      );

  @override
  List<FormzInput> get inputs => [host, port, user, password, database];

  @override
  List<Object?> get props => [host, port, user, password, database];
}

enum HostValidationError { empty, invalid }

class Host extends FormzInput<String, HostValidationError> {
  const Host.pure([String value = '']) : super.pure(value);
  const Host.dirty([String value = '']) : super.dirty(value);

  @override
  HostValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : HostValidationError.empty;
  }
}

enum PortValidationError { empty, invalid }

class Port extends FormzInput<String, PortValidationError> {
  const Port.pure([String value = '']) : super.pure(value);
  const Port.dirty([String value = '']) : super.dirty(value);

  @override
  PortValidationError? validator(String? value) {
    PortValidationError? error;

    if (value?.isEmpty == true) {
      error = PortValidationError.empty;
    }

    if (value == null) {
      return error;
    }

    final isNumber = int.tryParse(value) != null;

    error = isNumber ? error : PortValidationError.invalid;

    return error;
  }
}

enum UserValidationError { empty, invalid }

class User extends FormzInput<String, UserValidationError> {
  const User.pure([String value = '']) : super.pure(value);
  const User.dirty([String value = '']) : super.dirty(value);

  @override
  UserValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : UserValidationError.empty;
  }
}

enum PasswordValidationError { empty, invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([String value = '']) : super.pure(value);
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {}
}

enum DatabaseValidationError { empty, invalid }

class Database extends FormzInput<String, DatabaseValidationError> {
  const Database.pure([String value = '']) : super.pure(value);
  const Database.dirty([String value = '']) : super.dirty(value);

  @override
  DatabaseValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : DatabaseValidationError.empty;
  }
}
