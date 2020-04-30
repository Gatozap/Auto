
import 'package:autooh/CampanhasParaUsuario/ListaCampanhasUsuario.dart';
import 'package:autooh/Helpers/Bairros.dart';
import 'package:autooh/Helpers/ListaEquipamentos.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Solicitacoes/SolicitacoesListPage.dart';
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
  Campanha campanha;
  HomePage({Key key,this.campanha }) : super(key: key);

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
    Helper.fbmsg.subscribeToTopic('user${Helper.localUser.id}');
    if(Helper.localUser.permissao == 10){
      Helper.fbmsg.subscribeToTopic('Administrador');
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
      appBar: myAppBar('Bem vindo, ${Helper.localUser.nome}', context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              sb,sb,sb,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(

                      margin: EdgeInsets.zero,
                      color: Colors.yellowAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            hText('Saldo Atual', context,
                                color: Colors.black),
                            SizedBox(height: 5),
                            Center(
                              child: hText('R\$: 0.00', context,
                                  color: corPrimaria,
                                  style: FontStyle.normal,
                                  weight: FontWeight.bold),
                            )
                          ],
                        ),
                      )),
                  Card(
                      margin: EdgeInsets.zero,
                      color: Colors.yellowAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment. center,
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
                ],
              ),sb,
              Divider(color: Colors.blue,),

              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      hText('Atividades', context,
                          color: Colors.blue, size: 100, weight: FontWeight.bold)
                    ],
                  )),
                ),
              ),
              Container(

                margin: EdgeInsets.all(10),

                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Racing()));
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
                                Container(width: 60, height: 60,child:  Image.asset('assets/iniciar_percurso.png', fit: BoxFit.fill),),
                            hText('Iniciar\nPercurso', context, color:  Colors.white, textaling: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EstatisticaPage(user: Helper.localUser)));
                    },
                      child:  Container(

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
                            Container(width: 60, height: 60,child:  Image.asset('assets/meus_percursos.png', fit: BoxFit.fill),),
                            hText('Meus\nPercursos', context, color:  Colors.white, textaling: TextAlign.center)
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
                    GestureDetector(
                      onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListaCampanhasUsuarioPage(user: Helper.localUser, campanha: widget.campanha,)));
                      },
                      child:  Container(

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
                            Container(width: 60, height: 60,child:  Image.asset('assets/Campanhas.png', fit: BoxFit.fill),),
                            hText('Campanhas', context, color:  Colors.white, textaling: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SolicitacoesListPage(user: Helper.localUser,isUser:true,)));
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
                            Container(width: 60, height: 60,child:  Image.asset('assets/duvidas_icone.png', fit: BoxFit.fill),),
                            hText('Solicitacoes', context, color:  Colors.white, textaling: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
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
