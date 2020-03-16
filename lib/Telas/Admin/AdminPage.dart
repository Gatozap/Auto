import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Distancia.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaCarroUserPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaUsuarioPage.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Versao/VersaoPage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'TelasAdmin/CriarCampanhaPage.dart';
import 'TelasAdmin/ListCampanhaPage.dart';

class AdminPage extends StatefulWidget {
  User user;
  Campanha campanha;
  Carro carro;
  Distancia distancia;
  Corrida corrida;
  AdminPage(
      {this.carro, this.distancia, this.corrida, this.campanha, this.user});

  @override
  _AdminPageState createState() {
    return _AdminPageState();
  }
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: myAppBar('Administrador', context, showBack: true),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
      children: <Widget>[

      Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CriarCampanhaPage()));
            },
            child: Container(
              color: Colors.lightBlue[50],
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

              height: getAltura(context) * .2,
              width: getLargura(context)*.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(MdiIcons.appleSafari, size: 55, color: Colors.lightBlue[700]), hText('Criar Campanha', context)
                ],
              ),
            ),
          ),


        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListaUsuarioPage(user: widget.user,)));
          },
          child: Container(
            color: Colors.lightBlue[50],
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

            height: getAltura(context) * .2,
            width: getLargura(context)*.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(MdiIcons.accountBox, size: 55, color: Colors.lightBlue[700]), hText('Lista de Usuários', context)
              ],
            ),
          ),
        ),
        ],
      ),
        Row(children: <Widget>[   GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListaCarroUserPage(carro: widget.carro, user: widget.user,campanha: widget.campanha, )));
          },
          child: Container(
            color: Colors.lightBlue[50],
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

            height: getAltura(context) * .2,
            width: getLargura(context)*.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(MdiIcons.car, size: 55, color: Colors.lightBlue[700]), hText('Lista de Carros', context)
              ],
            ),
          ),
        ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListaCampanhaPage(campanha: widget.campanha,carro: widget.carro, user: widget.user)));
            },
            child: Container(
              color: Colors.lightBlue[50],
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

              height: getAltura(context) * .2,
              width: getLargura(context)*.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(MdiIcons.appleSafari, size: 55, color: Colors.lightBlue[700]), hText('Editar Campanha', context)
                ],
              ),
            ),
          ),

        ],),
        Row(children: <Widget>[  GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EstatisticaPage(carro: widget.carro, user: widget.user,campanha: widget.campanha, corrida: widget.corrida,)));
          },
          child: Container(
            color: Colors.lightBlue[50],
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

            height: getAltura(context) * .2,
            width: getLargura(context)*.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(MdiIcons.chartAreaspline, size: 55, color: Colors.lightBlue[700]), hText('Estatísticas', context)
              ],
            ),
          ),
        ),],)
      ]),

      ),

    );
  }
}
