import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoadingWidgetState();
  }
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme.of(context).brightness == Brightness.light ? const RiveAnimation.asset(
          'assets/animations/rive/geometric_loading_animation.riv') : const RiveAnimation.asset(
          'assets/animations/rive/geometric_loading_animation_dark.riv'),
    );
  }
}
