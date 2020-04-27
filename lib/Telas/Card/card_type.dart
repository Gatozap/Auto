import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Styles.dart';

import 'card_controller.dart';


class CardType extends StatelessWidget {
  nutrannoLogo(context, m1, m2) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * m1,
      height: MediaQuery.of(context).size.height * m2,
      child: Container(
   ),
    );
  }

  Widget widgetTopMenu(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .1,
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * .01,
          ),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: MediaQuery.of(context).size.height * .01,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: corPrimaria,
                    )),
                nutrannoLogo(context, .2, .05),
                Icon(Icons.settings, color: Colors.white),
              ],
            ),
          )),
    );
  }

  final _buildTextInfo = Padding(
    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
    child: Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: '',
            style: TextStyle(
                color: Colors.lightBlue, fontWeight: FontWeight.bold)),
      ], text: ' '),
      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
      softWrap: true,
      textAlign: TextAlign.center,
    ),
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
          child: widgetTopMenu(context),
          preferredSize: MediaQuery.of(context).size * .2),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildRaisedButton(
                buttonColor: Colors.blue,
                buttonText: 'Cartão de Crédito',
                textColor: Colors.white,
                context: context),
            /* _buildRaisedButton(
                buttonColor: Colors.grey[100],
                buttonText: 'Cartão de Debito',
                textColor: Colors.grey[600],
                context: context),
            _buildRaisedButton(
                buttonColor: Colors.red[800],
                buttonText: 'Gift Card',
                textColor: Colors.white,
                context: context),*/
            _buildTextInfo
          ],
        ),
      ),
    );
  }

  Widget _buildRaisedButton(
      {Color buttonColor,
      String buttonText,
      Color textColor,
      BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          var blocProviderCardCreate = BlocProvider(
            bloc: CardController(),

          );
          blocProviderCardCreate.bloc.Incard_type(buttonText);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => blocProviderCardCreate));
        },
        color: buttonColor,
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
