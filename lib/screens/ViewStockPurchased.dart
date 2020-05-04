import 'package:flutter/material.dart';
import '../buttons/BottomButton.dart';
import '../reusables/MainAppBarDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MainMenuPage.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:audioplayers/audio_cache.dart';
import '../buttons/IntroButton.dart';
import '../spinners/SellingStockPackage.dart';
import '../constants/constants.dart';
import 'dart:math';
import 'package:expandable/expandable.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';


final _firestore = Firestore.instance;

class ViewStockPurchased extends StatefulWidget {

  static const String id = 'stockpurchase_screen';

  final companyName;
  final numberShares;

  final initialSharePrice;
  final currentSharePrice;
  final previousSharePrice;

  final initialBundleValue;
  final currentBundleValue;
  final previousBundleValue;

  final dateOfPurchase;
  final collectionLength;
  final subDocLink;

  ViewStockPurchased({
      @required this.companyName,
      @required this.numberShares,
      @required this.initialSharePrice,
      @required this.currentSharePrice,
      @required this.previousSharePrice,
      @required this.initialBundleValue,
      @required this.currentBundleValue,
      @required this.previousBundleValue,
      @required this.dateOfPurchase,
      @required this.collectionLength,
      @required this.subDocLink});

  @override
  _ViewStockPurchasedState createState() => _ViewStockPurchasedState();
}


////////////////////////////////////////////////////////////////////////////


class _ViewStockPurchasedState extends State<ViewStockPurchased> {

  @override
  void initState() {
    super.initState();
    updateUI(
          widget.companyName,
          widget.numberShares,
          widget.initialSharePrice,
          widget.currentSharePrice,
          widget.previousSharePrice,
          widget.initialBundleValue,
          widget.currentBundleValue,
          widget.previousBundleValue,
          widget.dateOfPurchase,
          widget.collectionLength,
          widget.subDocLink
    );
  }

  var companyname = new List();
  var numbershares = new List();
  var initialSharePrice = new List();
  var currentSharePrice = new List();
  var previousSharePrice = new List();
  var initialBundleValue = new List();
  var currentBundleValue = new List();
  var previousBundleValue = new List();
  var purchaseDateTime = new List();
  var subDocumentLink = new List();
  int subCollectionLength;

  List<PackageBox> packagesBoxes = [];

