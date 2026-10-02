import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();
  @override
  List<Object?> get props => [];
}

class BookFetchRequested extends BookEvent {}

class BookCreateSubmitted extends BookEvent {
  final String title;
  final String author;
  final String coverColorHex;
  final String? coverImageUrl;

  const BookCreateSubmitted({
    required this.title,
    required this.author,
    required this.coverColorHex,
    this.coverImageUrl,
  });

  @override
  List<Object?> get props => [title, author, coverColorHex];
}

class BookDeleteSubmitted extends BookEvent {
  final int bookId;
  const BookDeleteSubmitted({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}
