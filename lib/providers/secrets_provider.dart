import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groqApiKeyProvider = FutureProvider<String>((ref) async {
  final doc = await FirebaseFirestore.instance
      .collection('secrets')
      .doc('secretKeys')
      .get();
  
  final data = doc.data();
  if (data != null && data.containsKey('groqApi')) {
    return data['groqApi'] as String;
  }
  throw Exception('Groq API key not found in Firestore');
});
