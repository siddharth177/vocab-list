import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PostionedLoadingWidget extends StatefulWidget {
  const PostionedLoadingWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PositionedLoadedWidgetState();
  }
}

class _PositionedLoadedWidgetState extends State<PostionedLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
      child: RiveAnimation.asset(
          speedMultiplier: 3,
          'assets/animations/rive/dot_loading.riv'),
    );
  }
}
