// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAv7bHWs9dFLT8CXID_ol1J9scGLSoTmjY',
    appId: '1:670476272291:android:bf677d2ffd38af23eff516',
    messagingSenderId: '670476272291',
    projectId: 'sigma-f8312',
    storageBucket: 'sigma-f8312.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEFdyZaPqQqstjoupmUhyUXmQErRMtv_Y',
    appId: '1:670476272291:ios:d1fc233423182adfeff516',
    messagingSenderId: '670476272291',
    projectId: 'sigma-f8312',
    storageBucket: 'sigma-f8312.appspot.com',
    androidClientId: '670476272291-cqejgpnlj61n3cour8eufqt9ohjq1gr8.apps.googleusercontent.com',
    iosClientId: '670476272291-8aci2kt6s0nq7n76lg5lou1rnvsltk0q.apps.googleusercontent.com',
    iosBundleId: 'com.sigma.app',
  );
}
