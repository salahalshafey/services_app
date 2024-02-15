import 'dart:async';
import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get isNotConnected;
}

class MyNetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('www.google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  @override
  Future<bool> get isNotConnected async => !(await isConnected);
}
