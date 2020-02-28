import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/Styles.dart';

class EsqueceuSenha extends StatelessWidget {
  Color pageColor = corPrimaria;
  EdgeInsets ei = EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var controllerEmail = new TextEditingController(text: '');
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Recupere sua senha'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: ei,
            child: TextFormField(
              controller: controllerEmail,
              validator: (value) {
                if (value.isEmpty) {
                  return 'É necessário preencher o E-mail';
                } else {
                  if (value.contains('@')) {
                  } else {
                    return 'E-mail inválido!';
                  }
                }
              },
              decoration: InputDecoration(
                  icon: Icon(
                    LineAwesomeIcons.envelope,
                    color: pageColor,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                          style: BorderStyle.solid)),
                  hintText: 'nutrinho@bocaboca.com',
                  labelText: 'E-mail',
                  hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic)),
            ),
          ),
          RaisedButton(
            color: pageColor,
            child: Text(
              'Recuperar Senha',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              _auth
                  .sendPasswordResetEmail(email: controllerEmail.text)
                  .then((v) {
                dToast('Verifique seu e-mail');
              });
            },
          ),
        ],
      )),
    );
  }
}
