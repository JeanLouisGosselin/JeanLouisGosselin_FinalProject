import 'package:flutter/material.dart';
import 'screens/IntroPage.dart';
import 'spinners/BriefLoadingAndWaitingScreen.dart';
import 'screens/CreateAccountOrLogin.dart';
import 'screens/CreateAccountScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/MainMenuPage.dart';
import 'screens/StockShareShopNew.dart';
import 'screens/CreateUsernameAndDobScreen.dart';
import 'spinners/GetUserData.dart';
import 'spinners/StockPurchase.dart';
import 'spinners/PurchasedStockPackages.dart';
import 'screens/ViewStockPurchased.dart';



void main() => runApp(KingCashGame());

class KingCashGame extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

        //defining all named routes:

        initialRoute: IntroPage.id,

        routes: {
          IntroPage.id: (context) => IntroPage(),
          BriefLoadingAndWaitingScreen.id: (context) => BriefLoadingAndWaitingScreen(),
          CreateAccountOrLogin.id: (context) => CreateAccountOrLogin(),
          CreateAccountScreen.id: (context) => CreateAccountScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          MainMenuPage.id: (context) => MainMenuPage(),
          StockShareShopNew.id: (context) => StockShareShopNew(),
          CreateUsernameAndDobScreen.id: (context) => CreateUsernameAndDobScreen(),
          GetUserData.id: (context) => GetUserData(),
          StockPurchase.id: (context) => StockPurchase(),
          PurchasedStockPackages.id: (context) => PurchasedStockPackages(),
          ViewStockPurchased.id: (context) => ViewStockPurchased(),
          PackageBox.id: (context) => PackageBox(),
          PackageList.id: (context) => PackageList(),

        },
    );
  }
}







