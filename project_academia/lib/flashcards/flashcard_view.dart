import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  final String text;

  FlashcardView ({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.yellow[800],
      child: Center(
      child: Text(text, textAlign: TextAlign.center,),
      )
    );
  }
}