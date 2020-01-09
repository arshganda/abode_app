import 'package:abode/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'util/login_util.dart';

class ForgotPasswordPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Please enter your registered e-mail.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "We will send you an e-mail with instructions to reset your account password.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Container(
                  decoration: buildBoxDecoration(),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: buildInputDecoration('E-mail'),
                    validator: emailValidator,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text('Send'),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await _auth.sendPasswordResetEmail(email: _emailController.text);
                        },
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?"),
                    FlatButton(
                      child: Text('Sign up'),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
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
