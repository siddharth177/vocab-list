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
  String phonatic = '';

  WordMeaning({
    required this.word,
    required this.definition,
    required this.usages,
    required this.examples,
    required this.wordClass,
    required this.root,
    required this.phonatic,
  }) : id = uuid.v4();

  WordMeaning.word(this.word) : id = uuid.v4();

  WordMeaning.definition(this.word, this.definition) : id = uuid.v4();

  WordMeaning.usages(this.word, this.definition, this.usages) : id = uuid.v4();

  WordMeaning.examples(this.word, this.definition, this.usages, this.examples)
      : id = uuid.v4();

  WordMeaning.wordClass(
      this.word, this.definition, this.usages, this.examples, this.wordClass)
      : id = uuid.v4();

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
        wordClass: (data?['wordClass'] == 'verb')
            ? WordClass.verb
            : (data?['wordClass'] == 'noun')
                ? WordClass.noun
                : (data?['wordClass'] == 'determiner')
                    ? WordClass.determiner
                    : (data?['wordClass'] == 'adjective')
                        ? WordClass.adjective
                        : (data?['wordClass'] == 'adverb')
                            ? WordClass.adverb
                            : (data?['wordClass'] == 'preposition')
                                ? WordClass.preposition
                                : (data?['wordClass'] == 'conjunction')
                                    ? WordClass.conjunction
                                    : WordClass.none,
        root: data?['root'],
        phonatic: data?['phonatic']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'definition': definition,
      'usages': usages,
      'examples': examples,
      'wordClass': wordClass.name,
      'root': root,
      'phonatic': phonatic
    };
  }
}
