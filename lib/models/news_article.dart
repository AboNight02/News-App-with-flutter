class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  bool isBookmarked;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    this.isBookmarked = false,
  });

  // Add these methods for database operations
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }

  static NewsArticle fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'] ?? 'assets/images/placeholder.png', // Use local placeholder
      source: map['source'],
      publishedAt: map['publishedAt'],
      isBookmarked: map['isBookmarked'] == 1,
    );
  }
}
