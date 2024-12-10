import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/word_meaning.dart';
import '../utils/colors_and_theme.dart';
import 'add_word_widget.dart';
import 'word_expanded_display_widget.dart';

class WordDisplayWidget extends StatefulWidget {
  const WordDisplayWidget({required this.wordMeaning, super.key});

  final WordMeaning wordMeaning;

  @override
  State<StatefulWidget> createState() {
    return _WordDisplayWidgetState();
  }
}

class _WordDisplayWidgetState extends State<WordDisplayWidget> {
  get wordMeaning =>  widget.wordMeaning;

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
          definition: widget.wordMeaning.definition,
          isEdit: true,
        );
      },
      isScrollControlled: true,
    );
  }

  void _openDisplayWordDialog() {
    showModalBottomSheet(backgroundColor: Colors.transparent, context: context, builder: (ctx) {
      return DisplayVocabListElement(wordMeaning: wordMeaning);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: Color(getColorForWord(widget.wordMeaning.word[0])),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        // splashColor: Colors.white,
        // highlightColor: Colors.yellow,
        onTap: () {
          _openDisplayWordDialog();
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
                // backgroundColor: Theme.of(context).cardThe,
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
                // backgroundColor: Theme.of(context).disabledColor,
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
            title: Padding(padding: const EdgeInsets.only(bottom: 20), 
              child: Text(widget.wordMeaning.word,
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(getColorForWord('WORD_CARD')),
                fontStyle: FontStyle.normal
              ),),),
            subtitle:
            Text(widget.wordMeaning.definition.isNotEmpty ? widget.wordMeaning.definition: ''
            ,style: GoogleFonts.robotoMono(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                color: Color(getColorForWord('WORD_CARD')),
                fontSize: 20
              ),),
          ),
        ),
      ),
    );
  }
}
