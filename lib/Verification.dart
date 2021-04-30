import 'package:chatbookflutter/Adddetails.dart';
import 'package:chatbookflutter/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:overlay/overlay.dart';

class OTPScreen extends StatefulWidget {
  @override
    String phone;
  OTPScreen(this.phone);
  _otpscreenState createState() => _otpscreenState();
}

class _otpscreenState extends State<OTPScreen> {
  @override
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }
  String VerificationCode;
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBook"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text("We have send OTP to ${widget.phone}"),
          ),
          Container(
            margin: EdgeInsets.all(40),
            child: PinPut(
              fieldsCount: 6,
              onSubmit: (String pin){
                //CircularProgressIndicator();
                // CustomOverlay(
                //     context: context,
                // overlayWidget:
                // const SpinKitSquareCircle(color: Colors.blue,size: 50,),
                // );
                try{
                  FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: VerificationCode, smsCode: pin)).then((value)async{
                    if(value.user!=null)
                      {
                      print("Signed in");

                      Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Adddetails()));
                      }
                      });
                }catch(e){
                  print("Error"+e);
                }
              },
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(.5),
                ),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.all(40),
          //   child: Center(
          //     child: ElevatedButton(
          //       child: Text("GET OTP"),
          //       onPressed: () {
          //
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
  _verifyPhone() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async{
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              print("Signed in");
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Adddetails()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e)
        {
          print(e.message);
        },
        codeSent: (String verificationID,int ResendToken)
        {
          setState(() {
            this.VerificationCode=verificationID;
          });
          Fluttertoast.showToast(
              msg: "We have sent OTP",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
          );
        },
        codeAutoRetrievalTimeout:(String verificationID)
        {
          setState(() {
            this.VerificationCode=verificationID;
          });
        },
    timeout: Duration(seconds: 60));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}