import 'package:flutter/material.dart';
import 'package:flutter_application_final/models/news_article.dart';
import 'package:share_plus/share_plus.dart';
// First run: flutter pub add shared_preferences
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NewsDetailPage extends StatefulWidget {
  final NewsArticle article;

  const NewsDetailPage({super.key, required this.article});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks') ?? [];
    final articleJson = _getArticleJson();
    setState(() {
      isBookmarked = bookmarks.contains(articleJson);
    });
  }

  String _getArticleJson() {
    return jsonEncode({
      'title': widget.article.title,
      'description': widget.article.description,
      'imageUrl': widget.article.imageUrl,
      'source': widget.article.source,
      'publishedAt': widget.article.publishedAt,
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks') ?? [];
    final articleJson = _getArticleJson();

    setState(() {
      if (isBookmarked) {
        bookmarks.remove(articleJson);
        isBookmarked = false;
        _showSnackBar('Article removed from bookmarks');
      } else {
        bookmarks.add(articleJson);
        isBookmarked = true;
        _showSnackBar('Article saved to bookmarks');
      }
    });

    await prefs.setStringList('bookmarks', bookmarks);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            padding: EdgeInsets.zero,
            onPressed: _toggleBookmark,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.article.imageUrl.isNotEmpty)
                  Hero(
                    tag: widget.article.imageUrl,
                    child: Image.network(
                      widget.article.imageUrl,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.error_outline, size: 50),
                          ),
                        );
                      },
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                          child: child,
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                Transform.translate(
                  offset: const Offset(0, -50),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 20.0,
                      bottom: 80.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.article.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.article.source,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.article.publishedAt,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          widget.article.description.isEmpty
                              ? 'No description available'
                              : widget.article.description,
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.6,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -4),
                blurRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.thumb_up_outlined,
                label: 'Like',
                onPressed: () => _showSnackBar('You liked this article'),
              ),
              _buildActionButton(
                icon: Icons.comment_outlined,
                label: 'Comment',
                onPressed: () => _showSnackBar('Comments feature coming soon'),
              ),
              _buildActionButton(
                icon: Icons.share,
                label: 'Share',
                onPressed: () async {
                  try {
                    final String shareContent =
                        '${widget.article.title}\n\n${widget.article.description.isEmpty ? 'No description available' : widget.article.description}\n\nSource: ${widget.article.source}';
                    await Share.share(shareContent,
                        subject: widget.article.title);
                  } catch (e) {
                    _showSnackBar('Failed to share: ${e.toString()}');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
