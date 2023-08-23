import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:studfees/util/config.dart';
import 'dic_service.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  String _wordOfTheDay = '';
  String _searchTerm = '';
  List<dynamic> _searchResults = [];
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _getWordOfTheDay();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-UK');
    await flutterTts.speak(text);
  }

  Future<void> _getWordOfTheDay() async {
    final response = await DictionaryService.getWordOfTheDay();
    if (response != null && response is Map) {
      setState(() {
        _wordOfTheDay = response['word'];
      });
    }
  }

  Future<void> _performSearch() async {
    final results =
        await DictionaryService.getAdvancedSearchResults(_searchTerm);

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Dictionary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   margin: const EdgeInsets.all(16),
            //   child: Text(
            //     'Search: $_wordOfTheDay',
            //     style: const TextStyle(fontSize: 24),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.all(16),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  suffixStyle: const TextStyle(color: Colors.black54),
                  suffixIcon: IconButton(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.search),
                  ),
                  labelStyle:
                      const TextStyle(color: Colors.black54, fontSize: 20),
                  labelText: 'Search for a word',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 230, 230),
                  prefixIconColor: Colors.black54,
                  focusColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(10)),
                  errorBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      _searchTerm = value;
                    },
                  );
                },
              ),
            ),
            if (_searchResults.isNotEmpty)
              ListView.builder(
                // scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final idParts =
                      _searchResults[index]['meta']['id'].split(':');
                  final mainWord = idParts[0];
                  return Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              mainWord,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              color: Config.primaryColor,
                              onPressed: () {
                                _speak(mainWord);
                              },
                            ),
                          ],
                        ),
                        Text(
                          _searchResults[index]['fl'] ?? '',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 8),
                        Text(_searchResults[index]['shortdef'][0] ?? ''),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: _searchResults.isNotEmpty,
        child: BottomAppBar(
          elevation: 0,
          child: TextButton(
            child: const Text(
              'Clear List',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
            onPressed: () {
              setState(() {
                _searchResults.clear();
              });
            },
          ),
        ),
      ),
    );
  }
}
