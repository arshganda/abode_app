import 'package:abode/register_page.dart';
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                    child: Form(
                      key: _formKey,
                      child: FormField(
                        builder: (context) => TextField(
                          controller: _emailController,
                          decoration: buildInputDecoration('E-mail'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        validator: (_) => emailValidator(_emailController.text),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  if (isEmailInvalid)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Please enter a valid email address.",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  SizedBox(height: 2),
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
                                  ))
                              : Text('Send'),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          onPressed: () {
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
                              _auth.sendPasswordResetEmail(email: _emailController.text).then((value) {
                                setState(() {
                                  isSubmitting = false;
                                });
                                SnackBar snackBar = SnackBar(
                                  content: Text("Password reset email sent."),
                                  behavior: SnackBarBehavior.floating,
                                );
                                _scaffoldKey.currentState.showSnackBar(snackBar);
                              }).catchError((error) => {
                                    setState(() {
                                      isSubmitting = false;
                                    })
                                  });
                            }
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
      ),
    );
  }
}
