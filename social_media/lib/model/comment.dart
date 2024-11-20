import 'package:uuid/uuid.dart';

import 'author.dart';

class Comment {
  final int id;
  final String body;
  final Author author;

  Comment({
    required this.body,
    required this.author,
    required this.id
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      body: json['body'],
      author: Author.fromJson(json['author']),
    );
  }
}
