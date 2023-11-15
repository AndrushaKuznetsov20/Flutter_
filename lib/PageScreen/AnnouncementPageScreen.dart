import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled5/Models/ModelAnnouncement.dart';
import 'package:untitled5/PageScreen/UserPageScreen.dart';
import "package:flutter_localizations/flutter_localizations.dart";

class AnnouncementPageScreen extends StatefulWidget {
  @override
  AnnouncementPageScreenState createState() => AnnouncementPageScreenState();
}

class AnnouncementPageScreenState extends State<AnnouncementPageScreen> {

  final url = Uri.parse('http://172.20.10.3:8092/api_announcements/announcements_status_ok');
  final headers = {'Content-Type': 'application/json'};

  List<ModelAnnouncement> dataList = [];

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  Future<void> addAnnouncement() async {
    final response = await http.get(Uri.parse('http://172.20.10.3:8092/api_announcements/announcements_status_ok'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ModelAnnouncement>.from(jsonData.map((data) => ModelAnnouncement.fromJson(data)));
      });
    }
  }
  Future<void> addResponse(int? announcementId, BuildContext context) async {
    int? userId = await getUserId();
    final response = await http.post(Uri.parse('http://172.20.10.3:8092/api_responses/addResponses/$announcementId/$userId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    addAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Список объявлений'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPageScreen()),);
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
                      Text(
                        utf8.decode(data.name.codeUnits),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        utf8.decode(data.description.codeUnits),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Условия и требования:',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        utf8.decode(data.conditions_and_requirements.codeUnits),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        child: Text('Отклик'),
                        onPressed: () {
                          addResponse(data.id, context);
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
