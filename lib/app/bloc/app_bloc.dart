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
  late final StreamSubscription<AppMysqlStatus> _mysqlStatusSubscription;

  AppBloc({
    required SettingsRepository settingsRepository,
    required MysqlDatabaseRepository databaseRepository,
  })  : _settingsRepository = settingsRepository,
        _databaseRepository = databaseRepository,
        super(const AppState(mysqlStatus: AppMysqlStatus.connecting)) {
    on<AppChangedMysqlSettings>(_onAppChangedMysqlSettings);

    on<AppChangedMysqlStatus>(_onAppChangedMysqlStatus);

    _mysqlSettingsSubscription = _settingsRepository.mysqlSettings.listen(
      (mysqlSettings) {
        add(AppChangedMysqlSettings(mysqlSettings));
      },
    );

    _mysqlStatusSubscription = _databaseRepository.mysqlStatus.listen(
      (mysqlStatus) {
        add(AppChangedMysqlStatus(mysqlStatus));
      },
    );
  }

  void _onAppChangedMysqlStatus(
    AppChangedMysqlStatus event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(mysqlStatus: event.mysqlStatus));
  }

  void _onAppChangedMysqlSettings(
    AppChangedMysqlSettings event,
    Emitter<AppState> emit,
  ) async {
    if (event.mysqlSettings.isEmpty) {
      _showErrorMessage(
          emit, 'No Mysql connection details provided, go to settings.');
      return;
    }

    emit(state.copyWith(mysqlSettings: event.mysqlSettings));

    try {
      await _databaseRepository.connect(event.mysqlSettings);
      _showMessage(emit, 'Database connection successful');

      emit(state.copyWith(
        mysqlSettings: event.mysqlSettings,
      ));
    } on DatabaseConnectionException catch (e) {
      _showErrorMessage(emit, e.message);
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
    _mysqlStatusSubscription.cancel();
    return super.close();
  }
}
