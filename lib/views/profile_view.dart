import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_link/firestore_method.dart';
import 'package:uni_link/providers/user_provider.dart';
import 'package:uni_link/resources/auth_methods.dart';
import 'package:uni_link/resources/navigation_service.dart';
import 'package:uni_link/router/routing_argument_keys.dart';
import 'package:uni_link/router/routing_constants.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/utils/global_variables.dart';
import 'package:uni_link/views/conversation_view.dart';
import 'package:uni_link/views/login_view.dart';
import 'package:uni_link/widgets/follow_button.dart';
import 'package:uni_link/widgets/uni_link_flush_bar.dart';
import 'package:uni_link/models/user.dart' as model;

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required this.uid}) : super(key: key);
  final String uid;
  //the uid's that wil be use in the profile screen to get the users documents and posts will be passed in
  //depending on where you're accessing the screen from
  //if you're accessing the screen from the bottom navigation bar, it means you are a user current in(using) the app
  //so the currentUser!.uid will be passed and thats is what will be used in the profile screen
  //but if your accessing the screen from any other place like the search
  //when a user is searched and clicked on(i.e you're navigating to the profile screen), the search users the detail is what is needed
  //then the searched users uid will be passed and used in the profile screen
  //the uid is what we'll use when we search for a user in the search screen
  //so when then user ListTile is selected it'll navigate to the profile screen with the searched uid (which is what is the name of the document holding users data)

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<dynamic, dynamic> userData = {};
  //userData is of type Map<dynamic, dynamic>
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  ///create a chatroom, send user to conversation screen, pushreplacement
  createChatRoomAndStartConversation(
      {required String userName, required String currentUser}) {
    if (userName != currentUser) {
      //chatRoomId is generated randomly with the getChatRoomId() fn
      String chatRoomId = getChatRoomId(userName, currentUser);
      //userName is the searched username
      //Constants.myName the locally stored username of the currentuser

      //
      List<String> users = [userName, currentUser];
      //userName is the searched username
      //Constants.myName the locally stored username of the currentuser

      //chatRoomMap is the Map that'll be stored in the firestore databas
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };
      FirestoreMethod().createChatRoom(chatRoomId, chatRoomMap);
      //chatRoomId is generated randomly with the getChatRoomId() fn
      //chatRoomMap is the Map that'll be stored in the firestore database
      NavigationService.instance
          .navigateTo(NavigatorRoutes.conversationView, argument: {
        RoutingArgumentKey.chatRoomId: chatRoomId,
      });
    } else {
      print("object");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => getData());
    print("object");
    print(widget.uid);
    print("object.5");
    print(FirebaseAuth.instance.currentUser!.uid);
    print("object2");
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      //we're getting the document in the collection("users") that has the uid referenced

      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          //find every document in the "posts" collection that has the same value of the key referenced("uid")
          //that is equal to or the same as the value given (in our case the currentUser.uid) and then get them(the documents)
          .get();
      postLen = postSnap.docs.length;
      //getting the length of documents in the "post" collection
      userData = userSnap.data()!;
      //we are passing the data inside a document(which is of type Map) into userData
      //userData is of type Map<dynamic, dynamic>
      followers = userSnap.data()!["followers"].length;
      following = userSnap.data()!["following"].length;
      //getting the length of the elements in the value(a List) of both followers and following keys in the "users" collection
      isFollowing = userSnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);
      //checking if the current user's uid is inside the searched users document (i.e is the followers list as in "followers": [])
      //if our uid is inside, we added it to the searched user's List(follower: []).
      //essentially we are following the searched user
      print(userData["username"]);
      setState(() {
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      UniLinkFlushBar.showFailure(
        // context: NavigationService.instance.navigatorKey.currentContext!,
        message: e.message.toString(),
        title: "Error",
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser!;
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFEAEAEB)),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: widget.uid != FirebaseAuth.instance.currentUser!.uid
                  ? GestureDetector(
                      onTap: () {
                        
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    )
                  : null,
              backgroundColor: mobileBackgroundColor,
              title: Text(userData["username"] ?? ""),
              centerTitle: false,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await getData();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(userData["photoUrl"] ?? noImage),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(postLen, "post"),
                                      buildStatColumn(followers, "followers"),
                                      buildStatColumn(following, "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          //if it the current users profile(uid) in the profile screen
                                          ? FollowButton(
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              borderColor: Colors.grey,
                                              text: "Sign Out",
                                              textColor: primaryColor,
                                              function: () async {
                                                await AuthMethods().signOut();
                                                NavigationService.instance
                                                    .navigateToReplaceAll(
                                                  NavigatorRoutes.login,
                                                );
                                              },
                                            )
                                          : isFollowing
                                              //if it is the searched user profile(uid) in the profile screen
                                              //
                                              //if we are following the searched user
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    FollowButton(
                                                      backgroundColor:
                                                          Colors.white,
                                                      borderColor: Colors.grey,
                                                      text: "Unfollow",
                                                      textColor: Colors.black,
                                                      function: () async {
                                                        await FirestoreMethod()
                                                            .followUser(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                userData[
                                                                    "uid"]);
                                                        //userData["uid"] represents the searched user uid
                                                        //since we'll be in the searched user profile screen
                                                        setState(() {
                                                          isFollowing = false;
                                                          followers--;
                                                        });
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        createChatRoomAndStartConversation(
                                                          userName: userData[
                                                              "username"],
                                                          currentUser:
                                                              user.username,
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.message_sharp,
                                                        color: primaryColor,
                                                        size: 28,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    FollowButton(
                                                      //if we are not following the searched user
                                                      backgroundColor:
                                                          Colors.blue,
                                                      borderColor: Colors.blue,
                                                      text: "Follow",
                                                      textColor: Colors.white,
                                                      function: () async {
                                                        await FirestoreMethod()
                                                            .followUser(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                userData[
                                                                    "uid"]);
                                                        //userData["uid"] represents the searched user uid
                                                        //since we'll be in the searched user profile screen
                                                        setState(() {
                                                          isFollowing = true;
                                                          followers++;
                                                        });
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        createChatRoomAndStartConversation(
                                                          userName: userData[
                                                              "username"],
                                                          currentUser:
                                                              user.username,
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.message_sharp,
                                                        color: primaryColor,
                                                        size: 28,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            userData["username"] ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            userData["bio"] ?? "",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .where("uid", isEqualTo: widget.uid)
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFEAEAEB)),
                          );
                        }
                        return Expanded(
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5,
                                      childAspectRatio: 1),
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Image(
                                    image: NetworkImage(
                                      (snapshot.data! as dynamic).docs[index]
                                          ["postUrl"],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }),
                        );
                      }))
                ],
              ),
            ),
          );
  }

  Column buildStatColumn(int number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

//generating unique ids
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return " $b.$a";
  } else {
    return " $a.$b";
  }
}
