import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../screens/UserProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GetUserData extends StatefulWidget {

  static const String id = 'LoadingUserData_Screen';

  @override
  _GetUserDataState createState() => _GetUserDataState();
}


class _GetUserDataState extends State<GetUserData> {

  final _auth = FirebaseAuth.instance;

  //here: creating an instance of the CLOUD_FIRESTORE:
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String docLink;

  String username = 'this is a default username';
  double usermoney = 1000000.0;

  @override
  void initState() {
    super.initState();
    getUserDataFromCloud();
    print('The user\'s data is fetched');
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

        docLink = loggedInUser.email.toString();

        await Firestore.instance
            .collection('userDetails')
            .document(docLink)
            .get()
            .then((DocumentSnapshot document) {

          print('username value: ${document['username']}');

          username = document['username'].toString();

        });

        await Firestore.instance
            .collection('userDetails')
            .document(docLink)
            .get()
            .then((DocumentSnapshot document) {

          print('user money: ${document['totalmoney']}');

          usermoney = document['totalmoney'];

        });

        //for testing only
        print('HERE: yes, the user\'s data is fetched');

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return UserProfile(
                    mainUserName: username,
                    mainUserTotalMoney: usermoney,
                  );
                }
            )
        );
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