import 'dart:convert';
import 'package:http/http.dart' as http;

class DictionaryService {
  static const _baseUrl =
      'https://www.dictionaryapi.com/api/v3/references/collegiate/json';
  static const _apiKey = '9c3b151e-629e-49d7-969d-b969c915a8b2';

  static Future<List<dynamic>> getAdvancedSearchResults(
    String word, {
    bool includeSynonyms = false,
    bool includeAntonyms = false,
    bool includeExamples = false,
  }) async {
    final queryParams = <String, String>{'key': _apiKey};

    if (includeSynonyms) {
      queryParams['syn'] = 'true';
    }

    if (includeAntonyms) {
      queryParams['ant'] = 'true';
    }

    if (includeExamples) {
      queryParams['examples'] = 'true';
    }

    final url = '$_baseUrl/$word?${Uri(queryParameters: queryParams).query}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);
      if (jsonResponse is List) {
        return jsonResponse;
      } else {
        return [jsonResponse];
      }
    } else {
      throw Exception('Failed to retrieve search results');
    }
  }

  static getWordOfTheDay() {}
}
