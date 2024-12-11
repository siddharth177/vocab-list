import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:vocab_list/services/groq_llama.dart';
import 'package:vocab_list/utils/snackbar_messaging.dart';
import 'package:vocab_list/widgets/postioned_loading_widget.dart';

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
  bool _isLoading = false;

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

    _definitionController.text = _definition;
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

  Future<void> _fetchWordData(kWord) async {
    if (kWord.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final wordData = await getWordData(kWord);
      clearAndDisplaySnackbar(context, 'data fetched from llama model successfully', duration: 1);
      _word = kWord ?? '';
      _phonatic = wordData['phonetic'] ?? '';
      _root = wordData['root'] ?? '';
      _wordClass = _getWordClassFromString(wordData['wordType']);
      _definition = wordData['definition'] ?? '';
      _usages.addAll(_getStringListFromApiData(wordData['usages']));
      _examples.addAll(_getStringListFromApiData(wordData['examples']));

      _wordController.text = _word;
      _phonaticController.text = _phonatic;
      _rootController.text = _root;
      _definitionController.text = _definition;
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper function to convert string to WordClass enum
  WordClass _getWordClassFromString(String? wordClassString) {
    if (wordClassString != null) {
      try {
        return WordClass.values.byName(wordClassString);
      } catch (e) {}
    }
    return WordClass.none;
  }

  // Helper function to extract string list from API data
  List<String> _getStringListFromApiData(dynamic apiData) {
    if (apiData is String) {
      return apiData.split(';').map((s) => s.trim()).toList();
    } else if (apiData is List) {
      return apiData.cast<String>();
    }
    return [];
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
                        onFieldSubmitted: (v) {
                          _fetchWordData(v);
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
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _rootController,
                            decoration: const InputDecoration(
                              label: Text("Root"),
                            ),
                            onSaved: (value) {
                              _root = value!;
                            },
                          ),
                          if (_isLoading) // Only show the loading indicator when isLoading is true
                            const PostionedLoadingWidget(),
                        ],
                      ),
                    )
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
                      child: Stack(
                        children: [
                          DropdownMenu<WordClass>(
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
                          if (_isLoading) // Only show the loading indicator when isLoading is true
                            const PostionedLoadingWidget(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          TextFormField(
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
                          if (_isLoading) // Only show the loading indicator when isLoading is true
                            const PostionedLoadingWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
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
                        if (_isLoading) // Only show the loading indicator when isLoading is true
                          const PostionedLoadingWidget(),
                      ],
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
                    Stack(
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
                            setState(() {
                              _usages.add(_usageController.text);
                              _usageController.clear();
                            });
                          },
                        ),
                        if (_isLoading) // Only show the loading indicator when isLoading is true
                          const PostionedLoadingWidget(),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _usages.map((meaning) {
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
                              Expanded(child: Text(meaning)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _usages.remove(meaning);
                                    });
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        TextFormField(
                          controller: _exampleController,
                          decoration: const InputDecoration(
                            label: Text('Examples'),
                          ),
                          onFieldSubmitted: (value) {
                            if (_examples.isEmpty &&
                                widget.examples.isNotEmpty) {
                              _examples = widget.examples;
                            }
                            setState(() {
                              _examples.add(_exampleController.text);
                              _exampleController.clear();
                            });
                          },
                        ),
                        if (_isLoading) // Only show the loading indicator when isLoading is true
                          const PostionedLoadingWidget(),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _examples.map((meaning) {
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
                              Expanded(child: Text(meaning)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _examples.remove(meaning);
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        );
                      }).toList(),
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
}
