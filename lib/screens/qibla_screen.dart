import 'dart:math' show pi;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    super.dispose();
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled) {
      _locationStreamController.sink.add(locationStatus);
    } else {
      await _showLocationPermissionDialog();
    }
  }

  Future<void> _showLocationPermissionDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Service Required'),
        content: const Text(
          'Please enable location services and grant permission to determine the Qibla direction.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            child: const Text('OPEN SETTINGS'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInstructions,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkLocationStatus,
          ),
        ],
      ),
      body: StreamBuilder<LocationStatus>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.data?.enabled == false) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_off,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Location services are disabled',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _checkLocationStatus,
                    child: const Text('Enable Location'),
                  ),
                ],
              ),
            );
          }

          return StreamBuilder<QiblahDirection>(
            stream: FlutterQiblah.qiblahStream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final qiblahDirection = snapshot.data;
              var angle = ((qiblahDirection?.qiblah ?? 0) * (pi / 180) * -1);

              return Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Qibla is ${qiblahDirection?.direction.toStringAsFixed(1)}° ${_getDirectionText(qiblahDirection?.direction ?? 0)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  // Removed accuracy display as QiblahDirection does not have accuracy
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/compass_background.png',
                            fit: BoxFit.contain,
                          ),
                          Transform.rotate(
                            angle: angle,
                            child: Image.asset(
                              'assets/images/compass_needle.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Move your phone in a figure-8 pattern to calibrate the compass',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _getDirectionText(double direction) {
    if (direction >= 337.5 || direction < 22.5) return 'N';
    if (direction >= 22.5 && direction < 67.5) return 'NE';
    if (direction >= 67.5 && direction < 112.5) return 'E';
    if (direction >= 112.5 && direction < 157.5) return 'SE';
    if (direction >= 157.5 && direction < 202.5) return 'S';
    if (direction >= 202.5 && direction < 247.5) return 'SW';
    if (direction >= 247.5 && direction < 292.5) return 'W';
    return 'NW';
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use the Qibla Compass'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Hold your phone flat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Keep your phone parallel to the ground'),
              SizedBox(height: 8),
              Text(
                '2. Calibrate the compass',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Move your phone in a figure-8 pattern'),
              SizedBox(height: 8),
              Text(
                '3. Find the Qibla',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('The arrow will point towards the Qibla'),
              SizedBox(height: 8),
              Text(
                '4. Accuracy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Green: Excellent (≤5°)\nOrange: Good (≤10°)\nRed: Poor (>10°)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('GOT IT'),
          ),
        ],
      ),
    );
  }
}
