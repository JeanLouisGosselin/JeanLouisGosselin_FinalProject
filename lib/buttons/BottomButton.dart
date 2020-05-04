import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {

  //our fields (one of which is a function -> legal!):
  final Function onTapFunction;
  final String buttonTitle;

  //our customized constructor:
  BottomButton({@required this.onTapFunction, @required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      //here: using our field above:
      onTap:
      onTapFunction,

      child: Container(

            child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30.0
            ),
        ),
      );
  }
}
