import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';

class DraggableFloatingChatIcon extends StatelessWidget {
  final VoidCallback onTap;

  const DraggableFloatingChatIcon({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: FloatingActionButton(
        onPressed: onTap,
        child: const Icon(Icons.chat),
      ),
      childWhenDragging: Container(),
      child: FloatingActionButton(
        backgroundColor: kBlack,
        onPressed: onTap,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
