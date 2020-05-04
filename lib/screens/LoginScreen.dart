import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:audioplayers/audio_cache.dart';
import 'MainMenuPage.dart';
import '../reusables/MainAppBarDesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  static const String id = 'Login_Screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  //this is for the spinner:
  bool showSpinner = false;

  ////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

        backgroundColor: Colors.black,

        appBar: MainAppBarDesign(),

      body: ModalProgressHUD(

        inAsyncCall: showSpinner,

        child: Container(

          constraints: BoxConstraints.expand(),

          child: SafeArea(

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[

                /////////////////////////////////////////////////

                //box no.1: user's email address
                Container(

                  padding: EdgeInsets.fromLTRB(20, 230, 20, 25),

                  child: TextField(

                    style: kMainBlackBackground,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,

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

                    textAlign: TextAlign.center,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    style: kMainBlackBackground,

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
                /////////////////////////////////////////////////
                /////////////////////////////////////////////////


                Expanded(

                  child: Container(

                    padding: EdgeInsets.only(top: 200.0),

                    child: Center(

                        child: RaisedButton(

                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.amberAccent)
                          ),

                          //////////////////////////////////////////////////

                          onPressed: () async {

                            //here: setting our spinner to TRUE (for it to spin!):
                            setState(() {
                              showSpinner = true;
                            });

                            try{
                              final user = await _auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password);

                              if (user != null) {
                                final player = AudioCache();
                                player.play('short_bell.wav');
                                Navigator.pushNamed(context, MainMenuPage.id);
                              }
                            }
                            catch(e){
                              print(e);
                            }

                            //here: setting our spinner to FALSE (for it to stop spinning!):
                            setState(() {
                              showSpinner = false;
                            });

                          },

                          ///////////////////////////////////////////////////

                          color: Colors.black,
                          textColor: Colors.amberAccent,
                          padding: EdgeInsets.all(0.0),
                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.black
                            ),
                            padding: EdgeInsets.all(10.0),
                            child:
                            const Text(
                                'Enter!',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontStyle: FontStyle.italic)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          )
        ),
      )
    );
  }
}