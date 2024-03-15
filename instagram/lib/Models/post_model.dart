import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final dataPublished;
  final String photoUrl;
  final String profImage;
  final likes;
  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.dataPublished,
    required this.photoUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "dataPublished": dataPublished,
        "photoUrl": photoUrl,
        "profImage": profImage,
        "likes": likes,
      };
  static Post? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data();
    if (snapshot != null && snapshot is Map<String, dynamic>) {
      return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        description: snapshot['description'],
        photoUrl: snapshot['photoUrl'],
        profImage: snapshot['profImage'],
        postId: snapshot['postId'],
        likes: snapshot['likes'],
        dataPublished: snapshot['dataPublished'],
      );
    } else {
      // Handle the case where snap.data() is null or not a Map<String, dynamic>,
      // for example, return null or throw an error.
      return null;
    }
  }
}
