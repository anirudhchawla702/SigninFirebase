import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  Widget firstname() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      controller: firstNameInputController,
      validator: (value) {
        if (value.length < 3) {
          return "Please enter a valid first name.";
        }
      },
    );
  }

  Widget lastname() {
    return TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        controller: lastNameInputController,
        validator: (value) {
          if (value.length < 3) {
            return "Please enter a valid last name.";
          }
        });
  }

  Widget email() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      controller: emailInputController,
      keyboardType: TextInputType.emailAddress,
      validator: emailValidator,
    );
  }

  Widget password() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      controller: pwdInputController,
      obscureText: true,
      validator: pwdValidator,
    );
  }

  Widget confirmpassword() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      controller: confirmPwdInputController,
      obscureText: true,
      validator: pwdValidator,
    );
  }

  Widget raisedbutton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_registerFormKey.currentState.validate()) {
            if (pwdInputController.text == confirmPwdInputController.text) {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: emailInputController.text,
                      password: pwdInputController.text)
                  .then((currentUser) => Firestore.instance
                      .collection("users")
                      .document(currentUser.user.uid)
                      .setData({
                        "uid": currentUser.user.uid,
                        "fname": firstNameInputController.text,
                        "surname": lastNameInputController.text,
                        "email": emailInputController.text,
                      })
                      .then((result) => {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          title: firstNameInputController.text +
                                              "'s Tasks",
                                          uid: currentUser.user.uid,
                                        )),
                                (_) => false),
                            firstNameInputController.clear(),
                            lastNameInputController.clear(),
                            emailInputController.clear(),
                            pwdInputController.clear(),
                            confirmPwdInputController.clear()
                          })
                      .catchError((err) => print(err)))
                  .catchError((err) => print(err));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("The passwords do not match"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
          }
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget flatbutton() {
    return FlatButton(
      child: Text(
        "Sign In",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget logo() {
    return Image.asset(
      "assets/images/nevergiveup.jpg",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  logo(),
                  SizedBox(
                    height: 5,
                  ),
                  firstname(),
                  SizedBox(
                    height: 15,
                  ),
                  lastname(),
                  SizedBox(
                    height: 15,
                  ),
                  email(),
                  SizedBox(
                    height: 15,
                  ),
                  password(),
                  SizedBox(
                    height: 15,
                  ),
                  confirmpassword(),
                  SizedBox(
                    height: 15,
                  ),
                  raisedbutton(),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Already have an account?"),
                  flatbutton(),
                ],
              ),
            ))));
  }
}
