// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studfees/components/button.dart';
import 'package:studfees/components/custom_textfield.dart';
import 'package:studfees/util/navigator.dart';
import 'package:http/http.dart' as http;

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-library',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Search your favourite book...',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomTextField(
                      editingController: _searchController,
                      textInputType: TextInputType.name,
                      labelText: 'Search',
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Feild cant be empty';
                        }
                        return null;
                      },
                      isPassword: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: CustomElevated(
                      buttonText: 'Search',
                      icon: Icons.search,
                      function: () async {
                        var query = _searchController.text;
                        var books = await _searchBooks(query);
                        setState(() {
                          _books = books;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (BuildContext context, int index) {
                var book = _books[index];
                // print(book);
                return ListTile(
                  leading: book['volumeInfo']['imageLinks'] != null &&
                          book['volumeInfo']['imageLinks']['thumbnail'] != null
                      ? CachedNetworkImage(
                          imageUrl: book['volumeInfo']['imageLinks']
                              ['thumbnail'],
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const SizedBox.shrink(),
                  title: Text(book['volumeInfo']['title']),
                  subtitle:
                      Text(book['volumeInfo']['authors']?.join(', ') ?? ''),
                  onTap: () {
                    nextScreen(context, BookDetailScreen(book: book));
                  },
                );
              },
            ),
      bottomNavigationBar: Visibility(
        visible: _books.isNotEmpty,
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
                _books = [];
                _searchController.clear();
              });
            },
          ),
        ),
      ),
    );
  }
}

Future<List<dynamic>> _searchBooks(String query) async {
  dynamic url = Uri.https('www.googleapis.com', '/books/v1/volumes',
      {'q': query, 'key': 'AIzaSyC8y20rUn5ZqJgdM5QjsT14gdnezWkSgz0'});

  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    dynamic data = jsonDecode(response.body);
    // print(data['items']);
    return data['items'];
  } else {
    throw Exception('Failed to search for books');
  }

  // var url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=search-terms&AIzaSyC8y20rUn5ZqJgdM5QjsT14gdnezWkSgz0');
}

class BookDetailScreen extends StatelessWidget {
  final dynamic book;
  const BookDetailScreen({
    Key? key,
    required this.book,
  }) : super(key: key);

  // Future<void> _launchURL(Uri url) async {
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<String> getPdfUrlFromAcsm(String acsmUrl) async {
    // Download the acsm file
    final response = await http.get(Uri.parse(acsmUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to download ACSM file');
    }

    // Save the acsm file to the device
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/book.acsm');
    await file.writeAsBytes(response.bodyBytes);

    // Read the acsm file content and extract the PDF URL
    final acsmData = await file.readAsString();
    final regex = RegExp(r'<media:src>(.+\.pdf)</media:src>');
    final match = regex.firstMatch(acsmData);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    }
    throw Exception('Failed to extract PDF URL from ACSM file');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(book['volumeInfo']['title']?.toString() ?? ''),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CachedNetworkImage(
              imageUrl:
                  book['volumeInfo']['imageLinks']['thumbnail']?.toString() ??
                      '',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'By ${book['volumeInfo']['authors']?.join(', ')}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Rating: ${book['volumeInfo']['averageRating']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.amber, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              book['volumeInfo']['description']?.toString() ?? '',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                var pdfInfo = book['accessInfo']['pdf'];
                var pdfInfo2 = book['accessInfo'];
                if (pdfInfo != null && pdfInfo.containsKey('acsTokenLink')) {
                  // String acsmUrl = pdfInfo['acsTokenLink'];
                  // print(acsmUrl);
                  try {
                    // ignore: unused_local_variable
                    final pdfUrl = await getPdfUrlFromAcsm(
                        book['accessInfo']['pdf']['acsTokenLink']);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           PdfViewerWidget(pdfUrl: pdfUrl)),
                    // );
                  } catch (e) {
                    // print('Failed to extract PDF URL: $e');
                  }
                  // String pdfUrl = await getPdfUrlFromAcsm(acsmFile);
                  // ignore: use_build_context_synchronously

                } else if (pdfInfo2 != null &&
                    pdfInfo.containsKey('webReaderLink')) {
                  // print('Load web');
                } else {
                  // print('PDF download link not available');
                }
              },
              child: const Text(
                'Read Book',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
