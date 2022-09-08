import 'dart:async';
import 'dart:io';

class InternetService {
  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('www.google.com')
          .timeout(const Duration(seconds: 10));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }
}
