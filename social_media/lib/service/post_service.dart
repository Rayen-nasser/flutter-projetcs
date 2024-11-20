import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/post.dart';

class PostService {
  Future<List<Post>> fetchPosts({required int page}) async {
    final String apiUrl = "https://tarmeezacademy.com/api/v1/posts?page=$page&limit=5";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);

        if (body.containsKey('data') && body['data'] is List) {
          List<dynamic> postsJson = body['data'];
          return postsJson.map((item) {
            try {
              return Post.fromJson(item);
            } catch (e) {
              print('Error parsing post: $e');
              print('Post data: $item');
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
