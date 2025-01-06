import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocab_list/utils/secrets.dart';

Future<Map<String, dynamic>> getWordData(String word) async {
  final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
  final headers = {
    'Authorization': kGroqApiKey,
    'Content-Type': 'application/json',
  };
  final body = json.encode({
    "messages": [
      {
        "role": "system",
        "content": "you are a dictionary that provides definition, root, usages, type of word (noun, verb, etc.) and examples (examples should also include some from different possible tenses for the word (eg: in past tense, in gerund form, in future tense, in past perfect etc) of the word provided in JSON format as described below. {\"definition\": \"definition of the word\",\"usages\": \"usages of the word\",\"root\": \"root of the word\",\"examples\": \"examples of the word\",\"wordType\": \"type of word\"}. The definition, usages, examples could be multiple, separate by;ex {\"definition\": \"definition1; definition2\",\"usages\": \"usages1; usage2\",\"root\": \"root of the word\",\"examples\": \"examples1; example2\",\"wordType\": \"type of word\"}. wordType should be from (verb, noun, determiner, adjective, adverb, preposition, conjunction, none)"
      },
      {
        "role": "user",
        "content": word
      }
    ],
    "model": "llama-3.3-70b-versatile",
    "temperature": 0.2,
    "max_tokens": 1024,
    "top_p": 1,
    "stream": false,
    "response_format": {
      "type": "json_object"
    },
    "stop": null
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return json.decode(responseData['choices'][0]['message']['content']);
    } else {
      throw Exception('Failed to load data from llama');
    }
  } catch (e) {
    throw Exception('Failed to get data from llama.: $e' );
  }
}