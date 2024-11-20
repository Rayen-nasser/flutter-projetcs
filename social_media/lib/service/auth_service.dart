import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AuthService {


  Future<void> signup({required File? image, required String username, required String password}) async {
    final apiUrl = 'https://tarmeezacademy.com/api/v1/register'; // Replace with your API URL

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add text fields to the request
      request.fields['username'] = username;
      request.fields['password'] = password;

      // Add the image file to the request, if available
      if (image != null) {
        request.files.add(
          http.MultipartFile(
            'image', // The name of the field in the form data
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.uri.pathSegments.last,
            contentType: MediaType('image', 'jpeg'), // Adjust the content type as needed
          ),
        );
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        print('Redirecting to: $redirectUrl');
        // Handle redirection if needed
      } else if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Success: $responseData');
        // Handle success, e.g., show a success message
      } else {
        print('Failed: ${response.statusCode}');
        // Handle failure, e.g., show an error message
      }
    } catch (e) {
      print('Error: $e');
      // Handle any errors
    }
  }
  void _login({required username, required password}) async{

  }
}