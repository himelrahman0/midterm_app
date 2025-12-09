import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import '../models/landmark.dart';

class ApiService {
  static const String baseUrl = 'https://labs.anontech.info/cse489/t3/api.php';

  // Get all landmarks
  static Future<List<Landmark>> getLandmarks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Landmark.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load landmarks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching landmarks: $e');
    }
  }

  // Create a new landmark
  static Future<Map<String, dynamic>> createLandmark({
    required String title,
    required double lat,
    required double lon,
    required File imageFile,
  }) async {
    try {
      // Resize image to 800x600
      final imageBytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }
      
      final resizedImage = img.copyResize(
        originalImage,
        width: 800,
        height: 600,
        interpolation: img.Interpolation.linear,
      );
      
      final resizedBytes = img.encodeJpg(resizedImage, quality: 85);

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields['title'] = title;
      request.fields['lat'] = lat.toString();
      request.fields['lon'] = lon.toString();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          resizedBytes,
          filename: 'landmark.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create landmark: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating landmark: $e');
    }
  }

  // Update an existing landmark
  static Future<Map<String, dynamic>> updateLandmark({
    required int id,
    required String title,
    required double lat,
    required double lon,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(baseUrl));
      request.fields['id'] = id.toString();
      request.fields['title'] = title;
      request.fields['lat'] = lat.toString();
      request.fields['lon'] = lon.toString();

      if (imageFile != null) {
        // Resize image to 800x600
        final imageBytes = await imageFile.readAsBytes();
        final originalImage = img.decodeImage(imageBytes);
        if (originalImage != null) {
          final resizedImage = img.copyResize(
            originalImage,
            width: 800,
            height: 600,
            interpolation: img.Interpolation.linear,
          );
          final resizedBytes = img.encodeJpg(resizedImage, quality: 85);
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              resizedBytes,
              filename: 'landmark.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update landmark: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating landmark: $e');
    }
  }

  // Delete a landmark
  static Future<void> deleteLandmark(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'id=$id',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete landmark: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting landmark: $e');
    }
  }
}

