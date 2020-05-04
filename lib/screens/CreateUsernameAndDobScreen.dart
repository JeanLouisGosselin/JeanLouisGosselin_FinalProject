import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:audioplayers/audio_cache.dart';
import 'MainMenuPage.dart';
import '../reusables/MainAppBarDesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class CreateUsernameAndDobScreen extends StatefulWidget {

  static const String id = 'CreateUsernameAndDob_Screen';

  @override
  _CreateUsernameAndDobScreenState createState() => _CreateUsernameAndDobScreenState();
}

class _CreateUsernameAndDobScreenState extends State<CreateUsernameAndDobScreen> {

  //creating an instance of the CLOUD_FIRESTORE:
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;

  String username;
  String userDOB;
  double totalEarnings = 1000000.0; //this is automatically set for every new user
  String docID;

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm');
    userDOB = formatter.format(now);
  }

  void getCurrentUser() async {

      try {
        final user = await _auth.currentUser();
        if (user != null) {
          loggedInUser = user;
          print(loggedInUser.email);
        }
      }
      catch(e){
        print(e);
      }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: MainAppBarDesign(),

      body: ModalProgressHUD(

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

                  padding: EdgeInsets.fromLTRB(20, 260, 20, 25),

                  child: TextField(

                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    style: kMainBlackBackground,

                    decoration: kAllUserDetails.copyWith(
                        hintText: 'Enter username of your choice',
                        icon: Icon(
                            Icons.account_circle,
                            color: Colors.white
                        )
                    ),

                    onChanged: (value){
                      username = value;
                    },
                  ),
                ),

                /////////////////////////////////////////////////

                Expanded(

                  child: Container(

                      padding: EdgeInsets.only(top: 280.0),

                      child: Center(

                        child: RaisedButton(

                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.amber)
                          ),

                          onPressed: () async {

                            await _firestore
                                .collection('userDetails')
                                .document(loggedInUser.email)
                                .setData({
                              //first field:
                              'username': username,
                              //second field:
                              'totalmoney': totalEarnings,
                              //second field (for DOB)
                              'userDOB': userDOB,
                            });

                            //this is just for testing, to ensure values are captured and are available for use
                            print('The email of the current user that is logged in: ${loggedInUser.email}');

                            if(loggedInUser.email is String)
                              print('the user email is a string');
                            else
                              print('the user email is not a string');

                            final player = AudioCache();
                            player.play('short_bell.wav');

                            Navigator.pushNamed(context, MainMenuPage.id);
                          },

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
                                'Confirm!',
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