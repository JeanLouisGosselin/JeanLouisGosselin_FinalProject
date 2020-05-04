import 'package:flutter/material.dart';

class MenuDividingLine extends StatelessWidget {
  const MenuDividingLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 1.0,
        width: 50.0,
        child: Divider(
          color: Colors.white
        )
    );
  }
}