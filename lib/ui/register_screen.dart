import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String role = 'Student';
  String username = '';
  String firstname = '';
  String lastname = '';
  String address = '';
  String birthday = '';
  String? teacherKey;
  String? studentID;
  bool _isLoading = false;
  bool _obscureText = true;
  bool _confirmObscureText = true;

  void _showPopup(String message, {bool isSuccess = true}) {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      // Check if email, username, and student ID are already taken
      if (await _authService.isEmailTaken(email)) {
        _showPopup('Email is already in use.', isSuccess: false);
        return;
      }

      if (await _authService.isUsernameTaken(username)) {
        _showPopup('Username is already in use.', isSuccess: false);
        return;
      }

      if (role == 'Student' &&
          studentID != null &&
          await _authService.isStudentIDTaken(studentID!)) {
        _showPopup('Student ID is already in use.', isSuccess: false);
        return;
      }

      // Proceed with registration
      final result = await _authService.register(
        email,
        password,
        role,
        username: username,
        firstname: firstname,
        lastname: lastname,
        address: address,
        birthday: birthday,
        teacherKey: teacherKey,
        studentID: studentID,
      );

      setState(() {
        _isLoading = false; // Hide loading spinner
      });

      if (result['success']) {
        _showPopup('Registration successful!', isSuccess: true);
      } else {
        _showPopup(result['message']!, isSuccess: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFB6CFE3),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a username' : null,
                      onChanged: (val) => setState(() => username = val),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your first name' : null,
                      onChanged: (val) => setState(() => firstname = val),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your last name' : null,
                      onChanged: (val) => setState(() => lastname = val),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your address' : null,
                      onChanged: (val) => setState(() => address = val),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Birthday',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.grey),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                birthday =
                                    "${pickedDate.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                        ),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your birthday' : null,
                      controller: TextEditingController(text: birthday),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) => setState(() => password = val),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmObscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmObscureText = !_confirmObscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _confirmObscureText,
                      validator: (val) =>
                          val != password ? 'Passwords do not match' : null,
                      onChanged: (val) => setState(() => confirmPassword = val),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: role,
                      items:
                          ['Teacher', 'Student', 'Parent'].map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => role = val!),
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (role == 'Teacher')
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Teacher Key',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        validator: (val) =>
                            val != '1234' ? 'Invalid teacher key' : null,
                        onChanged: (val) => setState(() => teacherKey = val),
                      ),
                    if (role == 'Student')
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Student ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your student ID' : null,
                        onChanged: (val) => setState(() => studentID = val),
                      ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              child: const Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _registerUser,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.blue[700],
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      child: const Text('Already have an account? Login here'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
