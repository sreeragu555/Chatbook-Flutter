import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomePage.dart';

class Adddetails extends StatefulWidget {
  @override
  _AdddetailsState createState() => _AdddetailsState();
}
var user = FirebaseAuth.instance.currentUser;
var uid = user.uid;
class _AdddetailsState extends State<Adddetails> {
  @override

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File _image;
  var imgurl;
  final name = TextEditingController();
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path) as File;
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url;
    Reference ref =
        storage.ref().child("uploads/image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL() as String;
      print(url);
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }



  Future<void> addUser() {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    // Call the user's CollectionReference to add a new user
     users.add({
       'uid':uid,
      'Name': name.text,
      'Profile_pic_url':imgurl
    })
        .then((value) {
          print("User Added");
          return true;
     })
        .catchError((error){
          print("Failed to add user: $error");
          return false;
     });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(300.0),
                child: _image != null
                    ? Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: FileImage(_image))))
                    : Stack(children: <Widget>[
                        Container(
                          width: 300,
                          height: 300,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: Image(
                                image: NetworkImage(
                                    "https://devtalk.blender.org/uploads/default/original/2X/c/cbd0b1a6345a44b58dda0f6a355eb39ce4e8a56a.png"),
                              )),
                        ),
                        Positioned(
                          child: FloatingActionButton(
                            onPressed: getImage,
                            tooltip: 'Pick Image',
                            child: Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                          left: 190,
                          top: 190,
                        ),
                      ])),
            Container(
              margin: EdgeInsets.only(left: 60, right: 60),
              child: TextField(
                controller: name,
                decoration: InputDecoration(hintText: "Name"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: () {
                    imgurl = uploadImageToFirebase(context);

                    if(imgurl!=null)
                    {
                      print("We have uploaded the image");
                      var added_or_not=addUser();
                      if(added_or_not==true)
                        {
                          print("We have added user also.");
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                        }
                    }
                    else
                      print("Some error while uploading image");
                  },
                  child: Text("Next")),
            )
          ],
        ),
      ),
    ));
  }
}
