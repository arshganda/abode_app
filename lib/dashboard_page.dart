import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Abode"),
          actions: <Widget>[Icon(Icons.settings)],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              title: Text("Dashboard"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bug_report),
              title: Text("Feedback"),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.home_menu,
          animatedIconTheme: IconThemeData(size: 22.0),
          overlayOpacity: 0,
          animationSpeed: 120,
          children: [
            SpeedDialChild(
              child: Icon(Icons.mail),
              label: "Invite roommate",
            ),
            SpeedDialChild(
              child: Icon(Icons.note_add),
              label: "Add a chore",
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }
}
