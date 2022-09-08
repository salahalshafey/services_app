class InternetException implements Exception {
  InternetException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
