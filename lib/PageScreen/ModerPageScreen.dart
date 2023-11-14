import 'package:flutter/material.dart';
import 'package:untitled5/Models/ModelAnnouncement.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled5/PageScreen/LkPageScreen.dart';

class ModerPageSceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: ModerPageScreen(),
    );
  }
}
class ModerPageScreen extends StatefulWidget {
  @override
  ModerPageScreenState createState() => ModerPageScreenState();
}

class ModerPageScreenState extends State<ModerPageScreen> {
  final url = Uri.parse('http://172.20.10.3:8092/api_announcements/announcements');
  final headers = {'Content-Type': 'application/json'};

  List<ModelAnnouncement> dataList = [];

  Future<void> addAnnouncement() async {
    final response = await http.get(Uri.parse('http://172.20.10.3:8092/api_announcements/announcements'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataList = List<ModelAnnouncement>.from(jsonData.map((data) => ModelAnnouncement.fromJson(data)));
      });
    }
  }

  Future<void> moderData(int id,BuildContext context) async {
    final response = await http.put(Uri.parse('http://172.20.10.3:8092/api_announcements/moder/$id'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
  }

  Future<void> blockData(int id,BuildContext context) async {
    final response = await http.put(Uri.parse('http://172.20.10.3:8092/api_announcements/block/$id'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
    else {
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
          title: Text('Список входящих объявлений'),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LkPageScreen()),
                );
              },
            ),
          ],
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
                        'Условия и требованияв:',
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
                        child: Text('Модерировать'),
                        onPressed: () {
                          moderData(data.id,context);
                        },
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        child: Text('Заблокировать'),
                        onPressed: () {
                          blockData(data.id,context);
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

