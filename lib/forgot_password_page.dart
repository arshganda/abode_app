import 'package:flutter/material.dart';
import 'package:reddit_ppl/register_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password?'),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: <Widget>[
            Text("Please enter your registered e-mail"),
            TextFormField(),
            RaisedButton(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account?"),
                FlatButton(
                  child: Text('Sign up'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RegisterPage()));
                  },
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
