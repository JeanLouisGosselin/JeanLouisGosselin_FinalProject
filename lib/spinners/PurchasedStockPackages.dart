import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/ViewStockPurchased.dart';
import '../StockDataGetter.dart';


class PurchasedStockPackages extends StatefulWidget {

  static const String id = 'PurchasedStockPackages_Screen';

  @override
  _PurchasedStockPackagesState createState() => _PurchasedStockPackagesState();
}

class _PurchasedStockPackagesState extends State<PurchasedStockPackages> {

  final _auth = FirebaseAuth.instance;

  //here: creating an instance of the CLOUD_FIRESTORE:
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String docLink;

  StockDataGetter stockDataGetter = StockDataGetter();

  var companyname = new List();
  var numbershares = new List();

  var initialSharePrice = new List();
  var currentSharePrice = new List();
  var previousSharePrice = new List();

  var initialBundleValue = new List();
  var currentBundleValue = new List();
  var previousBundleValue = new List();

  var dateTimePurchased = new List();
  var subCollectionDocLink = new List();

  double thisCurrentPrice;

  double prevSharePrice;
  double prevBundleValue;

  int subCollectionLength;

  @override
  void initState() {
    super.initState();
    print('The purchased stock\'s data is fetched');
    getAllStockPurchased();
  }

  //////////////////////////////////////////////////
  //////////////////////////////////////////////////
  //////////////////////////////////////////////////

  void updatePreviousSharePrice(String myCompanyName, double val, String subLink) async{

    if (myCompanyName != null) {

      await Firestore.instance
          .collection('userDetails')
          .document(loggedInUser.email)
          .collection('stock_purchase')
          .document(subLink)
          .updateData({'PreviousSharePrice': val});
    }
  }


  //updating the CURRENTSHAREPRICE field on Firebase subcollection with latest real-time value:
  //(in other words: recalculating the entire value of the stock
  // package based on current up-to-date weather temperature values):
  void updateCurrentSharePrice(String myCompanyName, String subLink) async {

    if (myCompanyName != null) {

      var dataForThisCompany =
      await stockDataGetter.getStockData(myCompanyName);

      double currentIndividualPrice = dataForThisCompany['main']['temp'].toDouble();

      print('The current single stock price for $myCompanyName: $currentIndividualPrice');

      await Firestore.instance
          .collection('userDetails')
          .document(loggedInUser.email)
          .collection('stock_purchase')
          .document(subLink)
          .updateData({'CurrentSharePrice': currentIndividualPrice});
    }
  }

  /////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////


  void updatePreviousBundleValue(String myCompanyName, double val, String subLink) async{

    if (myCompanyName != null) {

      await Firestore.instance
          .collection('userDetails')
          .document(loggedInUser.email)
          .collection('stock_purchase')
          .document(subLink)
          .updateData({'PreviousBundleValue': val});
    }
  }


  //updating the CURRENTBUNDLEVALUE field on Firebase subcollection with latest real-time value:
  //(in other words: recalculating the entire value of the stock
  // package based on current up-to-date weather temperature values):
  void updateCurrentBundleValue(String myCompanyName, int num, String subLink) async {

    if (myCompanyName != null) {

      var dataForThisCompany =
      await stockDataGetter.getStockData(myCompanyName);

      double currentIndividualPrice = dataForThisCompany['main']['temp'].toDouble();

      print('The current stock bundle value for $myCompanyName: $currentIndividualPrice');

      double fullCurrentPrice = currentIndividualPrice * num;

      await Firestore.instance
          .collection('userDetails')
          .document(loggedInUser.email)
          .collection('stock_purchase')
          .document(subLink)
          .updateData({'CurrentBundleValue': fullCurrentPrice});
    }
  }


