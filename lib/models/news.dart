class News {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String url;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
  });

  // تحويل JSON إلى نموذج Dart
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      url: json['url'],
    );
  }

  // تحويل النموذج إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'url': url,
    };
  }
}
