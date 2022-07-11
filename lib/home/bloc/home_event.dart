part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomePageChanged extends HomeEvent {
  final HomePage page;

  const HomePageChanged(this.page);

  @override
  List<Object> get props => [page];
}

class HomeStatusLoaded extends HomeEvent {
  final String message;

  const HomeStatusLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class HomeStatusProgressed extends HomeEvent {
  final String message;
  final double progress;

  const HomeStatusProgressed({required this.message, required this.progress});

  @override
  List<Object> get props => [message, progress];
}

class HomeStatusError extends HomeEvent {
  final String message;

  const HomeStatusError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeStatusCleared extends HomeEvent {}
