import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold,
                                color: kPrimaryGreen
                            )
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                          style: TextStyle(color: kBlack),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat().format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   child: const Icon(
          //     Icons.favorite,
          //     size: 16,
          //   ),
          // )
        ],
      ),
    );
  }
}