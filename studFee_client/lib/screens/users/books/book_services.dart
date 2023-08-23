import 'dart:convert';

import 'package:studfees/models/books_model.dart';
import 'package:http/http.dart' as http;

class BookService {
  static const _baseUrl = 'https://openlibrary.org';

  Future<List<Book>> search(String query) async {
    http.Response response =
        await http.get(Uri.parse('$_baseUrl/search.json?q=$query'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);

      final List<Book> books = [];

      for (var item in data['docs']) {
        final book = Book.fromJson(item);
        books.add(book);
      }
      return books;
    } else {
      throw Exception('Failed to search books');
    }
  }
}
