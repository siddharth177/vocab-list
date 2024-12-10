import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getWordData(String word) async {
  // Define the API URL
  final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

  // Define the request headers
  final headers = {
    'Authorization': 'Bearer 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',
    'Content-Type': 'application/json',
  };

  // Define the request body
  final body = json.encode({
    "messages": [
      {
        "role": "system",
        "content": "you are a dictionary that provides definition, root, phonetic, usages, type of word (noun, verb, etc.) and examples of the word provided in JSON format as provided below.\n\n{\n\"d\": \"definition of the word\",\n\"u\": \"usages of the word\",\n\"r\": \"root of the word\",\n\"e\": \"examples of the word\"\n\"p\": \"phonetic for the word\",\n\"t\": \"type of word\"\n}\n\nthe definition, usages, examples could be multiple, separate by;\nex\n{\n\"d\": \"definition1; definition2\",\n\"u\": \"usages1; usage2\",\n\"r\": \"root of the word\",\n\"e\": \"examples1; example2\"\n\"p\": \"phonetic for the word\",\n\"t\": \"type of word\"\n}"
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

  // Make the API call using a POST request
  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the response JSON
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to load data from llama');
    }
  } catch (e) {
    throw Exception('Failed to get data from llama.: $e' );
  }
}