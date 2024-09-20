import 'package:capstone_1/models/request_model.dart';
import 'package:capstone_1/ui/parent_pages/request_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/request_service.dart';

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

  @override
  _ParentProfilePageState createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  final TextEditingController _accountIdController = TextEditingController();
  final RequestService _requestService = RequestService();
  String? _parentId;
  // String? _parentemail;

  @override
  void initState() {
    super.initState();
    _fetchParentId();
  }

  void _fetchParentId() {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _parentId = user?.uid;
      // _parentemail = user?.email;
    });
  }

  @override
  void dispose() {
    _accountIdController.dispose();
    super.dispose();
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Create a Request',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _accountIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Account ID',
                  hintText: 'Account ID',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_parentId != null) {
                    _requestService.sendRequest(
                        _parentId!, _accountIdController.text);
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not authenticated')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('SEND', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 5),
                    Icon(Icons.send),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_parentId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blueGrey,
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text("parent001"),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _showRequestDialog,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Send Request",
                style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              side: const BorderSide(width: 1),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<List<RequestModel>>(
        stream: _requestService.getRequestsByParent(_parentId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No requests found.'));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return RequestListItem(request: requests[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRequestDialog,
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}
