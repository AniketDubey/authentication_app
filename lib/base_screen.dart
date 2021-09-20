import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Base_Screen extends StatefulWidget {
  const Base_Screen({Key? key}) : super(key: key);

  @override
  _Base_ScreenState createState() => _Base_ScreenState();
}

class _Base_ScreenState extends State<Base_Screen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> authData = {
    "email": "",
    "password": "",
    "username": "",
    "loginstatus": true,
  };

  var isLogin = true;

  void trySubmit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      authData["loginstatus"] = isLogin;
      submitData(authData);
    }
  }

  void submitData(Map<String, dynamic> authDetails) async {
    UserCredential authResult;

    try {
      if (authData["loginstatus"] == true) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: authData["email"],
          password: authData["password"],
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: authData["email"],
          password: authData["password"],
        );
        FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user?.uid)
            .set(
          {
            "username": authData["username"],
            "email": authData["email"],
            "shubhnaam": "aniket",
          },
        );
      }
    } on FirebaseAuthException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                key: ValueKey("email"),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return "Please enter valid Email address";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email address',
                ),
                onSaved: (value) {
                  authData["email"] = value.toString().trim();
                },
              ),
              if (isLogin == false)
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "Please enter valid username";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  onSaved: (value) {
                    authData["username"] = value.toString().trim();
                  },
                ),
              TextFormField(
                validator: (value) {
                  if (value!.length < 8) {
                    return "length short";
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                onSaved: (value) {
                  authData["password"] = value.toString().trim();
                },
              ),
              SizedBox(
                height: 15,
              ),
              FloatingActionButton.extended(
                onPressed: trySubmit,
                label: Text(isLogin ? "Login" : "SignUp"),
              ),
              SizedBox(
                height: 15,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  setState(
                    () {
                      isLogin = !isLogin;
                    },
                  );
                },
                label: Text(isLogin
                    ? 'Create new account'
                    : 'I already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
