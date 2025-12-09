import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/landmark.dart';
import '../providers/landmark_provider.dart';
import '../widgets/landmark_bottom_sheet.dart';

class MapOverviewScreen extends StatefulWidget {
  const MapOverviewScreen({super.key});

  @override
  State<MapOverviewScreen> createState() => _MapOverviewScreenState();
}

class _MapOverviewScreenState extends State<MapOverviewScreen> {
  final MapController _mapController = MapController();
  final LatLng _bangladeshCenter = const LatLng(23.6850, 90.3563);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LandmarkProvider>().loadLandmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landmark Overview'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<LandmarkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.landmarks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.landmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading landmarks',
                    style: TextStyle(fontSize: 18, color: Colors.red[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error ?? 'Unknown error',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadLandmarks(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _bangladeshCenter,
                  initialZoom: 7.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.midterm_app',
                  ),
                  MarkerLayer(
                    markers: provider.landmarks
                        .where((landmark) => landmark.hasValidCoordinates)
                        .map((landmark) {
                      return Marker(
                        point: LatLng(landmark.lat!, landmark.lon!),
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            _showLandmarkDetails(context, landmark);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    _mapController.move(_bangladeshCenter, 7.0);
                  },
                  child: const Icon(Icons.my_location),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[700],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLandmarkDetails(BuildContext context, Landmark landmark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LandmarkBottomSheet(landmark: landmark),
    );
  }
}

