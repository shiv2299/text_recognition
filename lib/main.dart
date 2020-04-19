import 'package:flutter/material.dart';
import 'package:text_recognition/BaseAuth.dart';
import 'package:text_recognition/RootPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(
        auth: Auth(),
      ), //MyHomePage(title: 'Text Recognition'),
      debugShowCheckedModeBanner: false,
    );
  }
}
