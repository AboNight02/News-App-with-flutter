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
            id TEXT,
            userId INTEGER,
            title TEXT,
            description TEXT,
            imageUrl TEXT,
            source TEXT,
            publishedAt TEXT,
            PRIMARY KEY (id, userId),
            FOREIGN KEY (userId) REFERENCES users(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE comments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            articleId TEXT,
            userId INTEGER,
            content TEXT,
            createdAt TEXT,
            FOREIGN KEY (userId) REFERENCES users(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      final db = await database;
      await db.insert(
        'users',
        {
          'name': name,
          'email': email,
          'password': password,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
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

  // Update bookmark methods to include userId
  Future<void> saveBookmark(NewsArticle article, int userId) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {
        'id': article.title,
        'userId': userId,
        'title': article.title,
        'description': article.description,
        'imageUrl': article.imageUrl,
        'source': article.source,
        'publishedAt': article.publishedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeBookmark(String articleId, int userId) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'id = ? AND userId = ?',
      whereArgs: [articleId, userId],
    );
  }

  Future<List<NewsArticle>> getUserBookmarks(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return NewsArticle(
        title: maps[i]['title'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        source: maps[i]['source'],
        publishedAt: maps[i]['publishedAt'],
      );
    });
  }

  // Add methods for comments
  Future<void> addComment(String articleId, int userId, String content) async {
    final db = await database;
    await db.insert(
      'comments',
      {
        'articleId': articleId,
        'userId': userId,
        'content': content,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getComments(String articleId) async {
    final db = await database;
    return await db.query(
      'comments',
      where: 'articleId = ?',
      whereArgs: [articleId],
      orderBy: 'createdAt DESC',
    );
  }

  Future<String> getUserName(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.first['name'];
  }
}
