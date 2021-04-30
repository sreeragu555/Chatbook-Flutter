import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_animations/loading_animations.dart';
import 'Adddetails.dart';
import 'Verification.dart';
import 'package:overlay/overlay.dart';

class LoginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}
final number = TextEditingController();

class _loginPageState extends State<LoginPage> {
  @override
  //final globalKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBook"),
        ),

      body: Builder(
      builder: (context) =>Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            margin: EdgeInsets.all(40),
            child: Center(
              child: Text("Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: 28
              ),),
            ),
          ),
          Container(
            margin: EdgeInsets.all(40),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Mobile number",
                  prefix: Text("+91"),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: number,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(40),
            child: Center(
              child: ElevatedButton(
                child: Text("GET OTP"),
                onPressed: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Adddetails()));

                  if(number.text.length==10)
                  Navigator.of(context).push( MaterialPageRoute(builder:(context) => OTPScreen(number.text)));
                  else {
                    final snackBar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Please enter a valid mobile number'),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ),
          //Loader(),
        //CircularProgressIndicator(),
        ],
      ),
    ),
    );
  }
  // Widget Loader()
  // {
  //   return CustomOverlay(
  //       context: context,
  //       // Using overlayWidget
  //       overlayWidget: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //   child: Card(
  //   child: Padding(
  //   padding: EdgeInsets.all(8),
  // child: const SpinKitRotatingCircle(color: Colors.blue)
  //   ));
  // }
}
