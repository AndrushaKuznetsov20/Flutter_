import 'package:flutter/material.dart';
import 'package:untitled5/PageScreen/LoginScreen.dart';
import 'package:untitled5/PageScreen/RegisterScreen.dart';
import 'package:untitled5/PageScreen/HomeScreen.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добро пожаловать !'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween(begin: 0.9, end: 1.0),
              duration: Duration(milliseconds: 300),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Авторизация'),
                  ),
                );
              },
            ),
            SizedBox(height: 8,),
            TweenAnimationBuilder(
              tween: Tween(begin: 0.9, end: 1.0),
              duration: Duration(milliseconds: 300),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('Регистрация'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
