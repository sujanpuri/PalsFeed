import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:palsfeed/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA7GcSUeiQ_o0aBoVQ_JrO8cjTQNZDIBhM",
      appId: "palsfeed",
      messagingSenderId: "833026027425",
      projectId: "palsfeed",
    ),
  );
  runApp(const PalsFeed());
}

class PalsFeed extends StatelessWidget {
  const PalsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PalsFeed",
      home: HomePage(),
    );
  }
}