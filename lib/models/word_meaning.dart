import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum WordClass {
  verb,
  noun,
  determiner,
  adjective,
  adverb,
  preposition,
  conjunction,
  none
}

class WordMeaning {
  String id;
  String word = '';
  String definition = '';
  List<String> usages = [];
  List<String> examples = [];
  WordClass wordClass = WordClass.none;
  String root = '';
  String phonetic = '';

  WordMeaning({
    required this.word,
    required this.definition,
    required this.usages,
    required this.examples,
    required this.wordClass,
    required this.root,
    required this.phonetic,
  }) : id = uuid.v4();

  factory WordMeaning.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return WordMeaning(
        word: data?['word'],
        definition:
            data?['definition'],
        usages: data?['usages'] is Iterable ? List.from(data?['usages']) : [],
        examples:
            data?['examples'] is Iterable ? List.from(data?['examples']) : [],
        wordClass: _parseWordClass(data?['wordClass']),
        root: data?['root'] ?? '',
        phonetic: data?['phonetic'] ?? '');
  }

  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'definition': definition,
      'usages': usages,
      'examples': examples,
      'wordClass': wordClass.name,
      'root': root,
      'phonetic': phonetic
    };
  }

  static WordClass _parseWordClass(String? name) {
    try {
        return WordClass.values.byName(name ?? '');
    } catch (_) {
        return WordClass.none;
    }
  }
}
