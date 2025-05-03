import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/news_article.dart';
import '../widgets/news_card.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<NewsArticle> _bookmarkedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await _databaseHelper.getBookmarks();
    setState(() {
      _bookmarkedArticles = bookmarks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: _bookmarkedArticles.isEmpty
          ? const Center(
              child: Text(
                'No bookmarks yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _bookmarkedArticles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: NewsCard(article: _bookmarkedArticles[index]),
                );
              },
            ),
    );
  }
}
