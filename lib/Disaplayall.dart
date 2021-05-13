import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Chat.dart';

class Displayall extends StatefulWidget {
  _DisplayallState createState() => _DisplayallState();
}
FirebaseAuth FAuth = FirebaseAuth.instance;
String uid = FAuth.currentUser.uid.toString();
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
        stream: FirebaseFirestore.instance.collection('Users').where("uid", isNotEqualTo: uid).snapshots(),
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
                              MaterialPageRoute(builder: (context) => ChatScreen(document.data()['Name'],document.data()['uid'],document.data()[
                              'Profile_pic_url'])));
                              },
                        leading: Container(
                            width: 50,
                            height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(300),
                                child: Image.network(
                                  document.data()[
                                  'Profile_pic_url'],
                                  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null ?
                                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
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