part of 'settings_cubit.dart';

enum SettingsPage { main, mysql }

class SettingsState extends Equatable {
  final SettingsPage page;
  final double? currentVersion;
  final Map? appLatestVersionInfo;
  final HomeStatus status;
  final double? progress;
  final String? message;
  final MysqlSettingsFormState? mysqlSettingsFormState;

  const SettingsState({
    required this.page,
    this.progress,
    this.appLatestVersionInfo,
    this.currentVersion = ApplicationConfig.currentVersion,
    this.status = HomeStatus.normal,
    this.message,
    this.mysqlSettingsFormState,
  });

  SettingsState copyWith({
    SettingsPage? page,
    double? currentVersion,
    Map? appLatestVersionInfo,
    HomeStatus? status,
    double? progress,
    String? message,
    MysqlSettingsFormState? mysqlSettingsFormState,
  }) =>
      SettingsState(
        page: page ?? this.page,
        currentVersion: currentVersion ?? this.currentVersion,
        appLatestVersionInfo: appLatestVersionInfo ?? this.appLatestVersionInfo,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        message: message ?? this.message,
        mysqlSettingsFormState:
            mysqlSettingsFormState ?? this.mysqlSettingsFormState,
      );

  @override
  List<Object?> get props => [
        page,
        currentVersion,
        appLatestVersionInfo,
        status,
        progress,
        message,
        mysqlSettingsFormState
      ];
}
