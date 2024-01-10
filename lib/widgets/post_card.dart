import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/helper_screens/edit_post.dart';
import '../screens/responsive/comment_screen.dart';
import '../services/post_service.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final post;
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  _editPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(post: widget.post),
      ),
    );
  }

  _deletePost() async {
    String postId = widget.post["postId"];

    try {
      String response = await PostService().deletePost(postId);

      if (response == "success") {
        showSnackBar(context, "Deleted Successful");
      } else {
        showSnackBar(context, response);
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void _confirmDeletePost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete the post "${widget.post['title']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                _deletePost();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    // bool isOwner = true;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (context) => CommentsScreen(
            //   postId: widget.post['postId'].toString(),
            builder: (context) => CommentsScreen(
              post: widget.post,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    widget.post['postUrl'].toString(),
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: getColor(widget.post['tag']),
                        ),
                        child: Text(widget.post['tag'],
                          style: TextStyle(
                            color: kWhite,
                          ),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  // builder: (context) => PostDetailScreen(
                                  builder: (context) => CommentsScreen(
                                    // post: widget.post,
                                    post: widget.post,
                                  ),
                                ),
                              );
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
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 4, horizontal: 8),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.purple, width: 1.0),
                      //     borderRadius: BorderRadius.all(Radius.circular(8)),
                      //   ),
                      //   child: Text(
                      //     "Tips & Tricks",
                      //     style: TextStyle(color: Colors.purple),
                      //   ),
                      // ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                child: CircleAvatar(
                                  backgroundImage:
                                  NetworkImage(widget.post['profileImage']),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                widget.post['username'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat()
                                .format(widget.post['datePublished'].toDate()),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     primary: kPrimaryGreen,
                          //     padding: EdgeInsets.symmetric(
                          //         vertical: 8.0,
                          //         horizontal:
                          //             16.0), // Adjust the padding as needed
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(4.0),
                          //     ),
                          //   ),
                          //   onPressed: () {},
                          //   child: const Text('See More'),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.post['uid'].toString() == user!.uid)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child: PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Handle Edit
                      _editPost();
                    } else if (value == 'delete') {
                      // Handle Delete
                      _confirmDeletePost();
                    }
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

  }


  getColor(tag) {
    // you can adjust this values according to your accuracy requirements

    switch (tag) {
      case "Sharing":
        return Colors.purple.shade500;
      case "Questions":
        return Colors.amber;
      case "Recipe":
        return Colors.pink;
      case "Tips & Tricks":
        return Colors.lightGreen;
      case "Experience":
        return Colors.cyan;
      default:
        return Colors.green;
    }
  }
}
