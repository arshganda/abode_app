import 'package:abode/app_state.dart';
import 'package:abode/dashboard_page.dart';
import 'package:abode/models/user.dart';
import 'package:abode/util/login_util.dart';
import 'package:abode/widgets/card_textfield.dart';
import 'package:abode/widgets/expanded_button.dart';
import 'package:abode/widgets/two_level_text.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinHousePage extends StatefulWidget {
  @override
  _JoinHousePageState createState() => _JoinHousePageState();
}

class _JoinHousePageState extends State<JoinHousePage> {
  bool isJoining = false;
  bool isFormInvalid = false;
  TextEditingController _card1Controller = TextEditingController();
  TextEditingController _card2Controller = TextEditingController();
  TextEditingController _card3Controller = TextEditingController();
  TextEditingController _card4Controller = TextEditingController();
  TextEditingController _card5Controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _card1Controller.dispose();
    _card2Controller.dispose();
    _card3Controller.dispose();
    _card4Controller.dispose();
    _card5Controller.dispose();
    focusNode.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dio dio = Provider.of<AppState>(context).dio;
    FirebaseAuth _auth = FirebaseAuth.instance;

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
              TwoLevelText(
                titleText: "Enter the invite code to join your house.",
                contentText: "Get the code from one of your roommates.",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextFieldCard(
                    controller: _card1Controller,
                    fn: focusNode,
                    action: TextInputAction.next,
                    onSubmitted: (_) => passFocus(focusNode, focusNode2, context),
                  ),
                  TextFieldCard(
                    controller: _card2Controller,
                    fn: focusNode2,
                    action: TextInputAction.next,
                    onSubmitted: (_) => passFocus(focusNode, focusNode2, context),
                  ),
                  TextFieldCard(
                    controller: _card3Controller,
                    fn: focusNode3,
                    action: TextInputAction.next,
                    onSubmitted: (_) => passFocus(focusNode, focusNode2, context),
                  ),
                  TextFieldCard(
                    controller: _card4Controller,
                    fn: focusNode4,
                    action: TextInputAction.next,
                    onSubmitted: (_) => passFocus(focusNode, focusNode2, context),
                  ),
                  TextFieldCard(
                    controller: _card5Controller,
                    fn: focusNode5,
                    action: TextInputAction.done,
                    onSubmitted: (_) => focusNode5.unfocus(),
                  ),
                ],
              ),
              if (isFormInvalid) buildInvalidHouseCodeText(),
              ExpandedButton(
                buttonLabel: generateButtonLabel(),
                onPressed: handleJoinHouse(dio, _auth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic handleJoinHouse(Dio dio, FirebaseAuth _auth) async {
    setState(() {
      isJoining = true;
    });
    String houseCode = _card1Controller.text + _card2Controller.text + _card3Controller.text + _card4Controller.text + _card5Controller.text;
    if (houseCode.length < 5) {
      setState(() {
        isJoining = false;
        isFormInvalid = true;
      });
      return;
    } else {
      setState(() {
        isFormInvalid = false;
      });
    }
    FirebaseUser _user = await _auth.currentUser();
    User modelUser = User(_user.uid, _user.displayName, _user.email, houseCode);
    await dio.post("/user", data: modelUser.toJson());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardPage()), (Route<dynamic> route) => false);
    setState(() {
      isJoining = false;
    });
  }

  Widget generateButtonLabel() {
    return isJoining
        ? SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))
        : Text("Join house");
  }

  Padding buildInvalidHouseCodeText() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        "Please enter a valid house code.",
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }
}
