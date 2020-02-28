import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/ShortStreamBuilder.dart';
import 'package:bocaboca/Objetos/Cartao.dart';

import 'card_chip.dart';
import 'card_color.dart';
import 'card_controller.dart';

class CardFrontDisplay extends StatelessWidget {
  final int rotatedTurnsValue;
  Cartao c;
  CardFrontDisplay({this.rotatedTurnsValue, this.c});

  @override
  Widget build(BuildContext context) {
    final _cardNumber = Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[_formatCardNumber(c.number, context)],
      ),
    );

    final _cardLastNumber = Padding(
        padding: const EdgeInsets.only(top: 1.0, left: 16.0),
        child: Text(
          c.number.isNotEmpty && c.number.length >= 15
              ? c.number.replaceAll(RegExp(r'\s+\b|\b\s'), ' ').substring(12)
              : '0000',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ));

    final _cardValidThru = Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'valid',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              ),
              Text(
                'thru',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              )
            ],
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            c.expiration_month != null ? c.expiration_month.toString() : '00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          Text(
            c.expiration_year != null && c.expiration_year.toString().length > 2
                ? '/${c.expiration_year.toString().substring(2)}'
                : '/00',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ],
      ),
    );

    final _cardOwner = Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 44.0),
      child: Text(
        c.owner == null ? 'Nome do proprietário' : c.owner.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    );

    final _cardLogo = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25.0, right: 45.0),
            child: Image(
              image:
                  AssetImage(getBandeira(c.marca == null ? 'Visa' : c.marca)),
              width: 65.0,
              height: 32.0,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 45.0),
              child: Text(
                c.tipo == null ? c.tipo : '',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ))
        ]);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color.fromARGB(255, c.R, c.G, c.B)),
      child: RotatedBox(
        quarterTurns: rotatedTurnsValue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CardChip(),
                  _cardLogo,
                ],
              ),
            ),

            _cardNumber,
            //_cardLastNumber,
            _cardValidThru,
            _cardOwner,
          ],
        ),
      ),
    );
  }

  Widget _formatCardNumber(String cardNumber, context) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    List<Widget> numberList = new List<Widget>();
    var counter = 0;
    for (var i = 0; i < cardNumber.length; i++) {
      counter += 1;
      numberList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Text(
            cardNumber[i],
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * .04),
          ),
        ),
      );
      if (counter == 4) {
        counter = 0;

        ///
        numberList
            .add(SizedBox(width: MediaQuery.of(context).size.width * .04));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numberList,
    );
  }
}
