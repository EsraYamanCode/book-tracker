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
import '../widgets/delete_account_dialog.dart';
import 'reading_screen.dart';
import 'package:sayfa/core/utils/snackbar_utils.dart';

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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.accentGold),
            color: AppTheme.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white10),
            ),
            offset: const Offset(0, 45),
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(AuthLogoutRequested());
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              } else if (value == 'delete_account') {
                 DeleteAccountDialog.show(
                  context,
                  onConfirm: () {
                    context.read<AuthBloc>().add(AuthAccountDeleteRequested());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  },
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: AppTheme.accentGold),
                    SizedBox(width: 12),
                    Text(
                      'Çıkış Yap',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const PopupMenuItem<String>(
                value: 'delete_account',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Hesabımı Sil',
                      style: TextStyle(color: Colors.redAccent, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
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
            context.showErrorSnack(state.message);
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
              separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                    final isCompleted =
                        book.status.toLowerCase() == 'completed';
                    if (isCompleted) {
                      context.showSuccessSnack('Bu kitap tamamlandı');
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReadingScreen(book: book),
                      ),
                    );
                  },
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
