import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/settings/models/mysql_settings.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(page: HomePage.dashboard)) {
    // on navigation pane clicked or page changed
    on<HomePageChanged>((event, emit) {
      emit(state.copyWith(page: event.page));
    });

    // on loading
    on<HomeStatusLoaded>((event, emit) {
      emit(state.copyWith(status: HomeStatus.loading, message: event.message));
    });

    // on progress
    on<HomeStatusProgressed>((event, emit) {
      emit(state.copyWith(
        status: HomeStatus.progress,
        message: event.message,
        progress: event.progress,
      ));
    });

    // on error
    on<HomeStatusError>((event, emit) {
      emit(state.copyWith(status: HomeStatus.error, message: event.message));
    });

    // on clear loading or progress dialog
    on<HomeStatusCleared>((event, emit) {
      emit(state.copyWith(status: HomeStatus.clear));
    });
  }
}
