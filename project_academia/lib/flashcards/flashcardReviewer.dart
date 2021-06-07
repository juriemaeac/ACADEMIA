
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:sample1/flashcards/flashcard_view.dart';
import 'package:sample1/reviewer/reviewerModel.dart';
import 'package:sample1/todolist/databaseHelpers.dart';

class Flashcard extends StatefulWidget {
  final Function updateReviewerList;
  final Reviewer reviewer;
  Flashcard({this.updateReviewerList, this.reviewer});

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  Future<List<Reviewer>> _reviewerList;

  @override
  void initState() { 
    super.initState();
    _updateReviewerList();
    //_delete();
  }

  int _currentIndex = 0;

  _updateReviewerList() {
    setState(() {
      _reviewerList = DatabaseHelper.instance.getReviewerList();
    });
  }

  int itemCount;
  @override
  void dispose(){
    //_dateController.dispose();
    super.dispose();
  }


  Widget _buildReviewer (Reviewer reviewer){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
      child: Center(
      child: Column(
      
      children: <Widget>[
        Container(
              margin: EdgeInsets.all(0),
              width: 350,
              height: 500,
              child: FlipCard(
                front: FlashcardView(
                  text: reviewer.titleReviewer,
                ),
                back: FlashcardView(
                  text: '${reviewer.descriptionReviewer}',
                ),
              ),
        ),

        ],
        ),
      ),
      ),

      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder(
        future: _reviewerList,
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),
            );
          }

          final int completedReviewerCount = snapshot.data
          .where((Reviewer reviewer) => reviewer.statusReviewer == 1)
          .toList()
          .length;

          return ListView.builder(
          //shrinkWrap: true,
          
          padding: EdgeInsets.symmetric(horizontal: 0),
          itemCount: 1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15, 
                  vertical: 60,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back_ios_new_outlined, 
                          size: 15,
                          color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                        child: Text(
                          'back',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      ]
                    ),
                        Container(  
                          alignment: Alignment.center,
                          child: Text(
                            "My Flashcards",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE28C7E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    SizedBox(height: 10),
                    
                    
                    Center( 
                      child: Text('$completedReviewerCount of ${snapshot.data.length}',
                      style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20, 
                      fontWeight: FontWeight.w600,  
                      ),
                    ),
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: (){
                            setState((){
                                _currentIndex = 
                                  (_currentIndex - 1 >= 0) ? _currentIndex - 1: snapshot.data.length - 1;
                              });
                          },
                          icon: Icon(
                            Icons.chevron_left,
                          ),
                          label: Text('Prev',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF98BD91),
                              onPrimary: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: (){
                            setState((){
                              _currentIndex = 
                                (_currentIndex + 1 < snapshot.data.length) ? _currentIndex + 1: 0;
                            });
                          },
                          icon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          label: Text('Next',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF98BD91),
                              onPrimary: Colors.white,
                          ),
                        ), 
                      ],
                    )
                  ]
                ),
              );
            }
            
            return _buildReviewer(snapshot.data[index-1]);
          },
        );
        },
      ),
      
    );
    
    
  }

  
}