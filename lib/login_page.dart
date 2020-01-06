import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reddit_ppl/forgot_password_page.dart';
import 'package:reddit_ppl/onboard_page.dart';
import 'package:reddit_ppl/register_page.dart';

import 'util/login_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    FocusNode focusNode2 = FocusNode();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Image.asset(
                    "abode_logo.png",
                    width: 200.0,
                  ),
                  Spacer(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: TextFormField(
                        controller: _emailController,
                        decoration: buildInputDecoration('E-mail'),
                        validator: emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: focusNode,
                        onFieldSubmitted: (String value) {
                          focusNode.unfocus();
                          FocusScope.of(context).requestFocus(focusNode2);
                        }),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      autocorrect: false,
                      decoration: buildInputDecoration('Password'),
                      validator: passwordValidator,
                      focusNode: focusNode2,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).unfocus();
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text('Submit'),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                FirebaseUser user =
                                    (await _auth.signInWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text))
                                        .user;
                                if (user != null && user.isEmailVerified)
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OnBoardPage()));
                              } catch (e) {
                                print(e);
                                return null;
                              }
                              return true;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        child: Text('Forgot password?'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ForgotPasswordPage()));
                        }),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      FlatButton(
                        child: Text('Sign up'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          RegisterPage()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a valid password';
    }
    return null;
  }
}
