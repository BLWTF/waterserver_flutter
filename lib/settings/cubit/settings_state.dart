part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final double? currentVersion;
  final Map? appLatestVersionInfo;
  final HomeStatus? status;
  final double? progress;
  final String? message;

  const SettingsState({
    this.progress,
    this.appLatestVersionInfo,
    this.currentVersion = ApplicationConfig.currentVersion,
    this.status,
    this.message,
  });

  SettingsState copyWith({
    double? currentVersion,
    Map? appLatestVersionInfo,
    HomeStatus? status,
    double? progress,
    String? message,
  }) =>
      SettingsState(
        currentVersion: currentVersion ?? this.currentVersion,
        appLatestVersionInfo: appLatestVersionInfo ?? this.appLatestVersionInfo,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props =>
      [currentVersion, appLatestVersionInfo, status, progress, message];
}
