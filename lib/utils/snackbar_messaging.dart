import 'package:flutter/material.dart';

void clearAndDisplaySnackbar(BuildContext context, String message, {int duration = 4}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(seconds: duration),));
}
