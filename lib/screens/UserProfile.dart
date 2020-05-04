import 'package:flutter/material.dart';
import 'package:king_cash_game/reusables/ReusableContainer.dart';
import '../buttons/BottomButton.dart';
import '../reusables/MainAppBarDesign.dart';
import '../constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MainMenuPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:audioplayers/audio_cache.dart';
import '../spinners/PurchasedStockPackages.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';


class UserProfile extends StatefulWidget {

  static const String id = 'UserProfile_Screen';

  final mainUserName;
  final mainUserTotalMoney;

  UserProfile({this.mainUserName, this.mainUserTotalMoney});

  @override
  _UserProfileState createState() => _UserProfileState();
}


class _UserProfileState extends State<UserProfile> {

  final _auth = FirebaseAuth.instance;

  //here: creating an instance of the CLOUD_FIRESTORE:
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String docLink;

  String username = 'default';
  String userDob = 'default';
  double totalMoney;
  String docID = '0';
  MoneyFormatterOutput fo;

  @override
  void initState() {

    super.initState();
    print('this is the USER class');
    updateUI(widget.mainUserName, widget.mainUserTotalMoney);

  }

  //////////////////////////////////////////////////////////////

  void updateUI(dynamic uName, dynamic uTotalMoney){

    setState(() {

      //failing to implement this IF statement can cause the system to crash!
      if(uName == null){
        username = "n/a";
        totalMoney = 0.0;
        return; //this is used to exit the process
      }
      else{
        username = uName;
        totalMoney = uTotalMoney;
        FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
            amount: totalMoney
        );
        fo = fmf.output;
      }
    });
  }

  //////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

        backgroundColor: Colors.black,

        appBar: MainAppBarDesign(),

        body: Center(

          child: Container(

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[

                Expanded(

                  child: ReusableContainer(

                    colour: kInactiveCardColour,

                    cardChild: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.only(bottom: 30, top: 50),
                          child: CircleAvatar(
                            radius: 90.0,
                            backgroundImage: AssetImage('images/trader.jpg'),
                          ),
                        ),

                        //here: AUTOSIZETEXT is used to make the username fit on screen
                        Center(
                          child: AutoSizeText(
                              username,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'SignikaNegative',
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),

                        Text(
                            'rank: IRON',
                            style: TextStyle(
                              fontFamily: 'SansPro',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.cyanAccent,
                              letterSpacing: 2.5,
                            )
                        ),

                        SizedBox(
                          height: 50.0,
                        ),

                        Card(
                            margin: EdgeInsets.symmetric(horizontal: 25.0),
                            color: Colors.black,
                            child: ListTile(
                                leading: Icon(
                                    Icons.attach_money,
                                    size: 40.0,
                                    color: Color(0xFFEB1555)),
                                title: Text(
                                    fo.nonSymbol.toString(),
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 30.0,
                                    ))
                            )
                        ),

                        SizedBox(
                          height: 20.0,
                        ),

                        Expanded(

                          child: Container(

                              padding: EdgeInsets.only(top: 10.0),

                              child: Center(

                                child: RaisedButton(

                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.amberAccent)
                                  ),

                                  onPressed: () {
                                    final player = AudioCache();
                                    player.play('tick.wav');
                                    Navigator.pushNamed(context, PurchasedStockPackages.id);
                                  },

                                  color: Colors.black,
                                  textColor: Colors.amberAccent,
                                  padding: EdgeInsets.all(5.0),

                                  child: Container(

                                    decoration: BoxDecoration(
                                        color: Colors.black
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    child:
                                    const Text(
                                        'Check stock purchases',
                                        style: TextStyle(
                                            fontSize: 28,
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

                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: BottomButton(
                      onTapFunction: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, MainMenuPage.id);
                      }
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
