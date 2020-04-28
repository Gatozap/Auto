import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Distancia.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaCarroUserPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaUsuarioPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/parceiros_cadastrar_page.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Versao/VersaoPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'TelasAdmin/CriarCampanhaPage.dart';
import 'TelasAdmin/ListCampanhaPage.dart';
import 'TelasAdmin/ParceirosListPage.dart';

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

              decoration: BoxDecoration(
                color:Color.fromRGBO(0, 125, 190, 100),
                border: Border.all(
                  color: Colors.transparent,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: getAltura(context) * .2,
              width: getLargura(context) * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 60, height: 60,child:  Image.asset('assets/icone_campanha.png', fit: BoxFit.fill),),
                  hText('Criar\nCampanha', context, color:  Colors.white, textaling: TextAlign.center)
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

              decoration: BoxDecoration(
                color:Color.fromRGBO(0, 125, 190, 100),
                border: Border.all(
                  color: Colors.transparent,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: getAltura(context) * .2,
              width: getLargura(context) * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 60, height: 60,child: Icon(FontAwesomeIcons.user, color: Colors.yellowAccent,size: 40),),
                  hText('Lista de\nUsuários', context, color:  Colors.white, textaling: TextAlign.center)
                ],
              ),
            ),
          ),


        ],
      ),
        Row(children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListaCarroUserPage(carro: widget.carro, user: widget.user,campanha: widget.campanha, )));
            },
            child: Container(

              decoration: BoxDecoration(
                color:Color.fromRGBO(0, 125, 190, 100),
                border: Border.all(
                  color: Colors.transparent,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: getAltura(context) * .2,
              width: getLargura(context) * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 60, height: 60,child:  Icon(FontAwesomeIcons.carSide, color: Colors.yellowAccent,size: 40),),
                  hText('Lista de\nCarros', context, color:  Colors.white, textaling: TextAlign.center)
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

              decoration: BoxDecoration(
                color:Color.fromRGBO(0, 125, 190, 100),
                border: Border.all(
                  color: Colors.transparent,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: getAltura(context) * .2,
              width: getLargura(context) * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 60, height: 60,child: Image.asset('assets/Campanhas.png', fit: BoxFit.fill),),
                  hText('Editar\nCampanha', context, color:  Colors.white, textaling: TextAlign.center)
                ],
              ),
            ),
          ),


        ],),

        Row(children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EstatisticaPage(carro: widget.carro, user: widget.user,campanha: widget.campanha, corrida: widget.corrida,)));
            },
            child: Container(

              decoration: BoxDecoration(
                color:Color.fromRGBO(0, 125, 190, 100),
                border: Border.all(
                  color: Colors.transparent,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: getAltura(context) * .2,
              width: getLargura(context) * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 60, height: 60,child: Icon(FontAwesomeIcons.chartPie, color: Colors.yellowAccent,size: 40),),
                  hText('Estatísticas', context, color:  Colors.white, textaling: TextAlign.center)
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ParceirosCadastrarPage()));
            },
            child: Container(

              decoration: BoxDecoration(
                color:Color.fromRGBO(0, 125, 190, 100),
                border: Border.all(
                  color: Colors.transparent,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: getAltura(context) * .2,
              width: getLargura(context) * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(width: 60, height: 60,child: Icon(FontAwesomeIcons.shopware, color: Colors.yellowAccent,size: 40),),
                  hText('Parceiros', context, color:  Colors.white, textaling: TextAlign.center)
                ],
              ),
            ),
          ),

         ],)
      ]),

      ),

    );
  }
}
