import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login_User extends StatefulWidget {
  @override
  State<Login_User> createState() => _Login_UserState();
}

class _Login_UserState extends State<Login_User> {
  var uName;

  @override
  void initState() {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser?.uid)
        .get()
        .then(
      (value) {
        //print(value.data());
        setState(() {
          //uName = value.data()!["username"];
          uName = value.data();
        });
      },
    );
    super.initState();
  }

  Future<void> _updateData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser?.uid)
        .update({
      "shubhnaam": "",
    });
  }

  Future<void> _deleteUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser?.uid)
        .delete();

    //  change the screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(uName == null ? "Loading...." : uName["username"]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              label: Text("LOGOUT"),
            ),
            FloatingActionButton.extended(
              onPressed: _updateData,
              label: Text("EDIT"),
            ),
            FloatingActionButton.extended(
              onPressed: _deleteUser,
              label: Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
