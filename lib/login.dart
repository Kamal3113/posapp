import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:posbillingapp/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // late String _email, _password;
//   signupfirestorelogin(){
//   FirebaseAuth.instance.createUserWithEmailAndPassword(email: useremail.text, password: userpassword.text);

// }

  loginfirestore(BuildContext context) {
    _formKey.currentState.validate();
    if (_email.text.length == 0 ||
        _password.text.length == 0 ||
        !_email.text.contains("@")) {
      return;
    }
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _email.text, password: _password.text)
        .then((result) async {
      // String name = _email.text;
      // var changename = name.replaceAll('@techsapphire.net', '');
      // print(changename);
      SharedPreferences _localstorage = await SharedPreferences.getInstance();
      _localstorage.setString('email', _email.text);
      // _localstorage.setString('username', changename);
      _localstorage.setString('userid', result.user.uid);
      print(result.user.uid);

      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => Mainpage(name: '')),
          (Route<dynamic> route) => false);
    });
  }
  // Future<void> login() async {
  //   _formKey.currentState!.validate();
  //   try {
  //     FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //             email: _email.text, password: _password.text)
  //         .then((val) {
  //           if(val.user!.uid){

  //           }
  //         });
  //   } catch (e) {}
  //   // try{

  //   //   final FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _username, password: _password)).user;
  //   //   if(!user.uid.isEmpty()){
  //   //    Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()));
  //   //   }else{
  //   //    setState((){
  //   //      loginfail = true; //loginfail is bool
  //   //     });
  //   //   }

  //   // }catch(e){
  //   //   print(e.message);
  //   // }
  // }

  void initState() {
    super.initState();
  }

 String name;
  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .then((result) async {
        FirebaseFirestore.instance
            .collection(_email.text)
            .add({'name': _name.text});
        // String name = _email.text;
        // var changename = name.replaceAll('@techsapphire.net', '');
        // print(changename);
        SharedPreferences _localstorage = await SharedPreferences.getInstance();
        _localstorage.setString('email', _email.text);
        _localstorage.setString('username', _name.text);
        _localstorage.setString('userid', result.user.uid);

        print(result.user.uid);
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => Mainpage(name: _name.text)),
            (Route<dynamic> route) => false);
      });
    }
  }

  String register = '0';
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: register != '1'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                          child: Text('Smart',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                          child: Text('Food Store',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        // Container(
                        //   padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                        //   child: Text('.',
                        //       style: TextStyle(
                        //           fontSize: 80.0,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.green)),
                        // )
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                    labelText: 'EMAIL',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                                validator: (val) {
                                  if (val.length == 0)
                                    return "Please enter email";
                                  else if (!val.contains("@"))
                                    return "Please enter valid email";
                                },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                controller: _password,
                                decoration: InputDecoration(
                                    labelText: 'PASSWORD',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                                validator: (val) {
                                  if (val.length == 0)
                                    return "Please enter password";
                                },
                                obscureText: true,
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                alignment: Alignment(1.0, 0.0),
                                padding: EdgeInsets.only(top: 15.0, left: 20.0),
                                child: InkWell(
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.0),
                              Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70.0),
                                  color: Colors.green,
                                ),
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    loginfirestore(context);
                                  },
                                  child: Center(
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                height: 40.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: ImageIcon(
                                            AssetImage('assest/fb.png')),
                                      ),
                                      SizedBox(width: 10.0),
                                      Center(
                                        child: Text('Log in with facebook',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Montserrat')),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ))),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Don\'t have an Account ?',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          setState(() {
                            register = '1';
                          });
                          // Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                          child: Text('Smart',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                          child: Text('Food Store',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        // Container(
                        //   padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                        //   child: Text('.',
                        //       style: TextStyle(
                        //           fontSize: 80.0,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.green)),
                        // )
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _name,
                                decoration: InputDecoration(
                                    labelText: 'NAME',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                                validator: (val) {
                                  if (val.length == 0)
                                    return "Please enter NAME";
                                },
                              ),
                              TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                    labelText: 'EMAIL',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                                validator: (val) {
                                  if (val.length == 0)
                                    return "Please enter email";
                                  else if (!val.contains("@"))
                                    return "Please enter valid email";
                                },
                              ),
                              // SizedBox(height: 20.0),
                              TextFormField(
                                controller: _password,
                                decoration: InputDecoration(
                                    labelText: 'PASSWORD',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                                validator: (val) {
                                  if (val.length == 0)
                                    return "Please enter password";
                                },
                                obscureText: true,
                              ),
                              // SizedBox(height: 5.0),
                              // Container(
                              //   alignment: Alignment(1.0, 0.0),
                              //   padding: EdgeInsets.only(top: 15.0, left: 20.0),
                              //   child: InkWell(
                              //     child: Text(
                              //       'Forgot Password',
                              //       style: TextStyle(
                              //           color: Colors.green,
                              //           fontWeight: FontWeight.bold,
                              //           fontFamily: 'Montserrat',
                              //           decoration: TextDecoration.underline),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 40.0),
                              Container(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: Colors.greenAccent,
                                  color: Colors.green,
                                  elevation: 7.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      signUp();
                                    },
                                    child: Center(
                                      child: Text(
                                        'REGISTER',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 20.0),
                              Container(
                                height: 40.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: ImageIcon(
                                            AssetImage('assest/fb.png')),
                                      ),
                                      SizedBox(width: 10.0),
                                      Center(
                                        child: Text('Log in with facebook',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Montserrat')),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )))
                  // : Container(

                  ,
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Have an Account ?',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          setState(() {
                            register = '0';
                          });
                          // Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ));
  }
}
