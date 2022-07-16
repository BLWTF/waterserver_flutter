class CouldNotConnectToDBException implements Exception {
  final String? message;

  CouldNotConnectToDBException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Could Not Connect To DB Exception";
    return "Could Not Connect To DB Exception: $message";
  }
}

class DatabaseSettingsNotProvided implements Exception {}
