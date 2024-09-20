import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'teacher_pages/add_content.dart';
import 'teacher_pages/calendar.dart';
import 'teacher_pages/teacher_home.dart';
import 'teacher_pages/teacher_more.dart';
import 'teacher_pages/custom_navbar.dart'; // Import the custom bottom navigation bar

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  int _currentIndex = 1; // Default index for the Home page

  final List<Widget> _pages = [
    const CalendarPage(),
    const TeacherHome(),
    const AddContentPage(),
    const TeacherMorePage(),
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
      body: _pages[_currentIndex], // Display the current page
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
