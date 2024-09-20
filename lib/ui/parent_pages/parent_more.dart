import 'package:flutter/material.dart';

class ParentMorePage extends StatelessWidget {
  const ParentMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // background color
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(
                Icons.person, // Replace with the icon you want to use
                size: 50,
                color: Colors.white,
              ), // Set the background color
            ),
            const SizedBox(height: 10),
            // Username
            const Text(
              'User08',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Menu Items
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.visibility, color: Colors.black),
                      title: const Text('See Students Location',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:
                          const Text('List of people can view your location'),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.contacts, color: Colors.black),
                      title: const Text('Contacts',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Lists of Emergency Contacts'),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.black),
                      title: const Text('Account Settings',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Manage Account'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
