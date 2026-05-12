import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyBy3enrNTuDQfTrviLHwnqsphcnwovQ7ho",
      authDomain: "vs6451071059.firebaseapp.com",
      databaseURL: "https://vs6451071059-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "vs6451071059",
      storageBucket: "vs6451071059.firebasestorage.app",
      messagingSenderId: "152096645156",
      appId: "1:152096645156:web:e91800877e5d423489b8b1",
      measurementId: "G-G8HBNL4L8J"
  );
}
