import 'package:flutter/material.dart';

const kIconSize = 80.0;
const kSizedBoxHeight = 15.0;
const kTextFontSize = 18.0;
const kTextColour = 0xFF8D8E98;
const kMarginPixels = 15.0;
const kBorderRadiusValue = 20.0;
const kBottomContainerHeight = 80.0;
const kBottomContainerColour = Color(0xFFEB1555);
const kTopMargin = 10.0;
const kActiveCardColour = Color(0xFF303438);
const kInactiveCardColour = Color(0xFF1B1C1F);
const kMinimumSliderHeight = 1.0;
const kMaximumSliderHeight = 10000.0;
const kButtonColor = Color(0xFF4C4F5E);

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

const TextStyle kSlickNumericStyle = TextStyle(
  color: Colors.white,
    fontSize: 50.0,
    fontWeight: FontWeight.w900);

const kLabelTextStyle= TextStyle(
  fontSize: 10.0,
  color: Color(kTextColour),);

const kLabelTextStyleBig = TextStyle(
  fontSize: 45.0,
  color: Color(kTextColour),);

const kNumShares = TextStyle(
  fontSize: 28.0,
  color: Color(0xFFEB1555),);

const kTotalSharePrice = TextStyle(
  fontSize: 38.0,
  color: Colors.white);


const kLabelTextStyleMedium = TextStyle(
  fontSize: 24.0,
  color: Color(kTextColour),);

const kMainPinkButtonTextStyle = TextStyle(
    fontSize: 24.0,
    color: Colors.white,
    fontWeight: FontWeight.w600);

const kResultLabelStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const kGeneralTextResultStyle = TextStyle(
    color: Color(0xFF24D876),
    fontSize: 22.0,
    fontWeight: FontWeight.bold
);

const kBMITextStyle = TextStyle(
    fontSize: 100.0,
    fontWeight: FontWeight.bold
);

const kBMICommentStyle = TextStyle(
    fontSize: 28.0,
    color: Colors.white
);

const kgivenPrice = TextStyle(
    fontSize: 28.0,
    color: Colors.grey
);

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////


const kColorGold = Color(0xFFBCB71A);
const kColorRed = Color(0xFFDB3654);
const String defaultFTSE = "London";
const String defaultCompany = "Sydney";

const kButtonTextStyle1 = TextStyle(
  color: kColorGold,
  fontSize: 30.0,
  fontStyle: FontStyle.italic,
);

const kButtonTextStyle2 = TextStyle(
  color: kColorRed,
  fontSize: 30.0,
  fontStyle: FontStyle.italic,
  decorationColor: kColorRed,
);


///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////


const kAllUserDetails = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
      Icons.favorite,
      color: Colors.white),
  //default string:
  hintText: 'Enter something',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all((Radius.circular(10.0))),
    borderSide: BorderSide.none,
  ),
);


///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////



const kMainBlackBackground = TextStyle(
    color: Colors.black
);


//////////////////////////////////////////////////////////////

//using our own API key to connect to the OPENWEATHERMAP key:
const apiKey = '0da5a45cd001285d7cb26ed2dd3d41cd';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';


//////////////////////////////////////////////////////////////


const List<String> companiesList = [
  'Sydney',
  'London',
  'Tokyo',
  'Montreal',
  'New York',
  'Madrid',
  'Berlin',
  'Vienna',
  'Oslo',
  'Helsinki',
  'Moscow',
  'Beijing',
  'Chicago',
  'Vancouver',
  'Mexico',
  'Rome',
  'Budapest',
  'Naples',
  'Paris',
  'Perth',
  'Auckland',
  'Minnesota',
  'Havana'
];


