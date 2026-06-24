# Implementation Plan - Firestore Secret Management

This plan outlines the changes to load the Groq API key from Firestore when the app starts and manage it across the session using Riverpod.

## User Review Required

> [!IMPORTANT]
> **Security Note:** Storing an API key in Firestore makes it easier to manage and update without a new build, but it can still be accessed by any user of your app if Firestore rules are not properly configured. Ensure your Firestore rules only allow reading the `secrets/secretKeys` document for authenticated users (or restrict it further if possible).

## Proposed Changes

### [Core/Providers]
Manage the Groq API key state.

#### [NEW] [secrets_provider.dart](file:///Users/Siddharth/Development/projects/vocabList/lib/providers/secrets_provider.dart)
- Create a `FutureProvider` that fetches the `groqApi` field from `secrets/secretKeys` in Firestore.

```dart
final groqApiKeyProvider = FutureProvider<String>((ref) async {
  final doc = await FirebaseFirestore.instance.collection('secrets').doc('secretKeys').get();
  final data = doc.data();
  if (data != null && data.containsKey('groqApi')) {
    return data['groqApi'] as String;
  }
  throw Exception('Groq API key not found in Firestore');
});
```

---

### [Services]
Update services to use the dynamically loaded key.

#### [word_details.dart](file:///Users/Siddharth/Development/projects/vocabList/lib/services/word_details.dart)
- Modify `getWordData` to accept the API key as an argument.
- Remove the dependency on `secrets.dart`.

```dart
Future<Map<String, dynamic>> getWordData(String word, String apiKey) async {
  // Use apiKey in headers
}
```

---

### [UI/Screens]
Ensure the key is loaded and passed to services.

#### [vocab_list.dart](file:///Users/Siddharth/Development/projects/vocabList/lib/screens/vocab_list.dart) (or where `getWordData` is called)
- Watch the `groqApiKeyProvider`.
- Pass the loaded key when calling `getWordData`.

---

## Verification Plan

### Manual Verification
- **Fetch Test:** Log messages to confirm the key is fetched successfully from Firestore on app startup.
- **Functionality Test:** Verify that searching for a word still works correctly (which confirms the dynamic key is being used for the API request).
- **Error Handling:** Check how the app behaves if the key is missing from Firestore (it should ideally show a clear error or fallback).
