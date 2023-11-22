import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_link/resources/navigation_service.dart';
import 'package:uni_link/router/routing_argument_keys.dart';
import 'package:uni_link/router/routing_constants.dart';
import 'package:uni_link/utils/colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key, this.isShowUsers = false}) : super(key: key);
  final bool isShowUsers;
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  bool? isShowUsers;

  @override
  void initState() {
    isUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  isUser() {
    isShowUsers = widget.isShowUsers;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: isShowUsers!
            ? GestureDetector(
                onTap: () {
                  isShowUsers = false;
                  searchController.clear();
                  setState(() {});
                  // Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              )
            : null,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: "Search for a user",
          ),
          onFieldSubmitted: ((value) {
            FocusScope.of(context).unfocus();
            setState(() {
              isShowUsers = true;
            });
          }),
        ),
      ),
      body: isShowUsers!
          ? StreamBuilder(
            
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where(
                    "username",
                    isGreaterThanOrEqualTo: searchController.text,
                    
                  )
                  .snapshots(),

              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFEAEAEB)),
                  );
                }
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () {
                          NavigationService.instance.navigateTo(
                              NavigatorRoutes.profileView,
                              argument: {
                                RoutingArgumentKey.profileUid:
                                    (snapshot.data! as dynamic).docs[index]
                                        ["uid"],
                              });

                          //the uid in the document of the particlar index
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ["photoUrl"]),
                            //so we want to get the images of all the users(one or more) that have the value of the key used(in this case searched)
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ["username"]),
                          //so we want to get the usernames of all the users(one or more) that have the value of the key used(in this case searched)
                        ),
                      );
                    }));
              }),
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: secondColor),
                  );
                }
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.6),
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                          (snapshot.data! as dynamic).docs[index]["postUrl"]);
                    });
              })),
    );
  }
}
