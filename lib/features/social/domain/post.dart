import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String text;
  final String imageUrl;
  final String videoUrl;
  final DateTime createdAt;
  final int likes;
  final List<String> comments;

  Post({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.videoUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = map['createdAt'];

    return Post(
      id: id,
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      likes: map['likes'] ?? 0,
      comments: List<String>.from(map['comments'] ?? []),
      createdAt: timestamp != null
          ? (timestamp is Timestamp
                ? timestamp.toDate()
                : DateTime.tryParse(timestamp.toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
