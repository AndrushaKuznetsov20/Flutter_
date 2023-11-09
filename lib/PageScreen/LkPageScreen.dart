import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/Models/ModelUser.dart';
import 'dart:convert';

import 'HomeScreen.dart';

class LkPageScreen extends StatefulWidget {
  @override
  _LkPageScreenState createState() => _LkPageScreenState();
}

class _LkPageScreenState extends State<LkPageScreen> {

  ModelUser? user;

  @override
  void initState() {
    super.initState();
    fingByUser();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> fingByUser() async
  {
    int? userId = await getUserId();
    final response = await http.get(Uri.parse('http://172.20.10.3:8092/api_users/user/$userId'));
    if (response.statusCode == 200)
    {
      final jsonData = jsonDecode(response.body);
      setState(() {
        user = ModelUser.fromJson(jsonData);
      });
    }
    else
    {
      throw Exception('Ошибка загрузки пользователя!');
    }
  }
//dfdf
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Профиль'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Личный идентификатор: ${user?.id}'),
              Text('Имя: ${user?.name}'),
              Text('Email: ${user?.email}'),
              Text('Активность: ${user?.active}'),
              Text('Роль: ${user?.roles}'),
              SizedBox(height: 8,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                child: Text('Выйти'),
              ),
            ],
          ),
        ),
      );
    }
  }