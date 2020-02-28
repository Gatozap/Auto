import 'package:flutter/material.dart';

import 'card_color.dart';

class CardChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: 10.0, left: CardColor.LeftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image(
            image: AssetImage('assets/creditcardchipsilver.png'),
            width: 50.0,
          ),
        ],
      ),
    );
  }
}
