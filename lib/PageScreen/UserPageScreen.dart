import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled5/PageScreen/AnnouncementPageScreen.dart';
import 'package:untitled5/PageScreen/LkPageScreen.dart';

class UserPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  
  final List<Widget> _children = [
    PlaceholderWidget(color: Colors.red, text: '', index: 0),
    PlaceholderWidget(color: Colors.green, text: 'Страница создания объявления', index: 1),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Поиск вакансий',style: TextStyle(color: Colors.white)),
        actions: [
          if(_currentIndex != 0)
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPageScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LkPageScreen()),
              );
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.toc),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Создать объявление',
          ),
        ],
      ),
    );
  }
}
Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}
class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int index;
  List<String> myList = [];

  final TextEditingController announcementNameController = TextEditingController();
  final TextEditingController announcementDescriptionController = TextEditingController();
  final TextEditingController announcementConditions_and_requirementsController = TextEditingController();

  PlaceholderWidget({required this.color, required this.text,required this.index});

  Future<void> add(BuildContext context) async
  {
    int? userId = await getUserId();
    String name = announcementNameController.text;
    String description = announcementDescriptionController.text;
    String conditions_and_requirements= announcementConditions_and_requirementsController.text;

    final url = Uri.parse('http://172.20.10.3:8092/api_announcements/addAnnouncements/$userId');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'description': description,
      'conditions_and_requirements': conditions_and_requirements,
    });
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    }

    announcementNameController.clear();
    announcementDescriptionController.clear();
    announcementConditions_and_requirementsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          if(index == 0) ...[
            SingleChildScrollView(
              child: Container(
                height: 278,
                child: Row(
                  children: [
                    Expanded(
                      child: Image.network(
                        'https://sun6-20.userapi.com/s/v1/ig2/GolcmJFBPjSoP15Fzw-7icbKxxReKYBAHsDsy4QjoV-Un11unj0S6XAvk7V1BfNTDlGgVt_62371foFKE6MG1JZy.jpg?size=957x957&quality=95&crop=42,0,957,957&ava=1',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width:20),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    fixedSize: Size(405, 35),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementPageScreen(),
                      ),
                    );
                  },
                  child: Text('Нажми, чтобы начать охоту за кадрами'),
                ),
              ],
            ),
          ],
          if(index == 1) ...[
            SizedBox(height: 8.0),
            TextField(
              controller: announcementNameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.deepPurple),
                labelText: 'Наименование объявления:',
              ),
            ),
            TextFormField(
              controller: announcementDescriptionController,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.deepPurple),
                labelText: 'Описание объявления:',
              ),
            ),
            TextFormField(
              controller: announcementConditions_and_requirementsController,
              maxLines: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.deepPurple),
                labelText: 'Условия и требования:',
              ),
            ),
          ],
          if(index == 1) ...[
          SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              add(context);
            },
            child: Text('Создать объявление'),
          ),
        ],
        ]
      ),
    );
  }
}