  void updateUI(
      dynamic cName,
      dynamic nShares,
      dynamic iSharePrice,
      dynamic cSharePrice,
      dynamic pSharePrice,
      dynamic iBundleValue,
      dynamic cBundleValue,
      dynamic pBundleValue,
      dynamic dTime,
      dynamic cLength,
      dynamic dLink){

    setState(() {

      //ailing to implement this IF statement can cause the system to crash!
      if(cLength == 0){

        companyname.add("");
        numbershares.add(0);

        initialSharePrice.add(0);
        currentSharePrice.add(0);
        previousSharePrice.add(0);

        initialBundleValue.add(0);
        currentBundleValue.add(0);
        previousBundleValue.add(0);

        purchaseDateTime.add("");
        subDocumentLink.add("");
        subCollectionLength = cLength;

        return; //this is used to exit the process
      }
      else{

        companyname.addAll(cName);
        numbershares.addAll(nShares);

        initialSharePrice.addAll(iSharePrice);
        currentSharePrice.addAll(cSharePrice);
        previousSharePrice.addAll(pSharePrice);

        initialBundleValue.addAll(iBundleValue);
        currentBundleValue.addAll(cBundleValue);
        previousBundleValue.addAll(pBundleValue);

        purchaseDateTime.addAll(dTime);
        subDocumentLink = dLink;
        subCollectionLength = cLength;

      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

        backgroundColor: Colors.black,

        appBar: MainAppBarDesign(),

        body: SafeArea(

          child: Container(

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[

                //here: we create tne whole column of stock packages (2 classes are called):
                PackageList(
                    companyName: companyname,
                    numberShares: numbershares,
                    initialSharePrice: initialSharePrice,
                    currentSharePrice: currentSharePrice,
                    previousSharePrice: previousSharePrice,
                    initialBundleValue: initialBundleValue,
                    currentBundleValue: currentBundleValue,
                    previousBundleValue: previousBundleValue,
                    purchaseTime: purchaseDateTime,
                    sDocLink: subDocumentLink,
                    collectionLength: subCollectionLength),

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


/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////



class PackageList extends StatelessWidget {

  static const String id = 'packagelist_class';

  final companyName;
  final numberShares;
  final initialSharePrice;
  final currentSharePrice;
  final previousSharePrice;
  final initialBundleValue;
  final currentBundleValue;
  final previousBundleValue;
  final purchaseTime;
  final sDocLink;
  final collectionLength;

  PackageList({this.companyName,
              this.numberShares,
              this.initialSharePrice,
              this.currentSharePrice,
              this.previousSharePrice,
              this.initialBundleValue,
              this.currentBundleValue,
              this.previousBundleValue,
              this.purchaseTime,
              this.sDocLink,
              this.collectionLength});

  @override
  Widget build(BuildContext context){

    if(collectionLength == 0){
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
      );
    }

    List<PackageBox> packageBoxes = [];

    for(int i = 0; i<collectionLength; i++){

      final singlePackageBox = PackageBox(

        companyName: companyName[i],
        numberShares: numberShares[i],
        initialSharePrice: initialSharePrice[i],
        currentSharePrice: currentSharePrice[i],
        previousSharePrice: previousSharePrice[i],
        initialBundleValue: initialBundleValue[i],
        currentBundleValue: currentBundleValue[i],
        previousBundleValue: previousBundleValue[i],
        purchaseDate: purchaseTime[i],
        subDocLink: sDocLink[i],

      );

      packageBoxes.add(singlePackageBox);
    }

    /*
    here: sorting the returned finalized list by purchase date
     */
    packageBoxes.sort((a, b) => a.companyName.compareTo(b.companyName));

    //this is where the listview is returned to the parent class above:
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        //reverse: true,
        children: packageBoxes,
      ),
    );
  }
}


/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////


class PackageBox extends StatelessWidget {

  static const String id = 'packagebox_class';

  final companyName;
  final numberShares;
  final initialSharePrice;
  final currentSharePrice;
  final previousSharePrice;
  final initialBundleValue;
  final currentBundleValue;
  final previousBundleValue;
  final purchaseDate;
  final subDocLink;

  PackageBox({this.companyName,
            this.numberShares,
            this.initialSharePrice,
            this.currentSharePrice,
            this.previousSharePrice,
            this.initialBundleValue,
            this.currentBundleValue,
            this.previousBundleValue,
            this.purchaseDate,
            this.subDocLink});

  @override
  Widget build(BuildContext context) {

    bool isDone = false;

    ///////////////////////////////////////////////

    //all share price-related values:

    MoneyFormatterOutput fo_initialSharePrice;
    FlutterMoneyFormatter fmf_initialSharePrice = FlutterMoneyFormatter(
        amount: initialSharePrice
    );
    fo_initialSharePrice = fmf_initialSharePrice.output;

    MoneyFormatterOutput fo_previousSharePrice;
    FlutterMoneyFormatter fmf_previousSharePrice = FlutterMoneyFormatter(
        amount: previousSharePrice
    );
    fo_previousSharePrice = fmf_previousSharePrice.output;

    MoneyFormatterOutput fo_currentSharePrice;
    FlutterMoneyFormatter fmf_currentSharePrice = FlutterMoneyFormatter(
        amount: currentSharePrice
    );
    fo_currentSharePrice = fmf_currentSharePrice.output;

    ///////////////////////////////////////////////

    //all bundle value-related values:

    MoneyFormatterOutput fo_initialBundleValue;
    FlutterMoneyFormatter fmf_initialBundleValue = FlutterMoneyFormatter(
        amount: initialBundleValue
    );
    fo_initialBundleValue = fmf_initialBundleValue.output;

    MoneyFormatterOutput fo_previousBundleValue;
    FlutterMoneyFormatter fmf_previousBundleValue = FlutterMoneyFormatter(
        amount: previousBundleValue
    );
    fo_previousBundleValue = fmf_previousBundleValue.output;

    MoneyFormatterOutput fo_currentBundleValue;
    FlutterMoneyFormatter fmf_currentBundleValue = FlutterMoneyFormatter(
        amount: currentBundleValue
    );
    fo_currentBundleValue = fmf_currentBundleValue.output;

    print('testing: individual values for boxes:');
    print('currentSharePrice = $currentSharePrice');
    print('previousSharePrice = $previousSharePrice');
    print('currentBundleValue = $currentBundleValue');
    print('previousBundleValue = $previousBundleValue');


    ////////////////////////////////////////////////////////////////////////////////

    double sharePriceDifference = currentSharePrice - previousSharePrice;
    double bundleValueDifference = currentBundleValue - previousBundleValue;

    ////////////////////////////////////////////////////////////////////////////////

    print('sharePriceDifference = $sharePriceDifference');
    print('bundleValueDifference = $bundleValueDifference');

    int decimals = 1;
    int fac = pow(10, decimals);
    sharePriceDifference = (sharePriceDifference * fac).round() / fac;

    print('SHORTENED sharePriceDifference = $sharePriceDifference');
    print('SHORTENED bundleValueDifference = $bundleValueDifference');

    ////////////////////////////////////////////////////////////////////////////////

    MoneyFormatterOutput fo_sharePriceDifference;
    FlutterMoneyFormatter fmf_sharePriceDifference = FlutterMoneyFormatter(
        amount: sharePriceDifference
    );
    fo_sharePriceDifference = fmf_sharePriceDifference.output;

    MoneyFormatterOutput fo_bundleValueDifference;
    FlutterMoneyFormatter fmf_bundleValueDifference = FlutterMoneyFormatter(
        amount: bundleValueDifference
    );
    fo_bundleValueDifference = fmf_bundleValueDifference.output;



    /////////////////////////////////////////////////
    /////////////////////////////////////////////////
    /////////////////////////////////////////////////
    /////////////////////////////////////////////////


    String returnBundleValueDifference(){

      if(bundleValueDifference > 0)
        return fo_bundleValueDifference.symbolOnRight;

      else if (bundleValueDifference < 0){

        bundleValueDifference *= (-1);

        MoneyFormatterOutput fo_bundleValueDifference_NEG;
        FlutterMoneyFormatter fmf_bundleValueDifference_NEG = FlutterMoneyFormatter(
            amount: bundleValueDifference
        );
        fo_bundleValueDifference_NEG = fmf_bundleValueDifference_NEG.output;
        return fo_bundleValueDifference_NEG.symbolOnRight;
      }
      else
        return '';
    }

    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////

    /*
    //method for defining text properties of CURRENTBUNDLEVALUE:

    these text properties are:
          FONT COLOUR
          FONT STYLE
          FONT SIZE
     */

    IconData getIconBasedOnBundleValue() {

      if(currentBundleValue > previousBundleValue)
        return Icons.trending_up;
      else if(currentBundleValue < previousBundleValue)
        return Icons.trending_down;
      else
        return Icons.linear_scale;
    }

    IconData plusOrMinusBundleValue(){

      if(currentBundleValue > previousBundleValue)
        return Icons.add;
      else if(currentBundleValue < previousBundleValue)
        return Icons.remove;
      else
        return Icons.linear_scale;
    }


    Color setArrowAndValueColourBasedOnSharePrice() {

      if(currentSharePrice > previousSharePrice)
        return Colors.green;
      else if(currentSharePrice < previousSharePrice)
        return Colors.red;
      else
        return kInactiveCardColour; //Colors.amber;
    }

    double setArrowSize(){

      if(bundleValueDifference == 0)
        return 0.1;
      else
        return 60;

    }

    double setPlusMinusSize(){

      if(bundleValueDifference == 0)
        return 0.1;
      else
        return 20;

    }


    double setValueFontSize(){

      if(bundleValueDifference == 0)
        return 0.1;
      else
        return 20;

    }


    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////


    /*
    //method for defining text properties of CURRENTSHAREPRICE:

    these text properties are:
          FONT COLOUR
          FONT STYLE
     */

    bool decidingAllTextPropertiesForCurrentBundleValue() {
      if (currentBundleValue < initialBundleValue)
        return true;
      else
        return false;
    }

    bool decidingAllTextPropertiesForCurrentSharePrice() {
      if (currentSharePrice < initialSharePrice)
        return true;
      else
        return false;
    }


    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////

    return Padding(

      padding: EdgeInsets.all(10.0),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[

          Container(

              width: 400,

              child: Card(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: kInactiveCardColour,
                elevation: 10,

                child: Expanded(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[

                      Column(

                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: <Widget>[

                          Row(

                            children: <Widget>[

                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////

                              //here: trend arrow + amount won/lost:

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  getIconBasedOnBundleValue(),
                                  color: setArrowAndValueColourBasedOnSharePrice(),
                                  size: setArrowSize(),
                                ),
                              ),

                              Text(
                                '       ',
                              ),

                              Icon(
                                plusOrMinusBundleValue(),
                                color: setArrowAndValueColourBasedOnSharePrice(),
                                size: setPlusMinusSize(),
                              ),

                              Text(
                                '${returnBundleValueDifference()}',
                                style: TextStyle(
                                  fontSize: setValueFontSize(),
                                  color: setArrowAndValueColourBasedOnSharePrice(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),

                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////

                      Padding(

                          padding: const EdgeInsets.all(8.0),

                          child: Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'company: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.grey,

                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${companyName.toUpperCase()}       ',
                                        style: TextStyle(
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.cyanAccent
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),

                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////

                      /////////////////////

                        Padding(

                          padding: const EdgeInsets.only(top: 3, bottom: 20),

                          child: ConfigurableExpansionTile(

                            borderColorStart: kInactiveCardColour,

                            borderColorEnd: kInactiveCardColour,

                            animatedWidgetFollowingHeader: const Icon(
                              Icons.expand_more,
                              color: Colors.cyanAccent,
                              size: 30,
                            ),

                            headerExpanded:
                            Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 1, bottom: 1),
                                  child: Center(
                                    child: Text(
                                      "details",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20
                                      ),
                                    )
                                  ),
                                )
                            ),

                            header: Container(

                                child: Padding(
                                  padding: const EdgeInsets.only(top: 1, bottom: 1),
                                  child: Center(
                                      child: Text(
                                          "details",
                                          style: TextStyle(
                                              color: Colors.grey,
                                            fontSize: 20
                                          ),
                                      )
                                  ),
                                )
                            ),

                            headerBackgroundColorStart: kInactiveCardColour,

                            expandedBackgroundColor: kInactiveCardColour,

                            headerBackgroundColorEnd: kInactiveCardColour,

                            children: [

                              Padding(

                                  padding: const EdgeInsets.all(8.0),

                                  child: Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: 'shares: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${numberShares.toString()}',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),

                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////


                              Padding(

                                  padding: const EdgeInsets.all(8.0),

                                  child: Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: 'initial share price: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${fo_initialSharePrice.symbolOnRight}',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),


                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////

                              Padding(

                                  padding: const EdgeInsets.all(8.0),

                                  child: Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: 'previous share price: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${fo_previousSharePrice.symbolOnRight}',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),


                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////

                              Padding(

                                  padding: const EdgeInsets.all(8.0),

                                  child: Row(
                                    children: <Widget>[

                                      RichText(
                                        text: TextSpan(
                                          text: 'current share price: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${fo_currentSharePrice.symbolOnRight}',
                                                style: decidingAllTextPropertiesForCurrentSharePrice()
                                                    ?
                                                TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20,
                                                    fontStyle: FontStyle.normal
                                                )
                                                    :
                                                TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 20,
                                                    fontStyle: FontStyle.normal
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),

                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////

                              Padding(

                                  padding: const EdgeInsets.all(8.0),

                                  child: Row(
                                    children: <Widget>[

                                      RichText(
                                        text: TextSpan(
                                          text: 'initial bundle value: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${fo_initialBundleValue.symbolOnRight}',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),




                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////


                              Padding(

                                  padding: const EdgeInsets.all(8.0),

                                  child: Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: 'previous bundle value: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${fo_previousBundleValue.symbolOnRight}',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),


                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////

                              Padding(

                                  padding: const EdgeInsets.all(8.0),

                                  child: Row(
                                    children: <Widget>[

                                      RichText(
                                        text: TextSpan(
                                          text: 'current bundle value: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '${fo_currentBundleValue.symbolOnRight}',
                                                //NOTICE: here, using ternary operator (?:),
                                                //based on bool value returned from method
                                                style: decidingAllTextPropertiesForCurrentBundleValue()
                                                    ?
                                                TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20,
                                                    fontStyle: FontStyle.normal
                                                )
                                                    :
                                                TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 20,
                                                    fontStyle: FontStyle.normal
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),

                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////
                              /////////////////////////////////////////////////

                              Padding(

                                  padding: const EdgeInsets.all(8),

                                  child: Row(
                                    children: <Widget>[

                                      RichText(
                                        text: TextSpan(
                                          text: 'buy date: ',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '$purchaseDate',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),

                              Column(

                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '',
                                  ),
                                ],
                              ),
                              Column(

                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),


                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      /////////////////////////////////////////////////

                      //here: the SELL button:

                        //here: implementing a button of class INTROBUTTON:
                        Padding(
                          padding: const EdgeInsets.only(left: 250),
                          child: IntroButton(
                            //here: initialising all 4 fields of class INTROBUTTON:
                              title: 'SELL',
                              thisColor: Colors.amberAccent,
                              minimumWidth: 100.0,
                              thisFunc: (){

                                //adding an alert box, for user confirmation:
                                showDialog(

                                  context: context,
                                  builder: (BuildContext context) {

                                    return AlertDialog(

                                      title: new Text("Are you sure?"),
                                      content: new Text("Confirm your sale"),
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
                                                //Navigator.of(context).pop();
                                                final player = AudioCache();
                                                player.play('cha-ching.wav');

                                                Navigator.push(

                                                    context,

                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                          return SellingStockPackage(
                                                              subDocumentLink: subDocLink,
                                                              stockPrice: currentBundleValue
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
                              }
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}