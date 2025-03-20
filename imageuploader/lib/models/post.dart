// ignore_for_file: public_member_api_docs, sort_constructors_first

class Post {
  final int id;
  final String imageUrl;
  final String comment;
  final DateTime timestamp;
  Post({
    required this.id,
    required this.imageUrl,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image_url': imageUrl,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? 0,
      imageUrl: map['image_url'] ?? '',
      comment: map['comment'] ?? '',
      timestamp: map['timestamp'] == null
          ? DateTime.now()
          : DateTime.parse(map['timestamp']),
    );
  }
}
