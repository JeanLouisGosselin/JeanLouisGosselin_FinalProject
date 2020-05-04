import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/MainMenuPage.dart';


class SellingStockPackage extends StatefulWidget {

  static const String id = 'LoadingUserData_Screen';

  final subDocumentLink;
  final stockPrice;

  SellingStockPackage({@required this.subDocumentLink, @required this.stockPrice});

  @override
  _SellingStockPackageState createState() => _SellingStockPackageState();
}


class _SellingStockPackageState extends State<SellingStockPackage> {

  final _auth = FirebaseAuth.instance;

  //here: creating an instance of the CLOUD_FIRESTORE:
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String userLink;
  String username;
  double usermoney;
  String subDoc;
  double moreMoney;

  @override
  void initState() {
    super.initState();
    gettingValues(widget.subDocumentLink, widget.stockPrice);
    getUserDataFromCloud();
    print('The user\'s data is fetched to sell stock');
  }

  void gettingValues(dynamic sDoc, dynamic sPrice){
    subDoc = sDoc;
    moreMoney = sPrice;
  }

  void getUserDataFromCloud() async {

    try{

      final user = await _auth.currentUser();

      if (user != null) {
        loggedInUser = user;
        print('Current user\'s email: ${loggedInUser.email}');
        print('Current user\'s ID token: ${loggedInUser.getIdToken()}');
        print('Current user\'s name: ${loggedInUser.displayName}');
        print('Current user\'s uid: ${loggedInUser.uid}');
        print('Current user\'s providerID: ${loggedInUser.providerId}');
        print('Current user\'s provider data: ${loggedInUser.providerData}');
        DocumentReference ref = _firestore.collection('userDetails').document(user.uid);
        print(ref);

        userLink = loggedInUser.email.toString();

        await Firestore.instance.collection('userDetails').document(userLink).get().then((DocumentSnapshot document) {

          print('username value: ${document['username']}');

          username = document['username'].toString();

        });

        await Firestore.instance.collection('userDetails').document(userLink).get().then((DocumentSnapshot document) {

          print('user money: ${document['totalmoney']}');

          usermoney = document['totalmoney'];

          //here: adding the value of the sold stock package to user's total money:
          usermoney += moreMoney;

        });

        //(1) amending the user's total earnings data on the cloud

        await Firestore.instance
              .collection('userDetails')
              .document(userLink)
              .updateData({'totalmoney': usermoney});

        //(2) deleting the subdoc (using the doc link provided):

        await Firestore.instance
            .collection('userDetails')
            .document(userLink)
            .collection('stock_purchase')
            .document(subDoc).delete();

        //for testing only
        print('money data amended + stock package deleted');

        Navigator.pop(context);
        Navigator.pushNamed(context, MainMenuPage.id);

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
        body: Center(
            child: SpinKitCircle(
              color: Colors.redAccent,
              size: 100.0,
            )
        )
    );
  }
}

