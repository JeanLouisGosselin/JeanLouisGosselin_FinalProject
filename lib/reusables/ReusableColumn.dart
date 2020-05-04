import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ReusableColumn extends StatelessWidget {

  final IconData importedIcon;
  final String userSex;

  //here: both fields are @REQUIRED:
  ReusableColumn({@required this.importedIcon, @required this.userSex,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
            importedIcon,
            size: kIconSize ),
        SizedBox(
          height: kSizedBoxHeight,
        ),
        Text(
          userSex,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}