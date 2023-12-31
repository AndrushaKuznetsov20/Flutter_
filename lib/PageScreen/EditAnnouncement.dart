import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled5/PageScreen/MyAnnouncement.dart';
import 'package:untitled5/PageScreen/UserPageScreen.dart';

class EditAnnouncement extends StatefulWidget {

  final int id;
  final String nameAnnouncement;
  final String descriptionAnnouncement;
  final String conditions;

  EditAnnouncement(
      {required this.id,required this.nameAnnouncement, required this.descriptionAnnouncement, required this.conditions});

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState(id,nameAnnouncement,descriptionAnnouncement,conditions);
}
class _EditAnnouncementState extends State<EditAnnouncement> {
  late TextEditingController idAnnouncementController;
  late TextEditingController nameAnnouncementController;
  late TextEditingController descriptionAnnouncementController;
  late TextEditingController conditionsAnnouncementController;

  _EditAnnouncementState(int id, String nameAnnouncement,
      String descriptionAnnouncement, String conditions);

  @override
  void initState() {
    super.initState();
    idAnnouncementController = TextEditingController(text: widget.id.toString());
    nameAnnouncementController =
        TextEditingController(text: widget.nameAnnouncement);
    descriptionAnnouncementController =
        TextEditingController(text: widget.descriptionAnnouncement);
    conditionsAnnouncementController =
        TextEditingController(text: widget.conditions);
  }

  @override
  void dispose() {
    idAnnouncementController.dispose();
    nameAnnouncementController.dispose();
    descriptionAnnouncementController.dispose();
    conditionsAnnouncementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Редактирование объявления',style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyAnnouncement()),);
            },
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPageScreen()),);
            },
          ),
        ],

      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
          controller: idAnnouncementController,
              enabled: false,
          decoration: InputDecoration(
            labelText: 'Идентификатор объявления',
            labelStyle: TextStyle(color: Colors.deepPurple),
          ),
        ),
            TextField(
              controller: nameAnnouncementController,
              decoration: InputDecoration(
                labelText: 'Наименование объявления',
                labelStyle: TextStyle(color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionAnnouncementController,
              decoration: InputDecoration(
                labelText: 'Описание объявления',
                labelStyle: TextStyle(color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: conditionsAnnouncementController,
              decoration: InputDecoration(
                labelText: 'Условия и требования',
                labelStyle: TextStyle(color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                editData(context);
              },
              child: Text('Изменить объявление'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editData(BuildContext context) async {
    int? id = int.parse(idAnnouncementController.text);
    String nameAnnouncement = nameAnnouncementController.text;
    String descriptionAnnouncement = descriptionAnnouncementController.text;
    String conditionsAnnouncement = conditionsAnnouncementController.text;

    final url = Uri.parse('http://172.20.10.3:8092/api_announcements/update/$id');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'id': id,
      'name': nameAnnouncement,
      'description': descriptionAnnouncement,
      'conditions_and_requirements': conditionsAnnouncement,
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }
  }
}

