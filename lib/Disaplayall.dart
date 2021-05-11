import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Chat.dart';

class Displayall extends StatefulWidget {
  _DisplayallState createState() => _DisplayallState();
}
class _DisplayallState extends State<Displayall> {
  Widget build(BuildContext context) {
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
          ],
        ),
        body: displayAllUsers());
  }

  Widget displayAllUsers() {
    return new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if(!snapshot.hasData)
            {
             return Center(
               child: Text("No contacts available",style: TextStyle(
                 fontSize: 20
               ),)
             ) ;
            }
          else {
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return new Container(
                    padding: EdgeInsets.all(5),
                    child: ListTile(
                              onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatScreen(document.data()['Name'],document.data()['uid'])));
                              },
                        leading: CircleAvatar(
                                           child: Icon(Icons.person),
                                           radius: 25,
                                         ),
                                         title: Text(document.data()['Name'], style: TextStyle(
                                             //fontWeight:FontWeight.bold,
                                           letterSpacing: 1.0,
                                           ),
                                        ),
                ),
                );
              }).toList(),
            );
          }
        }
    );
  }
}