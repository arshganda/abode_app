import 'package:abode/app_state.dart';
import 'package:abode/dashboard_page.dart';
import 'package:abode/forgot_password_page.dart';
import 'package:abode/onboard_page.dart';
import 'package:abode/register_page.dart';
import 'package:abode/widgets/textformfield_uncoupled.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'util/login_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSubmitting = false;
  bool isFormInvalid = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dio dio = Provider.of<AppState>(context).dio;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Image.asset(
                    "abode_logo.png",
                    width: 200.0,
                  ),
                  Spacer(),
                  if (isFormInvalid) buildInvalidText(),
                  UncoupledTextField(
                    isEnabled: !isSubmitting,
                    controller: _emailController,
                    decoration: buildInputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    fn: focusNode,
                    fn2: focusNode2,
                    validator: emailValidator,
                    onSubmitted: (String value) => passFocus(focusNode, focusNode2, context),
                  ),
                  SizedBox(height: 16),
                  UncoupledTextField(
                    isEnabled: !isSubmitting,
                    controller: _passwordController,
                    shouldObscureText: true,
                    shouldAutocorrect: false,
                    decoration: buildInputDecoration('Password'),
                    fn: focusNode2,
                    action: TextInputAction.done,
                    onSubmitted: (String value) => focusNode2.unfocus(),
                    validator: passwordValidator,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          focusNode: focusNode3,
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
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  focusNode2.unfocus();
                                  FocusScope.of(context).requestFocus(focusNode3);
                                  isFormInvalid = !_formKey.currentState.validate();
                                  if (!isFormInvalid) {
                                    setState(() {
                                      isSubmitting = true;
                                      isFormInvalid = false;
                                    });
                                    try {
                                      FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
                                      if (!user.isEmailVerified) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text("Re-send email?"),
                                                  content: Text("Your email is currently not verified. Check your email inbox or re-send the verification email."),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text("Close"),
                                                      textColor: Theme.of(context).accentColor,
                                                    ),
                                                    FlatButton(
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        user.sendEmailVerification().then((value) {
                                                          SnackBar snackBar = SnackBar(
                                                            content: Text("Verification e-mail sent!"),
                                                            behavior: SnackBarBehavior.floating,
                                                          );
                                                          _scaffoldKey.currentState.showSnackBar(snackBar);
                                                          setState(() {
                                                            isSubmitting = false;
                                                          });
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Send Email"),
                                                      color: Theme.of(context).accentColor,
                                                    ),
                                                  ],
                                                ));
                                      }
                                      Response r = await dio.get("/user", queryParameters: {"firebaseId": user.uid});
                                      User modelUser = User.fromJson(r.data);
                                      if (user != null && modelUser.houseCode != null)
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DashboardPage()));
                                      else if (user != null && user.isEmailVerified) Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OnBoardPage()));
                                    } catch (e) {
                                      setState(() {
                                        isSubmitting = false;
                                      });
                                      print(e);
                                      return null;
                                    }
                                    setState(() {
                                      isSubmitting = false;
                                    });
                                    return true;
                                  } else {
                                    setState(() {
                                      isFormInvalid = true;
                                    });
                                    return null;
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                  buildForgotPassword(context),
                  Spacer(),
                  buildSignUp(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildInvalidText() {
    return Column(
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
    );
  }

  Row buildSignUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Don't have an account?"),
        FlatButton(
          child: Text('Sign up'),
          onPressed: isSubmitting
              ? null
              : () {
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => RegisterPage()));
                },
        ),
      ],
    );
  }

  Align buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
          child: Text('Forgot password?'),
          onPressed: isSubmitting
              ? null
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ForgotPasswordPage()));
                }),
    );
  }
}
