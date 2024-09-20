import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class StudentMessagesPage extends StatefulWidget {
  const StudentMessagesPage({Key? key}) : super(key: key);

  @override
  _StudentMessagesPageState createState() => _StudentMessagesPageState();
}

class _StudentMessagesPageState extends State<StudentMessagesPage> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Function to request location permissions
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _trackLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
    }
  }

  // Function to continuously track the student's location
  void _trackLocation() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Get the email of the current user
      final userEmail = currentUser.email;

      // Start tracking location
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Updates location every 10 meters
        ),
      ).listen((Position position) {
        // Store the user's location (latitude, longitude, and timestamp) in Firestore
        FirebaseFirestore.instance
            .collection('locations')
            .doc(userEmail) // Use email as document ID
            .set({
          'email': userEmail, // Store the email
          'latitude': position.latitude, // Store latitude
          'longitude': position.longitude, // Store longitude
          'timestamp': FieldValue.serverTimestamp(), // Store timestamp
        }, SetOptions(merge: true)).catchError((error) {
          print('Failed to update location: $error');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Sharing Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: currentUserId != null
            ? FirebaseFirestore.instance
                .collection('requests')
                .where('childAccountId', isEqualTo: currentUserId)
                .snapshots()
            : const Stream.empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests available.'));
          }

          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data() as Map<String, dynamic>;

              final parentName = request.containsKey('parentName')
                  ? request['parentName']
                  : 'N/A';
              final status =
                  request.containsKey('status') ? request['status'] : 'Pending';
              final timestamp = request.containsKey('timestamp')
                  ? (request['timestamp'] as Timestamp).toDate()
                  : DateTime.now();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Parent: $parentName'),
                  subtitle: Text(
                      'Status: $status\nRequested on: ${timestamp.toLocal()}'),
                  trailing: status == 'Pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                _handleRequest(
                                    context, requests[index].id, 'Accepted');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _handleRequest(
                                    context, requests[index].id, 'Declined');
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to handle request acceptance or rejection
  void _handleRequest(
      BuildContext context, String requestId, String status) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $status'),
          content: Text('Are you sure you want to $status this request?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .update({
          'status': status,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request $status')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update request: $e')),
        );
      }
    }
  }
}
