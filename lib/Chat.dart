import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
  String Name;
  String puid;
  String imageurl;
  ChatScreen(this.Name, this.puid, this.imageurl);
}

FirebaseAuth FAuth = FirebaseAuth.instance;
String uid = FAuth.currentUser.uid.toString();

class ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController;

  void initState() {
    _scrollController = ScrollController();
    if (_scrollController.hasClients)
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
    super.initState();
  }

  @override
  final message = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                //margin: EdgeInsets.only(top: 30),
                width: 60,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: Image.network(
                      widget.imageurl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${widget.Name}"),
                    // Text(
                    //   "Online",
                    //   style: TextStyle(color: Colors.white, fontSize: 13),
                    // ),
                  ],
                ))
          ],
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            //margin: EdgeInsets.only(bottom: 70),
            height: MediaQuery.of(context).size.height - 150,
            child: GetMessage(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.attach_file,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: message,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      CollectionReference messages = FirebaseFirestore.instance
                          .collection('Chats')
                          .doc(uid + widget.puid)
                          .collection("Messages");
                      messages.add({
                        'Message': message.text,
                        'TimeStamp':
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        'User': FieldValue.arrayUnion([uid, widget.puid])
                      }).then((value) {
                        //print("Message added");
                        CheckReceiverinChats(uid, widget.puid, 0);
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
        //overflow: Overflow.,
      ),
    );
  }

  void CheckReceiverinChats(String Applyon, String addid, int checker) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    users.where("uid", isEqualTo: Applyon).get().then((value) {
      //print(value.docs[0].reference.id);
      List<dynamic> Users = value.docs[0].data()["Chats"];
      //print(Users.contains(widget.puid));
      var userexistornot = false;
      for (int i = 0; i < value.docs[0].data()["Chats"].length; i++) {
        if (value.docs[0].data()["Chats"][i]["SendBy"] == addid) {
          userexistornot = true;
          Users[i]["LastMessage"] = message.text;
          Users[i]["Time"] = DateTime.now().millisecondsSinceEpoch.toString();
          FirebaseFirestore.instance
              .collection('Users')
              .doc(value.docs[0].reference.id)
              .update({'Chats': Users}).then((value) {
            //print("updated the last message and time");
            if (checker == 0) {
              CheckReceiverinChats(addid, Applyon, 1);
            } else {
              message.text = "";
            }
          });
        }
      }
      if (userexistornot == false) {
        Users.add({
          'LastMessage': message.text,
          'Time': DateTime.now().millisecondsSinceEpoch.toString(),
          'SendBy': addid
        });
        FirebaseFirestore.instance
            .collection('Users')
            .doc(value.docs[0].reference.id)
            .update({'Chats': Users}).then((value) {
          //print("updated the last message and time with new data");
          message.text = "";
        });
      }
    });
  }

  // Widget displayMessages() {
  //   return new StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection('Messages')
  //           .orderBy("TimeStamp", descending: true)
  //           .where("User", arrayContains: widget.puid)
  //           .snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (!snapshot.hasData) {
  //           return Center(
  //               child: Text(
  //             "No contacts available",
  //             style: TextStyle(fontSize: 20),
  //           ));
  //         } else {
  //           return new StreamBuilder<QuerySnapshot>(
  //               stream: FirebaseFirestore.instance
  //                   .collection('Messages')
  //                   .orderBy("TimeStamp", descending: true)
  //                   .where("User", arrayContains: uid)
  //                   .snapshots(),
  //               builder: (BuildContext context,
  //                   AsyncSnapshot<QuerySnapshot> snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return Center(child: CircularProgressIndicator());
  //                 } else if (!snapshot.hasData) {
  //                   return Center(
  //                       child: Text(
  //                     "No contacts available",
  //                     style: TextStyle(fontSize: 20),
  //                   ));
  //                 } else {
  //                   if (_scrollController.hasClients)
  //                     _scrollController.animateTo(
  //                         _scrollController.offset + snapshot.data.docs.length,
  //                         duration: const Duration(milliseconds: 500),
  //                         curve: Curves.easeOut);
  //                   return new ListView(
  //                     shrinkWrap: true,
  //                     reverse: true,
  //                     controller: _scrollController,
  //                     scrollDirection: Axis.vertical,
  //                     physics: BouncingScrollPhysics(),
  //                     children:
  //                         snapshot.data.docs.map((DocumentSnapshot document) {
  //                       //print("Document datas");
  //                       //print(document.data()["User"][0]);
  //                       return Container(
  //                           padding: EdgeInsets.only(
  //                               left: 14, right: 14, top: 10, bottom: 10),
  //                           child: Align(
  //                               alignment:
  //                                   (document.data()["User"][1] == widget.puid
  //                                       ? Alignment.topRight
  //                                       : Alignment.topLeft),
  //                               child: Container(
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(20),
  //                                     color: (document.data()["User"][1] ==
  //                                             widget.puid
  //                                         ? Colors.grey.shade200
  //                                         : Colors.blue[200]),
  //                                   ),
  //                                   padding: EdgeInsets.all(16),
  //                                   child: Text(
  //                                     document.data()['Message'],
  //                                     style: TextStyle(fontSize: 15),
  //                                   ))));
  //                     }).toList(),
  //                   );
  //                 }
  //               });
  //         }
  //       });
  // }
  Widget GetMessage() {

    return new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .doc(uid + widget.puid)
            .collection("Messages")
            .orderBy("TimeStamp", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            print("in else");
            //Start
              return CheckwithIdreverse();
            //End
          } else {
            return new ListView(
              shrinkWrap: true,
              reverse: true,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                //print("Document datas");
                //print(document.data()["User"][0]);
                return Container(
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                        alignment: (document.data()["User"][1] == widget.puid
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (document.data()["User"][1] == widget.puid
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              document.data()['Message'],
                              style: TextStyle(fontSize: 15),
                            ))));
              }).toList(),
            );
          }
        });
  }
  Widget CheckwithIdreverse()
  {
    return new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .doc(widget.puid + uid)
            .collection("Messages")
            .orderBy("TimeStamp", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Center(
                child: Text(
                  "No Chats available",
                  style: TextStyle(fontSize: 20),
                ));
          } else {
            print("In ListView");
            return new ListView(
              shrinkWrap: true,
              reverse: true,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              children: snapshot.data.docs
                  .map((DocumentSnapshot document) {
                //print("Document datas");
                //print(document.data()["User"][0]);
                return Container(
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                        alignment: (document.data()["User"][1] ==
                            widget.puid
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(20),
                              color: (document.data()["User"]
                              [1] ==
                                  widget.puid
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              document.data()['Message'],
                              style: TextStyle(fontSize: 15),
                            ))));
              }).toList(),
            );
          }
        });
  }
}
