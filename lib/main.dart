import 'package:chatbookflutter/HomePage.dart';
import 'package:chatbookflutter/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'LoginPage.dart';

void main() aync {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if ( FirebaseAuth.instance.currentUser != null) {
      return MaterialApp(
        title: 'ChatBook',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      );
    } else {
      return MaterialApp(
        title: 'ChatBook',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      );
    }


  }
}


