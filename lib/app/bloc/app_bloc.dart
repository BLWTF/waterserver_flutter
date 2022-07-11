import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState(page: AppPage.dashboard)) {
    on<AppNavigationChanged>(_onNavigationChanged);
    on<AppLoaded>(_onLoaded);
    on<AppLoadedWithProgress>(_onLoadedWithProgress);
    on<AppReturnedToNormal>(_onReturnedToNormal);
    on<AppEncounteredError>(_onEAppEncounteredError);
  }

  void _onNavigationChanged(
    AppNavigationChanged event,
    Emitter<AppState> emit,
  ) {
    emit(AppState(page: event.page));
  }

  void _onLoaded(
    AppLoaded event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(
      status: AppStatus.loading,
      message: event.message,
    ));
  }

  void _onLoadedWithProgress(
    AppLoadedWithProgress event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(
      status: AppStatus.progress,
      message: event.message,
      progress: event.progress,
    ));
  }

  void _onEAppEncounteredError(
    AppEncounteredError event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(
      status: AppStatus.error,
      message: event.message,
    ));
  }

  void _onReturnedToNormal(
    AppReturnedToNormal event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(status: AppStatus.clear));
  }
}
