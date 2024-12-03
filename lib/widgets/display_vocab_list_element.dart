import 'package:flutter/cupertino.dart';

class DisplayVocabListElement extends StatefulWidget {
  const DisplayVocabListElement({required this.listToDisplay, super.key});

  final List<String> listToDisplay;

  @override
  State<StatefulWidget> createState() {
    return _DisplayVocabListElementState();
  }
}

class _DisplayVocabListElementState extends State<DisplayVocabListElement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.listToDisplay.map((e) => Text(e)).toList(),
    );
  }
}
