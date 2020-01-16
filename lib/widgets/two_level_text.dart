import 'package:flutter/material.dart';

class TwoLevelText extends StatelessWidget {
  final String titleText;
  final String contentText;

  const TwoLevelText({this.titleText, this.contentText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titleText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          contentText,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
