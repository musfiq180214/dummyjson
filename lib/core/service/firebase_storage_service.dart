import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    final ref = _storage
        .ref()
        .child('posts')
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }
}
