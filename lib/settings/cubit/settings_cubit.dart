import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/application.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  late final StreamSubscription<MysqlSettings> _mysqlSettingsSubscription;

  SettingsCubit({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(const SettingsState(page: SettingsPage.main)) {
    // _mysqlSettingsSubscription = _settingsRepository.mysqlSettings.listen(
    //   (mysqlSettings) {
    // print('ohhhh');
    // emit(
    //   state.copyWith(
    //     mysqlSettingsFormState:
    //         MysqlSettingsFormState.fromModel(mysqlSettings),
    //   ),
    // );
    //   },
    // );
  }

  void initMysqlSettingsFormState(MysqlSettings mysqlSettings) {
    emit(
      state.copyWith(
        mysqlSettingsFormState: MysqlSettingsFormState.fromModel(mysqlSettings),
      ),
    );
  }

  void mysqlSettingsChanged() {
    final MysqlSettings mysqlSettings = MysqlSettings(
      database: state.mysqlSettingsFormState!.database.value,
      host: state.mysqlSettingsFormState!.host.value,
      user: state.mysqlSettingsFormState!.user.value,
      port: int.parse(state.mysqlSettingsFormState!.port.value),
      password: state.mysqlSettingsFormState!.password.value,
    );
    _settingsRepository.saveMysqlSettings(mysqlSettings);
  }

  void pageChanged(SettingsPage page) {
    emit(state.copyWith(page: page));
  }

  void hostUpdated(String value) {
    final host = Host.dirty(value);

    final newSettingsState = state.mysqlSettingsFormState == null
        ? MysqlSettingsFormState(host: host)
        : state.mysqlSettingsFormState!.copyWith(host: host);

    emit(state.copyWith(mysqlSettingsFormState: newSettingsState));
  }

  void portUpdated(String value) {
    final port = Port.dirty(value);

    final newSettingsState = state.mysqlSettingsFormState == null
        ? MysqlSettingsFormState(port: port)
        : state.mysqlSettingsFormState!.copyWith(port: port);

    emit(state.copyWith(mysqlSettingsFormState: newSettingsState));
  }

  void userUpdated(String value) {
    final user = User.dirty(value);

    final newSettingsState = state.mysqlSettingsFormState == null
        ? MysqlSettingsFormState(user: user)
        : state.mysqlSettingsFormState!.copyWith(user: user);

    emit(state.copyWith(mysqlSettingsFormState: newSettingsState));
  }

  void passwordUpdated(String value) {
    final password = Password.dirty(value);

    final newSettingsState = state.mysqlSettingsFormState == null
        ? MysqlSettingsFormState(password: password)
        : state.mysqlSettingsFormState!.copyWith(password: password);

    emit(state.copyWith(mysqlSettingsFormState: newSettingsState));
  }

  void databaseUpdated(String value) {
    final database = Database.dirty(value);

    final newSettingsState = state.mysqlSettingsFormState == null
        ? MysqlSettingsFormState(database: database)
        : state.mysqlSettingsFormState!.copyWith(database: database);

    emit(state.copyWith(mysqlSettingsFormState: newSettingsState));
  }

  Future<void> checkForUpdates() async {
    emit(state.copyWith(
        status: HomeStatus.loading, message: 'Checking for new updates...'));

    try {
      final jsonVal = await _loadJsonFromGithub();

      emit(state.copyWith(appLatestVersionInfo: jsonVal));

      _clearStatus();

      return;
    } on http.ClientException catch (e) {
      _clearStatus();

      _showError(e.message);
    } on SocketException catch (_) {
      _clearStatus();

      _showError('No internet connection.');
    }
  }

  Future<void> downloadNewVersion(String appPath) async {
    emit(state.copyWith(
      status: HomeStatus.loading,
      message: 'Downloading update, please wait.',
    ));

    final fileName = appPath.split("/").last;

    final dio = Dio();

    final downloadedFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/$fileName';

    await dio.download(
      '$gitFolderUri/$appPath',
      downloadedFilePath,
      // onReceiveProgress: (received, total) {
      //   final progress = (received / total) * 100;
      //   emit(state.copyWith(progress: progress));
      // },
    );

    emit(state.copyWith(
        status: HomeStatus.loading, message: 'Installing new version'));

    await _openExeFile(downloadedFilePath);

    _clearStatus();
  }

  Future<Map<String, dynamic>> _loadJsonFromGithub() async {
    final response = await http.read(Uri.parse(gitVersionFile));
    return jsonDecode(response);
  }

  Future<void> _openExeFile(String filePath) async {
    await Process.start(filePath, ["-t", "-l", "1000"]).then((value) {});
  }

  void _clearStatus() {
    emit(state.copyWith(status: HomeStatus.clear));

    emit(state.copyWith(status: HomeStatus.normal));
  }

  void _showError(String? message) {
    emit(state.copyWith(
      status: HomeStatus.error,
      message: message,
    ));

    emit(state.copyWith(status: HomeStatus.normal));
  }
}
