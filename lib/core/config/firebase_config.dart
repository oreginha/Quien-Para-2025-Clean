import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    // Enable offline persistence for Firestore using the recommended approach
    FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Configure Firebase Storage caching
    FirebaseStorage.instance.setMaxDownloadRetryTime(
      const Duration(minutes: 3),
    );
    FirebaseStorage.instance.setMaxUploadRetryTime(const Duration(minutes: 3));
  }
}
