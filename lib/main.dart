import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      theme: ThemeData(
        // primaryColor: Color(0xFF048295),
        primaryColor: Colors.lightBlue[700],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 12.0, fontFamily: 'Hind'),
        ),
      ),
    );
  }
}
