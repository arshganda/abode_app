import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  final Widget buttonLabel;
  final Function onPressed;

  const ExpandedButton({this.buttonLabel, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: buttonLabel,
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
