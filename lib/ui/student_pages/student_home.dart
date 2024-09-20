import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return; // If location services are not enabled, handle this case (e.g., show a message)
    }

    // Check and request permission for location access
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return; // Permission denied, handle appropriately
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case where permission is permanently denied
      return;
    }

    // Subscribe to position updates
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Update only when the user moves by 1meter
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 100),
          const SizedBox(height: 20),
          const Text(
            'Welcome, Student',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          _currentPosition != null
              ? Column(
                  children: [
                    Text(
                      'Longitude: ${_currentPosition?.longitude ?? "Loading..."}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Latitude: ${_currentPosition?.latitude ?? "Loading..."}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
