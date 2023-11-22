import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uni_link/firestore_method.dart';
import 'package:uni_link/models/user.dart';
import 'package:uni_link/providers/user_provider.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsView extends StatefulWidget {
  const CommentsView({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["postId"])
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
       
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFEAEAEB)),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              return CommentCard(
                snap: snapshot.data!.docs[index],
              );
            }),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: "Comment as ${user.username}",
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                await FirestoreMethod().postComment(
                    widget.snap["postId"],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl);
                setState(() {
                  _commentController.text = "";
                  //after posting your comment, you want the text field to be empty, this does that
                });
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    "post",
                    style: TextStyle(
                      color: secondColor,
                    ),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
