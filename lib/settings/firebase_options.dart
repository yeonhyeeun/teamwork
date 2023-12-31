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
    apiKey: 'AIzaSyDyK-JapzH-nExBL7PcTwjM-GZX5kTbhJ8',
    appId: '1:315108969937:web:74de5c38e1fdfa44e1e4f0',
    messagingSenderId: '315108969937',
    projectId: 'joystudy-97b83',
    authDomain: 'joystudy-97b83.firebaseapp.com',
    storageBucket: 'joystudy-97b83.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJ6HjpSgEsGnCWUv5NHSfBXtSt8lq_MRE',
    appId: '1:315108969937:android:47800c941ed5307ce1e4f0',
    messagingSenderId: '315108969937',
    projectId: 'joystudy-97b83',
    storageBucket: 'joystudy-97b83.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZRuajFHMgzTa3NvaDDp9q_Fwm8jMLkzo',
    appId: '1:315108969937:ios:32cca586b560a9b7e1e4f0',
    messagingSenderId: '315108969937',
    projectId: 'joystudy-97b83',
    storageBucket: 'joystudy-97b83.appspot.com',
    iosClientId: '315108969937-h4ai7v55kln5i2k8oku4fojutf1gb6s3.apps.googleusercontent.com',
    iosBundleId: 'com.example.teamwork',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZRuajFHMgzTa3NvaDDp9q_Fwm8jMLkzo',
    appId: '1:315108969937:ios:9d9d12c4d270eaf8e1e4f0',
    messagingSenderId: '315108969937',
    projectId: 'joystudy-97b83',
    storageBucket: 'joystudy-97b83.appspot.com',
    iosClientId: '315108969937-9t9jg3p4b812k52ss4c8uvcrrnp1jtj5.apps.googleusercontent.com',
    iosBundleId: 'com.example.teamwork.RunnerTests',
  );
}
