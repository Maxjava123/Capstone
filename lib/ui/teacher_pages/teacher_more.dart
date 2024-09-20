import 'package:flutter/material.dart';

class TeacherMorePage extends StatelessWidget {
  const TeacherMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: const Center(
        child: Text('More Page'),
      ),
    );
  }
}
