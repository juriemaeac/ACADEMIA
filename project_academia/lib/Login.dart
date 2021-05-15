import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample1/HomePage.dart';
import 'package:sample1/SignUp.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  String _email, _password;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        //Navigator.pushReplacementNamed(context, "/");
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>HomePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } 
      catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Sign In Error.'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ]
        );
      }
    );
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }


  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              //SizedBox(height: 50.0),
              Container(
                height: 250,
                child: Image(
                image: AssetImage("assets/iconLog.png"),
                fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                child: Form(
                  key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Enter your Email.';
                            }
                            if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(input)) {
          return 'Please enter a valid email adress';
        }
                            return null;
                          },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              hoverColor: Color(0xFFE28C7E),
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                              prefixIcon: Icon(Icons.email)),
                            onSaved: (input) => _email = input,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Provide a Minimum of 6 Character Password.';
                              }
                              return null;
                            },
                            obscureText: !this._showPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              hoverColor: Color(0xFFE28C7E),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this._showPassword ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () {
                              setState(() => this._showPassword = !this._showPassword);
                              },
                            
                            ),
                            
                          ),
                          //obscureText: true, 
                          onSaved: (input) => _password = input,
                        ),
                        ),
                        SizedBox(height: 50.0),
                        ElevatedButton(
                        onPressed: login,
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          primary: Color(0xFFE28C7E),
                          onPrimary: Colors.white,
                          //shadowColor: Colors.grey,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  alignment: FractionalOffset.center,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Doesn't have an account yet? ",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      GestureDetector(
                        child: Text("Create an account here.",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.indigoAccent, fontSize: 15)),
                        onTap: navigateToSignUp,
                      )
                    ],
                  )
                ),
                SizedBox(height: 10.0),  
                Text(
                  'Secured login powered by: Firebase Authentication',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ), 
                Text(
                  'Academia. All Rights Reserved (2021)',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),     
            ],
          )
        ),
      )
    );
  }
}