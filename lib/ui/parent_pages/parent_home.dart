import 'package:flutter/material.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.family_restroom, size: 100),
          SizedBox(height: 20),
          Text('Welcome, Parent', style: TextStyle(fontSize: 24)),
          // Add Parent-specific actions here
        ],
      ),
    );
  }
}
