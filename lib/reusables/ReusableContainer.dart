import 'package:flutter/material.dart';
import '../constants/constants.dart';


class ReusableContainer extends StatelessWidget {

  final Color colour;
  final Widget cardChild; //---> this is important to remember! we have created this field from scratch!

  //notice: CARDCHILD is not set as @REQUIRED:
  ReusableContainer({@required this.colour, this.cardChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      margin: EdgeInsets.all(kMarginPixels),
      decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(kBorderRadiusValue)
      ),
    );
  }
}
