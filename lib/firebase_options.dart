import 'package:firebase_core/firebase_core.dart';
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

  // Method to initialize Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDcRznH8N3k7-jYPi7fR48TZjIv4EHJLvk',
    appId: '1:143258043100:web:a4a6a8476dc4c39c9fea19',
    messagingSenderId: '143258043100',
    projectId: 'capstoneproject-70223',
    authDomain: 'capstoneproject-70223.firebaseapp.com',
    storageBucket: 'capstoneproject-70223.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaUvuw4pNDL7Eqbu01YHgWEwk8MO77-GM',
    appId: '1:143258043100:android:031ce86a1f0c7b5c9fea19',
    messagingSenderId: '143258043100',
    projectId: 'capstoneproject-70223',
    storageBucket: 'capstoneproject-70223.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsLGTVTJE-egNnYwtWFduU7Wusm_kLaRM',
    appId: '1:143258043100:ios:c304275cebb5ad909fea19',
    messagingSenderId: '143258043100',
    projectId: 'capstoneproject-70223',
    storageBucket: 'capstoneproject-70223.appspot.com',
    iosBundleId: 'com.example.capstone1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDsLGTVTJE-egNnYwtWFduU7Wusm_kLaRM',
    appId: '1:143258043100:ios:c304275cebb5ad909fea19',
    messagingSenderId: '143258043100',
    projectId: 'capstoneproject-70223',
    storageBucket: 'capstoneproject-70223.appspot.com',
    iosBundleId: 'com.example.capstone1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcRznH8N3k7-jYPi7fR48TZjIv4EHJLvk',
    appId: '1:143258043100:web:6a57827d7212b1f79fea19',
    messagingSenderId: '143258043100',
    projectId: 'capstoneproject-70223',
    authDomain: 'capstoneproject-70223.firebaseapp.com',
    storageBucket: 'capstoneproject-70223.appspot.com',
  );
}
