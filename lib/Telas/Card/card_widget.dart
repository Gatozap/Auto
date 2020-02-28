import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bocaboca/Objetos/Cartao.dart';

import 'card_chip.dart';
import 'card_color.dart';

class CardWidget extends StatelessWidget {
  final Cartao card;
  CardWidget({this.card});

  @override
  Widget build(BuildContext context) {
    Random r = new Random();
    final _cardLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: CardColor.TopPadding, right: 52.0),
          child: Image(
            image: AssetImage('assets/visa_logo.png'),
            width: 65.0,
            height: 32.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 52.0),
          child: Text(
            'Crédito',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );

    final _cardNumber = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPadding, left: CardColor.LeftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildDots(),
        ],
      ),
    );

    final _cardValidThru = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPadding,
          right: 15.0,
          left: MediaQuery.of(context).size.width * .5),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'valido',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              ),
              Text(
                'até',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              )
            ],
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            '${card.expiration_month}/${card.expiration_year.toString().substring(2)}',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );

    final _cardOwner = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPadding, left: CardColor.LeftPadding),
      child: Text(
        card.owner,
        style: TextStyle(color: Colors.white, fontSize: 26.0),
      ),
    );
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: card.R == null
              ? CardColor.baseColors[r.nextInt(CardColor.baseColors.length)]
              : Color.fromARGB(255, card.R, card.G, card.B)),
      child: RotatedBox(
        quarterTurns: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _cardLogo,
            CardChip(),
            _cardNumber,
            _cardValidThru,
            _cardOwner
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    List<Widget> dotList = new List<Widget>();
    var counter = 0;
    for (var i = 0; i < 12; i++) {
      counter++;
      dotList.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Container(
          width: 4.0,
          height: 4.0,
          decoration:
              new BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ));
      if (counter == 4) {
        counter = 0;
        dotList.add(SizedBox(
          width: 15.0,
        ));
      }
    }
    dotList.add(_buildNumbers());
    return Row(
      children: dotList,
    );
  }

  Widget _buildNumbers() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: new Text(
        card.number.substring(14),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
