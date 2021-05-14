import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample1/Start.dart';
//import 'package:sample1/logic/get_books.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:sample1/models/book.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        //Navigator.of(context).pushReplacementNamed("start");
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Start()));
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
      });
    }
  }

  signOut() async {
    _auth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                      SizedBox(height: 60.0),
                       Row( 
                      mainAxisAlignment: MainAxisAlignment.start,
                       children: <Widget>[
                        
                         
                          
                         ]
                       ),
                       Container(                    
                            alignment: Alignment.center,
                            child: Text(
                              "ACADEMIA",
                              style: TextStyle(
                                  
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                              textAlign: TextAlign.center,
                            ),
                          ),

                      
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Hello ${user.displayName} you are logged in as ${user.email}",
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
                                horizontal: 30, vertical: 20),
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
                      SizedBox(width: 100),
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              onPressed: signOut,
                              icon: Icon(Icons.exit_to_app,
                                color: Colors.white,
                                size: 20.0,),
                              label: Text(
                                'SIGN OUT',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(19, 0, 19, 0),
                                  primary: Colors.redAccent,
                                  onPrimary: Colors.white,                                 
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                            ),
                          ),   
                      SizedBox(height: 100.0),
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