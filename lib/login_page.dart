import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_ppl/home_page.dart';
import 'package:reddit_ppl/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
              decoration: InputDecoration(hintText: 'Password'),
              validator: passwordValidator,
            ),
            RaisedButton(
              child: Text('Submit'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  try {
                    FirebaseUser _user =
                        (await _auth.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text))
                            .user;
                    if (_user != null)
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()));
                  } catch (e) {
                    return null;
                  }
                  return true;
                }
                return null;
              },
            ),
            FlatButton(
              child: Text('Create account'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
