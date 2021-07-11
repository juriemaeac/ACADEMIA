import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:sample1/logic/get_books.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:sample1/models/book.dart';
import 'package:sample1/Navbar.dart';
import 'package:intl/intl.dart';
import 'package:sample1/profile/input.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int _currentIndex = 0;
  

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;
  
  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
        //Navigator.push(context, MaterialPageRoute(builder: (context)=> Navbar()));
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
        textName = '${user.displayName}';
        textEmail = '${user.email}';
        textDescription = '<<No description>>';
        textLRN = '<<No LRN>>';
        textCourse = '<<No Course>>';
        textNumber = '<<No Contact Number>>';
      });
    }
  }

  signOut() async {
    _auth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

//   void onTabTapped(int index) {
//    setState(() {
//      _currentIndex = index;
//    });
//  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: Navbar(),
      appBar: AppBar(title: Text('Home'),
      elevation: 0,
      backgroundColor: Colors.white,
      ),
      //body: _children[_currentIndex], // new
        // bottomNavigationBar: BottomNavigationBar(
          
        //   onTap: onTabTapped, // new
        //   currentIndex: _currentIndex, // this will be set when a new tab is tapped
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home,size: 30),
        //       label: 'Home',
        //     ),
            
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person, size: 30),
        //       label: 'Profile'
              
        //     )
        //   ],
        // ),
      
        //backgroundColor: Colors.white,
        body: Center(
          
          child: Container(
            
            child: SafeArea(
            child: !isloggedin? CircularProgressIndicator(
              backgroundColor: Color(0xFFE28C7E),
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Color(0xFFF2E2D2)),
              strokeWidth: 10,
            )
                :  
                Column(
                    children: <Widget>[
                      SizedBox(height: 0),
                      Container(
                        alignment: FractionalOffset.center,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              DateFormat("yMd").format(DateTime.now()),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[850], fontSize: 20),
                            ),
                            
                            Text(
                              DateFormat.jm().format(DateTime.now()),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[850], fontSize: 20)
                            ),
                            
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(  
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat.EEEE().format(DateTime.now()),
                          style: TextStyle(
                              
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE28C7E),),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(  
                        alignment: Alignment.center,
                        child: Text(
                          "ACADEMIA",
                          style: TextStyle(
                              
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE28C7E),),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Hello ${user.displayName} you are logged in as ${user.email}!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      
                      SizedBox(height: 40.0),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Assignments',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 40),
                            primary: Color(0xFF98BD91),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            )),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            primary: Color(0xFF98BD91),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            )),
                      ),
                      SizedBox(height: 70.0),
                      Container(
                        width: 380,
                        child: Center(
                          child: Text(
                            'This project aims to help the students and workers who are organizing '+ 
                            'their assignment or workloads.',
                            style: TextStyle(color: Colors.grey, fontSize: 13,),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ), 
                      SizedBox(height: 5.0),  
                      Text(
                        'Academia. All Rights Reserved (2021)',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),   
                                                                           
                    ],                    
                  ),
          )),
        ));
  }
}