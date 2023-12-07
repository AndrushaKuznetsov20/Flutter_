import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled5/PageScreen/HomeScreen.dart';
class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Регистрация',style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.deepPurple),
                labelText: 'Имя',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.deepPurple),
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: numberPhoneController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.deepPurple),
                labelText: 'Номер телефона',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.deepPurple),
                labelText: 'Пароль',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                register(context);
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register(BuildContext context) async {
    String name = usernameController.text;
    String password = passwordController.text;
    String email = emailController.text;
    String numberPhone = numberPhoneController.text;

    final url = Uri.parse('http://172.20.10.3:8092/api_users/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'numberPhone': numberPhone,
      'email': email,
      'password': password
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
      Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else
    {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Text('Ошибка!'),
         content: Text('Пользователь с таким именем уже существует!'),
         actions: [
           TextButton(
             onPressed: () {
               Navigator.pop(context);
             },
             child: Text('OK'),
           ),
         ],
       ),
     );
 }
}
}