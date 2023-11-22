import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_link/firestore_method.dart';
import 'package:uni_link/models/user.dart';
import 'package:uni_link/providers/user_provider.dart';
import 'package:uni_link/utils/colors.dart';

class ConversationView extends StatefulWidget {
  ConversationView({
    Key? key,
    this.chatRoomId,
  }) : super(key: key);
  final String? chatRoomId;

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  // FirestoreMethod databaseMethods = FirestoreMethod();
  //Stream? chatMessagesStream;

  TextEditingController messageController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   // // databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
  //   // //   setState(() {
  //   // //     chatMessagesStream = value;
  //   // //   });
  //   // });
  // }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser!;

    return Scaffold(
      // backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ChatRoom")
                    .doc(widget.chatRoomId)
                    .collection("chats")
                    .orderBy("time", descending: false)
                    .snapshots(),
                //we want to get all the documents in the "chats" collection
                //NB: every single messaged is saved in a document
                builder: ((context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFEAEAEB)),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return MessageTile(
                          message: snapshot.data!.docs[index]["message"],
                          isSendByMe: snapshot.data!.docs[index]["sendBy"] ==
                              user.username,
                        );
                      }));
                })),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: const Color(0x54FFFFFF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: 'Message ...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (messageController.text.isNotEmpty) {
                          Map<String, dynamic> messageMap = {
                            "message": messageController.text,
                            "sendBy": user.username,
                            "time": DateTime.now().millisecondsSinceEpoch
                          };
                          FirestoreMethod().addConversationMessages(
                              widget.chatRoomId, messageMap);
                          messageController.text = "";
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 40,
                        // padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ],
                          ),
                          // borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, this.message, required this.isSendByMe})
      : super(key: key);
  final String? message;
  final bool isSendByMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff7C5E93), const Color(0xff4B284A)]
                    : [const Color(0xffBB965A), const Color(0xff614647)])),
        child: Text(
          message!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
