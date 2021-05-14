//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sample1/Start.dart';
import 'package:sample1/Login.dart';
import 'package:sample1/HomePage.dart';
import 'package:sample1/SignUp.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        
        primaryColor: Color(0xFFE28C7E),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      //home: Start(),
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
      }
    );
  }
}
