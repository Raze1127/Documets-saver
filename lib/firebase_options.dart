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
    apiKey: 'AIzaSyAij9abus35-ssIJtk69BMHYEfTRdAiAsU',
    appId: '1:948194303133:web:803cf96a86a5613da90874',
    messagingSenderId: '948194303133',
    projectId: 'weedydocs',
    authDomain: 'weedydocs.firebaseapp.com',
    databaseURL: 'https://weedydocs-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'weedydocs.appspot.com',
    measurementId: 'G-G6GLWW1RKX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXvTTxp3uNDDm_Uv6VQtFjVFnlflCqoZA',
    appId: '1:948194303133:android:8c6768a852dc9df9a90874',
    messagingSenderId: '948194303133',
    projectId: 'weedydocs',
    databaseURL: 'https://weedydocs-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'weedydocs.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8nbWFO_30u89pEwAGadQ5i3MZRkPSwQQ',
    appId: '1:948194303133:ios:5396e5e522ffb45aa90874',
    messagingSenderId: '948194303133',
    projectId: 'weedydocs',
    databaseURL: 'https://weedydocs-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'weedydocs.appspot.com',
    androidClientId: '948194303133-uvu5b9nus8rh6snpudj599r5kt8ofaii.apps.googleusercontent.com',
    iosClientId: '948194303133-q72524u8o57i6lms4gl7jr8avjqglvkp.apps.googleusercontent.com',
    iosBundleId: 'com.example.weedydocs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8nbWFO_30u89pEwAGadQ5i3MZRkPSwQQ',
    appId: '1:948194303133:ios:5396e5e522ffb45aa90874',
    messagingSenderId: '948194303133',
    projectId: 'weedydocs',
    databaseURL: 'https://weedydocs-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'weedydocs.appspot.com',
    androidClientId: '948194303133-uvu5b9nus8rh6snpudj599r5kt8ofaii.apps.googleusercontent.com',
    iosClientId: '948194303133-q72524u8o57i6lms4gl7jr8avjqglvkp.apps.googleusercontent.com',
    iosBundleId: 'com.example.weedydocs',
  );
}