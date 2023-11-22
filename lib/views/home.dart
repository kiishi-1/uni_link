import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:uni_link/providers/user_provider.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:uni_link/models/user.dart' as model;
import 'package:uni_link/views/add_post_view.dart';
import 'package:uni_link/views/feed_view.dart';
import 'package:uni_link/views/profile_view.dart';
import 'package:uni_link/views/search_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    // pageController = PageController();
    addData();
  }

  addData() async {
    final UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   pageController.dispose();
  // }

  // void navigationTapped(int page) {
  //   pageController.jumpToPage(page);
  // }
  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;
    return PersistentTabView(
      context,
      controller: _controller,
      navBarHeight: 70,
      // padding: NavBarPadding.all(value),
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: MediaQuery.of(context).padding.bottom + 12,
      ),

      bottomScreenMargin: 0,
      screens: [
        const FeedView(),
        const SearchView(),
        const AddPostView(),
        ProfileView(
          uid: FirebaseAuth.instance.currentUser!.uid,
        ),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.home,
          ),
          title: ("Feed"),
          activeColorPrimary: secondColor,
          inactiveColorPrimary: secondaryColor,
          activeColorSecondary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.search,
          ),
          title: ("Search"),
          activeColorPrimary: secondColor,
          inactiveColorPrimary: secondaryColor,
          activeColorSecondary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.add_circle,
          ),
          title: ("New Post"),
          activeColorPrimary: secondColor,
          inactiveColorPrimary: secondaryColor,
          activeColorSecondary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.person,
          ),
          title: ("Profile"),
          activeColorPrimary: secondColor,
          inactiveColorPrimary: secondaryColor,
          activeColorSecondary: primaryColor,
        )
      ],
      confineInSafeArea: false,
      backgroundColor: mobileBackgroundColor, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: secondColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(2.0, 2.0),
          )
        ],
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style10, // Choose the nav bar style with this property.
    );
    //  Scaffold(
    //   body: PageView(
    //     controller: pageController,
    //     onPageChanged: onPageChanged,
    //     physics: const NeverScrollableScrollPhysics(),
    //     children: [
    //       const FeedView(),
    //       const SearchView(),
    //       const AddPostView(),
    //       ProfileView(
    //         uid: FirebaseAuth.instance.currentUser!.uid,
    //       ),
    //     ],
    //   ),
    //   bottomNavigationBar: CupertinoTabBar(
    //     height: 65,
    //     backgroundColor: mobileBackgroundColor,
    //     items: [
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.home,
    //             color: _page == 0 ? primaryColor : secondaryColor,
    //           ),
    //           label: "",
    //           backgroundColor: primaryColor),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.search,
    //               color: _page == 1 ? primaryColor : secondaryColor),
    //           label: "",
    //           backgroundColor: primaryColor),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.add_circle,
    //               color: _page == 2 ? primaryColor : secondaryColor),
    //           label: "",
    //           backgroundColor: primaryColor),
    //       // BottomNavigationBarItem(
    //       //     icon: Icon(Icons.favorite,
    //       //         color: _page == 3 ? primaryColor : secondaryColor),
    //       //     label: "",
    //       //     backgroundColor: primaryColor),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.person,
    //               color: _page == 3 ? primaryColor : secondaryColor),
    //           label: "",
    //           backgroundColor: primaryColor)
    //     ],
    //     onTap: navigationTapped,
    //   ),
    // );
  }
}
