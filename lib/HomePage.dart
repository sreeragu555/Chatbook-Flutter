import 'package:chatbookflutter/Chat.dart';
import 'package:chatbookflutter/Disaplayall.dart';
import 'package:chatbookflutter/LoginPage.dart';
import 'package:chatbookflutter/Settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

FirebaseAuth FAuth = FirebaseAuth.instance;
String uid = FAuth.currentUser.uid.toString();

class HomeScreenState extends State<HomeScreen> {
  @override
  static const String Settings = "Settings";
  static const String Logout = "Logout";
  static const List<String> choices = <String>[Settings, Logout];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBook"),
        leading: GestureDetector(
          onTap: () {
          },
          child: Icon(Icons.person),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              onSelected: Action_for_PopUp,
              offset: Offset(150, 30),
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem(value: choice, child: Text(choice));
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: Container(
        //margin: EdgeInsets.only(top: 5),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: CheckwithUser(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message_outlined),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Displayall()));
          }),
    );
  }

  Future<void> Action_for_PopUp(String choice) async {
    if (choice == Settings)
      {
        FirebaseFirestore.instance
                 .collection('Users')
                 .where("uid", isEqualTo: uid)
                 .get()
                .then((value) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SettingsScreen(value.docs[0].data()["Name"],value.docs[0].data()["Profile_pic_url"]
                  )));
        });
        }
    else if (choice == Logout) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Widget CheckwithUser() {
    return new StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where("uid",isEqualTo: uid )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('No Chats available..'));
        } else {
          return ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.docs[0]["Chats"].length,
              itemBuilder: (context, index) {
                //DocumentSnapshot mypost = snapshot.data.docs[0];
                Map<dynamic, dynamic> User =snapshot.data.docs[0]["Chats"][index];
                //print(User["SendBy"]);
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('uid', isEqualTo: User["SendBy"])
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                              "No contacts available",
                              style: TextStyle(fontSize: 20),
                            ));
                      } else {
                        return new ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                            return new Container(
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              document.data()['Name'],
                                              document.data()['uid'],document.data()['Profile_pic_url'])));
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
                                title: Text(
                                  document.data()['Name'],
                                  style: TextStyle(
                                    //fontWeight:FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                 trailing: Text(
                                   getTime(User["Time"]),
                                   style: TextStyle(fontSize: 12),
                                 ),
                                 subtitle: Text(User["LastMessage"]),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    });
                //return Container(child: Text(mypost["Chats"][index]));
              });
        }
      },
    );
  }

  String getTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
      format = DateFormat.yMMMMd('en_US').add_jm();
    } else {
      format = DateFormat.yMd('en_US');
    }
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }
}
