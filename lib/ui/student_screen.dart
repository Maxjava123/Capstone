import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_pages/student_home.dart';
import 'student_pages/student_profile.dart';
import 'student_pages/student_messages.dart';
import 'student_pages/student_more.dart';
import 'student_pages/custom_navbar.dart'; // Adjust the import as per your file structure

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const StudentHomePage(),
    const StudentProfilePage(),
    const StudentMessagesPage(),
    const StudentMorePage(),
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
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _signOut(context),
        child: const Icon(Icons.logout),
        tooltip: 'Sign Out',
      ),
    );
  }
}
