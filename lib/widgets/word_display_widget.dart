import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/word_meaning.dart';
import 'add_word_widget.dart';
import 'display_vocab_list_element.dart';

class WordDisplayWidget extends StatefulWidget {
  const WordDisplayWidget({required this.wordMeaning, super.key});

  final WordMeaning wordMeaning;

  @override
  State<StatefulWidget> createState() {
    return _WordDisplayWidgetState();
  }
}

class _WordDisplayWidgetState extends State<WordDisplayWidget> {
  void _editWordField() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return AddWordWidget(
          word: widget.wordMeaning.word,
          root: widget.wordMeaning.root,
          phonatic: widget.wordMeaning.phonatic,
          wordClass: widget.wordMeaning.wordClass,
          examples: widget.wordMeaning.examples,
          usages: widget.wordMeaning.usages,
          meanings: widget.wordMeaning.meanings,
          popupTitle: 'Edit Word',
        );
      },
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: Theme.of(context).cardTheme.color,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white,
        // highlightColor: Colors.yellow,
        onTap: () {
          _editWordField();
        },
        child: Slidable(
          key: ValueKey(widget.wordMeaning.word),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  _editWordField();
                },
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icons.edit,
                label: 'Edit',
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('vocabList')
                    .doc(widget.wordMeaning.word)
                    .delete();
              },
            ),
            children: [
              SlidableAction(
                onPressed: (context) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('vocabList')
                      .doc(widget.wordMeaning.word)
                      .delete();
                },
                backgroundColor: Theme.of(context).disabledColor,
                icon: Icons.delete,
                label: 'Delete',
              )
            ],
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            // Define how the card's content should be clipped
            title:
            Text(widget.wordMeaning.word),
            subtitle:
            Text(widget.wordMeaning.meanings.isNotEmpty ? widget.wordMeaning.meanings.first: ''),
          ),
        ),
      ),
    );
  }
}
