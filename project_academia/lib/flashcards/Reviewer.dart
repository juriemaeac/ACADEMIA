import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:sample1/flashcards/flashcard.dart';
import 'package:sample1/flashcards/flashcard_view.dart';

class Reviewer extends StatefulWidget {
  @override
  _ReviewerState createState() => _ReviewerState();
}
class _ReviewerState extends State<Reviewer> {
  List<Flashcard> _flashcards = [
    Flashcard(
      question: "ano kinain mo?",
      answer: "secret"),
    Flashcard(
      question: "sino crush mo?",
      answer: "pake mo"),
    Flashcard(
      question: "ano binili mo?",
      answer: "hatdog ka"),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: FlipCard(
                front: FlashcardView(
                  text: _flashcards[_currentIndex].question,
                  ),
                back: FlashcardView(
                  text: _flashcards[_currentIndex].answer,
                  ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              OutlinedButton.icon(
                onPressed: showPreviousCard,
              icon: Icon(Icons.chevron_left),
              label: Text('Prev')),
              OutlinedButton.icon(
                onPressed: showNextCard,
                icon: Icon(Icons.chevron_right),
                label: Text('Next')), 
              ],
            )
          ],
        ),
      ),
    );
  }

  void showNextCard(){
  setState((){
      _currentIndex = 
        (_currentIndex + 1 < _flashcards.length) ? _currentIndex + 1: 0;
    });
  }
    
  void showPreviousCard(){
    setState((){
      _currentIndex = 
        (_currentIndex - 1 >= 0) ? _currentIndex - 1: _flashcards.length - 1;
    });
  }
}


