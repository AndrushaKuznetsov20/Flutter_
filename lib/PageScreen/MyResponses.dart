import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled5/Models/ModelAnnouncement.dart';
import 'package:untitled5/Models/ModelResponse.dart';
import 'package:untitled5/PageScreen/LkPageScreen.dart';
import 'package:untitled5/PageScreen/UserPageScreen.dart';
import "package:flutter_localizations/flutter_localizations.dart";

class MyResponses extends StatefulWidget {
  @override
  MyResponsestState createState() => MyResponsestState();
}

class MyResponsestState extends State<MyResponses> {
  ModelResponse? response;

  final headers = {'Content-Type': 'application/json'};
  List<ModelResponse> dataList = [];

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> listMyResponse() async {
    int? userId = await getUserId();
    final response = await http.get(Uri.parse('http://172.20.10.3:8092/api_responses/my_responses/$userId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ModelResponse>.from(jsonData.map((data) => ModelResponse.fromJson(data)));
      });
    }
  }
  Future<void> deleteAnnouncement(int? announcementId) async {
    final response = await http.delete(Uri.parse('http://172.20.10.3:8092/api_announcements/delete/$announcementId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    listMyResponse();
  }
  @override
  void initState() {
    super.initState();
    listMyResponse();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Список откликов'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LkPageScreen()),);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];
            return Card(
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Объявление: ${data?.announcement}'),
                    Text('Пользователь: ${data?.user_response}'),
                    SizedBox(height: 8),
                    ElevatedButton(
                      child: Text('Удалить'),
                      onPressed: () {
                        deleteAnnouncement(data?.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}