import 'package:flutter/foundation.dart';
import '../models/landmark.dart';
import '../services/api_service.dart';

class LandmarkProvider with ChangeNotifier {
  List<Landmark> _landmarks = [];
  bool _isLoading = false;
  String? _error;

  List<Landmark> get landmarks => _landmarks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLandmarks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _landmarks = await ApiService.getLandmarks();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _landmarks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLandmark({
    required String title,
    required double lat,
    required double lon,
    required dynamic imageFile,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.createLandmark(
        title: title,
        lat: lat,
        lon: lon,
        imageFile: imageFile,
      );
      await loadLandmarks(); // Reload to get the new landmark with ID
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLandmark({
    required int id,
    required String title,
    required double lat,
    required double lon,
    dynamic imageFile,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.updateLandmark(
        id: id,
        title: title,
        lat: lat,
        lon: lon,
        imageFile: imageFile,
      );
      await loadLandmarks(); // Reload to get updated data
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLandmark(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.deleteLandmark(id);
      _landmarks.removeWhere((landmark) => landmark.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

