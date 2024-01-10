import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  final post;
  const CommentsScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(child: Text("comment screen"),);
  }
}
