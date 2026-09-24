
class SessionModel {
  final int id;
  final int bookId;
  final int durationSeconds;
  final String? notes;
 final DateTime createdAt;

  SessionModel({
    required this.id,
    required this.bookId,
    required this.durationSeconds,
    this.notes,
    required this.createdAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as int,
      bookId: json['bookId'] as int,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
