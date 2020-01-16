import 'dart:async';

import 'package:abode/register_page.dart';
import 'package:abode/widgets/expanded_button.dart';
import 'package:abode/widgets/textformfield_uncoupled.dart';
import 'package:abode/widgets/two_level_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'util/login_util.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  bool isEmailInvalid = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  TwoLevelText(
                    titleText: "Please enter your registered email.",
                    contentText: "We will send you an e-mail with instructions to reset your account password.",
                  ),
                  SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: UncoupledTextField(
                      isEnabled: !isSubmitting,
                      controller: _emailController,
                      decoration: buildInputDecoration('E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (isEmailInvalid) buildEmailInvalidText(),
                  SizedBox(height: 2),
                  ExpandedButton(
                    buttonLabel: generateLabelText(),
                    onPressed: isSubmitting ? null : handleForgotPw(),
                  ),
                  Spacer(),
                  buildSignUpQuery(context),
                ],
              )),
        ),
      ),
    );
  }

  Align buildEmailInvalidText() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        "Please enter a valid email address.",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Row buildSignUpQuery(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Don't have an account?"),
        FlatButton(
          child: Text('Sign up'),
          onPressed: isSubmitting
              ? null
              : () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
                },
        ),
      ],
    );
  }

  handleForgotPw() {
    if (!_formKey.currentState.validate()) {
      setState(() {
        isEmailInvalid = true;
        isSubmitting = false;
      });
    } else {
      setState(() {
        isSubmitting = true;
        isEmailInvalid = false;
      });
      _auth.sendPasswordResetEmail(email: _emailController.text).then(showSnackBar).catchError((error) => {
            setState(() {
              isSubmitting = false;
            })
          });
    }
  }

  FutureOr<dynamic> showSnackBar(value) {
    setState(() {
      isSubmitting = false;
    });
    SnackBar snackBar = SnackBar(
      content: Text("Password reset email sent."),
      behavior: SnackBarBehavior.floating,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget generateLabelText() {
    return isSubmitting
        ? SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))
        : Text('Send');
  }
}
