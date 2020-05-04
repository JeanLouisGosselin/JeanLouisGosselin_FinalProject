import '../constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../StockDataGetter.dart';
import '../screens/MainStockDataScreen.dart';


/*
NOTE:
This class is an intermediary class: it is wedged between the SCREEN_MENU_PAGE file and
the actual SCREEN_MAIN_STOCK_DATA

We need this class to initially set the SCREEN_MAIN_STOCK_DATA class with pre-fetched values.

---> notice: the INITSTATE() method below, which invokes the
getDefaultStockDataForStartingApp() method, also declared and defined below

SCREEN_MAIN_STOCK_DATA collects this ***default*** weather information to initialise
both FTSE and searched city fields (with weather data from London.

SCREEN_MAIN_STOCK_DATA then later offers the possibility of getting weather data from another city
(although the FTSE value is set as a permanent, immutable value).

The reason we have a waiting spinner at the bottom of this file is because
it may take some time to get this online weather data for the city of London;
therefore, it is more classy to put a spinning shape of some kind as a visual reference.
 */


class BriefLoadingAndWaitingScreen extends StatefulWidget {

  static const String id = 'BriefLoadingAndWaiting_Screen';

  @override
  _BriefLoadingAndWaitingScreenState createState() => _BriefLoadingAndWaitingScreenState();
}

class _BriefLoadingAndWaitingScreenState extends State<BriefLoadingAndWaitingScreen> {

  @override
  void initState() {
    super.initState();
    getStockDataForStartingApp();
    print('The programme starts with weather for London which is fetched by default');

  }

  void getStockDataForStartingApp() async{

    //here: creating an instance of STOCKDATAGETTER, to fetch data through its
    //GETSTOCKDATA() method (based on the argument it has been issued)
    StockDataGetter stockDataGetter = StockDataGetter();

    /*
    IMPORTANT: the value returned from STOCKDATAGETTER() method (which is in fact data returned
    from the NETWORKENSURER class) is essentially JSON data; this explains why we assign this returned
    data to two VAR variables below:
     */
    var dataForDefaultFTSE = await stockDataGetter.getStockData(defaultFTSE);
    var dataForDefaultCompany = await stockDataGetter.getStockData(defaultCompany);

    //here: not using named route

    Navigator.push(

        context,
        MaterialPageRoute(
            builder: (context) {
              return MainStockDataScreen(
                  defaultFTSEdata: dataForDefaultFTSE,
                  chosenCompanyData: dataForDefaultCompany
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