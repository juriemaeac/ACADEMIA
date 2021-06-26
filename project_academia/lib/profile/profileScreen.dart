import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample1/Navbar.dart';
import 'package:sample1/forgotPass.dart';
import 'package:sample1/profile/animation.dart';
import 'package:flutter/material.dart';
import 'package:sample1/profile/editProfileScreen.dart';
import 'package:sample1/start.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPref sharedPref = SharedPref();
  ProfileInfo userLoad = ProfileInfo();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;
  //final userid = user.uid;
  
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
      });
    }
  }

  delete() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser.delete();
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
    loadSharedPrefs();
  }

  loadSharedPrefs() async {
    try {
      ProfileInfo user = ProfileInfo.fromJson(await sharedPref.read("user"));
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Loaded!"),
          duration: const Duration(milliseconds: 500)));
      setState(() {
        userLoad = user;
      });
    } catch (Exception) {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Nothing found!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    String _userName = userLoad.userName ?? "Username";
    String _userDesription = userLoad.userDescription ?? "<<Description>>";
    String _userEmail = userLoad.userEmail ?? "Email";
    String _userCourse = userLoad.userCourse ?? "Course";
    String _userLRN = userLoad.userLRN ?? "LRN";
    String _userNumber = userLoad.userNumber ?? "Number";
    return Scaffold(
      drawer: Navbar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Row(
                  children: <Widget>[
                    SizedBox(width: 245,),
                    IconButton(
                      icon: Icon(
                        Icons.mode_edit_outline, 
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_)=> EditProfile(
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          shadows: [
                            // Shadow( // bottomLeft
                            //   offset: Offset(-1.5, -1.5),
                            //   color: Colors.white
                            // ),
                            Shadow( // bottomRight
                              offset: Offset(1.5, -1.5),
                              color: Colors.black
                            ),
                            // Shadow( // topRight
                            //   offset: Offset(1.5, 1.5),
                            //   color: Colors.white
                            // ),
                            // Shadow( // topLeft
                            //   offset: Offset(-1.5, 1.5),
                            //   color: Colors.white
                            // ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_)=> EditProfile(
                            ),
                          ),
                        );
                      },
                    ),
                  ],
            
                ),
                expandedHeight: 420,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/profile.jpg'),
                        fit: BoxFit.cover
                      )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(.1)
                          ]
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(1, Text("$_userName", style: 
                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40)
                            ,)),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                FadeAnimation(1.2, 
                                  Text("$_userCourse", style: TextStyle(color: Colors.grey[850], fontSize: 16),)
                                ),
                                SizedBox(width: 50,),
                                FadeAnimation(1.3, Text("$_userLRN", style: 
                                  TextStyle(color: Colors.grey[850], fontSize: 16)
                                ,))
                              ],
                            )
                            
                          ],
                          
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(1.6, Text("$_userDesription", 
                        style: TextStyle(color: Colors.grey[850], height: 1.4,fontSize: 16,),)),
                        
                        SizedBox(height: 40,),
                        
                        Row(
                          children: [
                            FadeAnimation(1.6, 
                            Icon(Icons.email, color: Color(0xFFFFB8AC),),),
                            SizedBox(width: 10,),
                            FadeAnimation(1.6, 
                              Text("$_userEmail", style: TextStyle(color: Color(0xFFFFB8AC),fontSize: 18,fontWeight: FontWeight.bold),)
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            SizedBox(width: 33),
                            FadeAnimation(1.6, 
                              Text("Email", style: TextStyle(color: Colors.grey[850], ),)
                            ),
                          ],
                        ),
                            

                        SizedBox(height: 20,),
                        Row(
                          children: [
                            FadeAnimation(1.6, 
                            Icon(Icons.phone, color: Color(0xFFFFB8AC),),),
                            SizedBox(width: 10,),
                            FadeAnimation(1.6, 
                              Text("$_userNumber", style: TextStyle(color: Color(0xFFFFB8AC),fontSize: 18,fontWeight: FontWeight.bold),)
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            SizedBox(width: 33),
                            FadeAnimation(1.6, 
                              Text("Contact Number", style: TextStyle(color: Colors.grey[850], ),)
                            ),
                          ],
                        ),

                        SizedBox(height: 20,),
                        Row(
                          children: [
                            FadeAnimation(1.6, 
                            Icon(Icons.cake, color: Color(0xFFFFB8AC),),),
                            SizedBox(width: 10,),
                            FadeAnimation(1.6, 
                              Text("January 02, 2001", style: TextStyle(color: Color(0xFFFFB8AC),fontSize: 18,fontWeight: FontWeight.bold),)
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            SizedBox(width: 33),
                            FadeAnimation(1.6, 
                              Text("Birthdate", style: TextStyle(color: Colors.grey[850], ),)
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20,),
                        FadeAnimation(1.6,
                          Column(
                            children: [
                              Center(
                                child: GestureDetector(
                                  child: Text("Change Password",
                                  textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.grey[850], fontSize: 18, fontWeight: FontWeight.bold, ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        FadeAnimation(1.6,
                          Column(
                            children: [
                              Center(
                                child: GestureDetector(
                                  child: Text("Delete Account",
                                  textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.grey[850], fontSize: 18, fontWeight: FontWeight.bold, ),
                                  ),
                                  onTap: (){
                                    return showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text("Delete Account",textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        content: Text("Are you sure you want to delete your account?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              delete();
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => Start()));
                                            },
                                            child: Text('Yes',style: TextStyle(color: Colors.red[700]),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('No'))
                                        ],
                                      ),
                                    );
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
          // Positioned.fill(
          //   bottom: 50,
          //   child: Container(
          //     child: Align(
          //       alignment: Alignment.bottomCenter,
          //       child: FadeAnimation(2,
          //         Container(
          //           margin: EdgeInsets.symmetric(horizontal: 30),
          //           height: 50,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(50),
          //             color: Colors.yellow[700]
          //           ),
          //           child: Align(child: Text("Edit", style: TextStyle(color: Colors.white),)),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget makeVideo({image}) {
    return AspectRatio(
      aspectRatio: 1.5/ 1,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.3)
              ]
            )
          ),
          child: Align(
            child: Icon(Icons.play_arrow, color: Colors.white, size: 70,),
          ),
        ),
      ),
    );
  }
}