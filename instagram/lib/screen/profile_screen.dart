import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Authentication/login.dart';
import 'package:instagram/Constants/Colors.dart';
import 'package:instagram/Constants/image_picker.dart';
import 'package:instagram/resources/Auth_Method.dart';
import 'package:instagram/resources/firestore_method.dart';

import '../Widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({super.key, this.uid});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  // getData() async {
  //   try {
  //     var Usersnap = await FirebaseFirestore.instance
  //         .collection('users2')
  //         .doc(widget.uid)
  //         .get();
  //     userData = Usersnap.data()!;
  //     setState(() {});

  //   } catch (e) {
  //     ShowSnackBar(e.toString(), context);
  //   }
  // }
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var Usersnap = await FirebaseFirestore.instance
          .collection('users2')
          .doc(widget.uid)
          .get();
//get post LENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;

      // Check if Usersnap.data() is not null before assigning it to userData
      if (Usersnap.exists) {
        userData = Usersnap.data()!;

        followers = Usersnap.data()!['followers'].length;
        following = Usersnap.data()!['following'].length;
        isFollowing = Usersnap.data()!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
        setState(() {});
      } else {
        // Handle the case where the document doesn't exist
        ShowSnackBar('User data not found', context);
      }
    } catch (e) {
      ShowSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null ||
        userData['username'] == null ||
        userData['bio'] == null) {
      // If userData or specific properties are null, show a loading indicator or an error message.
      // For example, you can return a CircularProgressIndicator or an error widget.
      return Center(child: CircularProgressIndicator());
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              // title: Text('uesername'),
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(
                    children: [
                      CircleAvatar(
                        // backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData['photoUrl']),
                        radius: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                buildStatColumn(postLen, 'posts'),
                                buildStatColumn(followers, 'followers'),
                                buildStatColumn(following, 'following'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        text: 'Sign Out',
                                        backgroundColor: mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await AuthMethods().signOut();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()));
                                        })
                                    : isFollowing
                                        ? FollowButton(
                                            text: 'Unfollow',
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await FirestoreMethods()
                                                  .followUsers(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid'],
                                              );
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            })
                                        : FollowButton(
                                            text: 'follow',
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            borderColor: Colors.blue,
                                            function: () async {
                                              await FirestoreMethods()
                                                  .followUsers(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid'],
                                              );
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      userData['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 1),
                    child: Text(
                      userData['bio'],
                    ),
                  ),
                ]),
              ),
              const Divider(),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: widget.uid)
                    .get(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return SizedBox(
                          child: Image(
                            image: NetworkImage(snap['photoUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      });
                }),
              )
            ]),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
