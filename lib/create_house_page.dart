import 'package:abode/app_state.dart';
import 'package:abode/dashboard_page.dart';
import 'package:abode/widgets/expanded_button.dart';
import 'package:abode/widgets/two_level_text.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'models/user.dart';
import 'widgets/house_code_card.dart';

class CreateHousePage extends StatefulWidget {
  @override
  _CreateHousePageState createState() => _CreateHousePageState();
}

class _CreateHousePageState extends State<CreateHousePage> {
  Future<Response<String>> _houseCode;
  bool isGoingToDashboard = false;

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
              TwoLevelText(
                titleText: "We've created a new code for your house.",
                contentText: "Share this code with your roommates so that they can join your house.",
              ),
              SizedBox(height: 16),
              FutureBuilder(
                future: _houseCode,
                builder: (context, AsyncSnapshot<Response<String>> snapshot) {
                  return displayHouseCode(context, snapshot, _shareHouseCode);
                },
              ),
              SizedBox(height: 10),
              ExpandedButton(
                buttonLabel: Text("Share code"),
                onPressed: shareCode(_shareHouseCode),
              ),
              ExpandedButton(
                buttonLabel: generateGoToDashboardLabel(),
                onPressed: isGoingToDashboard ? null : handleGoToDashboard(dio, _auth, _shareHouseCode),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic displayHouseCode(BuildContext context, AsyncSnapshot<Response<String>> snapshot, String shareHouseCode) {
    if (snapshot.hasData) {
      shareHouseCode = snapshot.data.data;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ...List<HouseCodeCard>.generate(5, (int index) {
            return HouseCodeCard(cardText: shareHouseCode[index]);
          })
        ],
      );
    } else if (snapshot.hasError) {
      return Text("House code could not be generated");
    } else {
      return Align(alignment: Alignment.center, child: CircularProgressIndicator());
    }
  }

  dynamic handleGoToDashboard(Dio dio, FirebaseAuth _auth, String _shareHouseCode) async {
    setState(() {
      isGoingToDashboard = true;
    });
    FirebaseUser _user = await _auth.currentUser();
    User modelUser = User(_user.uid, _user.displayName, _user.email, _shareHouseCode);
    await dio.post("/user", data: modelUser.toJson());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardPage()), (Route<dynamic> route) => false);
  }

  Widget generateGoToDashboardLabel() {
    return isGoingToDashboard
        ? SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
        : Text("Go to Dashboard");
  }

  Function shareCode(String _shareHouseCode) {
    return isGoingToDashboard
        ? null
        : () {
            // TODO: Link to download app
            Share.share("Join our virtual Abode with the code $_shareHouseCode!");
          };
  }
}
