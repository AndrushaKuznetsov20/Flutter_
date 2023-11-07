import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  bool isColor = false;

  List<ModelAnnouncement> dataList = [];

  Future<void> addAnnouncement() async {
    final response = await http.get(Uri.parse('http://172.20.10.3:8092/api_announcements/announcements_status_ok'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ModelAnnouncement>.from(jsonData.map((data) => ModelAnnouncement.fromJson(data)));
      });
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
              color: isColor ? Colors.red : Colors.teal,
              elevation: 15,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isColor = !isColor;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        utf8.decode(data.name.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        utf8.decode(data.description.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Условия и требования:',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        utf8.decode(data.conditions_and_requirements.codeUnits),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        child: Text('Отклик'),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );

          },
        ),
      ),
    );
  }
}
