part of 'app_bloc.dart';

enum AppStatus { clear, loading, progress, success, error }

enum AppPage { dashboard, contract, settings }

@immutable
class AppState extends Equatable {
  final String appTitle = '';
  final AppStatus? status;
  final AppPage page;
  final String? message;
  final double? progress;

  const AppState({
    required this.page,
    this.status,
    this.message,
    this.progress,
  });

  AppState copyWith({
    AppStatus? status,
    AppPage? page,
    String? message,
    double? progress,
  }) =>
      AppState(
        status: status ?? this.status,
        message: message ?? this.message,
        page: page ?? this.page,
        progress: progress ?? this.progress,
      );

  @override
  List<Object?> get props => [status, page, message, progress];
}
