//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
//import 'package:sample1/Sidebar_layout.dart';
import 'package:sample1/Navbar.dart';
import 'package:sample1/Profile.dart';
import 'package:sample1/Start.dart';
import 'package:sample1/Login.dart';
import 'package:sample1/HomePage.dart';
import 'package:sample1/SignUp.dart';
import 'package:sample1/Attendance.dart';
import 'package:sample1/Calendar.dart';
import 'package:sample1/flashcards/Reviewer.dart';
import 'package:sample1/Settings.dart';
import 'package:sample1/todo/Todolist.dart';
import 'package:sample1/schedule.dart';
import 'package:sample1/Policies.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:sample1/todo/todoProvider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final String title = 'Todo App';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodosProvider(),
      
    child: MaterialApp( //note dati itong return MaterialApp
      theme: ThemeData(
        
        primaryColor: Color(0xFFCDB193),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      //home: MyHome(),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/logo.png',
          ),
        nextScreen: Start(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Color(0xFFEEBAB2),
        duration: 2000,
      ),
      routes: <String, WidgetBuilder>{
        "Login": (BuildContext context) => Login(),
        "SignUp": (BuildContext context) => SignUp(),
        "start": (BuildContext context) => Start(),
        "HomePage": (BuildContext context) => HomePage(),
        "Navbar": (BuildContext context) => Navbar(),
        "Profile": (BuildContext context) => Profile(),
        "Todolist": (BuildContext context) => Todolist(),
        "Schedule": (BuildContext context) => Schedule(),
        "Calendar": (BuildContext context) => Calendar(),
        "Attendance": (BuildContext context) => Attendance(),
        "Reviewer": (BuildContext context) => Reviewer(),
        "Policies": (BuildContext context) => Policies(),
        "Settings": (BuildContext context) => Settings(),
      }
    ),
    );
    
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(title: Text('Home'),
      ),
      body: Center(),
    );
  }
}