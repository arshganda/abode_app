import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_ppl/app_state.dart';
import 'package:reddit_ppl/dashboard_page.dart';
import 'package:reddit_ppl/models/user.dart';

class JoinHousePage extends StatefulWidget {
  @override
  _JoinHousePageState createState() => _JoinHousePageState();
}

class _JoinHousePageState extends State<JoinHousePage> {
  @override
  Widget build(BuildContext context) {
    Dio dio = Provider.of<AppState>(context).dio;
    FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController card1 = TextEditingController();
    TextEditingController card2 = TextEditingController();
    TextEditingController card3 = TextEditingController();
    TextEditingController card4 = TextEditingController();
    TextEditingController card5 = TextEditingController();
    FocusNode focusNode = FocusNode();
    FocusNode focusNode2 = FocusNode();
    FocusNode focusNode3 = FocusNode();
    FocusNode focusNode4 = FocusNode();
    FocusNode focusNode5 = FocusNode();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Join a House"),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Enter the invite code to join your house.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Get the code from one of your roommates.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildCard(card1, focusNode, context, focusNode2),
                  buildCard(card2, focusNode2, context, focusNode3),
                  buildCard(card3, focusNode3, context, focusNode4),
                  buildCard(card4, focusNode4, context, focusNode5),
                  Card(
                    margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    elevation: 6.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 32,
                        child: TextField(
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 24.0,
                          ),
                          controller: card5,
                          focusNode: focusNode5,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (String value) =>
                              FocusScope.of(context).unfocus(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text("Join"),
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      onPressed: () async {
                        String houseCode = card1.text +
                            card2.text +
                            card3.text +
                            card4.text +
                            card5.text;
                        FirebaseUser _user = await _auth.currentUser();
                        User modelUser = User(_user.uid, _user.displayName,
                            _user.email, houseCode);
                        print(modelUser);
                        print(houseCode);
                        Response r =
                            await dio.post("/user", data: modelUser.toJson());
                        print(r.data);
                        print(r.statusMessage);
                        print(r);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildCard(TextEditingController card1, FocusNode focusNode,
      BuildContext context, FocusNode focusNode2) {
    return Card(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 32,
          child: TextField(
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
            controller: card1,
            focusNode: focusNode,
            textInputAction: TextInputAction.next,
            onChanged: (String value) =>
                FocusScope.of(context).requestFocus(focusNode2),
          ),
        ),
      ),
    );
  }
}
