// ignore_for_file: public_member_api_docs, sort_constructors_first
class Book {
  final String title;
  final String coverUrl;
  final String url;
  final String author;
  // final List<String> author;
  // final String coverId;
  // final int publishYear;
  // final String language;
  // bool bookmarked;
  // List<Book> recommendedBooks;

  Book({
    required this.url,
    required this.title,
    required this.author,
    // required this.coverId,
    required this.coverUrl,
    // required this.publishYear,
    // required this.language,
    // this.bookmarked = false,
    // this.recommendedBooks = const [],
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      url: json['key'] ?? '',
      title: json['title'] ?? '',
      author: json['author_name'] != null ? json['author_name'][0] : '',
      // author: List<String>.from(
      //     (json['author_name'] as List<dynamic>).map((name) => name as String)),
      // coverId: json['cover_i']?.toString() ?? '',
      // publishYear: json['publish_year']?.isNotEmpty == true
      //     ? int.parse(json['publish_year'][0])
      //     : 0,
      // language: json['language']?.first ?? '',
      coverUrl: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg'
          : '',
    );
  }
}
