import 'dart:async';

import 'package:flutter/material.dart';

import 'package:posbillingapp/homescreen.dart';
import 'package:posbillingapp/login.dart';
import 'package:posbillingapp/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   String userid;
   String username;
  getappid() async {
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("userid").toString();
      username = preferences.getString("username").toString();
    });
    return Timer(Duration(seconds: 3), () {
      checkuserid(context);
    });
  }

  checkuserid(context) {
    if (userid == 'null') {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    } else
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Homescreen(
                    name: username,
                  )),
          (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    getappid();

    // Timer(Duration(seconds: 3), () {
    //   return
    //   // Navigator.pushAndRemoveUntil(
    //   //             context,
    //   //             MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
    //   //            (Route<dynamic> route) => false
    //   //           );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 180,
                          width: 130,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              shape: BoxShape.circle),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            //  radius: 5,
                            // child: ClipOval(
                            //   child: Image.asset(
                            //     "assest/vakeel.png",
                            //   ),
                            // ),
                          )
                          // Image.asset("assest/vakeel.png"),
                          ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Food Store ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Version-1.0",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
