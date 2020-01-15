import 'package:abode/util/login_util.dart';
import 'package:flutter/material.dart';

class UncoupledTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction action;
  final FocusNode fn;
  final FocusNode fn2;
  final Function validator;

  const UncoupledTextField({this.isEnabled, this.controller, this.decoration, this.keyboardType, this.action, this.fn, this.fn2, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(),
      child: FormField(
        builder: (FormFieldState state) => TextField(
            enabled: isEnabled,
            controller: controller,
            decoration: decoration,
            keyboardType: keyboardType,
            textInputAction: action,
            focusNode: fn,
            onSubmitted: (String value) {
              fn.unfocus();
              FocusScope.of(context).requestFocus(fn2);
            }),
        validator: (_) => validator(controller.text),
      ),
    );
  }
}
