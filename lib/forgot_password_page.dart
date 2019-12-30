import 'package:flutter/material.dart';
import 'package:reddit_ppl/register_page.dart';

import 'util/login_util.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password?'),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: <Widget>[
            Text("Please enter your registered e-mail"),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'E-mail',
              ),
              validator: emailValidator,
              keyboardType: TextInputType.emailAddress,
            ),
            RaisedButton(
              child: Text('Send'),
            ),
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
