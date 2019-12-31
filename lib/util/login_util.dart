import 'package:flutter/material.dart';

String emailValidator(String value) {
  RegExp exp = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  if (exp.hasMatch(value)) {
    return null;
  }
  return 'Please enter a valid e-mail address';
}

String passwordValidator(String value) {
  RegExp exp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
  if (exp.hasMatch(value)) {
    return null;
  }
  return 'Please enter a password that has at least one letter, one number, and 8 characters long.';
}

String nameValidator(String value) {
  RegExp exp = RegExp(r"^([a-zA-ZÀ-ÿ\u00f1\u00d1]+[ \-]{0,1})+$");
  if (exp.hasMatch(value)) {
    return null;
  }
  return 'Please enter a valid name.';
}

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2.0),
      ),
    ],
  );
}
