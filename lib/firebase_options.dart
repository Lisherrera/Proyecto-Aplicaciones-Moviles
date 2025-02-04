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
        return macos;
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
    apiKey: 'AIzaSyBK4IzbNV7Xv1rlKORS06TihccRA5ONT4k',
    appId: '1:36239158079:web:588743294a50802796818a',
    messagingSenderId: '36239158079',
    projectId: 'recetas-bcea9',
    authDomain: 'recetas-bcea9.firebaseapp.com',
    storageBucket: 'recetas-bcea9.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnksJ38yk5qGAnJJY1yz-L4h_d8QWmV2M',
    appId: '1:36239158079:android:fa2d1e05ea18982596818a',
    messagingSenderId: '36239158079',
    projectId: 'recetas-bcea9',
    storageBucket: 'recetas-bcea9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBokrs58_KG7BZouFKpl2fCKwUJgZpcZbI',
    appId: '1:36239158079:ios:cf0dc65a5e28a53396818a',
    messagingSenderId: '36239158079',
    projectId: 'recetas-bcea9',
    storageBucket: 'recetas-bcea9.firebasestorage.app',
    iosBundleId: 'com.example.proyectoFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBokrs58_KG7BZouFKpl2fCKwUJgZpcZbI',
    appId: '1:36239158079:ios:cf0dc65a5e28a53396818a',
    messagingSenderId: '36239158079',
    projectId: 'recetas-bcea9',
    storageBucket: 'recetas-bcea9.firebasestorage.app',
    iosBundleId: 'com.example.proyectoFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBK4IzbNV7Xv1rlKORS06TihccRA5ONT4k',
    appId: '1:36239158079:web:7fa9b19ef91496fc96818a',
    messagingSenderId: '36239158079',
    projectId: 'recetas-bcea9',
    authDomain: 'recetas-bcea9.firebaseapp.com',
    storageBucket: 'recetas-bcea9.firebasestorage.app',
  );
}
