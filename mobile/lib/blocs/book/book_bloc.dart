import '../../data/repositories/book_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'book_state.dart';
import 'book_event.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _bookRepository;

  BookBloc({required BookRepository bookRepository})
    : _bookRepository = bookRepository,
      super(BookInitial()) {
    on<BookFetchRequested>(_onBookFetchRequested);
    on<BookCreateSubmitted>(_onBookCreateSubmitted);
    on<BookDeleteSubmitted>(_onBookDeleteSubmitted);
  }

  Future<void> _onBookFetchRequested(
    BookFetchRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    try {
      final books = await _bookRepository.getBooks();
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onBookCreateSubmitted(
    BookCreateSubmitted event,
    Emitter<BookState> emit,
  ) async {
    try {
      await _bookRepository.createBook(
        title: event.title,
        author: event.author,
        coverColorHex: event.coverColorHex,
        coverImageUrl: event.coverImageUrl,
      );
      final updatedBooks = await _bookRepository.getBooks();
      emit(BookLoaded(books: updatedBooks));
    } catch (e) {
      emit(BookFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onBookDeleteSubmitted(
    BookDeleteSubmitted event,
    Emitter<BookState> emit,
  ) async {
    try {
      await _bookRepository.deleteBook(event.bookId);
      final updatedBooks = await _bookRepository.getBooks();
      emit(BookLoaded(books: updatedBooks));
    } catch (e) {
      emit(BookFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
