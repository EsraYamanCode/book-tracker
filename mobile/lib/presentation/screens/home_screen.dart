import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/book/book_bloc.dart';
import '../../blocs/book/book_event.dart';
import '../../blocs/book/book_state.dart';
import '../../core/constants/app_theme.dart';
import 'auth_screen.dart';
import '../widgets/book_card.dart';
import '../widgets/add_book_sheet.dart';
import 'reading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(BookFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitaplığım'),
        actions: [
          FloatingActionButton(
            heroTag: 'logoutButton',
            backgroundColor: AppTheme.accentGold,
            foregroundColor: AppTheme.background,
            shape: const CircleBorder(),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addBookButton',
        backgroundColor: AppTheme.accentGold,
        foregroundColor: AppTheme.background,
        shape: const CircleBorder(),
        onPressed: () {
          showAddBookDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<BookBloc, BookState>(
        listener: (context, state) {
          if (state is BookFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF723348),
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.accentGold),
            );
          }
          if (state is BookLoaded) {
            if (state.books.isEmpty) {
              return const Center(
                child: Text(
                  'Henüz kitap eklemedin.\nSağ alttaki butona basarak başlayabilirsin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.books.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final book = state.books[index];
                return BookCard(
                  book: book,
                  onDelete: () {
                    context.read<BookBloc>().add(
                      BookDeleteSubmitted(bookId: book.id),
                    );
                  },
                  onActionTap: () {
                    final isCompleted = book.status.toLowerCase() == 'completed';
                    if (isCompleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF723348),
                          content: Text('Bu kitap tamamlandı.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReadingScreen(book: book),
                      ),
                    );
                  }
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
