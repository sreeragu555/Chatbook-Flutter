import 'package:chatbookflutter/Chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'TestUsers.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  static const String Settings = "Settings";
  static const String Logout = "Logout";
  static const List<String> choices = <String>[Settings, Logout];

  List<TestUsers> chatUsers = [
    TestUsers(Name: "Sreerag", message_Text: "Hi", time: "Now"),
    TestUsers(Name: "Sreejith", message_Text: "Hi", time: "Now"),
    TestUsers(Name: "Sandeep", message_Text: "Hi", time: "Now"),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBook"),
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
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
        margin: EdgeInsets.only(top: 5),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Chats(),
        ),
      ),
    );
  }

  void Action_for_PopUp(String choice) {
    if (choice == Settings)
      print("Settings clicked");
    else if (choice == Logout) print("Logout clicked");
  }

  Widget Chats() => ListView.builder(
      itemCount: chatUsers.length,
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen(chatUsers[index].Name)));
              },
              leading: CircleAvatar(
                child: Icon(Icons.person),
                radius: 25,
              ),
              title: Text(
                chatUsers[index].Name,
                style: TextStyle(
                    //fontWeight:FontWeight.bold,
                    letterSpacing: 1.0,
                    fontFamily: ''),
              ),
              trailing: Text(
                chatUsers[index].time,
                style: TextStyle(fontSize: 12),
              ),
              subtitle: Text(chatUsers[index].message_Text),

            ),

          ),
        );
      });
}
