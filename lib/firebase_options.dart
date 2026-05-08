import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no soportado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCgmkx-oftDK9AfGijRI9llP1V0_6YiOAo',
    appId: '1:369143246314:web:a74944f58d00fe2a0a1693',
    messagingSenderId: '369143246314',
    projectId: 'bdcrudfloreria',
    authDomain: 'bdcrudfloreria.firebaseapp.com',
    storageBucket: 'bdcrudfloreria.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgmkx-oftDK9AfGijRI9llP1V0_6YiOAo',
    appId: '1:369143246314:android:tu_app_id',
    messagingSenderId: '369143246314',
    projectId: 'bdcrudfloreria',
    storageBucket: 'bdcrudfloreria.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgmkx-oftDK9AfGijRI9llP1V0_6YiOAo',
    appId: '1:369143246314:ios:tu_app_id',
    messagingSenderId: '369143246314',
    projectId: 'bdcrudfloreria',
    storageBucket: 'bdcrudfloreria.firebasestorage.app',
    iosBundleId: 'com.example.floreriaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCgmkx-oftDK9AfGijRI9llP1V0_6YiOAo',
    appId: '1:369143246314:web:a74944f58d00fe2a0a1693',
    messagingSenderId: '369143246314',
    projectId: 'bdcrudfloreria',
    authDomain: 'bdcrudfloreria.firebaseapp.com',
    storageBucket: 'bdcrudfloreria.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgmkx-oftDK9AfGijRI9llP1V0_6YiOAo',
    appId: '1:369143246314:ios:tu_app_id',
    messagingSenderId: '369143246314',
    projectId: 'bdcrudfloreria',
    storageBucket: 'bdcrudfloreria.firebasestorage.app',
    iosBundleId: 'com.example.floreriaApp',
  );
}