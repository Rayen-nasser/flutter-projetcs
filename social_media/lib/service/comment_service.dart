import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/comment.dart';
import '../model/post.dart';

class CommentService {
  Future<List<Comment>> fetchCommentsByPost({required int postId}) async {
    final String apiUrl = "https://tarmeezacademy.com/api/v1/posts/$postId";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);

        if (body.containsKey('data')) {
          List<dynamic> commentJson = body['data']['comments'];
          return commentJson.map((item) {
            try {
              return Comment.fromJson(item);
            } catch (e) {
              print('Error parsing post: $e');
              print('Comment data: $item');
              rethrow;
            }
          }).toList();
        } else {
          throw Exception("Invalid JSON structure: 'data' key not found or not a list");
        }
      } else {
        throw Exception("Failed to load posts. Status code: ${response.statusCode}");
      }
    } on FormatException catch (e) {
      print('Error parsing JSON: $e');
      throw Exception("Failed to parse posts data");
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception("Failed to load posts: $e");
    }
  }
}
