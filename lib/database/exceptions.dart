abstract class DatabaseConnectionException {
  final String message;

  DatabaseConnectionException(this.message);
}

class CouldNotConnectToDBException implements DatabaseConnectionException {
  @override
  final String message;

  CouldNotConnectToDBException(
      [this.message = "Could Not Connect To DB Exception"]);

  @override
  String toString() {
    Object? message = this.message;
    return "Could Not Connect To DB Exception: $message";
  }
}

class DatabaseSettingsNotProvidedException
    implements DatabaseConnectionException {
  @override
  final String message = 'Database Settings Not Provided';

  DatabaseSettingsNotProvidedException();

  @override
  String toString() {
    return message;
  }
}

class DatabaseIsNotConnectedException implements Exception {
  final String message;

  DatabaseIsNotConnectedException([this.message = 'Database Is Not Connected']);

  @override
  String toString() {
    return message;
  }
}

class DatabaseAlreadyOpenException implements Exception {}
