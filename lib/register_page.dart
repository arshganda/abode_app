import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'models/user.dart';
import 'util/login_util.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isSubmitting = false;
  bool isFormInvalid = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Dio dio = Provider.of<AppState>(context).dio;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Image.asset("abode_logo.png", width: 200.0),
                  Spacer(),
                  if (isFormInvalid)
                    Column(
                      children: <Widget>[
                        Text(
                          "Your name, e-mail or password are invalid.",
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
                        controller: _nameController,
                        decoration: buildInputDecoration('Full name'),
                        focusNode: focusNode1,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNode2),
                      ),
                      validator: (_) => nameValidator(_nameController.text),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: FormField(
                      builder: (FormFieldState state) => TextField(
                        controller: _emailController,
                        decoration: buildInputDecoration('E-mail'),
                        focusNode: focusNode2,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNode3),
                      ),
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
                        focusNode: focusNode3,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focusNode4),
                        decoration: buildInputDecoration('Password'),
                      ),
                      validator: (_) =>
                          passwordValidator(_passwordController.text),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: FormField(
                      builder: (FormFieldState state) => TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        autocorrect: false,
                        focusNode: focusNode4,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        decoration: buildInputDecoration('Re-enter password'),
                      ),
                      validator: (value) {
                        if (_confirmPasswordController.text !=
                            _passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          child: isSubmitting
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : Text('Create account'),
                          onPressed: () async {
                            isFormInvalid = !_formKey.currentState.validate();
                            if (!isFormInvalid) {
                              setState(() {
                                isSubmitting = true;
                                isFormInvalid = false;
                              });
                              FirebaseUser user =
                                  (await _auth.createUserWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text))
                                      .user;
                              if (user != null) {
                                //do something
                                UserUpdateInfo uuInfo = UserUpdateInfo();
                                uuInfo.displayName = _nameController.text;
                                uuInfo.photoUrl = "";
                                await user.updateProfile(uuInfo);
                                await user.sendEmailVerification();
                                User modelUser = User(
                                    user.uid,
                                    _nameController.text,
                                    _emailController.text);
                                await dio.post("/user",
                                    data: modelUser.toJson());
                              } else {
                                // do something else
                              }
                            }
                            setState(() {
                              isFormInvalid = true;
                              isSubmitting = false;
                            });
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      FlatButton(
                        child: Text('Log in'),
                        onPressed: () {
                          Navigator.pop(context);
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
