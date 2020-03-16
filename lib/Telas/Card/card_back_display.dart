import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/ShortStreamBuilder.dart';
import 'package:autooh/Objetos/Cartao.dart';

import 'card_color.dart';
import 'card_controller.dart';

class CardBackDisplay extends StatelessWidget {
  Cartao c;

  CardBackDisplay(this.c);

  @override
  Widget build(BuildContext context) {

    return  Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, c.R, c.G, c.B),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Image(
                          image: AssetImage('assets/card_band.jpg'),
                          width: 200.0,
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Container(
                        width: 65.0,
                        height: 42.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.red, width: 3.0),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(c.cvc.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, left: 12.0),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(10.0),
                      child: Image(
                          image: AssetImage('assets/card_back.jpg'),
                          width: 65.0,
                          height: 40.0,
                          fit: BoxFit.fill),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
