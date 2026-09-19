class BookModel {
  final int id;
  final String title;
  final String author;
  final String coverColorHex;
  final String status;
  final int totalReadingSeconds;
  final String formattedTotalTime;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.coverColorHex,
    required this.status,
    required this.totalReadingSeconds,
    required this.formattedTotalTime,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      coverColorHex: json['coverColorHex'] as String,
      status: json['status'] as String,
      totalReadingSeconds: json['totalReadingSeconds'] as int? ?? 0,
      formattedTotalTime: json['formattedTotalTime'] as String? ?? '0 dk',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverColorHex': coverColorHex,
      'status': status,
      'totalReadingSeconds': totalReadingSeconds,
      'formattedTotalTime': formattedTotalTime,
    };
  }
}