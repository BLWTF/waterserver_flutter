import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/settings/settings.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final SettingsRepository _settingsRepository;
  final MysqlDatabaseRepository _databaseRepository;
  late final StreamSubscription<MysqlSettings> _mysqlSettingsSubscription;

  AppBloc({
    required SettingsRepository settingsRepository,
    required MysqlDatabaseRepository databaseRepository,
  })  : _settingsRepository = settingsRepository,
        _databaseRepository = databaseRepository,
        super(const AppState()) {
    on<AppChangedMysqlSettings>(_onAppChangedMysqlSettings);

    _mysqlSettingsSubscription = _settingsRepository.mysqlSettings.listen(
      (mysqlSettings) {
        add(AppChangedMysqlSettings(mysqlSettings));
      },
    );
  }

  void _onAppChangedMysqlSettings(
    AppChangedMysqlSettings event,
    Emitter<AppState> emit,
  ) async {
    if (event.mysqlSettings.isEmpty) {
      return;
    }

    emit(state.copyWith(mysqlSettings: event.mysqlSettings));

    try {
      await _databaseRepository.connect(event.mysqlSettings);

      _showMessage(emit, 'Database connection successful');

      emit(state.copyWith(
        mysqlStatus: AppMysqlStatus.connected,
        mysqlSettings: event.mysqlSettings,
      ));
    } on CouldNotConnectToDBException catch (e) {
      _showErrorMessage(emit, e.message!);
    }
  }

  void _showMessage(Emitter<AppState> emit, String message) {
    emit(state.copyWith(message: message));
    emit(state.copyWith(message: null));
  }

  void _showErrorMessage(Emitter<AppState> emit, String message) {
    emit(state.copyWith(errorMessage: message));
    emit(state.copyWith(errorMessage: null));
  }

  @override
  Future<void> close() {
    _mysqlSettingsSubscription.cancel();
    return super.close();
  }
}
