import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts __tts = FlutterTts();
speakAloud(word) {
  __tts.speak(word);
}