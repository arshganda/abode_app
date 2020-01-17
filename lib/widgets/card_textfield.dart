import 'package:flutter/material.dart';

class TextFieldCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode fn;
  final TextInputAction action;
  final Function onSubmitted;

  const TextFieldCard({this.controller, this.fn, this.action, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 32,
          child: TextField(
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
            controller: controller,
            focusNode: fn,
            textInputAction: action,
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    );
  }
}
