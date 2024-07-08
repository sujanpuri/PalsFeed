import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> addPost(String name, String content) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 177, 229),
        centerTitle: true,
        title: Text(
          "PalsFeed",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Post"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                      TextField(
                        controller: _postController,
                        decoration: InputDecoration(labelText: "Post Content"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addPost(_nameController.text, _postController.text);
                      Navigator.of(context).pop();
                    },
                    child: Text("Post"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 130, 177, 229),
      ),
      
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Something went wrong."));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading...",style: TextStyle(color: Colors.white),));
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return PostCard(
                  postId: document.id,
                  name: data['name'],
                  content: data['content'],
                  likes: data["likes"],
                  comments: List<String>.from(data['comments']),
                );
              }).toList(),
            );
          },
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
  final List<String> comments;

  const PostCard({
    Key? key,
    required this.name,
    required this.postId,
    required this.content,
    required this.likes,
    required this.comments,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _commentController = TextEditingController();
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

  void addComment(String comment) {
    FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
      'comments': FieldValue.arrayUnion([comment]),
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: postLiked ? Color.fromARGB(255, 130, 177, 229) : Colors.grey,
                  onPressed: likePost, // Handle like action
                ),
                Text('${widget.likes}'),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.comment),
                  color: Color.fromARGB(255, 130, 177, 229),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add Comment'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _commentController,
                                  decoration: InputDecoration(labelText: "Comment"),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                addComment(_commentController.text); // Add comment to Firestore
                                Navigator.of(context).pop();
                              },
                              child: Text("Comment"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            if (widget.comments.isNotEmpty) ...[
              Divider(),
              Text(
                "Comments:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...widget.comments.map((comment) => ListTile(
                title: Text(comment),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
