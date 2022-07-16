part of 'app_bloc.dart';

enum AppMysqlStatus { connected, disconnected }

@immutable
class AppState extends Equatable {
  final AppMysqlStatus mysqlStatus;
  final MysqlSettings mysqlSettings;
  final String? message;
  final String? errorMessage;

  const AppState({
    this.mysqlStatus = AppMysqlStatus.disconnected,
    this.mysqlSettings = MysqlSettings.empty,
    this.message,
    this.errorMessage,
  });

  AppState copyWith({
    AppMysqlStatus? mysqlStatus,
    MysqlSettings? mysqlSettings,
    String? message,
    String? errorMessage,
  }) =>
      AppState(
        mysqlStatus: mysqlStatus ?? this.mysqlStatus,
        mysqlSettings: mysqlSettings ?? this.mysqlSettings,
        message: message,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [mysqlStatus, mysqlSettings, message, errorMessage];
}
