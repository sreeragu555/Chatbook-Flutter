import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class SettingsScreen extends StatefulWidget {
  String imageurl;
  String Name;
  SettingsScreen(this.Name, this.imageurl);

  @override
  _SettingsState createState() => _SettingsState();
}

FirebaseAuth FAuth = FirebaseAuth.instance;
String uid = FAuth.currentUser.uid;
String Phonenumber = FAuth.currentUser.phoneNumber;

class _SettingsState extends State<SettingsScreen> {
  File _image;
  var imgurl;
  final picker = ImagePicker();
  final name = TextEditingController();
  @override
  List<String> subtitle = [Phonenumber, "abc@gmail.com"];
  List<IconData> logos = [Icons.local_phone_outlined, Icons.support];
  final List<String> entries = ["Phone", "Help and Support"];

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    _cropImage(pickedFile.path);
  }
  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 200,
      maxHeight: 200,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings:AndroidUiSettings(
        toolbarColor: Colors.blue,
            toolbarTitle: "Crop your image",
      ),
        cropStyle: CropStyle.circle,
      );
    setState(() {
      if (croppedImage != null) {
        _image = File(croppedImage.path) as File;
        uploadImageToFirebase(context);
      } else {
        Fluttertoast.showToast(
          msg: "No image has been selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = "";
    Reference ref =
        storage.ref().child("uploads/image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL() as String;
      updateImage(url);
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  Future<void> updateImage(url) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    users.where("uid", isEqualTo: uid).get().then((value) {
      users
          .doc(value.docs[0].reference.id)
          .update({'Profile_pic_url': url}).then((value) {
        //print("Updated image url");
        setState(() {
          widget.imageurl=url;
        });
      });
    });
  }

  var visible=false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        child:SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 30),
                      width: 200,
                      height: 200,
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))),
              Positioned(
                left: 240,
                top: 170,
                child: FloatingActionButton(
                  backgroundColor: Colors.lightGreen,
                  onPressed: () {
                    getImage();
                  },
                  tooltip: 'Pick Image',
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Offstage(
              offstage: visible==false?false:true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      widget.Name,
                      style: GoogleFonts.varelaRound(
                          fontSize: 23,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(onTap: () {
                    setState(() {
                      visible=true;
                    });
                    name.text=widget.Name;
                  }, child: Icon(Icons.edit))
                ],
              )),
          Offstage(
              offstage: visible==false?true:false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:200,
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      inputFormatters: [new WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z ]")),],
                      controller: name,
                    ),
                  ),
                  GestureDetector(onTap: () {
                    CollectionReference users = FirebaseFirestore.instance.collection('Users');
                    users.where("uid", isEqualTo: uid).get().then((value) {
                      users.doc(value.docs[0].reference.id).update({
                        'Name': name.text
                      }).then((value) {
                        //print("Updated Name");
                        setState(() {
                          widget.Name=name.text;
                          visible=false;
                        });
                      });
                    });
                  }, child: Icon(Icons.check))
                ],
              )),

          Container(
            margin: EdgeInsets.only(top: 30),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: ListTile(
                  leading: Container(
                    height: 50,
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.black87))),
                    child: Icon(logos[index]),
                  ),
                  title: Container(
                    child: Text(
                      entries[index],
                      style: GoogleFonts.mcLaren(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  subtitle: Container(
                    child: Text(subtitle[index],
                        style: GoogleFonts.koHo(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        )),
                  ),
                ));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Center(
                child: Text("from",
                    style: GoogleFonts.koHo(fontSize: 25, letterSpacing: 1))),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
                child: Text("NVS",
                    style: GoogleFonts.lobster(
                        fontSize: 25,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w900))),
          )
        ],
      ))),
    );
  }
}
