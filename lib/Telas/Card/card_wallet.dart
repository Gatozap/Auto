import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Styles.dart';

import 'card_controller.dart';
import 'card_front.dart';
import 'cartoes_page.dart';

class CardWallet extends StatefulWidget {
  @override
  _CardWallet createState() => _CardWallet();
}

class _CardWallet extends State<CardWallet> with TickerProviderStateMixin {
  AnimationController rotateController;
  AnimationController opacityController;
  Animation<double> animation;
  Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    final CardController bloc = BlocProvider.of<CardController>(context);
    rotateController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: 300));
    opacityController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));

    CurvedAnimation curvedAnimation = new CurvedAnimation(
        parent: opacityController, curve: Curves.fastOutSlowIn);

    animation = Tween(begin: -2.0, end: -3.15).animate(rotateController);
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);

    opacityAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bloc.saveCard();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CartoesPage()));
      }
    });

    rotateController.forward();
    opacityController.forward();
  }

  @override
  dispose() {
    rotateController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  nutrannoLogo(context, m1, m2) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * m1,
      height: MediaQuery.of(context).size.height * m2,
      child: Container(
        padding: EdgeInsets.all(1),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * m1,
        height: MediaQuery.of(context).size.height * m2,
        color: Colors.transparent,
        child: Image(
          image: AssetImage('assets/images/nutrannoLogo.png'),
          width: MediaQuery.of(context).size.width * m1,
          height: MediaQuery.of(context).size.height * m2,
        ),
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

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            child: widgetTopMenu(context),
            preferredSize: MediaQuery.of(context).size * .2),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: AnimatedBuilder(
                    animation: animation,
                    child: Container(
                      width: _screenSize.width / 1.6,
                      height: _screenSize.height / 2.2,
                      child: CardFront(rotatedTurnsValue: -3),
                    ),
                    builder: (context, _widget) {
                      return Transform.rotate(
                        angle: animation.value,
                        child: _widget,
                      );
                    }),
              ),
              SizedBox(
                height: 150.0,
              ),
              CircularProgressIndicator(
                strokeWidth: 6.0,
                backgroundColor: Colors.lightBlue,
              ),
              SizedBox(
                height: 30.0,
              ),
              FadeTransition(
                opacity: opacityAnimation,
                child: Text(
                  'Card Added',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
