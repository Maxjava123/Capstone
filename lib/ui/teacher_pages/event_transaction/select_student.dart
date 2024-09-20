import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectStudentsPage extends StatefulWidget {
  final String eventId;

  const SelectStudentsPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _SelectStudentsPageState createState() => _SelectStudentsPageState();
}

class _SelectStudentsPageState extends State<SelectStudentsPage> {
  final List<String> selectedStudents = [];

  void _toggleStudentSelection(String studentId) {
    setState(() {
      if (selectedStudents.contains(studentId)) {
        selectedStudents.remove(studentId);
      } else {
        selectedStudents.add(studentId);
      }
    });
  }

  Future<void> _finalizeSelection() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .update({'studentIds': selectedStudents});

    // After finalizing, navigate to the event list or confirmation page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Students')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'student')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final studentId = student.id;
              final studentName = student['name'];

              return ListTile(
                title: Text(studentName),
                trailing: Checkbox(
                  value: selectedStudents.contains(studentId),
                  onChanged: (_) => _toggleStudentSelection(studentId),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _finalizeSelection,
        child: const Icon(Icons.check),
      ),
    );
  }
}
