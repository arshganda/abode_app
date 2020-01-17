import 'package:abode/create_house_page.dart';
import 'package:abode/join_house_page.dart';
import 'package:abode/widgets/expanded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OnBoardPage extends StatefulWidget {
  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  FirebaseAuth _auth;
  Future<FirebaseUser> _user;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = getCurrentUser();
  }

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Image.asset("abode_logo.png", width: 180),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(flex: 17),
              buildGreeting(),
              Spacer(flex: 1),
              SizedBox(height: 16),
              ExpandedButton(
                buttonLabel: Text("Create a house"),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateHousePage())),
              ),
              SizedBox(height: 8),
              ExpandedButton(
                buttonLabel: Text("Join a house"),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JoinHousePage())),
              ),
              Spacer(flex: 20),
            ],
          ),
        ),
      ),
    );
  }

  Column buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FutureBuilder<FirebaseUser>(
            future: _user,
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                return buildDynamicText(snapshot);
              } else {
                return buildStaticText();
              }
            }),
        SizedBox(height: 8),
        Text(
          "Thanks for verifying your account.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Text buildStaticText() {
    return Text(
      "Hi!",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text buildDynamicText(AsyncSnapshot<FirebaseUser> snapshot) {
    return Text(
      "Hi " + snapshot.data.displayName + "!",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
