import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
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

  Widget emailInput() {
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

  Widget passwordInput() {
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      controller: pwdInputController,
      obscureText: true,
      validator: pwdValidator,
    );
  }

  Widget button() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_loginFormKey.currentState.validate()) {
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailInputController.text,
                    password: pwdInputController.text)
                .then((currentUser) => Firestore.instance
                    .collection("users")
                    .document(currentUser.user.uid)
                    .get()
                    .then(
                        (DocumentSnapshot result) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      title: result["fname"] + "'s Tasks",
                                      uid: currentUser.user.uid,
                                    ))))
                    .catchError((err) => print(err)))
                .catchError((err) => print(err));
          }
        },
        child: Text(
          "Login",
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: FlatButton(
        child: Text(
          "Register here!",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/register");
        },
      ),
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
          title: Center(
            child: Text(
              "Login Page",
            ),
          ),
        ),
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                  child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    logo(),
                    emailInput(),
                    SizedBox(
                      height: 15,
                    ),
                    passwordInput(),
                    SizedBox(
                      height: 15,
                    ),
                    button(),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Don't have an account yet?"),
                    SizedBox(
                      height: 4,
                    ),
                    flatbutton(),
                  ],
                ),
              ))),
        ));
  }
}
