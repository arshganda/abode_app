import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Full name',
              ),
              validator: nameValidator,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'E-mail',
              ),
              validator: emailValidator,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              validator: passwordValidator,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Re-enter password',
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
            RaisedButton(
              child: Text('Submit'),
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

                    Dio dio = new Dio();
                    dio.options.baseUrl = "https://abode-backend.herokuapp.com";
                    await dio.post("/user", data: {
                      "firebaseId": user.uid,
                      "name": _nameController.text,
                      "email": _emailController.text
                    });
                  } else {
                    // do something else
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
