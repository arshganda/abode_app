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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Dio dio = Provider.of<AppState>(context).dio;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Image.asset("abode_logo.png", height: 30),
                SizedBox(height: 8.0 * 8.0),
                Container(
                  decoration: buildBoxDecoration(),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: buildInputDecoration('Full name'),
                    validator: nameValidator,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: buildBoxDecoration(),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: buildInputDecoration('E-mail'),
                    validator: emailValidator,
                  ),
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
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: buildBoxDecoration(),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    autocorrect: false,
                    decoration: buildInputDecoration('Re-enter password'),
                    validator: (value) {
                      if (value != _passwordController.text) {
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
                        child: Text('Create account'),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
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
                              User modelUser = User(user.uid,
                                  _nameController.text, _emailController.text);
                              await dio.post("/user", data: modelUser.toJson());
                            } else {
                              // do something else
                            }
                          }
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
    );
  }
}
