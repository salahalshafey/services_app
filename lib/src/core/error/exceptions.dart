class Error implements Exception {
  Error(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class ServerException implements Exception {}

class OfflineException implements Exception {}
