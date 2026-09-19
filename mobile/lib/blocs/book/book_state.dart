import 'package:equatable/equatable.dart';
import 'package:sayfa/data/models/book_model.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<BookModel> books;

  const BookLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

class BookFailure extends BookState {
  final String message;

  const BookFailure({required this.message});

  @override
  List<Object> get props => [message];
}