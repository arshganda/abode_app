import 'package:flutter/material.dart';
import 'package:reddit_ppl/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      return 'Please enter a valid e-mail address';
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
              onPressed: () {
                if (_formKey.currentState.validate()) {
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
