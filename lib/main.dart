import 'package:aniketcheck2/login_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aniketcheck2/base_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
      builder: (ctx, usersnapshot) {
        //User? firebaseUser = FirebaseAuth.instance.currentUser;
        return usersnapshot.hasData ? Login_User() : Base_Screen();
      },
      stream: FirebaseAuth.instance.authStateChanges(),
    ));
  }
}
