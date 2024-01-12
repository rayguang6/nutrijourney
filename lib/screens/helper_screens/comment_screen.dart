import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post_service.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/comment_card.dart';


class CommentsScreen extends StatefulWidget {
  final post;
  const CommentsScreen({Key? key, required this.post}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
  TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await PostService().postComment(
        widget.post['postId'],
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.network(
                  widget.post['postUrl'].toString(),
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Like",
                        icon: widget.post['likes'].contains(user?.uid)
                            ? const Icon(
                          Icons.thumb_up,
                          color: Colors.blue,
                        )
                            : const Icon(
                          Icons.thumb_up_outlined,
                        ),
                        onPressed: () => PostService()
                            .likePost(
                          widget.post['postId'].toString(),
                          user!.uid,
                          widget.post['likes'],
                        )
                            .then(
                              (response) =>
                              showSnackBar(context, response),
                        ),
                      ),
                      Text("Like"),
                    ],
                  ),
                  InkWell(
                    onTap: () {

                    },
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.chat_outlined)),
                        Text('Comment')
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            showSnackBar(
                                context, "Will be develop later");
                          },
                          icon: Icon(Icons.favorite)),
                      Text('Save'),
                    ],
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(16) ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post['title'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.post['content'],
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
              ,
              _buildCommentContainer(),
            ],
          ),
        ),
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.profileImage),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user?.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user!.uid,
                  user!.username,
                  user!.profileImage,
                ),
                child: Container(
                  // color: kPrimaryGreen,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: kPrimaryGreen
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        // border: Border.all(color: kLightGreen),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Comments",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),

            ],
          ),
          const SizedBox(height: 10.0),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.post['postId'])
                .collection('comments')
                .orderBy("datePublished")
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => CommentCard(
                  snap: snapshot.data!.docs[index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

