import 'author.dart';

class Post {
  final int id;
  final String? title;
  final String body;
  final Author author;
  final dynamic image;
  final String createdAt; // Change this to String
  final int commentsCount;

  Post({
    required this.id,
    this.title,
    required this.body,
    required this.author,
    this.image,
    required this.createdAt,
    required this.commentsCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      author: Author.fromJson(json['author']),
      image: json['image'],
      createdAt: json['created_at'], // Store as String
      commentsCount: json['comments_count'],
    );
  }

  String? get imageUrl {
    if (image is String) {
      return image;
    } else if (image is Map<String, dynamic>) {
      return image['url'] as String?;
    }
    return null;
  }

  DateTime? get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      print('Error parsing date: $createdAt');
      return null;
    }
  }
}