import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AllUsers.dart';
import 'Chat.dart';

class Displayall extends StatefulWidget {

  _DisplayallState createState() => _DisplayallState();
}

List<AllUsers> allcontacts = [];
FirebaseAuth user = FirebaseAuth.instance;
String uid = user.currentUser.uid.toString();

class _DisplayallState extends State<Displayall> {

  Future GetUsers() async{
    allcontacts=[];
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    users.doc(uid).get().then((value){
      allcontacts.insert(0,AllUsers(Name: value.data()["Name"], imageurl: value.data()["Profile_pic_url"]));
      print("NICE");
    });
  }

  @override
  void initState(){
    GetUsers();
    super.initState();
  }

  Widget build(BuildContext context) {
    if (allcontacts.length != 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text("ChatBook"),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  ))
            ],),
          body: displayAllUsers()
      );
    }
    else{
      return Scaffold(
          appBar: AppBar(
            title: Text("ChatBook"),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  ))
            ],),
          body: Container(
            child: Center(
              child: Text("No contacts available",style: TextStyle(
                fontSize: 20,
              ),)
            ),
          )
      );
    }
  }



  Widget displayAllUsers() =>
    ListView.builder(
        itemCount: allcontacts.length,
        shrinkWrap: true,
        //padding: EdgeInsets.only(top: 16),
        //physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    //border: Border(bottom: BorderSide())
                    ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 25,
                  ),
                  title: Text(
                    allcontacts[index].Name,
                    style: TextStyle(
                        //fontWeight:FontWeight.bold,
                        letterSpacing: 1.0,
                        fontFamily: ''),
                  ),
                ),
              ));
        });
  }
