
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sample1/reviewer/addReviewer.dart';
import 'package:sample1/reviewer/reviewerModel.dart';
import 'package:sample1/databaseHelpers.dart';

class ReviewerScreen extends StatefulWidget {
  final Function updateReviewerList;
  final Reviewer reviewer;
  ReviewerScreen({this.updateReviewerList, this.reviewer});

  @override
  _ReviewerScreenState createState() => _ReviewerScreenState();
}

class _ReviewerScreenState extends State<ReviewerScreen> {
  Future<List<Reviewer>> _reviewerList;

  @override
  void initState() { 
    super.initState();
    _updateReviewerList();
    //_delete();
  }

  _updateReviewerList() {
    setState(() {
      _reviewerList = DatabaseHelper.instance.getReviewerList();
    });
  }

  @override
  void dispose(){
    //_dateController.dispose();
    super.dispose();
  }

  // _delete() {
  //   DatabaseHelper.instance.deleteReviewer(widget.reviewer.idReviewer);
  //   widget.updateReviewerList();
  //   Navigator.pop(context);
  // }

  

  Widget _buildReviewer (Reviewer reviewer){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        
        child: Column(
          children: <Widget>[
            // Icon(
            //       Icons.lightbulb_outline_rounded, 
            //       size: 20,
            //       color: Colors.black,
            //     ),
            ListTile(
              title: Transform.translate(
                offset: Offset(20, 0),
                child: Text(reviewer.titleReviewer,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    decoration: reviewer.statusReviewer == 0 
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
                  ),
                ),
              ),
              subtitle: Transform.translate(
                offset: Offset(20, 0),
                child: Text('${reviewer.descriptionReviewer}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    // decoration: reviewer.statusReviewer == 0 
                    // ? TextDecoration.none
                    // : TextDecoration.lineThrough,
                  ),
                ),
              ),
              trailing: Icon(Icons.bookmark_border_outlined,
                  size: 25,
                  color: Color(0xFF98BD91)),
            ),
            Divider(),
          ],
        ),
      ),
      
        actions: <Widget>[
          IconSlideAction(
            caption: 'Edit',
            color: Colors.green,
            icon: Icons.edit,
            onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => AddReviewerScreen(
                    updateReviewerList: _updateReviewerList,
                    reviewer: reviewer,
                  ),
                ),
              ),
          ),
        ],
        
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {},
            ),
        ],
      ),
    );
  }

  navigateToFlashcard() async {
    Navigator.pushReplacementNamed(context, "FR");//Flashcard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar:
      PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: AppBar(
          centerTitle: false,
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // SizedBox(height: 30),
              //   GestureDetector(
              //     onTap: () => Navigator.pop(context),
              //     child: Icon(Icons.arrow_back, 
              //     size: 40,
              //     color: Colors.black,
              //     ),
              //   ),
              Text(
              'Topic Title',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, 
                  fontSize: 20),
              ),
              SizedBox(width: 95),
              IconButton(
                icon: Icon(
                  Icons.add, 
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_)=> AddReviewerScreen(
                        updateReviewerList: _updateReviewerList,
                      ),
                    ),
                  );
                },
              ),
              GestureDetector(
                child: Text(
                  'Add Card',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold, 
                      fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_)=> AddReviewerScreen(
                        updateReviewerList: _updateReviewerList,
                      ),
                    ),
                  );
                },
              ),
            ],
            
           )
           //backgroundColor: Color.fromRGBO(232, 232, 242, 1),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(25),
      //   ),
      //   backgroundColor: Color(0xFFCDB193),
      //   child: Icon(Icons.add),
      //   onPressed: () => Navigator.push(
      //     context, 
      //     MaterialPageRoute(
      //       builder: (_)=> AddReviewerScreen(
      //         updateReviewerList: _updateReviewerList,
      //       ),
      //     ),
      //   ),
      // ),
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
          padding: EdgeInsets.symmetric(vertical: 0),
          itemCount: 1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15, 
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 0),
                      Container(
                        alignment: FractionalOffset.center,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){},
                              child: Icon(Icons.sort_outlined, 
                              size: 30,
                              color: Colors.black,
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(
                                Icons.library_books_outlined,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: navigateToFlashcard,
                              label: Text('Practice',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 8),
                                  primary: Color(0xFF98BD91),
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.search, 
                              size: 30,
                              color: Colors.black,
                              ),
                            ),
                            
                          ],
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
                  ]
                ),
              );
            }
            // return Container(
            //   margin: EdgeInsets.all(3),
            //   height: 100, 
            //   width: double.infinity, 
            //   color: Colors.red,
            // );
            return _buildReviewer(snapshot.data[index-1]);
          },
        );
        },
      ),
    );
  }
}