import 'package:abode/util/login_util.dart';
import 'package:flutter/material.dart';

class UncoupledTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction action;
  final FocusNode fn;
  final Function validator;
  final Function onSubmitted;
  final bool shouldObscureText;
  final bool shouldAutocorrect;

  const UncoupledTextField(
      {this.isEnabled, this.controller, this.shouldAutocorrect = true, this.shouldObscureText = false, this.decoration, this.keyboardType, this.action, this.fn, this.validator, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(),
      child: FormField(
        builder: (FormFieldState state) => TextField(
          enabled: isEnabled,
          controller: controller,
          autocorrect: shouldAutocorrect,
          obscureText: shouldObscureText,
          decoration: decoration,
          keyboardType: keyboardType,
          textInputAction: action,
          focusNode: fn,
          onSubmitted: onSubmitted,
        ),
        validator: (_) => validator(controller.text),
      ),
    );
  }
}
