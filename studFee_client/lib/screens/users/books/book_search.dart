import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:studfees/models/books_model.dart';

import 'book_reader.dart';
import 'book_services.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final BookService _bookService = BookService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Book> _books = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _searchBooks(String query) async {
    setState(() => _isLoading = true);
    try {
      final books = await _bookService.search(query);
      setState(() {
        _books = books;
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSearchBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
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
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for books',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _searchBooks(_searchController.text),
              ),
            ),
            onSaved: ((newValue) => _searchBooks(newValue.toString())),
          ),
        ),
      ],
    );
  }

  Widget _buildBookListItem(Book book) {
    Future<String> getFilePath() async {
      final file = await DefaultCacheManager().getSingleFile(book.url);
      // print(file);
      return file.path;
    }

    return GestureDetector(
      onTap: () async {
        final filePath = await getFilePath();
        // print(filePath);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookReaderScreen(filePath: filePath),
          ),
        );
      },
      child: ListTile(
        leading: book.coverUrl.isNotEmpty ? Image.network(book.coverUrl) : null,
        title: Text(book.title),
        subtitle: Text(book.author),
      ),
    );
  }

  Widget _buildBookList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _books.length,
      itemBuilder: (context, index) => _buildBookListItem(_books[index]),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
                child: _isLoading ? _buildLoadingIndicator() : _buildBookList())
          ],
        ),
      ),
    );
  }
}
