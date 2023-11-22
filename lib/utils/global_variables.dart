import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_link/views/add_post_view.dart';
import 'package:uni_link/views/feed_view.dart';
import 'package:uni_link/views/profile_view.dart';
import 'package:uni_link/views/search_view.dart';

const webScreenSize = 600;

const noImage =
    "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg";

List<Widget> homeScreenItems = [
  const FeedView(),
  const SearchView(),
  const AddPostView(),
  ProfileView(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
