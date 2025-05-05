import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = false;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;

  Future<bool> register(String name, String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if email already exists
      final db = await _databaseHelper.database;
      final existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existingUser.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final success = await _databaseHelper.registerUser(name, email, password);
      if (success) {
        _currentUser = UserModel(
          id: '', // This will be updated once we get the ID from the database
          name: name,
          email: email,
        );
        // Get the newly created user's ID
        final user = await db.query(
          'users',
          where: 'email = ?',
          whereArgs: [email],
        );
        if (user.isNotEmpty) {
          _currentUser = UserModel(
            id: user.first['id'].toString(),
            name: _currentUser!.name,
            email: _currentUser!.email,
          );
          print('User registered successfully with ID: ${_currentUser!.id}');
        }
      } else {
        print('Registration failed in DatabaseHelper');
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      print('Registration error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _databaseHelper.loginUser(email, password);
      if (user != null) {
        _currentUser = UserModel(
          id: user['id'].toString(),
          name: user['name'],
          email: user['email'],
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      _currentUser = null;
      notifyListeners();
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}
