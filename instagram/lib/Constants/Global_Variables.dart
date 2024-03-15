import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screen/profile_screen.dart';

import '../screen/add_post_screen.dart';
import '../screen/search_screen.dart';
import '../screen/show_screen.dart';

const WebScreenSize = 600;
List<Widget> homeScreenItems = [
  // Text('feed'),
  const ShowScreen(),
  const SearchScreen(),

  // const Text('search'),
  // Text('add post'),
  const AddPostScreen(),

  Text('notify'),
  // Text('profile'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
