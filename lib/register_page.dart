import 'package:abode/registration_succesful_page.dart';
import 'package:abode/widgets/expanded_button.dart';
import 'package:abode/widgets/textformfield_uncoupled.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'models/user.dart';
import 'util/login_util.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isEmailInUse = false;
  bool isSubmitting = false;
  bool isFormInvalid = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  @override
  void dispose() {
    super.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Dio dio = Provider.of<AppState>(context).dio;

    return SafeArea(
      child: Scaffold(
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
                  Image.asset("abode_logo.png", width: 200.0),
                  Spacer(),
                  if (isFormInvalid) buildFormInvalidText(),
                  if (isEmailInUse) buildEmailInUse(),
                  UncoupledTextField(
                    isEnabled: !isSubmitting,
                    controller: _nameController,
                    decoration: buildInputDecoration('Full name'),
                    fn: focusNode1,
                    action: TextInputAction.next,
                    onSubmitted: (String value) => passFocus(focusNode1, focusNode2, context),
                    validator: nameValidator,
                  ),
                  SizedBox(height: 16),
                  UncoupledTextField(
                    isEnabled: !isSubmitting,
                    controller: _emailController,
                    decoration: buildInputDecoration('Email'),
                    fn: focusNode2,
                    action: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (String value) => passFocus(focusNode2, focusNode3, context),
                    validator: emailValidator,
                  ),
                  SizedBox(height: 16),
                  UncoupledTextField(
                    isEnabled: !isSubmitting,
                    controller: _passwordController,
                    shouldObscureText: true,
                    shouldAutocorrect: false,
                    decoration: buildInputDecoration('Password'),
                    fn: focusNode3,
                    action: TextInputAction.next,
                    onSubmitted: (String value) => passFocus(focusNode3, focusNode4, context),
                    validator: passwordValidator,
                  ),
                  SizedBox(height: 16),
                  UncoupledTextField(
                    isEnabled: !isSubmitting,
                    controller: _confirmPasswordController,
                    shouldObscureText: true,
                    shouldAutocorrect: false,
                    decoration: buildInputDecoration('Re-enter password'),
                    fn: focusNode4,
                    action: TextInputAction.done,
                    onSubmitted: (String value) => focusNode4.unfocus(),
                    validator: validatePassword,
                  ),
                  SizedBox(height: 10),
                  ExpandedButton(
                    buttonLabel: generateButtonLabel(),
                    onPressed: isSubmitting ? null : handleRegister(dio),
                  ),
                  Spacer(),
                  buildLoginPrompt(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget generateButtonLabel() {
    return isSubmitting
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
        : Text('Create account');
  }

  Column buildFormInvalidText() {
    return Column(
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
    );
  }

  Column buildEmailInUse() {
    return Column(
      children: <Widget>[
        Text(
          "Your email address is already in use.",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16)
      ],
    );
  }

  String validatePassword(value) {
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  Row buildLoginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Already have an account?"),
        FlatButton(
          child: Text('Log in'),
          onPressed: isSubmitting
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
      ],
    );
  }

  dynamic handleRegister(Dio dio) async {
    isFormInvalid = !_formKey.currentState.validate();
    if (!isFormInvalid) {
      setState(() {
        isSubmitting = true;
        isFormInvalid = false;
        isEmailInUse = false;
      });
      FirebaseUser user;
      try {
        user = (await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
      } catch (e) {
        setState(() {
          isEmailInUse = true;
        });
        return;
      }
      if (user != null) {
        UserUpdateInfo uuInfo = UserUpdateInfo();
        uuInfo.displayName = _nameController.text;
        uuInfo.photoUrl = "";
        await user.updateProfile(uuInfo);
        await user.sendEmailVerification();
        User modelUser = User(user.uid, _nameController.text, _emailController.text);
        Response r = await dio.post("/user", data: modelUser.toJson());
        if (r.statusCode == 200) {
          setState(() {
            isSubmitting = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegistrationSuccessfulPage(name: _nameController.text)),
          );
        }
      }
    } else {
      setState(() {
        isEmailInUse = false;
        isFormInvalid = true;
        isSubmitting = false;
      });
      return null;
    }
  }
}
