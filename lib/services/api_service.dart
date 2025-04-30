import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class ApiService {
  static const String baseUrl =
      'https://680cbd832ea307e081d4e526.mockapi.io/api/v1/news';

  // جلب الأخبار من الـ API
  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((news) => News.fromJson(news)).toList();
    } else {
      throw Exception('فشل تحميل الأخبار');
    }
  }

  // إضافة خبر جديد
  Future<void> addNews(News news) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(news.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل إضافة الخبر');
    }
  }

  // تعديل خبر
  Future<void> updateNews(String id, News news) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(news.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('فشل تعديل الخبر');
    }
  }

  // حذف خبر
  Future<void> deleteNews(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('فشل حذف الخبر');
    }
  }
}
