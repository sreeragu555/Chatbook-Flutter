import 'dart:convert';
import 'package:chatbookflutter/AllUsers.dart';
import 'package:chatbookflutter/Chat.dart';
import 'package:chatbookflutter/Disaplayall.dart';
import 'package:chatbookflutter/LoginPage.dart';
import 'package:chatbookflutter/Settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'TestUsers.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

FirebaseAuth FAuth = FirebaseAuth.instance;
String uid = FAuth.currentUser.uid.toString();

class HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    print("current user id " + uid);
    //GetUserIDFromMessage();
    // print("After function"+MessageID.toString());
    // print("We are executing");
    // GetMessagedUsers();
  }

  @override
  static const String Settings = "Settings";
  static const String Logout = "Logout";
  static const List<String> choices = <String>[Settings, Logout];

  // List<AllUsers> Chats = [];
  //
  // List<TestUsers> chatUsers = [
  //   TestUsers(Name: "Sreerag", message_Text: "Hi", time: "Now"),
  //   TestUsers(Name: "Sreejith", message_Text: "Hi", time: "Now"),
  //   TestUsers(Name: "Sandeep", message_Text: "Hi", time: "Now"),
  // ];

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

  // Widget Chatslist() => ListView.builder(
  //     itemCount: chatUsers.length,
  //     shrinkWrap: true,
  //     //padding: EdgeInsets.only(top: 16),
  //     //physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return GestureDetector(
  //         onTap: () {},
  //         child: Container(
  //           padding: EdgeInsets.all(5),
  //           child: ListTile(
  //             onTap: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) =>
  //                           ChatScreen(chatUsers[index].Name)));
  //             },
  //             leading: CircleAvatar(
  //               child: Icon(Icons.person),
  //               radius: 25,
  //             ),
  //             title: Text(
  //               chatUsers[index].Name,
  //               style: TextStyle(
  //                   //fontWeight:FontWeight.bold,
  //                   letterSpacing: 1.0,
  //                   fontFamily: ''),
  //             ),
  //             trailing: Text(
  //               chatUsers[index].time,
  //               style: TextStyle(fontSize: 12),
  //             ),
  //             subtitle: Text(chatUsers[index].message_Text),
  //           ),
  //         ),
  //       );
  //     });
  // List<String> MessageID = [];
  //
  // Stream<AllUsers> GetUserIDFromMessage() {
  //   FirebaseFirestore.instance
  //       .collection('Messages')
  //       .orderBy("TimeStamp",descending: true)
  //       .where("User", arrayContains: uid)
  //       .get()
  //       .then((val) {
  //     for (int i = 0; i < val.docs.length; ++i) {
  //       setState(() {
  //       List.from(val.docs[i].data()["User"]).forEach((element) {
  //
  //         //then add the data to the List<Offset>, now we have a type Offset
  //         pointList.add(element);
  //         print(pointList);
  //       });
  //     });
  //           }
  //   });
  //   // print("From GetUserID "+MessageID[0]);
  //   GetMessagedUsers();
  // }
  //
  // Stream<AllUsers> GetMessagedUsers() {
  //   final jsonList = MessageID.map((item) => jsonEncode(item)).toList();
  //
  //   // using toSet - toList strategy
  //   final uniqueJsonList = jsonList.toSet().toList();
  //
  //   // convert each item back to the original form using JSON decoding
  //   final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
  //   print("result list contains:");
  //   print(result);
  //   for (int i = 0; i < result.length; i++) {
  //     FirebaseFirestore.instance
  //         .collection('Users')
  //         .where("uid", isEqualTo: result[i])
  //         .get()
  //         .then((value) {
  //       for (int i = 0; i < value.docs.length; ++i) {
  //         Chats.insert(
  //             0,
  //             AllUsers(
  //                 Name: value.docs[i].data()["Name"],
  //                 imageurl: value.docs[i].data()["Profile_pic_url"]));
  //       }
  //     });
  //   }
  //   print("Chats list contains:");
  //   print(Chats[0].Name.toString());
  // }

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
                DocumentSnapshot mypost = snapshot.data.docs[0];
                //print(snapshot.data.docs[0]["Chats"].length);
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('uid', isEqualTo: mypost["Chats"][index])
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
                                              document.data()['uid'])));
                                },
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(300.0),
                                    child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    document.data()[
                                                    'Profile_pic_url']))))),
                                title: Text(
                                  document.data()['Name'],
                                  style: TextStyle(
                                    //fontWeight:FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                // trailing: Text(
                                //   //getTime(mypost["TimeStamp"].toString()),
                                //   style: TextStyle(fontSize: 12),
                                // ),
                                // subtitle: Text(mypost["Message"]),
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

  String searchid;
  var displayusers = List<String>();
  Widget GetMessagedUserswidget() {
    return new StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Messages')
          .orderBy("TimeStamp", descending: true)
          .where("User",isEqualTo: uid )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('No Chats available..'));
        } else {
          return ListView.builder(
              physics: BouncingScrollPhysics(),
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot mypost = snapshot.data.docs[index];
                //print("Receiver id: " + mypost['Receiver_id']);
                //print(mypost["User"]);
                mypost["User"][0] == uid ? searchid = mypost['User'][1] : searchid = mypost["User"][0];
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('uid', isEqualTo: searchid)
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
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return new Container(
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              document.data()['Name'],
                                              document.data()['uid'])));
                                },
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(300.0),
                                    child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    document.data()[
                                                        'Profile_pic_url']))))),
                                title: Text(
                                  document.data()['Name'],
                                  style: TextStyle(
                                    //fontWeight:FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                trailing: Text(
                                  getTime(mypost["TimeStamp"].toString()),
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(mypost["Message"]),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    });
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
