import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_ppl/login_page.dart';

import 'app_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Surprise!',
        theme: ThemeData(
          primarySwatch: Colors.red,
          backgroundColor: Color.fromARGB(255, 234, 244, 255),
          primaryColor: Color.fromARGB(255, 176, 215, 255),
          accentColor: Color.fromARGB(255, 45, 49, 66),
          accentTextTheme: TextTheme(
            button: TextStyle(color: Colors.white),
          ),
        ),
        home: LoginPage(),
//      home: DashboardPage(),
//        home: RegistrationSuccessfulPage(name: "YEEET GANDAAAAAAAAAAAAAA"),
      ),
    );
  }
}