  void getAllStockPurchased() async {

    try {
      final user = await _auth.currentUser();

      if (user != null) {

        loggedInUser = user;

        docLink = loggedInUser.email.toString();

        QuerySnapshot variable = await _firestore
            .collection('userDetails')
            .document(docLink)
            .collection('stock_purchase')
            .getDocuments(); //(NOTE: this method returns a FUTURE):

        subCollectionLength = variable.documents.length;

        int x=0;

        print('testing: getting all data from Firebase:');

        for (var package in variable.documents) {

          //here: just for testing purposes:
          print('This is the current subdoc\'s link: ${package.documentID}');
          print('...and this is the current subdoc\'s data:');
          print(package.data);

          //here: grabbing + assigning data from subcollection to our list variables:

          companyname.add(package.data['CompanyName']);
          numbershares.add(package.data['NumberShares']);
          int numShares = numbershares[x];

          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////



          //here: updating PREVIOUSSHAREPRICE field with CURRENTSHAREPRICE field:
          // (before it changes):
          prevSharePrice = package.data['CurrentSharePrice'];
          print('@@@@@@ The previous value (before change) is: ${package.data['PreviousSharePrice']}');
          updatePreviousSharePrice(companyname[x], prevSharePrice, package.documentID.toString());
          print('@@@@@@ The previous value (after change) is: ${package.data['PreviousSharePrice']}');



          //here: updating CURRENTSHAREPRICE field based on up-to-date values:
          print('@@@@@@ The current value (before change) is: ${package.data['CurrentSharePrice']}');
          updateCurrentSharePrice(companyname[x], package.documentID.toString());
          print('@@@@@@ The current value (afterchange) is: ${package.data['CurrentSharePrice']}');



          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////



          //here: saving the latest value of CURRENTBUNDLEVALUE to PREVIOUSBUNDLEVALUE field
          // (before it changes):
          prevBundleValue = package.data['CurrentBundleValue'];
          print('@@@@@@ The previous value (before change) is: ${package.data['PreviousBundleValue']}');
          updatePreviousBundleValue(companyname[x], prevBundleValue, package.documentID.toString());
          print('@@@@@@ The previous value (after change) is: ${package.data['PreviousBundleValue']}');



          //here: updating CURRENTBUNDLEVALUE field based on up-to-date values (using the company name):
          print('@@@@@@ The current bundle value (before change) is: ${package.data['CurrentBundleValue']}');
          updateCurrentBundleValue(companyname[x], numShares, package.documentID.toString());
          print('@@@@@@ The current bundle value (after change) is: ${package.data['CurrentBundleValue']}');



          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////
          ///////////////////////////////////////////////////

          //here: adding all up-to-date values to our lists declared at the start of the class:

          initialSharePrice.add(package.data['InitialSharePrice']);
          currentSharePrice.add(package.data['CurrentSharePrice']);
          previousSharePrice.add(package.data['PreviousSharePrice']);

          initialBundleValue.add(package.data['InitialBundleValue']);
          currentBundleValue.add(package.data['CurrentBundleValue']);
          previousBundleValue.add(package.data['PreviousBundleValue']);

          dateTimePurchased.add(package.data['DateTimeOfPurchase']);
          subCollectionDocLink.add(package.documentID);

          //just for testing:
          print('[[[[[ PRINTING VALUES FROM LISTS ]]]]]');

          print('initialSharePrice ${x+1} = ${initialSharePrice[x]}');
          print('currentSharePrice ${x+1} = ${currentSharePrice[x]}');
          print('previousSharePrice ${x+1} = ${previousSharePrice[x]}');

          print('initialBundleValue ${x+1} = ${initialBundleValue[x]}');
          print('currentBundleValue ${x+1} = ${currentBundleValue[x]}');
          print('previousBundleValue ${x+1} = ${previousBundleValue[x]}');

          x += 1;
        }
      }
    }
    catch (e) {
      print(e);
    }

    //for testing only
    print('HERE: the user\'s purchased stock packages are fetched');

    Navigator.push(

        context,
        MaterialPageRoute(

            builder: (context) {
              return ViewStockPurchased(
                companyName: companyname,
                numberShares: numbershares,
                initialSharePrice: initialSharePrice,
                currentSharePrice: currentSharePrice,
                previousSharePrice: previousSharePrice,
                initialBundleValue: initialBundleValue,
                currentBundleValue: currentBundleValue,
                previousBundleValue: previousBundleValue,
                dateOfPurchase: dateTimePurchased,
                collectionLength: subCollectionLength,
                subDocLink: subCollectionDocLink,
              );
            }
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: SpinKitCircle(
              color: Colors.redAccent,
              size: 100.0,
            )
        )
    );
  }
}
