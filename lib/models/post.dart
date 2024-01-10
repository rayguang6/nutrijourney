import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String content;
  final String uid;
  final String username;
  final likes;
  final String? postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  final String tag;

  const Post({
    required this.content,
    required this.title,
    required this.uid,
    required this.username,
    required this.likes,
    this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.tag,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        title: snapshot["title"],
        content: snapshot["content"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        tag: snapshot['tag'],
        profileImage: snapshot['profileImage']);
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "uid": uid,
    "likes": likes,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profileImage': profileImage,
    'tag': tag,
  };
}
