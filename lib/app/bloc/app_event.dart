part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppChangedMysqlSettings extends AppEvent {
  final MysqlSettings mysqlSettings;

  const AppChangedMysqlSettings(this.mysqlSettings);

  @override
  List<Object?> get props => [mysqlSettings];
}

class AppClearedMessages extends AppEvent {}
