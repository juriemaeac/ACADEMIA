import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample1/profile/profileScreen.dart';
import 'package:sample1/profile/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

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
    loadSharedPrefs();
  }
  

  PickedFile _imageFile;
  static ImagePicker _picker = ImagePicker();
  static final TextEditingController textName = TextEditingController();
  static final TextEditingController textCourse = TextEditingController();
  static final TextEditingController textLRN = TextEditingController();
  static final TextEditingController textDescription = TextEditingController();
  static final TextEditingController textEmail = TextEditingController();
  static final TextEditingController textNumber = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SharedPref sharedPref = SharedPref();
  ProfileInfo userSave = ProfileInfo();
  ProfileInfo userLoad = ProfileInfo();

  loadSharedPrefs() async {
    try {
      ProfileInfo user = ProfileInfo.fromJson(await sharedPref.read("user"));
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Data Loaded!"),
          duration: const Duration(milliseconds: 500)));
      setState(() {
        userLoad = user;
      });
    } catch (Excepetion) {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("No Data Available"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  Widget _buildImage() {
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned(
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.menuBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                width: 8,
                color: Colors.white,
              ),
            ),
            child: CircleAvatar(
              radius: 90.0,
              backgroundImage: userLoad.imagePath == null
                  ? AssetImage('assets/profile.jpg')
                  : FileImage(File(userLoad.imagePath)),
            ),
            
          ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(
                //   width: 4,
                //   color: Theme.of(context).scaffoldBackgroundColor,
                // ),
                color: Color(0xFFEEBAB2).withOpacity(.8),
              ),
              child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => _buildSheet()),
                );
              },
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              )
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
                    Color(0xFFEEBAB2),
                    Color(0xFFF2E2D2),
                  ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        //borderRadius: BorderRadius.only( topRight: Radius.circular(20),
        //topLeft: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Text("Choose Profile Image",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera_rounded, color: Colors.white),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text('Camera',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
              ),
              SizedBox(
                width: 15,
              ),
              TextButton.icon(
                icon: Icon(Icons.image_rounded, color: Colors.white),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text('Gallery',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
      userSave.imagePath = _imageFile.path;
    });
    Navigator.of(context).pop();
  }

  Widget _buildUsername() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      
      child: TextFormField(
          controller: textName,
          style: TextStyle(color: Colors.black, fontSize: 20),
          cursorColor: Colors.black,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Name';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: "${user.displayName}",
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            focusColor: Colors.black,
            isDense: true,
            prefixIcon: Icon(
              Icons.face_unlock_rounded,
              color: Colors.black,
              size: 24,
            ),
          ),
          /////using shared preferences
          onChanged: (value) {
            setState(() {
              userSave.userName = value;
            });
          }),
    );
  }

  Widget _buildUserEmail() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      // decoration: BoxDecoration(
      //   color: CustomColors.menuBackgroundColor,
      //   borderRadius: BorderRadius.all(Radius.circular(30)),
      // ),
      child: TextFormField(
          controller: textEmail,
          style: TextStyle(color: Colors.black, fontSize: 20),
          cursorColor: Colors.black,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Email';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: '${user.email}',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            focusColor: Colors.black,
            isDense: true,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
              size: 24,
            ),
          ),
          /////using shared preferences
          onChanged: (value) {
            setState(() {
              userSave.userEmail = value;
            });
          }),
    );
  }

  Widget _buildUserLRN() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      // decoration: BoxDecoration(
      //   color: CustomColors.menuBackgroundColor,
      //   borderRadius: BorderRadius.all(Radius.circular(30)),
      // ),
      child: TextFormField(
          controller: textLRN,
          style: TextStyle(color: Colors.black, fontSize: 20),
          cursorColor: Colors.black,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter LRN';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: 'LRN',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            focusColor: Colors.black,
            isDense: true,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
              size: 24,
            ),
          ),
          /////using shared preferences
          onChanged: (value) {
            setState(() {
              userSave.userEmail = value;
            });
          }),
    );
  }

  Widget _buildUserCourse() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      // decoration: BoxDecoration(
      //   color: CustomColors.menuBackgroundColor,
      //   borderRadius: BorderRadius.all(Radius.circular(30)),
      // ),
      child: TextFormField(
          controller: textCourse,
          
          style: TextStyle(color: Colors.black, fontSize: 20),
          cursorColor: Colors.black,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Course';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: 'Course',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            focusColor: Colors.black,
            isDense: true,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
              size: 24,
            ),
          ),
          /////using shared preferences
          onChanged: (value) {
            setState(() {
              userSave.userEmail = value;
            });
          }),
    );
  }

  Widget _buildUserDescription() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      // decoration: BoxDecoration(
      //   color: CustomColors.menuBackgroundColor,
      //   borderRadius: BorderRadius.all(Radius.circular(30)),
      // ),
      child: TextFormField(
          controller: textDescription,
          style: TextStyle(color: Colors.black, fontSize: 20),
          cursorColor: Colors.black,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Description';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: 'Description',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            focusColor: Colors.black,
            isDense: true,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
              size: 24,
            ),
          ),
          /////using shared preferences
          onChanged: (value) {
            setState(() {
              userSave.userEmail = value;
            });
          }),
    );
  }

  Widget _buildUserNumber() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      // decoration: BoxDecoration(
      //   color: CustomColors.menuBackgroundColor,
      //   borderRadius: BorderRadius.all(Radius.circular(30)),
      // ),
      child: TextFormField(
          controller: textNumber,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black, fontSize: 20),
          cursorColor: Colors.black,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Contact Number';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: 'Contact Number',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            focusColor: Colors.black,
            isDense: true,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
              size: 24,
            ),
          ),
          /////using shared preferences
          onChanged: (value) {
            setState(() {
              userSave.userEmail = value;
            });
          }),
    );
  }

  Widget _buildButton(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              primary: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("CANCEL",
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2.2,
                    color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }
              _formKey.currentState.save();

              sharedPref.save("user", userSave);
              print("Profile Saved");
              loadSharedPrefs();
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_)=> Profile(
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFFFB8AC),
            padding: EdgeInsets.symmetric(horizontal: 50),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              " SAVE ",
              style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.2,
                  color: Colors.white),
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),

    );
  }
  
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFFFB8AC),
        title: Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 80),
              Text(
                'Edit Profile', style: TextStyle(color: Colors.white, fontSize: 24),
                //textAlign: TextAlign.center,
              ),
              SizedBox(width: 70),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () async {
                },
              ),
            ],
          ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    
      body: Center(
      child: Container(
        child: !isloggedin? _progress():
        Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            }, 
            child:  Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFB8AC),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    //physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0, top: 0, right: 0),
                            //height: height * 0.43,
                            height: height -80,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                //double innerHeight = constraints.maxHeight;
                                double innerWidth = constraints.maxWidth;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      top: 120,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        //height: (innerHeight + 400 ),
                                        width: innerWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(130.0),
                                        bottomRight: Radius.circular(0.0),
                                        topLeft: Radius.circular(130.0),
                                        bottomLeft: Radius.circular(0.0)),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 80),
                                            _buildUsername(),
                                            SizedBox(height: 10),
                                            _buildUserDescription(),
                                            SizedBox(height: 10),
                                            _buildUserEmail(),
                                            SizedBox(height: 10),
                                            _buildUserLRN(),
                                            SizedBox(height: 10),
                                            _buildUserCourse(),
                                            SizedBox(height: 10),
                                            _buildUserNumber(),
                                            SizedBox(height: 20),
                                            _buildButton(),
                                          ],
                                        ), 
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          child: _buildImage(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class ProfileInfo {
  var imagePath;
  String userName;
  String userEmail;
  String userLRN;
  String userDescription;
  String userCourse;
  String userNumber;

  ProfileInfo.createProfile(
    var imagePath,
    String userName,
    String userEmail,
    String userLRN,
    String userDescription,
    String userCourse,
    String userNumber) {
    imagePath = imagePath;
    userName = userName;
    userEmail = userEmail;
    userLRN = userLRN;
    userDescription = userDescription;
    userCourse = userCourse;
    userNumber = userNumber;
  }

  ProfileInfo();

  ProfileInfo.fromJson(Map<String, dynamic> json)
    : imagePath = json['imagePath'],
    userName = json['userName'],
    userEmail = json['userEmail'],
    userLRN = json['userLRN'],
    userDescription = json['userDescription'],
    userCourse = json['userCourse'],
    userNumber = json['userNumber'];
  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'userName': userName,
    'userEmail': userEmail,
    'userLRN': userLRN,
    'userDescription': userDescription,
    'userCourse': userCourse,
    'userNumber': userNumber,
  };
}

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

Widget _progress(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Color(0xFFE28C7E),
            valueColor:
                new AlwaysStoppedAnimation<Color>(Color(0xFFF2E2D2)),
            strokeWidth: 10,
          ),
        ],
      ),
    );
}