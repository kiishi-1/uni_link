import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_link/resources/navigation_service.dart';
import 'package:uni_link/router/routing_constants.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/widgets/post_card.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text(
          "UniLink",
          style: GoogleFonts.notoSansMeroitic(
            color: primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              NavigationService.instance.navigateTo(
                NavigatorRoutes.chatRoom,
              );
            },
            icon: const Icon(
              Icons.messenger_outline,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .orderBy("datePublished", descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFEAEAEB)),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    snap: snapshot.data!.docs[index],
                  );
                });
          }),
    );
  }
}
