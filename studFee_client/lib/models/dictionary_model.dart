class ApiResponse {
  final String? word;
  final String? definition;
  final String? example;
  final String? pronunciation;
  final String? audioUrl;

  ApiResponse({
    required this.word,
    required this.definition,
    required this.example,
    required this.pronunciation,
    required this.audioUrl,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      word: json['word'],
      definition: json['definitions'][0]['definition'],
      example: json['definitions'][0]['example'],
      pronunciation: json['pronunciation'],
      audioUrl: json['phonetics'][0]['audio'],
    );
  }
}
