import 'package:flutter/material.dart';
import 'package:untitled5/PageScreen/LoginScreen.dart';
import 'package:untitled5/PageScreen/RegisterScreen.dart';
import 'package:untitled5/PageScreen/HomeScreen.dart';
import 'package:untitled5/PageScreen/AdminPageScreen.dart';
import 'PageScreen/ModerPageScreen.dart';
import 'PageScreen/UserPageScreen.dart';
import 'PageScreen/AnnouncementPageScreen.dart';
import 'PageScreen/LkPageScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поиск вакансий',
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin_page': (context) => AdminPageScreen(),
        '/moder_page': (context) => ModerPageScreen(),
        '/user_page': (context) => UserPageScreen(),
        '/announcement_page': (context) => AnnouncementPageScreen(),
        '/LkPageScreen': (context) => LkPageScreen(),
      },
    );
  }
}
