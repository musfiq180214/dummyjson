import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummyjson/features/social/domain/post.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// CREATE POST
  Future<void> createPost({
    required String text,
    String imageUrl = '',
    String videoUrl = '',
  }) async {
    await _firestore.collection('posts').add({
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// GET POSTS (Realtime)
  Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Post.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}
