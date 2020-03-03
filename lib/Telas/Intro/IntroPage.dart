import 'package:bocaboca/Helpers/Styles.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() {
    return _IntroPageState();
  }
}

class _IntroPageState extends State<IntroPage> {
  final pages = [
    PageViewModel(
        pageColor: corPrimaria,
        // iconImageAssetPath: 'assets/air-hostess.png',
        bubble: Image.asset('assets/images/nutrannoLogo.png'),
        body: Text(
          'Bem Vindo(a) ao aplicativo do prestador Moderno!',
        ),
        title: Text(
          'bocaboca',
        ),
        textStyle: TextStyle(color: corPrimaria),
        mainImage: Image.asset(
          'assets/images/nutrannoLogo.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: corPrimaria,
      iconImageAssetPath: 'assets/images/nutrannoLogo.png',
      body: Text(
        'No bocaboca você pode. . . .',
      ),
      title: Text('bocaboca'),
      mainImage: Image.asset(
        'assets/images/nutrannoLogo.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      iconImageAssetPath: 'assets/images/nutrannoLogo.png',
      body: Text(
        'E Também . . . ',
      ),
      title: Text('bocaboca'),
      mainImage: Image.asset(
        'assets/images/nutrannoLogo.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: IntroViewsFlutter(

      pages,
          doneText:Text('Concluir'),
      skipText: Text('Pular'),
      onTapDoneButton: () {
        SharedPreferences.getInstance().then((sp) {
          sp.setBool('intro', true);
        });
        Navigator.pop(context); //MaterialPageRoute
      },

      pageButtonTextStyles: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
      ),
    ));
  }
}