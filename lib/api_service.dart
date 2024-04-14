import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Post {
  final String image; // Assuming you will send the image data as a base64 encoded string
  final String context;

  Post({required this.image, required this.context});

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'context': context,
    };
  }

  Future<XFile?> compressAndEncodeImage(File imageFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg', // Output path
        quality: 70, // Compression quality (0 - 100)
      );
      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      throw e; // Throw the error instead of returning the original file
    }
  }

  Future<void> postData(Post post) async {
    try {
      // Replace 'your-api-url' with your actual API endpoint URL
      var apiUrl = Uri.parse('https://anonymaskedcoder.pythonanywhere.com/upload');
      
      // Convert Post object to JSON
      var requestBody = jsonEncode(post.toJson());

      // Make POST request
      var response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      // Check response status
      if (response.statusCode == 200) {
        print('Post successful');
      } else {
        print('Failed to post data: ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      print('Error parsing JSON: $e');
      throw e; // Throw the error for further handling
    } on http.ClientException catch (e) {
      print('HTTP request failed: $e');
      throw e; // Throw the error for further handling
    } catch (e) {
      print('Unexpected error: $e');
      throw e; // Throw the error for further handling
    }
  }
}
