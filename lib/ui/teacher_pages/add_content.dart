import 'package:capstone_1/ui/teacher_pages/event_transaction/create_event.dart';
import 'package:flutter/material.dart';
// Import your CreateEventPage

class AddContentPage extends StatelessWidget {
  const AddContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Future.microtask to immediately navigate to CreateEventPage on build
    Future.microtask(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CreateEventPage()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Content'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
