import 'package:flutter/material.dart';
import 'package:flutter_application_final/models/news_article.dart';
import 'package:flutter_application_final/pages/bookmarks_page.dart';
import 'package:flutter_application_final/widgets/NewsSearchDelegate.dart';
import 'package:flutter_application_final/widgets/news_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key, required this.title});

  final String title;

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List<NewsArticle> _articles = [];
  bool _isLoading = true;
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&category=$_selectedCategory&apiKey=a7b7ab362c9647b888d2af421868ec9f'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<NewsArticle> articles = (data['articles'] as List)
            .map((article) => NewsArticle(
                  title: article['title'] ?? 'No title',
                  description: article['description'] ?? 'No description',
                  imageUrl: article['urlToImage'] ??
                      'https://via.placeholder.com/150',
                  source: article['source']['name'] ?? 'Unknown source',
                  publishedAt: _formatDate(article['publishedAt']),
                ))
            .toList();

        setState(() {
          _articles = articles;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown time';
    try {
      final date = DateTime.parse(dateStr);
      final difference = DateTime.now().difference(date);
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    } catch (e) {
      return dateStr;
    }
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchNews();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(_articles),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _fetchNews,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'News Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Choose your interest',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildCategoryTile('General', Icons.public, 'general'),
              _buildCategoryTile('Business', Icons.business, 'business'),
              _buildCategoryTile('Sports', Icons.sports_basketball, 'sports'),
              _buildCategoryTile('Health', Icons.health_and_safety, 'health'),
              _buildCategoryTile('Technology', Icons.computer, 'technology'),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
            )
          : RefreshIndicator(
              color: Colors.blue[700],
              onRefresh: _fetchNews,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: NewsCard(article: _articles[index]),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookmarksPage()),
          );
        },
        tooltip: 'Bookmarks',
        child: const Icon(Icons.bookmark, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryTile(String title, IconData icon, String category) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            _selectedCategory == category ? Colors.blue[700] : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedCategory == category
              ? Colors.blue[700]
              : Colors.grey[800],
          fontWeight: _selectedCategory == category
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      selected: _selectedCategory == category,
      selectedTileColor: Colors.blue[50],
      onTap: () => _changeCategory(category),
    );
  }
}
