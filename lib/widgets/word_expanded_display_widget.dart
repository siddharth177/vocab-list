import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_list/models/word_meaning.dart';

class DisplayVocabListElement extends StatefulWidget {
  const DisplayVocabListElement({required this.wordMeaning, super.key});

  final WordMeaning wordMeaning;

  @override
  State<StatefulWidget> createState() {
    return _DisplayVocabListElementState();
  }
}

class _DisplayVocabListElementState extends State<DisplayVocabListElement> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(width: 10),
                Text(widget.wordMeaning.word,
                  style: const TextStyle(
                  fontSize: 30,
                  color: Colors.green
                ),),
                Container(width: 10),
                const Text('Definitions:', style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue
                ),),
                 Column(
                  children: [Text(widget.wordMeaning.definition)],
                ),
                Container(width: 10),
                const Text('Examples:', style: TextStyle(
                    fontSize: 20,
                    color: Colors.green
                ),),
                Container(width: 10),
                const Text('Definitions:', style: TextStyle(
                    fontSize: 20,
                    color: Colors.green
                ),),
              ],
                        ),
            )],
        ),
      ),
    );
  }
}
