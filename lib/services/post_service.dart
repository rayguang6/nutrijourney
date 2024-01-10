import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';
import '../utils/utils.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//function to create post into database
  Future<String> createPost(
      title, content, _image, uid, username, profileImage, tag) async {
    // String profileImage =
    //     await StorageMethods().uploadImageToStorage('posts', file, true);
    String res = "";

    try {
      String postId = const Uuid().v1();
      String postImageLink = "";

      postImageLink = await uploadImageToStorage('posts', _image);

      Post post = Post(
        title: title,
        content: content,
        uid: uid,
        username: username,
        likes: [],
        datePublished: DateTime.now(),
        postId: postId,
        postUrl: postImageLink,
        profileImage: profileImage,
        tag: tag,
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //update post
  Future<String> updatePost(postId, title, content) async {
    String res = "";

    try {
      await _firestore.collection('posts').doc(postId).update({
        'title': title,
        'content': content,
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "error deleting post";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }


  Future<String> likePost(String postId, String uid, List likes) async {
    String response = "Some error occurred";

    print("postId: " + postId);
    print("UID: " + uid);
    print(likes.toString());

    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });

        response = 'Removed from Like';
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        response = 'Liked';
      }
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}
