import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: Column(
        children: <Widget>[
          ExpansionTile(title: Text('Create house')),
          ExpansionTile(title: Text('Join house'))
        ],
      ),
    );
  }
}
