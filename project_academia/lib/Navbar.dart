import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navbar extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  signOut() async {
    _auth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        //color: Colors.transparent,//Color(0xFFEEBAB2),
      child: Container(
      // decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [
      //           Color(0xFFEEBAB2),
      //           Color(0xFFF2E2D2),
      //         ],
      //       )
      //     ),
      child: ListView (
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFEEBAB2),
                Color(0xFFF2E2D2),
              ],
            )
          ),
          height: 105,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFEEBAB2),
              ),
              child: Text('ACADEMIA',
              style: TextStyle(color: Colors.white, fontSize: 24,)),
            ),
          ),
          UserAccountsDrawerHeader(
            accountName: Text('hatdogTestNamedipanagagawa'), 
            accountEmail: Text('testMaildipanagagawa@gmail.com'),
            
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network('https://i.pinimg.com/originals/21/59/c4/2159c493313c6084db38bee8e69a4fab.jpg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          // Divider(
          //   color: Colors.black,
          //   height: 0,
          //   thickness: 1,
          //   indent: 10,
          //   endIndent: 10,
          // ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.of(context).pushNamed("HomePage"),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => Navigator.of(context).pushNamed("Profile"),
            //onTap: ()=> null, //print('Home'),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('To-do List'),
            onTap: () => Navigator.of(context).pushNamed("Todolist"),
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text('Schedule'),
            onTap: () => Navigator.of(context).pushNamed("Schedule"),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () => Navigator.of(context).pushNamed("Calendar"),
          ),
          ListTile(
            leading: Icon(Icons.assignment_turned_in_sharp),
            title: Text('Attendance'),
            onTap: () => Navigator.of(context).pushNamed("Attendance"),
          ),
          ListTile(
            leading: Icon(Icons.rate_review_outlined),
            title: Text('Reviewer'),
            onTap: () => Navigator.of(context).pushNamed("Topic"),
          ),
          Divider(
            height: 30,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () => Navigator.of(context).pushNamed("Policies"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.of(context).pushNamed("Settings"),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: signOut,
          ),
        ],
      ),
      ),
    ),
    );
    
  }
}

