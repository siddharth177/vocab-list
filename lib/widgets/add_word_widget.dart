import 'package:flutter/material.dart';

import '../models/word_meaning.dart';
import '../utils/firebase.dart';

class AddWordWidget extends StatefulWidget {
  AddWordWidget(
      {
        super.key,
        required this.word,
      required this.root,
      required this.phonatic,
      required this.wordClass,
      required this.examples,
      required this.usages,
      required this.meanings,
        required this.popupTitle});

  String word = '';
  String phonatic = '';
  String root = '';
  WordClass wordClass = WordClass.none;
  List<String> meanings = [];
  List<String> usages = [];
  List<String> examples = [];
  String popupTitle = 'Add New Word';

  @override
  State<AddWordWidget> createState() {
    return _AddWordWidgetState();
  }
}

class _AddWordWidgetState extends State<AddWordWidget> {
  final _formKey = GlobalKey<FormState>();
  String _word = '';
  String _phonatic = '';
  String _root = '';
  WordClass _wordClass = WordClass.none;
  List<String> _meanings = [];
  List<String> _usages = [];
  List<String> _examples = [];
  String _popupTitle = "Add New Word";

  @override
  void initState() {
    super.initState();
    _word = widget.word;
    _phonatic = widget.phonatic;
    _root = widget.root;
    _wordClass = widget.wordClass;
    _meanings = widget.meanings;
    _usages = widget.usages;
    _examples = widget.examples;
    _popupTitle = widget.popupTitle;

    _wordController.text = _word;
    _phonaticController.text = _phonatic;
    _rootController.text = _root;
  }

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _rootController = TextEditingController();
  final TextEditingController _phonaticController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();

  Future<void> _onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var newWord = WordMeaning(
        word: _word,
        meanings: _meanings,
        usages: _usages,
        examples: _examples,
        wordClass: _wordClass,
        root: _root,
        phonatic: _phonatic,
      );

      var uid = firebaseAuthInstance.currentUser?.uid;
      final res = await firestoreInstance
          .collection('users')
          .doc(uid)
          .collection('vocabList')
          .withConverter(
              fromFirestore: WordMeaning.fromFirestore,
              toFirestore: (WordMeaning word, options) => word.toFirestore())
          .doc(_word)
          .set(newWord);

      Navigator.of(context).pop();
    }
  }

  void _clearEntries() {
    _wordController.clear();
    _phonaticController.clear();
    _rootController.clear();
    _meaningController.clear();
    _exampleController.clear();
    _usageController.clear();

    setState(() {
      _word = '';
      _phonatic = '';
      _root = '';
      _wordClass = WordClass.none;
      _meanings = [];
      _usages = [];
      _examples = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQueryData.fromView(WidgetsBinding.instance.window)
              .padding
              .top),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_popupTitle),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _wordController,
                        decoration: const InputDecoration(
                          label: Text("Word"),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length <= 1) {
                            return 'Word cannot be empty';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _word = value!;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _rootController,
                        decoration: const InputDecoration(
                          label: Text("Root"),
                        ),
                        onSaved: (value) {
                          _root = value!;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DropdownMenu<WordClass>(
                        initialSelection: _wordClass != WordClass.none
                            ? _wordClass
                            : WordClass.none,
                        requestFocusOnTap: true,
                        label: const Text('Word Class'),
                        dropdownMenuEntries: WordClass.values
                            .map<DropdownMenuEntry<WordClass>>((e) =>
                                DropdownMenuEntry<WordClass>(
                                    value: e, label: e.name))
                            .toList(),
                        onSelected: (value) {
                          _wordClass = value!;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _phonaticController,
                        decoration: const InputDecoration(
                          label: Text('Phonatic'),
                        ),
                        onSaved: (value) {
                          if (value == null || value.trim().length <= 1) {
                            return;
                          } else {
                            _phonatic = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _meaningController,
                      decoration: const InputDecoration(
                        label: Text('Meanings'),
                      ),
                      onFieldSubmitted: (value) {
                        if (_meanings.isEmpty && widget.meanings.isNotEmpty) {
                          _meanings = widget.meanings;
                        }
                        _meanings.add(_meaningController.text);
                        _meaningController.clear();
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _meanings.map((meaning) => Text(meaning)).toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _usageController,
                      decoration: const InputDecoration(
                        label: Text('Usages'),
                      ),
                      onFieldSubmitted: (value) {
                        if (_usages.isEmpty && widget.usages.isNotEmpty) {
                          _usages = widget.usages;
                        }
                        _usages.add(_usageController.text);
                        _usageController.clear();
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _usages.map((meaning) => Text(meaning)).toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _exampleController,
                      decoration: const InputDecoration(
                        label: Text('Examples'),
                      ),
                      onFieldSubmitted: (value) {
                        if (_examples.isEmpty && widget.examples.isNotEmpty) {
                          _examples = widget.examples;
                        }
                        _examples.add(_exampleController.text);
                        _exampleController.clear();
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _examples.map((meaning) => Text(meaning)).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _clearEntries,
                      child: const Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: _onFormSubmit,
                      child: const Text('Add Word'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
