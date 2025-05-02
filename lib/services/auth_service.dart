import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  String name='Yamani';
  UserModel? _currentUser;
  bool _isLoading = false;
 
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    name=email; //to check
    notifyListeners();


    // TODO: Implement actual login logic with your backend
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // For demo purposes, we'll create a mock user
    _currentUser = UserModel(
      id: '1',
      name: 'Yamani',
      email: email,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // TODO: Implement actual registration logic with your backend
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // For demo purposes, we'll create a mock user
    _currentUser = UserModel(
      id: '1',
      name: name,
      email: email,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
} 