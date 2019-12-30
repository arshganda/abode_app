import 'package:flutter/material.dart';
import 'package:reddit_ppl/register_page.dart';

import 'util/login_util.dart';

class ForgotPasswordPage extends StatelessWidget {
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
              children: <Widget>[
                Spacer(),
                Text("Please enter your registered e-mail"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        offset: Offset(0, 2.0),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'E-mail',
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: emailValidator,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                RaisedButton(
                  child: Text('Send'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    return 5;
                  },
                ),
                Spacer(),
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
                                builder: (BuildContext context) =>
                                    RegisterPage()));
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
