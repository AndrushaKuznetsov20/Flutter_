import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled5/Models/ModelAnnouncement.dart';
import 'package:untitled5/PageScreen/UserPageScreen.dart';
import "package:flutter_localizations/flutter_localizations.dart";

import '../Models/ModelUser.dart';
import 'ResponseButton.dart';

class AnnouncementPageScreen extends StatefulWidget {
  @override
  AnnouncementPageScreenState createState() => AnnouncementPageScreenState();
}

class AnnouncementPageScreenState extends State<AnnouncementPageScreen> {

  final url = Uri.parse('http://172.20.10.3:8092/api_announcements/announcements_status_ok');
  final headers = {'Content-Type': 'application/json'};

  List<ModelAnnouncement> dataList = [];
  ModelUser? user;

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
  _blockButton() async{
    int? user = 0;
    user = await getUserId();
    return user;
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Список объявлений', style: TextStyle(color: Colors.white)),
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
                      Row(
                        children: [
                          Text(
                            'Наименование: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.name.codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                       ]
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Описание: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            utf8.decode(data.description.codeUnits),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
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
                        ]
                      ),
                      FutureBuilder<int?>(
                        future: getUserId(),
                        builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              int? userId = snapshot.data;
                              return Column(
                                  children: [
                                    if(data.user?.id != userId)...[
                                      SizedBox(height: 8),
                                      ResponseButton(
                                        announcementId: data.id,
                                        addResponse: addResponse,
                                      ),
                                      // SizedBox(height: 8),
                                      // ElevatedButton(
                                      //   style: ElevatedButton.styleFrom(
                                      //     backgroundColor: Colors.deepPurple,
                                      //     onPrimary: Colors.white,
                                      //   ),
                                      //   child: Text('Отклик'),
                                      //   onPressed: () {
                                      //     addResponse(data.id, context);
                                      //   },
                                      // ),
                                    ],
                                    if(data.user?.id == userId) ...[
                                      SizedBox(height: 8),
                                      Container(
                                        child: Text(
                                          'Ваше объявление!',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                          }
                            else
                            {
                              return Text('Ошибка получения id пользователя');
                            }
                          }
                          else
                          {
                              return CircularProgressIndicator(); // или любой другой индикатор загрузки
                          }
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
