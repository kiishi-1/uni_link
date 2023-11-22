import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:uni_link/firestore_method.dart';
import 'package:uni_link/models/user.dart';
import 'package:uni_link/resources/navigation_service.dart';
import 'package:uni_link/router/routing_argument_keys.dart';
import 'package:uni_link/router/routing_constants.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/views/conversation_view.dart';

import '../providers/user_provider.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({Key? key}) : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      // backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ChatRoom")
              .where(
                "users",
                arrayContains: user.username,
              )
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
                  return ChatRoomTile(
                    // image: snapshot.data!.docs[index][],
                    userName: snapshot.data!.docs[index]["chatroomId"]
                        .toString()
                        .replaceAll(".", "")
                        .replaceAll(user.username, ""),
                    chatRoomId: snapshot.data!.docs[index]["chatroomId"],
                  );
                }));
          })),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  ChatRoomTile({
    Key? key,
    required this.userName,
    required this.chatRoomId,
  }) : super(key: key);
  final String userName;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.instance
            .navigateTo(NavigatorRoutes.conversationView, argument: {
          RoutingArgumentKey.chatRoomId: chatRoomId,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 70,
        color: Colors.black26,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: secondColor, borderRadius: BorderRadius.circular(40)),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }
}
