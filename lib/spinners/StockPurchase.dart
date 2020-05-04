import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'GetUserData.dart';


class StockPurchase extends StatefulWidget {

  static const String id = 'LoadingStockPurchase_Screen';

  final purchasePrice;

  StockPurchase({@required this.purchasePrice});

  @override
  _StockPurchaseState createState() => _StockPurchaseState();
}


class _StockPurchaseState extends State<StockPurchase> {

  final _auth = FirebaseAuth.instance;

  //here: creating an instance of the CLOUD_FIRESTORE:
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String docLink;
  double userMoney;

  @override
  void initState() {
    super.initState();
    getSetUserDataFromCloud(widget.purchasePrice);
  }

  /////////////////////////////////////////////////////////

  //here: fetching user's money stored in the cloud:

  void getSetUserDataFromCloud(dynamic purchPrice) async {

    try{

      final user = await _auth.currentUser();

      if (user != null) {

        loggedInUser = user;

        //this is just for checking:
        print('Current user\'s email: ${loggedInUser.email}');
        print('Current user\'s ID token: ${loggedInUser.getIdToken()}');
        print('Current user\'s name: ${loggedInUser.displayName}');
        print('Current user\'s uid: ${loggedInUser.uid}');
        print('Current user\'s providerID: ${loggedInUser.providerId}');
        print('Current user\'s provider data: ${loggedInUser.providerData}');
        DocumentReference ref = _firestore.collection('userDetails').document(user.uid);
        print(ref);

        docLink = loggedInUser.email.toString();


        await Firestore.instance
            .collection('userDetails')
            .document(docLink)
            .get()
            .then((DocumentSnapshot document) {

          //this is just for checking:
          print('totalmoney value: ${document['totalmoney']}');

          userMoney = document['totalmoney'];

          print('Before purchase, user\'s money = $userMoney');

        });

        ////////////////////////////////////////////////////

        //here: doing calculations:
        userMoney -= purchPrice;

        print('After purchase, user\'s money has dropped to $userMoney');

        ////////////////////////////////////////////////////

          try {
            Firestore.instance
                .collection('userDetails')
                .document(docLink)
                .updateData({'totalmoney': userMoney});
          } catch (e) {
            print(e.toString());
          }

        ////////////////////////////////////////////////////

        Navigator.push(

            context,
            MaterialPageRoute(
                builder: (context) {
                  return GetUserData();
                }
            )
        );
      }//end of mega IF statement
    }//end of TRY statement
    catch(e){
      print(e);
    }
  }//end of huge method

  ////////////////////////////////////////////////////////////////////////////

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