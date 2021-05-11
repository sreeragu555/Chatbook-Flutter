import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
String imageurl;
String Name;
SettingsScreen(this.Name,this.imageurl);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Settings"),
    ),
    body:Container(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        children: [
          Center(
            child: Container(
              width: 300,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.network(widget.imageurl,
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
                ),
              ),
            ),
          ),
          // Positioned(
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       //getImage();
          //     },
          //     tooltip: 'Pick Image',
          //     child: Icon(
          //       Icons.add_a_photo,
          //     ),
          //   ),
          //   left: 190,
          //   top: 190,
          // ),
        ],
      )
    ],
    )
    ),
    );
  }
}
