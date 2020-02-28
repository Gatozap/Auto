import 'package:flutter/material.dart';

import 'card_color_model.dart';

class CardColor {
  static var baseColors = <Color>[
    Colors.red[800],
    Colors.blue[800],
    Colors.green[800],
    Colors.black,
    Colors.grey[600],
  ];

  static var NoBlackColors = <Color>[
    Colors.red[800],
    Colors.green[500],
    Colors.yellow[900],
    Colors.teal[800],
  ];

  static const double LeftPadding = 25.0;
  static const double TopPadding = 2.0;
  static const double TopPaddingHorizontal = 20.0;

  static List<CardColorModel> cardColors = new List<CardColorModel>.generate(
      baseColors.length,
      (int i) => CardColorModel(isSelected: false, cardColor: i));
}
