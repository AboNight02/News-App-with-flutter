import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/news_article.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'news_bookmarks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE bookmarks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            imageUrl TEXT,
            source TEXT,
            publishedAt TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertBookmark(NewsArticle article) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {
        'title': article.title,
        'description': article.description,
        'imageUrl': article.imageUrl,
        'source': article.source,
        'publishedAt': article.publishedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookmark(String title) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<bool> isBookmarked(String title) async {
    final db = await database;
    final result = await db.query(
      'bookmarks',
      where: 'title = ?',
      whereArgs: [title],
    );
    return result.isNotEmpty;
  }

  Future<List<NewsArticle>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) {
      return NewsArticle(
        title: maps[i]['title'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        source: maps[i]['source'],
        publishedAt: maps[i]['publishedAt'],
        isBookmarked: true,
      );
    });
  }
}
