

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/Models/ModelUser.dart';
import 'package:untitled5/PageScreen/MyAnnouncement.dart';
import 'package:untitled5/PageScreen/MyResponses.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'HomeScreen.dart';

class LkPageScreen extends StatefulWidget {
  @override
  _LkPageScreenState createState() => _LkPageScreenState();
}

class _LkPageScreenState extends State<LkPageScreen> {

  ModelUser? user;
  final picker = ImagePicker();
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    fingByUser();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> uploadImage() async {
    int? userId = await getUserId();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      var request = http.MultipartRequest('POST', Uri.parse('http://172.20.10.3:8092/api_users/user/$userId/avatar'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          avatarUrl = 'http://172.20.10.3:8092/api_users/user/$userId/avatar';
        });
      } else {
        // Handle error
      }
    }
  }
  // Future<String?> getUserRole() async {
  //   final prefsRole = await SharedPreferences.getInstance();
  //   return prefsRole.getString('role');
  // }

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
              if (avatarUrl.isNotEmpty)
                Image.network(avatarUrl),
              ElevatedButton(
                onPressed: uploadImage,
                child: Text('Обновить аватар'),
              ),
              // ElevatedButton(
              //   onPressed: updateImage,
              //   child: Text('Update Image'),
              // ),
              Text('Личный идентификатор: ${user?.id}'),
              Text('Имя: ${user?.name}'),
              Text('Email: ${user?.email}'),
              Text('Email: ${user?.numberPhone}'),
              Text('Активность: ${user?.active}'),
              Text('Роль: ${user?.roles}'),
              // Text('Объявления: ${user?.announcements}'),
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
            if(user != null && user!.roles.contains("ROLE_USER"))...[
              SizedBox(height: 8,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyAnnouncement(),
                    ),
                  );
                  },
                child: Text('Мои объявления'),
              ),
              ],
              SizedBox(height: 8,),
              if(user != null && user!.roles.contains("ROLE_USER"))...[
              ElevatedButton(
                onPressed: () {
                  //for(String role in user!.roles) {
                  //if(role == "ROLE_USER")[
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyResponses(),
                    ),
                  );
                  // ];
                  //}
                },
                child: Text('Избранное'),
              ),
               ],
            ]
          ),
        ),
      );
    }
  }