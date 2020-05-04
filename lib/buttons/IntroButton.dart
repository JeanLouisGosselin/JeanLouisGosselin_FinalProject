import 'package:flutter/material.dart';


class IntroButton extends StatelessWidget {

  final String title;
  final Color thisColor;
  final double minimumWidth;
  final Function thisFunc;

  IntroButton({this.title, this.thisColor, this.minimumWidth, @required this.thisFunc});

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: EdgeInsets.symmetric(vertical: 16.0),

      child: Material(

        elevation: 5.0,
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: thisColor),
        ),

        child: MaterialButton(

          //here: 4th field above
          onPressed: thisFunc,
          //here: 3rd field above
          minWidth: minimumWidth,
          height: 45.0,

          child: Text(
            //here: 1st field above
            title,
            style: TextStyle(
              //here: 2nd field above
              color: thisColor,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}