import 'package:flutter/material.dart';
import 'package:palsfeed/homepage.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 177, 229),
        centerTitle: true,
        title: const Text(
          "Register",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(75.0),
        child: Column(
          children: [TextField(
  controller: _emailController,
  style: TextStyle(color: Colors.white), // White text
  decoration: InputDecoration(
    labelText: 'Email',
    labelStyle: TextStyle(color: Colors.white), // White label text
    filled: true,
    fillColor: Colors.black, // Black background
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border
      borderRadius: BorderRadius.circular(30.0), // Rounded corners
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border when focused
      borderRadius: BorderRadius.circular(30.0), // Rounded corners
    ),
  ),
),

SizedBox(height: 30),

TextField(
  controller: _passwordController,
  style: TextStyle(color: Colors.white), // White text
  decoration: InputDecoration(
    labelText: 'Password',
    labelStyle: TextStyle(color: Colors.white), // White label text
    filled: true,
    fillColor: Colors.black, // Black background
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border
      borderRadius: BorderRadius.circular(30.0), // Rounded corners
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // White border when focused
      borderRadius: BorderRadius.circular(30.0), // Rounded corners
    ),
  ),
  obscureText: true,
),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;
                final user = await _auth.registerWithEmailAndPassword(email, password);
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
