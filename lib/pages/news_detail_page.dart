import 'package:flutter/material.dart';
import 'package:flutter_application_final/models/news_article.dart';
import 'package:flutter_application_final/services/auth_service.dart';
import 'package:share_plus/share_plus.dart';
// First run: flutter pub add shared_preferences
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

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
            onPressed: _toggleBookmark, // Use the existing toggle function
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
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final likedArticles =
                      prefs.getStringList('liked_articles') ?? [];
                  final articleJson = _getArticleJson();

                  setState(() {
                    if (likedArticles.contains(articleJson)) {
                      likedArticles.remove(articleJson);
                      _showSnackBar('Removed from liked articles');
                    } else {
                      likedArticles.add(articleJson);
                      _showSnackBar('Added to liked articles');
                    }
                  });

                  await prefs.setStringList('liked_articles', likedArticles);
                },
              ),
              // In the NewsDetailPage class, update the comment button:
              _buildActionButton(
                icon: Icons.comment_outlined,
                label: 'Comment',
                onPressed: () {
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  if (authService.currentUser != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: CommentSection(
                          articleId: widget.article.title,
                          userId: int.parse(
                              authService.currentUser?.id ?? '0'),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login to comment')),
                    );
                  }
                },
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

class CommentSection extends StatefulWidget {
  final String articleId;
  final int userId;

  const CommentSection({
    super.key,
    required this.articleId,
    required this.userId,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = TextEditingController();

  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final commentsJson =
        prefs.getStringList('comments_${widget.articleId}') ?? [];
    final loadedComments = commentsJson
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();
    setState(() {
      comments = loadedComments;
    });
  }

  Future<void> _addComment() async {
    if (_commentController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final commentsJson =
          prefs.getStringList('comments_${widget.articleId}') ?? [];
      final newComment = {
        'userId': widget.userId,
        'content': _commentController.text,
        'createdAt': DateTime.now().toIso8601String(),
      };
      commentsJson.add(jsonEncode(newComment));
      await prefs.setStringList('comments_${widget.articleId}', commentsJson);
      _commentController.clear();
      await _loadComments();
    }
  }

  Future<String> _getUserName(int userId) async {
    return 'User ${userId.toString()}';
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${comments.length}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to comment',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return FutureBuilder<String>(
                        future: _getUserName(comment['userId']),
                        builder: (context, snapshot) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue[100],
                                      radius: 16,
                                      child: Text(
                                        (snapshot.data ?? 'U')[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      snapshot.data ?? 'User',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatDate(
                                          DateTime.parse(comment['createdAt'])),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  comment['content'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    color: Colors.white,
                    onPressed: _addComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
