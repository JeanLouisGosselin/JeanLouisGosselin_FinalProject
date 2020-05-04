import 'package:flutter/material.dart';
import '../buttons/BottomButton.dart';
import '../reusables/ReusableContainer.dart';
import '../constants/constants.dart';
import '../spinners/BriefLoadingAndWaitingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../spinners/StockPurchase.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:flutter_money_formatter/flutter_money_formatter.dart';



class StockShareShopNew extends StatefulWidget {

  static const String id = 'StockShareShop_Screen';

  final stockName;
  final initialShareValue;

  StockShareShopNew({@required this.stockName, @required this.initialShareValue});

  @override
  _StockShareShopNewState createState() => _StockShareShopNewState();
}

class _StockShareShopNewState extends State<StockShareShopNew> {

  String userChosenCompany;
  double initialSharePrice;
  int numberOfShares = 1;
  double initialTotalPrice;
  int decimalPrecision = 2;
  MoneyFormatterOutput fo, us;

  //creating an instance of the CLOUD_FIRESTORE:
  //(this is used in the button below)
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;
  String docLink;

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setValues(widget.stockName, widget.initialShareValue);
    initialTotalPrice = calculateTotalPrice();
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: initialTotalPrice
    );
    fo = fmf.output;
  }

  //we trigger this method as soon as our state is initialised, above:
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


  void setValues(String companyName, double stPrice) {
    userChosenCompany = companyName;
    initialSharePrice = superSimpleDecimalReducer(stPrice, decimalPrecision);
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: initialSharePrice
    );
    us = fmf.output;
  }

  void updateValues(dynamic numShares, dynamic totalStockPrice) {

    setState(() {
      numberOfShares = numShares;
      initialTotalPrice = superSimpleDecimalReducer(totalStockPrice, decimalPrecision);
      FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
          amount: initialTotalPrice
      );
      fo = fmf.output;
    });
  }

  double calculateTotalPrice() {
    return superSimpleDecimalReducer(
        (numberOfShares * initialSharePrice), decimalPrecision);
  }

  double superSimpleDecimalReducer(double oldValue, int precision) {
    return num.parse(oldValue.toStringAsFixed(precision));
  }


  @override
  Widget build(BuildContext context) {

    //here: creating a date variable for every purchased stock package:
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('hh:mm:ss yyyy-MM-dd').format(now);

    //here: generating a random string to name the collection's document for every stock package purchased:
    var randomString = randomAlphaNumeric(10);

    return Scaffold(

      backgroundColor: Colors.black,

      //here: design a special appbar that contains NO return arrow:
      appBar: AppBar(
        title: Image.asset(
            'images/KKG_logo.PNG',
            fit: BoxFit.cover,
            scale: 8
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[

          Expanded(

            child: Padding(

              padding: const EdgeInsets.only(top: 30),

              child: ReusableContainer(

                colour: kInactiveCardColour,

                cardChild: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

                    //////////////////////////  TEXT FIELDS  ///////////////////////////

                    SizedBox(
                      height: 10.0,
                    ),

                    Card(
                        margin: EdgeInsets.symmetric(horizontal: 25.0),
                        color: Colors.black,
                        child: ListTile(
                            title: Center(
                              child: AutoSizeText(
                                  userChosenCompany.toUpperCase(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.cyanAccent
                                  )
                              ),
                            )
                        )
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 20, bottom: 10),
                      child: Text(
                        '$numberOfShares ',
                        style: kNumShares,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: Text(
                        'x     ${us.symbolOnRight}',
                        style: kgivenPrice,
                      ),
                    ),

                    //here: DIVIDER
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: SizedBox(
                          height: 1.0,
                          width: 170.0,
                          child: Divider(
                              color: Colors.white
                          )
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 70, top: 5),
                      child: Text(
                        '${fo.symbolOnRight}',
                        style: kTotalSharePrice,
                      ),
                    ),

                    // the slider:

                    SliderTheme(
                      //here: we use a property specific to SLIDERTHEME: data
                      //the technique of using the COPYWITH() method is essentially to what we did
                      //previously with the THEMEDATA.DARK() in MAIN(): setting everything to default,
                      //but then cherry-picking the few things we'd like to change or add to these
                      //default settings:
                      data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0xFF8D8E98),
                          activeTrackColor: Colors.white,
                          thumbColor: Color(0xFFEB1555),
                          //making the button bigger:
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 17.0),
                          //making the outer transparent ring even bigger:
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 30.0),
                          overlayColor: Color(0x29EB1555)
                      ),
                      child: Slider(

                        value: numberOfShares.toDouble(),

                        //here: defining the fixed range (we set these two property values as CONST):
                        min: kMinimumSliderHeight,
                        max: kMaximumSliderHeight,

                        onChanged: (double newVal) {
                          setState(() {
                            numberOfShares = newVal.toInt();
                            updateValues(numberOfShares, calculateTotalPrice());
                          });
                          //just for testing:
                          print(newVal);
                        },
                      ),
                    ),

                    // the BUY button:

                    Expanded(

                      child: Container(

                          padding: EdgeInsets.only(top: 10.0),

                          child: Center(

                            child: RaisedButton(

                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.amberAccent) // amber
                              ),

                              onPressed: () {

                                //HERE: IMPLEMENTING A DIALOGUE BOX (for user confirmation)

                                showDialog(

                                  context: context,

                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: new Text("Are you sure?"),
                                      content: new Text("Confirm your purchase"),
                                      actions: <Widget>[

                                        Row(
                                          children: <Widget>[

                                            new FlatButton(
                                              child: new Text("Cancel"),
                                              onPressed: (){
                                                final player = AudioCache();
                                                player.play('tick.wav');
                                                Navigator.of(context).pop();
                                              },
                                            ),

                                            new FlatButton(

                                              child: new Text("Confirm"),

                                              onPressed: () {

                                                final player = AudioCache();
                                                player.play('cha-ching.wav');

                                                docLink = loggedInUser.email.toString();

                                                try {
                                                  _firestore
                                                      .collection('userDetails')
                                                      .document(docLink)
                                                      .collection('stock_purchase')
                                                      .document(randomString.toString())
                                                      .setData({
                                                    //field 1: company name
                                                    'CompanyName': userChosenCompany,
                                                    //field 2: number of shares
                                                    'NumberShares': numberOfShares,
                                                    //field 3: initial value of 1 share:
                                                    'InitialSharePrice': initialSharePrice,
                                                    //field 4: (repeat)
                                                    'CurrentSharePrice': initialSharePrice,
                                                    //field 5: (repeat))
                                                    'PreviousSharePrice': initialSharePrice,
                                                    //field 4: initial total purchase value:
                                                    'InitialBundleValue': initialTotalPrice,
                                                    //field 5: total purchase price
                                                    'CurrentBundleValue': initialTotalPrice,
                                                    //field 6:
                                                    'PreviousBundleValue': initialTotalPrice,
                                                    //field 7: date of purchase:
                                                    'DateTimeOfPurchase' : formattedDate,
                                                  });
                                                }
                                                catch(e){
                                                  print(e);
                                                }

                                                //for testing only:
                                                print('Subcollection created:\n');
                                                print('Company: $userChosenCompany');
                                                print('NumShares: $numberOfShares');
                                                print('InitialShareValue: $initialSharePrice');
                                                print('InitialCost: $initialTotalPrice');
                                                print('CurrentValue: $initialTotalPrice');
                                                print('PreviousValue: $initialTotalPrice');
                                                print('DatePurchased: $formattedDate');

                                                Navigator.push(

                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                          //here: constructor in "spinner_user_values.dart" file:
                                                          return StockPurchase(
                                                            purchasePrice: initialTotalPrice,
                                                          );
                                                        }
                                                    )
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                );
                              },

                              color: Colors.black,
                              textColor: Colors.amberAccent,
                              padding: EdgeInsets.all(30.0),

                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black
                                ),
                                padding: EdgeInsets.all(10.0),
                                child:
                                const Text(
                                    'Buy!',
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

          ///////////////////////   bottom arrow button ///////////////////

          Padding(

            padding: const EdgeInsets.only(bottom: 30),

            child: BottomButton(

                onTapFunction: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, BriefLoadingAndWaitingScreen.id);
                }
            ),
          ),
        ],
      ),
    );
  }
}