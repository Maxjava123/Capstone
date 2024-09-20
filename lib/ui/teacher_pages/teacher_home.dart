import 'package:flutter/material.dart';

class TeacherHome extends StatelessWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 100),
          SizedBox(height: 20),
          Text('Welcome, Teacher', style: TextStyle(fontSize: 24)),
          // Add Teacher-specific actions here
        ],
      ),
    );
  }
}
