import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> shareLocation(LatLng location) async {
    String? email = _auth.currentUser?.email;
    if (email != null) {
      await _db.collection('locations').doc(email).set({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<DocumentSnapshot> getLocationUpdates() {
    String? email = _auth.currentUser?.email;
    if (email != null) {
      return _db.collection('locations').doc(email).snapshots();
    }
    throw Exception('User not logged in');
  }
}
