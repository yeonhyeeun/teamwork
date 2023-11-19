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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCg4VH2g17hbJgzew_6lyC6F_PpwXVPKEk',
    appId: '1:179683281529:web:9bb9abcfcda0584d1322a8',
    messagingSenderId: '179683281529',
    projectId: 'study-joy',
    authDomain: 'study-joy.firebaseapp.com',
    storageBucket: 'study-joy.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEnGWPigD_ZFWC8tn4123niuxLE3ojqgA',
    appId: '1:179683281529:android:f8ef9acd288fd7571322a8',
    messagingSenderId: '179683281529',
    projectId: 'study-joy',
    storageBucket: 'study-joy.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlT5cZsqYXyM-Wblr1F-Egpbuxi2JDO4Y',
    appId: '1:179683281529:ios:517718f53c5a76a81322a8',
    messagingSenderId: '179683281529',
    projectId: 'study-joy',
    storageBucket: 'study-joy.appspot.com',
    androidClientId: '179683281529-hbiknmh1apn3u45lhnub51rmb3s1en13.apps.googleusercontent.com',
    iosClientId: '179683281529-ci0uaiepp5tuvc11qnse7o3jii8r8h57.apps.googleusercontent.com',
    iosBundleId: 'com.example.teamwork',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAlT5cZsqYXyM-Wblr1F-Egpbuxi2JDO4Y',
    appId: '1:179683281529:ios:e5ef5d305bebd9181322a8',
    messagingSenderId: '179683281529',
    projectId: 'study-joy',
    storageBucket: 'study-joy.appspot.com',
    androidClientId: '179683281529-hbiknmh1apn3u45lhnub51rmb3s1en13.apps.googleusercontent.com',
    iosClientId: '179683281529-lim1e222vbast21m0ht3mlkl45ur478q.apps.googleusercontent.com',
    iosBundleId: 'com.example.teamwork.RunnerTests',
  );
}
