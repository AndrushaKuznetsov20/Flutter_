import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/Models/ModelLogin.dart';
import 'package:untitled5/PageScreen/ModerPageScreen.dart';
import 'package:untitled5/PageScreen/UserPageScreen.dart';
import 'package:untitled5/PageScreen/AdminPageScreen.dart';
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Введите имя',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Введите пароль',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
     String name = usernameController.text;
     String password = passwordController.text;

     final url = Uri.parse('http://172.20.10.3:8092/api_users/login');
     final headers = {'Content-Type': 'application/json'};
     final body = jsonEncode({
       'name': name,
       'password': password,
     });

     final response = await http.post(url, headers: headers, body: body);

     if (response.statusCode == 200) {

       ModelLogin modelLogin = ModelLogin.fromJson(json.decode(response.body));

       List roles = modelLogin.roles;
       int userId = modelLogin.id;

       Future<void> saveUserId(int userId) async {
         final prefs = await SharedPreferences.getInstance();
         await prefs.setInt('userId', userId);
       }
      saveUserId(userId);

       // SharedPreferences prefs = await SharedPreferences.getInstance();
       // await prefs.setInt('id', userId);

       for (String role in roles)
       {
         if (role == 'ROLE_USER')
         {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => UserPageScreen()),
           );
         }
         if (role == 'ROLE_ADMIN') {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => AdminPageScreen()),
           );
         }
         if (role == 'ROLE_MODER') {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => ModerPageScreen()),
           );
         }
         // Future<void> saveUserRole(String role) async {
         //   final prefsRole = await SharedPreferences.getInstance();
         //   await prefsRole.setString('role', role);
         // }
         // saveUserRole("ROLE_USER");
       }
     }
  }
}