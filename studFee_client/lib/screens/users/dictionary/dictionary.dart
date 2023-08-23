import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../models/dictionary_model.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  String _searchWord = '';
  ApiResponse? _response;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Dictionary App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a word',
              ),
              onChanged: (value) {
                _searchWord = value;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                ApiResponse response = await fetchWord(_searchWord);
                setState(() {
                  _response = response;
                });
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            if (_response != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _response!.word!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _response!.definition!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (_response!.example!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Example: ${_response!.example}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  if (_response!.pronunciation!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Pronunciation: /${_response!.pronunciation}/',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  if (_response!.audioUrl!.isNotEmpty)
                    InkWell(
                      onTap: () async {
                        final url = _response!.audioUrl;
                        if (url != null) {
                          final result = await player.play(UrlSource(url));
                          // if (result == 1) {
                          //   // success
                          // } else {
                          //   // failure
                          // }
                        }
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.volume_up),
                          SizedBox(width: 8),
                          Text('Play audio'),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<ApiResponse> fetchWord(String word) async {
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en_US/$word'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse.isNotEmpty) {
        final wordData = jsonResponse[0];
        return ApiResponse(
          word: wordData['word'] ?? '',
          definition: wordData['meanings'][0]['definitions'][0]['definition'],
          example: wordData['meanings'][0]['definitions'][0]['example'] ?? '',
          pronunciation: wordData['phonetics'][0]['text'],
          audioUrl: wordData['phonetics'][0]['audio'] ?? '',
        );
      } else {
        throw Exception('Word not found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
