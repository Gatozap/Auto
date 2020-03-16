import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/ShortStreamBuilder.dart';

import 'card_chip.dart';
import 'card_color.dart';
import 'card_controller.dart';

class CardFront extends StatelessWidget {
  final int rotatedTurnsValue;
  CardFront({this.rotatedTurnsValue});

  @override
  Widget build(BuildContext context) {
    final CardController cc = BlocProvider.of<CardController>(context);

    final _cardNumber = Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SSB(
            error: Container(),
            stream: cc.Outnumber,
            buildfunction: (context, snapshot) {
              return snapshot.hasData
                  ? _formatCardNumber(snapshot.data, context)
                  : _formatCardNumber('0000000000000000', context);
            },
          ),
        ],
      ),
    );

    final _cardLastNumber = Padding(
        padding: const EdgeInsets.only(top: 1.0, left: 16.0),
        child: SSB(
          error: Container(),
          stream: cc.Outnumber,
          buildfunction: (context, snapshot) {
            return Text(
              snapshot.hasData && snapshot.data.length >= 15
                  ? snapshot.data
                      .replaceAll(RegExp(r'\s+\b|\b\s'), ' ')
                      .substring(12)
                  : '0000',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            );
          },
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
          SSB(
            error: Container(),
            stream: cc.Outexpiration_month,
            buildfunction: (context, snapshot) {
              return Text(
                snapshot.hasData ? snapshot.data.toString() : '00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              );
            },
          ),
          SSB(
              error: Container(),
              stream: cc.Outexpiration_year,
              buildfunction: (context, snapshot) {
                return Text(
                  snapshot.hasData && snapshot.data.toString().length > 2
                      ? '/${snapshot.data.toString().substring(2)}'
                      : '/00',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                );
              })
        ],
      ),
    );

    final _cardOwner = Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 44.0),
      child: SSB(
        stream: cc.Outowner_name,
        error: Text(
          'Nome do Proprietario',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        buildfunction: (context, snapshot) => Text(
          snapshot?.data ?? 'Nome do Proprietario',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );

    final _cardLogo = SSB(
        error: Container(),
        stream: cc.outCard_brand,
        buildfunction: (context, snapshot) {

          print('AQUI TIPO CARTÂO ${snapshot.data}');
          return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 25.0, right: 45.0),
          child: Image(
            image: AssetImage(getBandeira(snapshot.data == null? 'Visa': snapshot.data)),
            width: 65.0,
            height: 32.0,
          ),
        ),
        StreamBuilder<String>(
          stream: cc.Outcard_type,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(right: 45.0),
              child:
                    Text(
                      snapshot.hasData ? snapshot.data : '',textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    )

            );
          }
        ),
      ]);
        }
    );

    return StreamBuilder<int>(
        stream: cc.Outcard_color_index,
        initialData: 0,
        builder: (context, snapshopt) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: CardColor.baseColors[snapshopt.data]),
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
        });
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
