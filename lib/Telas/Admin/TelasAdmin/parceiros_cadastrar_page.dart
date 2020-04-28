import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:flutter/material.dart';

class ParceirosCadastrarPage extends StatefulWidget {
  Parceiro parceiro;
  ParceirosCadastrarPage({Key key,this.parceiro}) : super(key: key);

  @override
  _ParceirosCadastrarPageState createState() => _ParceirosCadastrarPageState();
}

class _ParceirosCadastrarPageState extends State<ParceirosCadastrarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar('Cadastrar Parceiro', context,showBack: true),);
  }
}