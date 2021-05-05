import 'package:chatbookflutter/HomePage.dart';
import 'package:chatbookflutter/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'LoginPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if ( FirebaseAuth.instance.currentUser != null) {
      return MaterialApp(
        title: 'ChatBook',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        builder: EasyLoading.init(),
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

