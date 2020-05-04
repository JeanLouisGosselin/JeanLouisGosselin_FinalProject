import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:audioplayers/audio_cache.dart';
import '../reusables/MainAppBarDesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'CreateUsernameAndDobScreen.dart';
import 'dart:async';



class CreateAccountScreen extends StatefulWidget {

  static const String id = 'CreateAccount_Screen';

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;

  //this is for the spinner:
  bool showSpinner = false;

  bool _isUserEmailVerified = false;
  Timer _timer;

  FirebaseUser loggedInUser;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: Colors.black,

        appBar: MainAppBarDesign(),

      body: ModalProgressHUD(

        //using this widget's property:'
        inAsyncCall: showSpinner,

        child: Center(

          child: Container(

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[

                  /////////////////////////////////////////////////

                  //box no.1: user's email address
                  Container(

                        padding: EdgeInsets.fromLTRB(20, 230, 20, 25),

                        child: TextField(

                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          style: kMainBlackBackground,

                          decoration: kAllUserDetails.copyWith(
                              hintText: 'Enter email',
                              icon: Icon(
                                  Icons.email,
                                  color: Colors.white
                              )
                          ),

                          onChanged: (value){
                            email = value;
                          },
                        ),
                      ),

                  /////////////////////////////////////////////////

                  //box no.2: user's password
                  Container(

                        padding: EdgeInsets.all(20.0),

                        child: TextField(

                          style: kMainBlackBackground,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress,

                          decoration: kAllUserDetails.copyWith(
                              hintText: 'Enter password',
                              icon: Icon(
                                  Icons.lock,
                                  color: Colors.white
                              )
                          ),

                          onChanged: (value){
                            password = value;
                          },
                        ),
                      ),

                  /////////////////////////////////////////////////

                  Expanded(

                    child: Container(

                      padding: EdgeInsets.only(top: 200.0),

                      child: Center(

                        child: RaisedButton(

                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.amber) // amber
                          ),

                          onPressed: () async {

                              //here: setting our spinner to TRUE (for it to spin!):
                              setState(() {
                                showSpinner = true;
                              });

                              //this is just for testing, to ensure values are captured and are available for use
                              print(email);
                              print(password);

                              try {

                                final newUser = await _auth
                                    .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password
                                );

                                if (newUser != null) {

                                  final user = await _auth.currentUser();

                                  user.sendEmailVerification();
                                  if(user.isEmailVerified)
                                    print('CONFIRMATION: USER EMAIL HAS BEEN VERIFIED.');

                                  final player = AudioCache();
                                  player.play('tick.wav');

                                  Navigator.pushNamed(
                                      context, CreateUsernameAndDobScreen.id
                                  );

                                }

                                //here: setting our spinner to FALSE (for it to stop spinning!):
                                setState(() {
                                  showSpinner = false;
                                });

                              }

                              catch(e){
                                print("An error occurred while trying to send email verification");
                                //print(e.message);
                                print(e);
                              }

                            }, //end of ONPRESSED() function

                          color: Colors.black,
                          textColor: Colors.amber, //amber
                          padding: EdgeInsets.all(0.0),

                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.black
                            ),
                            padding: EdgeInsets.all(10.0),
                            child:
                            const Text(
                                'Create!',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontStyle: FontStyle.italic)
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}