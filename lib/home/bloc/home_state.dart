part of 'home_bloc.dart';

enum HomeStatus { normal, clear, loading, progress, success, error }

enum HomePage { dashboard, contract, settings }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomePage page;
  final String? message;
  final double? progress;

  const HomeState({
    required this.page,
    this.status = HomeStatus.normal,
    this.message,
    this.progress,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomePage? page,
    String? message,
    double? progress,
  }) =>
      HomeState(
        status: status ?? this.status,
        message: message ?? this.message,
        page: page ?? this.page,
        progress: progress ?? this.progress,
      );

  @override
  List<Object?> get props => [status, page, message, progress];
}
