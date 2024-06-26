import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyA7GcSUeiQ_o0aBoVQ_JrO8cjTQNZDIBhM",
    appId: "palsfeed",
    messagingSenderId: "833026027425",
    projectId: "palsfeed",
  ));
  runApp(PalsFeed());
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Future <void> addData() async{
    String name = _nameController.text;
    int age = int.parse(_ageController.text);

    await FirebaseFirestore.instance.collection('users').add({
      'name':name,
      'age':age,
    }).then((value)=>print("User Added")).catchError((error)=>print("Failed to add User: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "PalsFeed",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: "Name"),
        ),
        TextField(
          controller: _ageController,
          decoration: InputDecoration(labelText: "Age"),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: addData, child: Text("Add Data")),
        SizedBox(height: 20,),
        Expanded(child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Text("Something went wrong.");
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Text("Loading...", style: TextStyle(fontWeight: FontWeight.bold),);
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text("Age : ${data['age']}"),
                );
              }).toList()
            );
          },
        ))
        
      ],),
    );
  }
}
