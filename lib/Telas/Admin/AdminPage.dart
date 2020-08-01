import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Distancia.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaCarroUserPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaUsuarioPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Solicitacoes/SolicitacoesListPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Parceiros/parceiros_cadastrar_page.dart';
import 'package:autooh/Chat/ChatList/ChatListPage.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Versao/VersaoPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Agendamento/agendamento_list_page.dart';
import 'TelasAdmin/CriarCampanhaPage.dart';
import 'TelasAdmin/ListCampanhaPage.dart';
import 'TelasAdmin/Parceiros/ParceirosListPage.dart';
import 'Ativos/ativos_page.dart';
import 'TelasAdmin/Relatorios/relatoriospage.dart';

class AdminPage extends StatefulWidget {
  User user;
  Campanha campanha;
  Carro carro;
  Distancia distancia;
  Corrida corrida;
  Parceiro parceiro;
  AdminPage(
      {this.carro, this.distancia, this.corrida, this.campanha, this.user, this.parceiro});

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
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Helper.localUser.permissao ==10 ?Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CriarCampanhaPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Image.asset('assets/icone_campanha.png',
                              fit: BoxFit.fill),
                        ),
                        hText('Criar\nCampanha', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaUsuarioPage(
                              user: widget.user,
                            )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.user,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Lista de\nUsuários', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),
              ],
            ):Container(),
            Row(
              children: <Widget>[
                Helper.localUser.permissao == 5? Container(): GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaCarroUserPage(
                              carro: widget.carro,
                              user: widget.user,
                              campanha: widget.campanha,
                            )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.carSide,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Lista de\nCarros', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),
                Helper.localUser.permissao == 5? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RelatoriosPage(
                        )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.file,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Relatorios', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ):Container(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaCampanhaPage(
                            campanha: widget.campanha,
                            carro: widget.carro,
                            user: widget.user)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Image.asset('assets/Campanhas.png',
                              fit: BoxFit.fill),
                        ),
                        hText(Helper.localUser.permissao == 5? 'Minhas campanhas': 'Editar\nCampanha', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EstatisticaPage(
                              carro: widget.carro,
                              user: widget.user,
                              campanha: widget.campanha,
                              corrida: widget.corrida,
                            )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.chartPie,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Estatísticas', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),
                Helper.localUser.permissao == 10? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ParceirosCadastrarPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.shopware,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Cadastrar\nParceiros', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ):Container(),
                Helper.localUser.permissao == 5? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AtivosPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.map,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Carros Ativos', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ):Container()
              ],
            ),
            Helper.localUser.permissao == 10? Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SolicitacoesListPage(user: widget.user,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.redhat,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Solicitacoes', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ParceirosListPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.shopware,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Editar\nParceiros', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),
              ],
            ):Container(),
            Row(
              children: <Widget>[
                Helper.localUser.permissao == 10? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AgendamentoListPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.calendar,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Agendamentos', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ):Container(),
                Helper.localUser.permissao == 10? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AtivosPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.map,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Carros Ativos', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ):Container(),
              ],
            ),

            Row(
              children: [
                Helper.localUser.permissao == 5? Container():GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RelatoriosPage(
                        )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(FontAwesomeIcons.file,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Relatorios', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ),

                Helper.localUser.permissao == 10? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatListPage(
                        )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 125, 190, 100),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: getAltura(context) * .2,
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: Icon(MdiIcons.chat,
                              color: Colors.yellowAccent, size: 40),
                        ),
                        hText('Suporte', context,
                            color: Colors.white, textaling: TextAlign.center)
                      ],
                    ),
                  ),
                ):Container(),
              ],
            ),
          ]),
        ),
      ),
    );
  }


}


