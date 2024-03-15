import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Constants/Colors.dart';
import 'package:instagram/Constants/Global_Variables.dart';
import 'package:provider/provider.dart';

import '../Models/user_model.dart' as model;
import '../provider/user_provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void dispose() {
    super.dispose();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  // String username = "";
  // @override
  // void initState() {
  //   super.initState;
  //   getUsername();
  // }
  // void getUsername() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users2')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   if (snap.exists) {
  //     setState(() {
  //       username = (snap.data() as Map<String, dynamic>)['username'];
  //     });
  //   } else {
  //     // Handle the case where the document does not exist.
  //     print('Document does not exist');
  //   }
  //   print(snap.data());
  // }

  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    if (user != null) {
      return Scaffold(
        body:
            // child: Text(user.username),
            // child: Text("This is Mobile"),
            PageView(
          children: homeScreenItems,
          //physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: _page == 2 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: _page == 3 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
          ],
          onTap: navigationTapped,
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
    // Widget build(BuildContext context) {
    //   model.User? user = Provider.of<UserProvider>(context).getUser;
    //   if (user != null) {
    //     return Scaffold(
    //       body: Center(child: Text(user.username)),
    //     );
    //   } else {
    //     // Handle the case where user is null, for example, show a loading indicator or an error message.
    //     return CircularProgressIndicator(); // Display a loading indicator.
    //     // Or display an error message:
    // return Text('User data is null');
  }
}
