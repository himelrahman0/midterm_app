class ImageUtils {
  static const String baseImageUrl = 'https://labs.anontech.info/cse489/t3/';

  static String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    return baseImageUrl + imagePath.replaceFirst(RegExp(r'^/'), '');
  }
}

