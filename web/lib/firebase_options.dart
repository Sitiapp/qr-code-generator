
/*
 * Copyright 2023 Nicola Pigozzo - www.sitiapp.it
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
      apiKey: 'YOUR-FIREBASE-CREDENTIALS',
      authDomain: 'YOUR-FIREBASE-CREDENTIALS',
      projectId: 'YOUR-FIREBASE-CREDENTIALS',
      storageBucket: 'YOUR-FIREBASE-CREDENTIALS',
      messagingSenderId: 'YOUR-FIREBASE-CREDENTIALS',
      appId: 'YOUR-FIREBASE-CREDENTIALS',
      measurementId: 'YOUR-FIREBASE-CREDENTIALS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR-FIREBASE-CREDENTIALS',
    appId: 'YOUR-FIREBASE-CREDENTIALS',
    messagingSenderId: 'YOUR-FIREBASE-CREDENTIALS',
    projectId: 'YOUR-FIREBASE-CREDENTIALS',
    storageBucket: 'YOUR-FIREBASE-CREDENTIALS',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-FIREBASE-CREDENTIALS',
    appId: 'YOUR-FIREBASE-CREDENTIALS',
    messagingSenderId: 'YOUR-FIREBASE-CREDENTIALS',
    projectId: 'YOUR-FIREBASE-CREDENTIALS',
    storageBucket: 'YOUR-FIREBASE-CREDENTIALS',
    iosClientId 'YOUR-FIREBASE-CREDENTIALS',
    iosBundleId: 'YOUR-FIREBASE-CREDENTIALS',,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey:'YOUR-FIREBASE-CREDENTIALS',
    appId:'YOUR-FIREBASE-CREDENTIALS',
    messagingSenderId:'YOUR-FIREBASE-CREDENTIALS',
    projectId:'YOUR-FIREBASE-CREDENTIALS',
    storageBucket:'YOUR-FIREBASE-CREDENTIALS',
    iosClientId'YOUR-FIREBASE-CREDENTIALS',
    iosBundleId: 'YOUR-FIREBASE-CREDENTIALS',
  );
}
