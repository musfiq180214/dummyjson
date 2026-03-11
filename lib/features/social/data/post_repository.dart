import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/social/domain/post.dart';
import 'package:flutter/foundation.dart';

abstract class IPostRepository {
  Future<void> createPost({required String text});
  Stream<List<Post>> getPosts();

  Future<void> likePost(String postId);
  Future<void> addComment(String postId, String comment);
}

class PostRepository implements IPostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// CREATE POST
  @override
  Future<void> createPost({
    required String text,
    String imageUrl = '',
    String videoUrl = '',
  }) async {
    final collection = 'posts';
    final postData = {
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': 0,
      'comments': [],
    };

    if (kDebugMode) {
      final logBuffer = StringBuffer()
        ..writeln('🔹 FIRESTORE REQUEST → CREATE POST')
        ..writeln('Request URL: firestore://$collection')
        ..writeln('Query Params: None')
        ..writeln('Headers: None (Firestore SDK manages)')
        ..writeln('Body: ${_prettifyJson(postData)}');
      AppLogger.i(logBuffer.toString());
    }

    try {
      await _firestore.collection(collection).add(postData);

      if (kDebugMode) {
        AppLogger.d('RESPONSE ← Post successfully created');
      }
    } catch (e, st) {
      if (kDebugMode) {
        final logBuffer = StringBuffer()
          ..writeln('ERROR ← Failed to create post')
          ..writeln('Message: $e')
          ..writeln('StackTrace: $st');
        AppLogger.e(logBuffer.toString());
      }
      rethrow;
    }
  }

  /// GET POSTS
  @override
  Stream<List<Post>> getPosts() {
    final collection = 'posts';
    final queryParams = {'orderBy': 'createdAt', 'descending': 'true'};
    final requestUrl =
        'firestore://$collection?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';

    if (kDebugMode) {
      final logBuffer = StringBuffer()
        ..writeln('🔹 FIRESTORE REQUEST → GET POSTS (real-time)')
        ..writeln('Request URL: $requestUrl')
        ..writeln('Query Params:');
      queryParams.forEach((key, value) {
        logBuffer.writeln('  $key: $value');
      });
      logBuffer.writeln('Headers: None (Firestore SDK manages)');
      AppLogger.i(logBuffer.toString());
    }

    return _firestore
        .collection(collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final posts = snapshot.docs
              .map((doc) => Post.fromMap(doc.data(), doc.id))
              .toList();

          if (kDebugMode) {
            final logBuffer = StringBuffer()
              ..writeln('🐛 RESPONSE ← ${posts.length} posts received')
              ..writeln(
                'Data: ${_prettifyJson(posts.map((e) => e.toJson()).toList())}',
              );
            AppLogger.d(logBuffer.toString());
          }

          return posts;
        })
        .handleError((e, st) {
          if (kDebugMode) {
            final logBuffer = StringBuffer()
              ..writeln('ERROR ← Failed to fetch posts')
              ..writeln('Message: $e')
              ..writeln('StackTrace: $st');
            AppLogger.e(logBuffer.toString());
          }
        });
  }

  @override
  Future<void> likePost(String postId) async {
    final docRef = _firestore.collection('posts').doc(postId);

    await docRef.update({'likes': FieldValue.increment(1)});
  }

  @override
  Future<void> addComment(String postId, String comment) async {
    final docRef = _firestore.collection('posts').doc(postId);

    await docRef.update({
      'comments': FieldValue.arrayUnion([comment]),
    });
  }
}

/// Pretty-print JSON
String _prettifyJson(dynamic data) {
  try {
    final jsonData = data is String ? jsonDecode(data) : data;
    return const JsonEncoder.withIndent('  ').convert(jsonData);
  } catch (_) {
    return data.toString();
  }
}

/// Extension to convert Post to JSON
extension PostJson on Post {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
