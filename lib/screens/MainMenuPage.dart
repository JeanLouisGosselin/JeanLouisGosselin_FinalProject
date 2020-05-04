import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:king_cash_game/spinners/GetUserData.dart';
import '../reusables/MenuDividingLine.dart';
import '../spinners/BriefLoadingAndWaitingScreen.dart';
import 'IntroPage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MainMenuPage extends StatefulWidget {

  static const String id = 'MainMenuPage_Screen';

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}


class _MainMenuPageState extends State<MainMenuPage> {

  final _auth = FirebaseAuth.instance;

  FirebaseUser loggedInUser;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{

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

    return Container(

      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "images/blackandred.jpg"),
              fit: BoxFit.cover
          ),
        border: Border.all(
          color: Colors.black,
          width: 30.0,
        ),
      ),


      child: Scaffold(

          backgroundColor: Colors.transparent,

          //here: appBar with no KCG logo
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),

          body: Center(),

          drawer: Drawer(

            child: Container(

              color: Colors.black,
              height: 100,

              child: ListView(

                padding: EdgeInsets.zero,

                children: <Widget>[

                  Container(

                    color: Colors.black,
                    height: 100,
                    //here: we purposely set this widget to nothing:
                    child: DrawerHeader(),
                  ),

                  ///////////////////////////////////////////////////////////

                  //here: we have refactored every dividing line, for clarity of code:

                  MenuDividingLine(),

                  ListTile(

                    title: Text('Portfolio',

                      style: TextStyle(
                        color: Colors.white,
                          fontSize: 20,
                          fontStyle: FontStyle.italic
                      ),
                    ),

                    onTap: () {
                      final player = AudioCache();
                      player.play('tick.wav');
                      Navigator.pushNamed(context, GetUserData.id);
                      },
                  ),

                  ///////////////////////////////////////////////////////////

                  MenuDividingLine(),

                  ///////////////////////////////////////////////////////////

                  ListTile(

                    title: Text('LET\'S INVEST!',

                      style: TextStyle(

                          color: Colors.cyanAccent,
                          fontSize: 28,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold

                      ),
                    ),

                    onTap: () {
                      final player = AudioCache();
                      player.play('tick.wav');
                      Navigator.pushNamed(context, BriefLoadingAndWaitingScreen.id);
                    },
                  ),

                  ///////////////////////////////////////////////////////////

                  MenuDividingLine(),

                  ///////////////////////////////////////////////////////////

                  ListTile(

                    title: Text('Sign out',

                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                      ),
                    ),

                    onTap: () {
                      final player = AudioCache();
                      player.play('logoutDing.wav');
                      _auth.signOut();
                      Navigator.pushNamed(context, IntroPage.id);
                    },
                  ),

                  ///////////////////////////////////////////////////////////

                  MenuDividingLine(),

                  ///////////////////////////////////////////////////////////

                ],
              ),
            ),
          ),
      ),
    );
  }
}