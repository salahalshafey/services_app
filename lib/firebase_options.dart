// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtymv7dqTa6cqt96IoBasNaVxQSjoLXHA',
    appId: '1:711179067079:web:7bcef5104c979c670628e2',
    messagingSenderId: '711179067079',
    projectId: 'servicesapp-e006f',
    authDomain: 'servicesapp-e006f.firebaseapp.com',
    storageBucket: 'servicesapp-e006f.appspot.com',
    measurementId: 'G-HHV16MGTRZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUu3Ngv7O4BmRpJTWVpFYMpgMeNnUtSjY',
    appId: '1:711179067079:android:41216a435ffb57680628e2',
    messagingSenderId: '711179067079',
    projectId: 'servicesapp-e006f',
    storageBucket: 'servicesapp-e006f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUAhObGprofP6K_ojzAjTSGO9X87sWwms',
    appId: '1:711179067079:ios:a1cab266e9b003dd0628e2',
    messagingSenderId: '711179067079',
    projectId: 'servicesapp-e006f',
    storageBucket: 'servicesapp-e006f.appspot.com',
    iosBundleId: 'com.salahalshafey.servicesapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCtymv7dqTa6cqt96IoBasNaVxQSjoLXHA',
    appId: '1:711179067079:web:f02eac75cf01bf720628e2',
    messagingSenderId: '711179067079',
    projectId: 'servicesapp-e006f',
    authDomain: 'servicesapp-e006f.firebaseapp.com',
    storageBucket: 'servicesapp-e006f.appspot.com',
    measurementId: 'G-184HQMVZGP',
  );
}
