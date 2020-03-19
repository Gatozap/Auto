
import 'package:autooh/Helpers/Bairros.dart';
import 'package:autooh/Helpers/ListaEquipamentos.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Intro/IntroPage.dart';
import 'package:autooh/Telas/Corrida/foreground.dart';
import 'package:autooh/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Grupo.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Grupo/Chat/ChatList/ChatListPage.dart';
import 'package:autooh/Telas/Home/GruposController.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((v) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
    });
    if (gc == null) {
      gc = new GruposController();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.shopping_cart), title: new Text('Serviços')),
      BottomNavigationBarItem(
        icon: new Icon(Icons.chat),
        title: new Text('conversas'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info_outline), title: Text('Yellow'))
    ];
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Color cor1 = corPrimaria;
  Color cor2 = Colors.cyan[200];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawerWidget(),
      appBar: myAppBar('Bem vindo ${Helper.localUser.nome}', context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              hText('Saldo Atual', context,
                                  color: Colors.black),
                              SizedBox(height: 5),
                              hText('R\$: 0.00', context,
                                  color: corPrimaria,
                                  style: FontStyle.normal,
                                  weight: FontWeight.bold)
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    child: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              hText('Km\'s Atuais', context,
                                  color: Colors.black),
                              SizedBox(height: 5),
                              hText('Km\'s: 0', context,
                                  color: corPrimaria,
                                  style: FontStyle.normal,
                                  weight: FontWeight.bold)
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      hText('Atividades', context,
                          color: Colors.grey[700], size: 100)
                    ],
                  )),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Racing()));
                      },
                      child: Container(
                        color: Colors.lightBlue[50],
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: getAltura(context) * .2,
                        width: getLargura(context) * .4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(MdiIcons.compass,
                                size: 55, color: Colors.lightBlue[700]),
                            hText('Iniciar Percurso', context)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EstatisticaPage(user: Helper.localUser)));
                    },
                      child: Container(
                        color: Colors.lightBlue[50],
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: getAltura(context) * .2,
                        width: getLargura(context) * .4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(MdiIcons.carConvertible,
                                size: 55, color: Colors.lightBlue[700]),
                            hText('Meus Percursos', context)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      color: Colors.lightBlue[50],
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: getAltura(context) * .2,
                      width: getLargura(context) * .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(MdiIcons.charity,
                              size: 55, color: Colors.lightBlue[700]),
                          hText('Anúncios', context)
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.lightBlue[50],
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: getAltura(context) * .2,
                      width: getLargura(context) * .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(MdiIcons.help,
                              size: 55, color: Colors.lightBlue[700]),
                          hText('Dúvidas', context)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        ChatListPage(),
        //Yellow(),
      ],
    );
  }
}
