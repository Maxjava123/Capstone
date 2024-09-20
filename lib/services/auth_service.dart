// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if email is already used
  Future<bool> isEmailTaken(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Check if student ID is already used
  Future<bool> isStudentIDTaken(String studentID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('studentID', isEqualTo: studentID)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Check if username is already taken
  Future<bool> isUsernameTaken(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Register a new user without logging them in
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String role, {
    required String username,
    required String firstname,
    required String lastname,
    required String address,
    required String birthday,
    String? teacherKey,
    String? studentID,
  }) async {
    try {
      // Check if email, username, and student ID are already taken
      if (await isEmailTaken(email)) {
        return {'success': false, 'message': 'Email is already in use.'};
      }

      if (await isUsernameTaken(username)) {
        return {'success': false, 'message': 'Username is already in use.'};
      }

      if (role == 'Student' &&
          studentID != null &&
          await isStudentIDTaken(studentID)) {
        return {'success': false, 'message': 'Student ID is already in use.'};
      }

      if (role == 'Teacher' && teacherKey != '1234') {
        return {'success': false, 'message': 'Invalid teacher key.'};
      }

      // Create a new user in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Create a new UserModel object
        UserModel newUser = UserModel(
          uid: user.uid,
          username: username,
          firstname: firstname,
          lastname: lastname,
          address: address,
          birthday: birthday,
          email: email,
          role: role,
          studentID: studentID,
        );

        // Store the new user's data in Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        return {'success': true, 'message': 'Registration successful!'};
      } else {
        return {'success': false, 'message': 'Registration failed.'};
      }
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'message': 'An error occurred during registration.'
      };
    }
  }

  // Login an existing user
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, user.uid);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out the currently authenticated user
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Retrieve user details from Firestore using the user's UID
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
