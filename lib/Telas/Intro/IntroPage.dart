import 'package:autooh/Helpers/Styles.dart';
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

        body: Text(
          'Bem Vindo(a) ao aplicativo do prestador Moderno!',
        ),
        title: Text(
          'autooh',
        ),
        textStyle: TextStyle(color: corPrimaria),
     ),
    PageViewModel(
      pageColor: corPrimaria,

      body: Text(
        'No autooh você pode. . . .',
      ),
      title: Text('autooh'),

      textStyle: TextStyle(color: Colors.black),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),

      body: Text(
        'E Também . . . ',
      ),
      title: Text('autooh'),

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
