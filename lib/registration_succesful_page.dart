import 'package:abode/login_page.dart';
import 'package:abode/widgets/expanded_button.dart';
import 'package:abode/widgets/two_level_text.dart';
import 'package:flutter/material.dart';

class RegistrationSuccessfulPage extends StatelessWidget {
  final String name;

  const RegistrationSuccessfulPage({Key key, this.name}) : super(key: key);

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
              Spacer(flex: 3),
              TwoLevelText(
                titleText: "Hi $name, welcome to Abode!",
                contentText: "Thank you for creating an account. An verification link has been sent to your email inbox. Please verify your "
                    "account to proceed with creating or joining a house.",
              ),
              Spacer(
                flex: 1,
              ),
              ExpandedButton(
                buttonLabel: Text("Return to login"),
                onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false),
              ),
              Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
