import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/word_meaning.dart';
import '../utils/firebase.dart';

class AddWordWidget extends StatefulWidget {
  AddWordWidget(
      {super.key,
      required this.word,
      required this.root,
      required this.phonatic,
      required this.wordClass,
      required this.examples,
      required this.usages,
      required this.definition,
      required this.isEdit});

  String word = '';
  String phonatic = '';
  String root = '';
  WordClass wordClass = WordClass.none;
  String definition = '';
  List<String> usages = [];
  List<String> examples = [];
  bool isEdit = false;

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
  String _definition = '';
  List<String> _usages = [];
  List<String> _examples = [];
  String _popupTitle = "Add New Word";
  String _saveButton = 'Add Word';
  String _clearButton = 'Clear';

  @override
  void initState() {
    super.initState();
    _word = widget.word;
    _phonatic = widget.phonatic;
    _root = widget.root;
    _wordClass = widget.wordClass;
    _definition = widget.definition;
    _usages = widget.usages;
    _examples = widget.examples;
    _popupTitle = widget.isEdit ? 'Edit Word' : 'Add New Word';
    _saveButton = widget.isEdit ? 'Save' : 'Add';
    _clearButton = widget.isEdit ? 'Delete' : 'Clear';

    _wordController.text = _word;
    _phonaticController.text = _phonatic;
    _rootController.text = _root;
  }

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _rootController = TextEditingController();
  final TextEditingController _phonaticController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();

  Future<void> _onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var newWord = WordMeaning(
        word: _word,
        definition: _definition,
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
    _definitionController.clear();
    _exampleController.clear();
    _usageController.clear();

    setState(() {
      _word = '';
      _phonatic = '';
      _root = '';
      _wordClass = WordClass.none;
      _definition = '';
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: 20,
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
                      controller: _definitionController,
                      decoration: const InputDecoration(
                        label: Text('Definition'),
                      ),
                      onFieldSubmitted: (value) {
                        _definition = value;
                        // if (_definition.isEmpty && widget.definition.isNotEmpty) {
                        //   _definition = widget.definition;
                        // }
                        // _definition.add(_meaningController.text);
                        // _meaningController.clear();
                      },
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children:
                    //       _definition.map((meaning) => Text(meaning)).toList(),
                    // ),
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
                          _usages.map((meaning){
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _usageController.text = meaning;
                                  _usages.remove(meaning);
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(meaning),
                              IconButton(onPressed: (){
                                setState(() {
                                  _usages.remove(meaning);
                                });
                              }, icon: Icon(Icons.delete)),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
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
                  _examples.map((meaning){
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _exampleController.text = meaning;
                          _examples.remove(meaning);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(meaning),
                          IconButton(onPressed: (){
                            setState(() {
                              _examples.remove(meaning);
                            });
                          }, icon: const Icon(Icons.delete)),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.isEdit)
                      ElevatedButton(
                        onPressed: _onFormSubmit,
                        child: Text(_saveButton),
                      )
                    else ...[
                      ElevatedButton(
                        onPressed: _clearEntries,
                        child: Text(_clearButton),
                      ),
                      ElevatedButton(
                        onPressed: _onFormSubmit,
                        child: Text(_saveButton),
                      ),
                    ]
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _removeExample(int index) {
    setState(() {
      // _exampleController.text = _examples[index];
      _examples.removeAt(index);
    });
  }

  _editExample(int index) {
    setState(() {
      _exampleController.text = _examples[index];
      _examples.removeAt(index);
    });
  }
}
