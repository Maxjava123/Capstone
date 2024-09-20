import 'package:flutter/material.dart';

class ParentMessagesPage extends StatelessWidget {
  const ParentMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: const Center(
        child: Text('Messages Page'),
      ),
    );
  }
}
