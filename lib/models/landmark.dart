import '../utils/image_utils.dart';

class Landmark {
  final int id;
  final String title;
  final double? lat;
  final double? lon;
  final String image;

  Landmark({
    required this.id,
    required this.title,
    this.lat,
    this.lon,
    required this.image,
  });

  // Check if landmark has valid coordinates
  bool get hasValidCoordinates => lat != null && lon != null;

  factory Landmark.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'];

    // Parse lat/lon safely, handling empty strings and null values
    double? parseDouble(dynamic value) {
      if (value == null || value == '') return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      return double.tryParse(str);
    }

    return Landmark(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      lat: parseDouble(json['lat']),
      lon: parseDouble(json['lon']),
      image: ImageUtils.getImageUrl(imagePath ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'lat': lat, 'lon': lon, 'image': image};
  }

  Landmark copyWith({
    int? id,
    String? title,
    double? lat,
    double? lon,
    String? image,
  }) {
    return Landmark(
      id: id ?? this.id,
      title: title ?? this.title,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      image: image ?? this.image,
    );
  }
}
