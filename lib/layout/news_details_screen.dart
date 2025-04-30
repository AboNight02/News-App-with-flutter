import 'package:flutter/material.dart';
import '../models/news.dart';

class NewsDetailsScreen extends StatelessWidget {
  final News news;

  NewsDetailsScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(news.imageUrl),
            SizedBox(height: 16),
            Text(
              news.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(news.description),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // فتح الرابط داخل المتصفح
                // نضيف هنا كود فتح الرابط
              },
              child: Text('قراءة المزيد'),
            ),
          ],
        ),
      ),
    );
  }
}
