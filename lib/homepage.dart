// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:palsfeed/auth_service.dart';
// import 'package:palsfeed/guest.dart';
// import 'package:palsfeed/sign_in_screen.dart';

// class HomePage extends StatefulWidget {
//   HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   bool loggedIn = true;

//   final TextEditingController _postController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
  
//   final AuthService _auth = AuthService();

//   Future<void> addPost(String name, String content) async {
//     if (_nameController.text.isNotEmpty && _postController.text.isNotEmpty) {
//       await FirebaseFirestore.instance.collection('posts').add({
//         'name': name,
//         'content': content,
//         'likes': 0,
//         'timestamp': FieldValue.serverTimestamp(),
//         'comments': [],
//       });
//       _nameController.clear();
//       _postController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 130, 177, 229),
//         centerTitle: true,
//         title: const Text(
//           "PalsFeed",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           loggedIn==false?
//           TextButton(
//             onPressed: () async {
//               await _auth.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => SignInScreen()),
//               );
//             },
//             child: Text('Log In', style: TextStyle(color: Color.fromARGB(255, 3, 3, 115))),
//           ):
//           TextButton(
//             onPressed: () async {
//               await _auth.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => GuestPage()),
//               );
//             },
//             child: Text('Sign Out', style: TextStyle(color: Color.fromARGB(255, 3, 3, 115))),
//           ),
//         ],

//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: const Text(
//                   "Add Post",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(labelText: "Name"),
//                       ),
//                       TextField(
//                         controller: _postController,
//                         decoration: const InputDecoration(labelText: "Post Content"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       addPost(_nameController.text, _postController.text);
//                       Navigator.of(context).pop();
//                     },
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(const Color.fromARGB(255, 130, 177, 229)),
//                     ),
//                     child: const Text(
//                       "Post",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         backgroundColor: const Color.fromARGB(255, 130, 177, 229),
//         child: const Icon(Icons.add),
//       ),
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection("posts").snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(child: Text("Something went wrong."));
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: Text("Loading...", style: TextStyle(color: Colors.white)));
//             }
//             return ListView(
//               children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                 Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//                 return PostCard(
//                   postId: document.id,
//                   name: data['name'],
//                   content: data['content'],
//                   likes: data["likes"],
//                   timestamp: data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate() : DateTime.now(),
//                   comments: data['comments'] != null
//                       ? List<Map<String, dynamic>>.from(data['comments'])
//                       : [],
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// class PostCard extends StatefulWidget {
//   final String name;
//   final String postId;
//   final String content;
//   final int likes;
//   final DateTime timestamp;
//   final List<Map<String, dynamic>> comments;

//   const PostCard({
//     super.key,
//     required this.name,
//     required this.postId,
//     required this.content,
//     required this.likes,
//     required this.timestamp,
//     required this.comments,
//   });

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   final TextEditingController _commentController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   bool postLiked = false;

//   void likePost() {
//     if (!postLiked) {
//       FirebaseFirestore.instance.collection("posts").doc(widget.postId).update({
//         'likes': widget.likes + 1,
//       }).then((_) {
//         setState(() {
//           postLiked = true;
//         });
//       }).catchError((error) {
//         print("Failed to like post: $error");
//       });
//     } else {
//       FirebaseFirestore.instance.collection("posts").doc(widget.postId).update({
//         'likes': widget.likes - 1,
//       }).then((_) {
//         setState(() {
//           postLiked = false;
//         });
//       }).catchError((error) {
//         print("Failed to unlike post: $error");
//       });
//     }
//   }

//   void addComment(String comment, String name) {
//     if (comment.isNotEmpty) {
//       FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
//         'comments': FieldValue.arrayUnion([
//           {
//             'name': name,
//             'text': comment,
//             'timestamp': Timestamp.now(),
//           }
//         ]),
//       });
//     }
//     _commentController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String formattedTimestamp = DateFormat('yyyy-MM-dd – kk:mm').format(widget.timestamp);

