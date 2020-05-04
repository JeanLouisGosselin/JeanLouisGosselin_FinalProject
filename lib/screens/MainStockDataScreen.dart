import 'package:flutter/material.dart';
import 'package:king_cash_game/screens/MainMenuPage.dart';
import '../constants/constants.dart';
import '../StockDataGetter.dart';
import '../buttons/BottomButton.dart';
import '../reusables/ReusableContainer.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:audioplayers/audio_cache.dart';
import 'StockShareShopNew.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:url_launcher/url_launcher.dart';



/////////////////////   STATEFULWIDGET    ////////////////////


class MainStockDataScreen extends StatefulWidget {

  static const String id = 'MainStockData_Screen';

  //these two fields are what is sent to us from the starting class, BriefLoadingAndWaitingScreen:
  final defaultFTSEdata; // == London data
  final chosenCompanyData;

  MainStockDataScreen({@required this.defaultFTSEdata, @required this.chosenCompanyData});

  @override
  _MainStockDataScreenState createState() => _MainStockDataScreenState();
}


class _MainStockDataScreenState extends State<MainStockDataScreen> {

  //here: this object of STOCKDATAGETTER class will serve to eventually get a
  //different data value entered by the user:
  StockDataGetter stockDataGetter = StockDataGetter();

  //creating new fields, which are used in the UPDATEUI() method below:
  double defaultFTSEindex;
  String defaultFTSEicon;
  String defaultFTSEmessage;
  String FTSEname = "FTSE";

  double stockPrice;
  String stockIcon;
  String stockMessage;
  String chosenCompanyName;
  int numShares = 1;
  int decimalPrecision = 2;

  //this is used to reformat the amount of money displayed (3 x screens)
  MoneyFormatterOutput def, act;

  Random rnd = new Random();
  int min = 5000, max = 7300;


  //here: ensuring that the processing + allocation of weather data is done ***immediately***,
  //ie: as soon as the window opens:
  @override
  void initState() {
    super.initState();
    updateUI(widget.defaultFTSEdata, widget.chosenCompanyData);
  }

  double superSimpleDecimalReducer(double oldValue, int precision) {
    return num.parse(oldValue.toStringAsFixed(precision));
  }

  void updateUI(dynamic defaultFTSE, dynamic chosenCompany){

    //all is placed in the SETSTATE() method (since these value will be changing over time)

    setState(() {

      //here: establishing an IF-ELSE, in case the system cannot for some reason get the weather data
      //(this is important: failing to implement this can cause the system to crash!)
      if(defaultFTSE == null || chosenCompany == null){

        defaultFTSEindex = 0;
        defaultFTSEicon = 'Error';
        defaultFTSEmessage = 'Unable to get stock data';
        FTSEname = '';

        stockPrice = 0;
        stockIcon = 'Error';
        stockMessage = 'Unable to get stock data';
        chosenCompanyName = '';
        return; //this is used as an 'exit' the process, to quit the method if a problem arises (== BREAK)
      }

      ///////////////////////////////////////////////////////////////////////////////////////////

      //part 1: all stock data for default FTSE (previously: London weather)

      defaultFTSEindex = defaultFTSE['main']['temp'].toDouble();
      /*
      NOTE: if still an error thrown, try this syntax:
      defaultFTSEindex = defaultFTSE['main']['temp'] as double;
       */
      //here: taking the precaution of converting any negative (weather) values into positive ones:
      if(defaultFTSEindex < 0)
        defaultFTSEindex *= (-1.0);
      defaultFTSEindex = superSimpleDecimalReducer(defaultFTSEindex, decimalPrecision);
      FlutterMoneyFormatter fmf1 = FlutterMoneyFormatter(
          amount: defaultFTSEindex
      );
      def = fmf1.output;

      FTSEname  = defaultFTSE['name'];

      ///////////////////////////////////////////////////////////////////////////////////////////

      //part 2: all weather data for default company (previously: weather in New York)

      stockPrice = chosenCompany['main']['temp'].toDouble();
      if(stockPrice < 0)
        stockPrice *= (-1.0);
      stockPrice = superSimpleDecimalReducer(stockPrice, decimalPrecision);
      FlutterMoneyFormatter fmf2 = FlutterMoneyFormatter(
          amount: stockPrice
      );
      act = fmf2.output;

      chosenCompanyName = chosenCompany['name'];

    });
  }

  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////

        //in this section: implementing methods for dropdown lists
        //which are specific to both devices

  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////


  //////////////////      (1) ANDROID devices    //////////////////////

