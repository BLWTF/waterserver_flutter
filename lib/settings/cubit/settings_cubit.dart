import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:waterserver/app/bloc/app_bloc.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/application.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> checkForUpdates() async {
    emit(state.copyWith(
        status: HomeStatus.loading, message: 'Checking for new updates...'));

    try {
      final jsonVal = await _loadJsonFromGithub();

      emit(state.copyWith(
          status: HomeStatus.clear, appLatestVersionInfo: jsonVal));

      return;
    } on http.ClientException catch (e) {
      emit(state.copyWith(status: HomeStatus.clear));

      emit(state.copyWith(
        status: HomeStatus.error,
        message: e.message,
      ));
    } on SocketException catch (_) {
      emit(state.copyWith(status: HomeStatus.clear));

      emit(state.copyWith(
        status: HomeStatus.error,
        message: 'No internet connection.',
      ));
    }
  }

  Future<Map<String, dynamic>> _loadJsonFromGithub() async {
    final response = await http.read(Uri.parse(gitVersionFile));
    return jsonDecode(response);
  }

  Future<void> _openExeFile(String filePath) async {
    await Process.start(filePath, ["-t", "-l", "1000"]).then((value) {});
  }

  Future<void> downloadNewVersion(String appPath) async {
    emit(state.copyWith(
      status: HomeStatus.progress,
      message: 'Downloading update',
      progress: 0,
    ));

    final fileName = appPath.split("/").last;

    final dio = Dio();

    final downloadedFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/$fileName';

    await dio.download(
      '$gitFolderUri/$appPath',
      downloadedFilePath,
      onReceiveProgress: (received, total) {
        final progress = (received / total) * 100;
        emit(state.copyWith(progress: progress));
      },
    );

    emit(state.copyWith(
        status: HomeStatus.loading, message: 'Installing new version'));

    await _openExeFile(downloadedFilePath);

    emit(state.copyWith(status: HomeStatus.clear));
  }
}
