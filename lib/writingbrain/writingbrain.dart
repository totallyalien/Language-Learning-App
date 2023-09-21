import 'dart:convert';

class WritingBrain{


Future<String?> extractTextFromImage(String imageUrl, String apiKey) async {
  final url = 'https://vision.googleapis.com/v1/images:annotate';
  final headers = {'Content-Type': 'application/json'};
  final requestBody = {
    'requests': [
      {
        'image': {'source': {'imageUri': imageUrl}},
        'features': [{'type': 'TEXT_DETECTION'}],
      }
    ]
  };

  try {
    final response = await http.post(
      Uri.parse('$url?key=$apiKey'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      if (decodedResponse['responses'][0]['textAnnotations'] != null) {
        return decodedResponse['responses'][0]['textAnnotations'][0]['description'];
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to extract text. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to extract text: $e');
  }
}


}