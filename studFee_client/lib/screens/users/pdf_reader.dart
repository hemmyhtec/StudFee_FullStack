import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerWidget extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerWidget({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.pdfUrl,
            onRender: (pages) => setState(() {
              _isLoading = false;
              _totalPages = pages!;
            }),
            onPageChanged: (page, total) =>
                setState(() => _currentPage = page!),
            onViewCreated: (PDFViewController vc) => _pdfViewController = vc,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Page ${_currentPage + 1}/$_totalPages'),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () =>
                          _pdfViewController?.setPage(_currentPage - 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () =>
                          _pdfViewController?.setPage(_currentPage + 1),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
