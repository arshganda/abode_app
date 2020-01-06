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
  bool isSubmitting = false;
  bool isFormInvalid = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
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
                  if (isFormInvalid)
                    Column(
                      children: <Widget>[
                        Text(
                          "Your e-mail/password are invalid.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16)
                      ],
                    ),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: FormField(
                      builder: (FormFieldState state) => TextField(
                          controller: _emailController,
                          decoration: buildInputDecoration('E-mail'),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: focusNode,
                          onSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(focusNode2);
                          }),
                      validator: (_) => emailValidator(_emailController.text),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: FormField(
                      builder: (FormFieldState state) => TextField(
                        controller: _passwordController,
                        obscureText: true,
                        autocorrect: false,
                        decoration: buildInputDecoration('Password'),
                        focusNode: focusNode2,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (String value) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      validator: (_) =>
                          passwordValidator(_passwordController.text),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: isSubmitting
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : Text('Submit'),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onPressed: () async {
                            isFormInvalid = !_formKey.currentState.validate();
                            if (!isFormInvalid) {
                              setState(() {
                                isSubmitting = true;
                                isFormInvalid = false;
                              });
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
                                setState(() {
                                  isSubmitting = false;
                                });
                                print(e);
                                return null;
                              }
                              return true;
                            }
                            setState(() {
                              isFormInvalid = true;
                            });
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
}
