import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'parent_pages/parent_home.dart';
import 'parent_pages/parent_messages.dart';
import 'parent_pages/parent_more.dart';
import 'parent_pages/parent_profile.dart';
import 'student_pages/custom_navbar.dart'; // Adjust the path accordingly

class ParentScreen extends StatefulWidget {
  const ParentScreen({Key? key}) : super(key: key);

  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ParentHomePage(),
    const ParentProfilePage(),
    const ParentMessagesPage(),
    const ParentMorePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully.');
      _showPopup(context, 'Signed out successfully!', isSuccess: true);
    } catch (e) {
      print('Sign out error: $e');
      _showPopup(context, 'Sign out failed. Please try again.',
          isSuccess: false);
    }
  }

  void _showPopup(BuildContext context, String message,
      {bool isSuccess = true}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacementNamed(context, '/welcome');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _pages[_currentIndex], // Display the current page based on the index
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // Update the index when a new tab is selected
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _signOut(context),
        child: const Icon(Icons.logout),
        tooltip: 'Sign Out',
      ),
    );
  }
}
