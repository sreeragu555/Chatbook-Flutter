import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Chats.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
  String Name;
  ChatScreen(this.Name);
}

class ChatScreenState extends State<ChatScreen> {
  @override
  List<Chats> messages = [
    Chats(Message: "Hi", Time: "One Minute ago", Sender: "Sreerag"),
    Chats(Message: "Hi", Time: "One Minute ago", Sender: "Sreejith"),
    Chats(Message: "How are you?", Time: "One Minute ago", Sender: "Sreerag"),
    Chats(Message: "Iam Fine", Time: "One Minute ago", Sender: "Sreejith"),
    Chats(Message: "Call me if you are free", Time: "Now", Sender: "Sreerag"),
    Chats(Message: "Ok. Calling you", Time: "Now", Sender: "Sreejith"),
  ];
  final message = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: -10,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
                radius: 22,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${widget.Name}"),
                      Text(
                        "Online",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ))
            ],
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            inputMessage(),
            Messages(),
          ],
          overflow: Overflow.visible,
        ));
  }

  Widget inputMessage() {
    return Stack(
      children: <Widget>[
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
                    controller:message,
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
                    messages.add(Chats(Message: message.text,Time: "Now",Sender: "${widget.Name}"));
                    ChatScreen("${widget.Name}");
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
    );
  }

  Widget Messages() =>
      SingleChildScrollView(
      child: Stack(children: <Widget>[
        ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            //padding: EdgeInsets.only(top: 16),
            //physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].Sender == "${widget.Name}"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].Sender == "${widget.Name}"
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        messages[index].Message,
                        style: TextStyle(fontSize: 15),
                      )
                      // child: Row(
                      //
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text(messages[index].Message),
                      //     Container(
                      //     child: Align(
                      //         alignment: Alignment.bottomRight,
                      //             child: Text(messages[index].Time,style: TextStyle(
                      //           fontSize: 10
                      //         ),))),
                      //   ],
                      // )),
                      ),
                ),
              );
            })
      ])
      );
}
