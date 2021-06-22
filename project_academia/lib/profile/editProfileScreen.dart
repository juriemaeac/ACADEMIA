
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample1/Settings.dart';
import 'package:image_picker/image_picker.dart';
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
  // static final TextEditingController textCourse = TextEditingController();
  // static final TextEditingController textLRN = TextEditingController();
  // static final TextEditingController textDescription = TextEditingController();
  static final TextEditingController textEmail = TextEditingController();
  // static final TextEditingController textNumber = TextEditingController();
  // static final TextEditingController textNationality = TextEditingController();

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
          Container(
            decoration: BoxDecoration(
              color: CustomColors.menuBackgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: CustomColors.menuBackgroundColor,
                    blurRadius: 4,
                    spreadRadius: 4,
                    offset: Offset(1, 1)),
              ],
            ),
            child: CircleAvatar(
              radius: 45.0,
              backgroundImage: userLoad.imagePath == null
                  ? AssetImage('assets/jurie.jpg')
                  : FileImage(File(userLoad.imagePath)),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 4,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                color: Color(0xFFEEBAB2),
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
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.9),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
          ),
        ],
        //borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: TextFormField(
          controller: textName,
          style: TextStyle(color: Colors.black, fontSize: 24),
          cursorColor: Colors.black,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Name';
            }
            return null;
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelText: 'Name',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 9,
              ),
              focusColor: Colors.black,
              isDense: true,
              prefixIcon: Icon(
                Icons.face_unlock_rounded,
                color: Colors.black,
                size: 24,
              )),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CustomColors.menuBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: CustomColors.menuBackgroundColor.withOpacity(0.9),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: TextFormField(
          controller: textEmail,
          style: TextStyle(color: Colors.white, fontSize: 24),
          cursorColor: Colors.white,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Enter Email';
            }
            return null;
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
              focusColor: Colors.white,
              isDense: true,
              prefixIcon: Icon(
                Icons.face_unlock_rounded,
                color: Colors.white,
                size: 24,
              )),
          /////using shared preferences
          onChanged: (value) {
            setState(() {
              userSave.userEmail = value;
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Color(0xFFFFB8AC),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Settings()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 0, right: 16),
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),
                Center(
                  child: Stack(
                    children: [
                      _buildImage(),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                _buildUsername(),
                _buildUserEmail(),
                buildTextField("Full Name", "${user.displayName}", false),
                buildTextField("Description", "Description", false),
                buildTextField("Course", "Course", false),
                buildTextField("LRN", "Enter LRN", false),
                buildTextField("E-mail", "${user.email}", false),
                buildTextField("Contact Number", "09123456789", false),
                buildTextField("Nationality", "Nationality", false),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        // Navigator.push(
                        //   context, 
                        //   MaterialPageRoute(
                        //     builder: (_)=> Profile(
                        //     ),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFEEBAB2),
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
                  ],
                ),
                SizedBox(height: 35),
                Text(
                  userLoad.userName ?? "Test User",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[900],
                      fontSize: 22),
                ),
              ],
            ),
        ),
            ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        //obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        //showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}

class ProfileInfo {
  

  var imagePath;
  String userName;
  String userEmail;

  ProfileInfo.createProfile(
      var imagePath,
      String userName,
      String userEmail) {
    imagePath = imagePath;
    userName = userName;
    userEmail = userEmail;
  }

  ProfileInfo();

  ProfileInfo.fromJson(Map<String, dynamic> json)
      : imagePath = json['imagePath'],
      userName = json['userName'],
      userEmail = json['userEmail'];
  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'userName': userName,
        'userEmail': userEmail,
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