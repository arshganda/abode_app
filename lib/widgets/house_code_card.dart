import 'package:flutter/material.dart';

class HouseCodeCard extends StatelessWidget {
  const HouseCodeCard({
    Key key,
    @required String cardText,
  })  : _cardText = cardText,
        super(key: key);

  final String _cardText;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          _cardText,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }
}
