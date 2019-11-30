import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String emailValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a valid e-mail address';
    }
    return null;
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a valid password';
    }
    return null;
  }

  String nameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a valid name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
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
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: 'First name',
              ),
              validator: nameValidator,
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: 'Last name',
              ),
              validator: nameValidator,
            ),
            RaisedButton(
              child: Text('Submit'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  FirebaseUser _user =
                      (await _auth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text))
                          .user;
                  return true;
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
