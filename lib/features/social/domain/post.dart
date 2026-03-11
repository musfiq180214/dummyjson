class Post {
  final String id;
  final String text;
  final String imageUrl;
  final String videoUrl;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.videoUrl,
    required this.createdAt,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      createdAt: (map['createdAt']).toDate(),
    );
  }
}
