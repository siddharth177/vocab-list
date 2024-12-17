import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocab_list/models/word_meaning.dart';
import 'package:vocab_list/utils/colors_and_theme.dart';

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
      padding: const EdgeInsets.all(10),
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? kDarkBlackShade2
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.wordMeaning.word[0].toUpperCase() +
                              widget.wordMeaning.word.substring(1).toLowerCase(),
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? kDarkWhiteShade1
                                : null,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          FlutterTts().speak(widget.wordMeaning.word);
                        },
                        icon: Icon(
                          Icons.record_voice_over,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkWhiteShade1
                              : null,
                        ),
                      ),
                    ],
                  ),
                  if (widget.wordMeaning.definition.isNotEmpty)
                    Text(widget.wordMeaning.definition,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkWhiteShade2
                              : null,
                        )),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.wordMeaning.root.isNotEmpty)
                    Text(widget.wordMeaning.root,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkWhiteShade2
                              : null,
                        )),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.wordMeaning.phonatic.isNotEmpty)
                    Text(widget.wordMeaning.phonatic,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkWhiteShade2
                              : null,
                        )),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.wordMeaning.usages.isNotEmpty)
                    Text('Usages',
                        style: GoogleFonts.poppins(
                          // fontWeight: FontWeight.w400,
                          fontSize: 26,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkWhiteShade1
                              : null,
                        )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.wordMeaning.usages
                        .map(
                          (meaning) => Text(
                            meaning,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? kDarkWhiteShade2
                                  : null,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.wordMeaning.examples.isNotEmpty)
                    Text('Examples',
                        style: GoogleFonts.roboto(
                          fontSize: 26,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkWhiteShade1
                              : null,
                        )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.wordMeaning.examples
                        .map((meaning) => Text(
                              meaning,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? kDarkWhiteShade2
                                    : null,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
