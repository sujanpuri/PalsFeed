import 'package:flutter/material.dart';
import 'package:palsfeed/homepage.dart';
import 'package:palsfeed/premiumpage.dart';
import 'package:palsfeed/register_screen.dart';
import 'auth_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
          "Sign In",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(75.0),
        child: Column(
          
          children: [
            TextField(
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

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;
                final user = await _auth.signInWithEmailAndPassword(email, password);
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GuestPage()),
                  );
                }
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 130, 177, 229), // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding
            ),
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.black),),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Register New',
              style: TextStyle(color: const Color.fromARGB(255, 130, 177, 229))),
            ),
            
            SizedBox(height: 15),
            Text("Here is Default ID:", style: TextStyle(color: Colors.white,)),
            Text("123@gmail.com", style: TextStyle(color: Colors.white,)),
            Text("123456", style: TextStyle(color: Colors.white,)),
          ],
        ),
        
      ),
    );
  }
}