//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.name,
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   formattedTimestamp,
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//             Text(
//               widget.content,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.thumb_up),
//                   color: postLiked
//                       ? const Color.fromARGB(255, 130, 177, 229)
//                       : Colors.grey,
//                   onPressed: likePost,
//                 ),
//                 Text('${widget.likes}'),
//                 const SizedBox(width: 10),
//                 IconButton(
//                   icon: const Icon(Icons.comment),
//                   color: Colors.grey,
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: const Text(
//                             'Comment',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           content: SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 TextField(
//                                   controller: _nameController,
//                                   decoration:
//                                       const InputDecoration(hintText: "Name"),
//                                 ),
//                                 TextField(
//                                   controller: _commentController,
//                                   decoration:
//                                       const InputDecoration(hintText: "Comment"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 addComment(
//                                     _commentController.text, _nameController.text);
//                                 Navigator.of(context).pop();
//                               },
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         const Color.fromARGB(255, 130, 177, 229)),
//                               ),
//                               child: const Text(
//                                 "Comment",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//             if (widget.comments.isNotEmpty) ...[
//               const Divider(),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: widget.comments.map((comment) {
//                   DateTime commentTimestamp =
//                       (comment['timestamp'] as Timestamp).toDate();
//                   String formattedCommentTimestamp =
//                       DateFormat('yyyy-MM-dd – kk:mm').format(commentTimestamp);
//                   return ListTile(
//                     title: Text(comment['name'], style: TextStyle(fontWeight: FontWeight.bold),),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(comment['text']),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:palsfeed/auth_service.dart';
import 'package:palsfeed/sign_in_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool loggedIn = false;

  final TextEditingController _postController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  final AuthService _auth = AuthService();

  Future<void> addPost(String name, String content) async {
    if (_nameController.text.isNotEmpty && _postController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('posts').add({
        'name': name,
        'content': content,
        'likes': 0,
        'timestamp': FieldValue.serverTimestamp(),
        'comments': [],
      });
      _nameController.clear();
      _postController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 177, 229),
        centerTitle: true,
        title: const Text(
          "PalsFeed",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          loggedIn==false?
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
            child: Text('Log In', style: TextStyle(color: Color.fromARGB(255, 0, 0, 115))),
          ):
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
            child: Text('Sign Out', style: TextStyle(color: Color.fromARGB(255, 0, 0, 115))),
          ),
        ],

      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Note: You need to Log In, inorder to add Post & Comment.", style: TextStyle(color: Colors.white,)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("posts").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong."));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("Loading...", style: TextStyle(color: Colors.white)));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return PostCard(
                        postId: document.id,
                        name: data['name'],
                        content: data['content'],
                        likes: data["likes"],
                        timestamp: data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate() : DateTime.now(),
                        comments: data['comments'] != null
                            ? List<Map<String, dynamic>>.from(data['comments'])
                            : [],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class PostCard extends StatefulWidget {
  final String name;
  final String postId;
  final String content;
  final int likes;
  final DateTime timestamp;
  final List<Map<String, dynamic>> comments;

  const PostCard({
    super.key,
    required this.name,
    required this.postId,
    required this.content,
    required this.likes,
    required this.timestamp,
    required this.comments,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool postLiked = false;

  void likePost() {
    if (!postLiked) {
      FirebaseFirestore.instance.collection("posts").doc(widget.postId).update({
        'likes': widget.likes + 1,
      }).then((_) {
        setState(() {
          postLiked = true;
        });
      }).catchError((error) {
        print("Failed to like post: $error");
      });
    } else {
      FirebaseFirestore.instance.collection("posts").doc(widget.postId).update({
        'likes': widget.likes - 1,
      }).then((_) {
        setState(() {
          postLiked = false;
        });
      }).catchError((error) {
        print("Failed to unlike post: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTimestamp = DateFormat('yyyy-MM-dd – kk:mm').format(widget.timestamp);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  formattedTimestamp,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Text(
              widget.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  color: postLiked
                      ? const Color.fromARGB(255, 130, 177, 229)
                      : Colors.grey,
                  onPressed: likePost,
                ),
                Text('${widget.likes}'),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.comment),
                  color: Colors.grey,
                  onPressed: (){},
                ),
              ],
            ),
            if (widget.comments.isNotEmpty) ...[
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.comments.map((comment) {
                  DateTime commentTimestamp =
                      (comment['timestamp'] as Timestamp).toDate();
                  String formattedCommentTimestamp =
                      DateFormat('yyyy-MM-dd – kk:mm').format(commentTimestamp);
                  return ListTile(
                    title: Text(comment['name'], style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment['text']),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
