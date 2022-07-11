part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppNavigationChanged extends AppEvent {
  final AppPage page;

  const AppNavigationChanged(this.page);

  @override
  List<Object?> get props => [page];
}

class AppLoaded extends AppEvent {
  final String message;

  const AppLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class AppLoadedWithProgress extends AppEvent {
  final String message;
  final double progress;

  const AppLoadedWithProgress({required this.message, required this.progress});

  @override
  List<Object?> get props => [message, progress];
}

class AppReturnedToNormal extends AppEvent {}

class AppEncounteredError extends AppEvent {
  final String message;

  const AppEncounteredError(this.message);

  @override
  List<Object?> get props => [message];
}
