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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
 }

 static const FirebaseOptions web = FirebaseOptions(
   apiKey: 'AIzaSyB0VbTsd0AWUca_baNzcrFNRGWeP9aiFW0',
   appId: '1:1012744146509:android:94db71dba9bfa18c46d604',
   messagingSenderId: '1012744146509',
   projectId: 'g21097717',
   authDomain: 'flutterfire-ui-codelab.firebaseapp.com',
   storageBucket: 'flutterfire-ui-codelab.appspot.com',
   measurementId: 'G-DGF0CP099H',
 );

 static const FirebaseOptions android = FirebaseOptions(
   apiKey: 'AIzaSyB0VbTsd0AWUca_baNzcrFNRGWeP9aiFW0',
   appId: '1:1012744146509:android:94db71dba9bfa18c46d604',
   messagingSenderId: '1012744146509',
   projectId: 'g21097717',
   storageBucket: 'flutterfire-ui-codelab.appspot.com',
 );

 static const FirebaseOptions ios = FirebaseOptions(
   apiKey: 'AIzaSyB0VbTsd0AWUca_baNzcrFNRGWeP9aiFW0',
   appId: '1:1012744146509:android:94db71dba9bfa18c46d604',
   messagingSenderId: '1012744146509',
   projectId: 'g21097717',
   storageBucket: 'flutterfire-ui-codelab.appspot.com',
   iosClientId: '963656261848-v7r3vq1v6haupv0l1mdrmsf56ktnua60.apps.googleusercontent.com',
   iosBundleId: 'com.example.complete',
 );

 static const FirebaseOptions macos = FirebaseOptions(
   apiKey: 'AIzaSyB0VbTsd0AWUca_baNzcrFNRGWeP9aiFW0',
   appId: '1:1012744146509:android:94db71dba9bfa18c46d604',
   messagingSenderId: '1012744146509',
   projectId: 'g21097717',
   storageBucket: 'flutterfire-ui-codelab.appspot.com',
   iosClientId: '963656261848-v7r3vq1v6haupv0l1mdrmsf56ktnua60.apps.googleusercontent.com',
   iosBundleId: 'com.example.complete',
 );
}