import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:untitled5/PageScreen/RegisterScreen.dart';

void main() {
  group('RegisterScreen', () {
    testWidgets('Отображает сообщение об успешном завершении регистрации', (WidgetTester tester)  async {
      final mockHTTPClient = MockClient((request) async {
        final response = {"Вы успешно зарегистрировались!"};
        return Response(jsonEncode(response), 200);
      });

      final widget = MaterialApp(home: RegisterScreen());
      await tester.pumpWidget(widget);

      await tester.enterText(find.byType(TextField).at(0), 'TestUser1212');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), '1234567890');
      await tester.enterText(find.byType(TextField).at(3), 'password');

      await tester.tap(find.text('Зарегистрироваться'));

      await tester.pump();

      expect(find.text("Вы успешно зарегистрировались!"), findsOneWidget);
    });

    testWidgets('Отображает сообщение об провальном завершении регистрации',(WidgetTester tester)  async {
      final mockHTTPClient = MockClient((request) async {
        final response = {"Пользователь с таким именем уже существует!"};
        return Response(jsonEncode(response), 500);
      });

      final widget = MaterialApp(home: RegisterScreen());
      await tester.pumpWidget(widget);

      await tester.enterText(find.byType(TextField).at(0), 'TestUser');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), '1234567890');
      await tester.enterText(find.byType(TextField).at(3), 'password');

      await tester.tap(find.text('Зарегистрироваться'));

      await tester.pump();

      expect(find.text("Пользователь с таким именем уже существует!"), findsOneWidget);
    });
  });
}