  DropdownButton<String> androidDropDown(){

    //here: notice syntax:
    List<DropdownMenuItem<String>> myDropDownItems = [];

    //step1: assigning every country string element from CURRENCIESLIST to a string CURR:
    for(String company in companiesList){

      //step 2: creating a DROPDWONMENUITEM based on that string
      var newItem = DropdownMenuItem(
        child: Text(company),
        value: company,
      );

      //step 3: adding that newly created DROPDOWNMENUITEM item to our list:
      myDropDownItems.add(newItem);

    }

    return DropdownButton<String>(
        value: chosenCompanyName,
        items: myDropDownItems,
        onChanged: (value){
          setState(() {
            chosenCompanyName = value;
            getLiveStockData(chosenCompanyName);
          });
        });
  }


  //////////////////      (2) iOS devices     //////////////////////

  CupertinoPicker iOSPicker(){

    List<Text> myCupertinoPickerItems = [];

    for(String company in companiesList){
      //here: populating our picker:
      myCupertinoPickerItems.add(Text(company));
    }

    return CupertinoPicker(

      //changing colours is optional:
      backgroundColor: Color(0xFFfeae8e8),
      //(height of item):
      itemExtent: 32.0,
      useMagnifier: true,
      magnification: 1.3,
      //for now: using a simple PRINT() statement to test this:
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          final player = AudioCache();
          player.play('scroll_tick.wav');
          chosenCompanyName = companiesList[selectedIndex];
          getLiveStockData(chosenCompanyName);
        });
      },

      children: myCupertinoPickerItems,

    );
  }

  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////

  void getLiveStockData(String myCompanyName) async {

    stockDataGetter.getStockData(myCompanyName);

    if (myCompanyName != null) {

      var sameDefaultFTSEData =
      await stockDataGetter.getStockData(defaultFTSE);

      var thisCompanyName =
      await stockDataGetter.getStockData(myCompanyName);

      updateUI(sameDefaultFTSEData, thisCompanyName);
    }
  }

  _launchURL(String companyName) async {
    final url = 'https://en.wikipedia.org/wiki/$companyName#Economy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  /////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

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

            flex: 0,

            child: Padding(

              padding: const EdgeInsets.only(top: 60),

              child: ReusableContainer(

                colour: kInactiveCardColour,

                cardChild: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

                    //////////////////////////  TEXT FIELDS  ///////////////////////////

                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 10),
                      child: Text(
                          'FTSE 100',
                          style: kLabelTextStyleBig,
                        ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '${def.nonSymbol}',
                        style: kBMICommentStyle,
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.only(top: 40, left: 10),
                        child: Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                              text: 'Share price for ',
                              style: kLabelTextStyleMedium,
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$chosenCompanyName'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.cyanAccent)
                                ),
                              ],
                            ),
                            ),
                          ],
                        )
                    ),


                    Padding(
                      padding: const EdgeInsets.only(bottom: 25, left: 10),
                      child: Text(
                        '${act.symbolOnRight}',
                        style: kBMICommentStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /////////////////// implementing the scrollable reel:  //////////////////

          Expanded(

            child: Padding(

              padding: const EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),

              child: Container(

                  child: Platform.isIOS ? iOSPicker() : androidDropDown(),

              ),
            ),
          ),


          /////////////////// implementing the shopping cart button:  //////////////////

          Expanded(

            flex: 0,

            child: Padding(

              padding: const EdgeInsets.only(left: 50, top: 20, right: 50),

              child: ReusableContainer(

                colour: kInactiveCardColour,

                cardChild: Row(

                  children: <Widget>[

                    FlatButton(

                      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 50, left: 20),

                      onPressed: () {

                        final player = AudioCache();
                        player.play('tick.wav');

                        //here: not using named route; instead, using tradition page navigation syntax

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return StockShareShopNew( //stock_calculator_shop.dart
                                      stockName: chosenCompanyName,
                                      initialShareValue: stockPrice);
                                }
                            )
                        );
                      },

                      child: Icon(
                        Icons.add_shopping_cart,
                        size: 60.0,
                        color: Color(0xFFEB1555),
                      ),
                    ),

                    FlatButton(
                        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 85, right: 20),
                        onPressed: () => _launchURL(chosenCompanyName),
                        //onPressed: () => {},
                        color: kInactiveCardColour,
                        //padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.info, color: Colors.amber,),
                            Text(
                              "info",
                              style:
                              TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///////////////////////   bottom arrow button ///////////////////

        Expanded(

          child: Padding(

              padding: const EdgeInsets.only(top: 40),

              child: BottomButton(

                  onTapFunction: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, MainMenuPage.id);
                  }
              ),
            ),
        ),
        ],
      )
    );
  }
}





