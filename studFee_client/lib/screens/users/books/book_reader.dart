import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class BookReaderScreen extends StatefulWidget {
  final String filePath;

  const BookReaderScreen({required this.filePath, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookReaderScreenState createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  // late PDFDocument _document;
  late PDFView _pdfView;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    // final file = File(widget.filePath);
    _pdfView = PDFView(
      filePath: widget.filePath,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pdfView,
    );
  }
}
