import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'layout/home_screen.dart';
import 'pages/login_page.dart';
import 'pages/welcome_page.dart';
import 'services/auth_service.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const WelcomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
