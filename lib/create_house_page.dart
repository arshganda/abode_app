import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_ppl/app_state.dart';
import 'package:reddit_ppl/dashboard.dart';
import 'package:share/share.dart';

import 'models/user.dart';
import 'widgets/house_code_card.dart';

class CreateHousePage extends StatefulWidget {
  @override
  _CreateHousePageState createState() => _CreateHousePageState();
}

class _CreateHousePageState extends State<CreateHousePage> {
  Future<Response<String>> _houseCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Dio dio = Provider.of<AppState>(context).dio;
    _houseCode = dio.get("/house-code");
  }

  @override
  Widget build(BuildContext context) {
    Dio dio = Provider.of<AppState>(context).dio;
    FirebaseAuth _auth = FirebaseAuth.instance;
    String _shareHouseCode = "";

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Create a New House"),
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
                    "We've created a new code for your house.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Share this code with your roommates so that they can join your house.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              FutureBuilder(
                future: _houseCode,
                builder: (context, AsyncSnapshot<Response<String>> snapshot) {
                  if (snapshot.hasData) {
                    _shareHouseCode = snapshot.data.data;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ...List<HouseCodeCard>.generate(5, (int index) {
                          return HouseCodeCard(
                              cardText: _shareHouseCode[index]);
                        })
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("House code could not be generated");
                  } else {
                    return Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  }
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text("Share code"),
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      onPressed: () {
                        Share.share(_shareHouseCode);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text("Go to Dashboard"),
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      onPressed: () async {
                        FirebaseUser _user = await _auth.currentUser();
                        User modelUser = User(_user.uid, _user.displayName,
                            _user.email, _shareHouseCode);
                        await dio.post("/user", data: modelUser.toJson());
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
}
