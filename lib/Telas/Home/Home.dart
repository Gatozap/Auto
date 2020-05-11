import 'package:autooh/CampanhasParaUsuario/ListaCampanhasUsuario.dart';
import 'package:autooh/Helpers/Bairros.dart';
import 'package:autooh/Helpers/ListaEquipamentos.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Estatisticas/EstatisticasController.dart';
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
import 'package:googleapis/classroom/v1.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  EstatisticaController ec;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((v) {
      /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntroPage()));*/
    });
    if (gc == null) {
      gc = new GruposController();
    }
    if (ec == null) {
      ec = EstatisticaController(null, null, Helper.localUser,
          DateTime.now().subtract(Duration(days: 30)), DateTime.now());
    }
    Helper.fbmsg.subscribeToTopic('user${Helper.localUser.id}');
    if (Helper.localUser.permissao == 10) {
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
              sb,
              sb,
              sb,
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
                            hText('Saldo Atual', context, color: Colors.black),
                            SizedBox(height: 5),
                            StreamBuilder(
                                stream: ec.outCorridas,
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return hText('R\$0.00', context,
                                        color: corPrimaria,
                                        style: FontStyle.normal,
                                        weight: FontWeight.bold);
                                  }
                                  return FutureBuilder(
                                    builder: (context, snap) {
                                      if (snap.data == null) {
                                        return hText('R\$0.00', context,
                                            color: corPrimaria,
                                            style: FontStyle.normal,
                                            weight: FontWeight.bold);
                                      }
                                      return snap.data;
                                    },
                                    future: ganhosWidget(snapshot.data),
                                  );
                                }),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            hText('Km\'s Atuais', context, color: Colors.black),
                            SizedBox(height: 5),
                            StreamBuilder(
                                stream: ec.outCorridas,
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return hText('Km\'s: 0.0', context,
                                        color: corPrimaria,
                                        style: FontStyle.normal,
                                        weight: FontWeight.bold);
                                  }
                                  return estatisticasWidget(snapshot.data);
                                }),
                          ],
                        ),
                      )),
                ],
              ),
              sb,
              Divider(
                color: Colors.blue,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      hText('Atividades', context,
                          color: Colors.blue,
                          size: 100,
                          weight: FontWeight.bold)
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Racing()));
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: getAltura(context) * .2,
                        width: getLargura(context) * .4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/iniciar_percurso.png',
                                  fit: BoxFit.fill),
                            ),
                            hText('Iniciar\nPercurso', context,
                                color: Colors.white,
                                textaling: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EstatisticaPage(user: Helper.localUser)));
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: getAltura(context) * .2,
                        width: getLargura(context) * .4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/meus_percursos.png',
                                  fit: BoxFit.fill),
                            ),
                            hText('Meus\nPercursos', context,
                                color: Colors.white,
                                textaling: TextAlign.center)
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
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListaCampanhasUsuarioPage(
                                  user: Helper.localUser,
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            hText('Campanhas', context,
                                color: Colors.white,
                                textaling: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SolicitacoesListPage(
                                  user: Helper.localUser,
                                  isUser: true,
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: getAltura(context) * .2,
                        width: getLargura(context) * .4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              child: Icon(MdiIcons.redhat,
                                  color: Colors.yellowAccent, size: 40),
                            ),
                            hText('Solicitacoes', context,
                                color: Colors.white,
                                textaling: TextAlign.center)
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

  Widget estatisticasWidget(corridas) {
    if (corridas.length == 0) {
      return Center(child: Container(child: hText('Sem Corridas', context)));
    }
    double visualizacoes = 0;
    double visualizacoesTempo = 0;
    double visualizacoesKm = 0;
    double dist = 0;
    List<Carro> carroIds = new List();
    String id_corrida = '';
    int countCorridas = 0;
    Map<String, List<Localizacao>> zonas = Map();
    countCorridas = corridas.length;
    var tempoNaRua = 0.0;
    for (Corrida c in corridas) {
      visualizacoes += c.vizualizacoes == null ? 0 : c.vizualizacoes;
      visualizacoesTempo +=
          c.vizualizacoes_por_tempo == null ? 0 : c.vizualizacoes_por_tempo;
      visualizacoesKm += c.vizualizacoes_por_distancia == null
          ? 0
          : c.vizualizacoes_por_distancia;
      dist += c.dist == null ? 0 : c.dist;
      tempoNaRua += c.duracao;
      bool containsCarro = false;
      for (Carro s in carroIds) {
        if (s.placa == c.carro.placa) {
          containsCarro = true;
        }
      }
      for (Localizacao p in c.points) {
        if (zonas[p.zona] == null) {
          zonas[p.zona] = new List();
        }
        zonas[p.zona].add(p);
      }
      if (!containsCarro) {
        carroIds.add(c.carro);
      }
    }
    int carros = carroIds.length;
    corridas.sort((Corrida a, Corrida b) {
      return a.hora_ini.compareTo(b.hora_ini);
    });

    dist = dist/1000;
    return hText('Km\'s: ${dist.toStringAsFixed(2)}', context,
        color: corPrimaria, style: FontStyle.normal, weight: FontWeight.bold);
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

  List<Campanha> campanhasList;
  Future<Widget> ganhosWidget(corridas) async {
    if (corridas.length == 0) {
      return Center(child: Container(child: hText('Sem Corridas', context)));
    }
    Map<String, List<Localizacao>> zonas = Map();
    double valor = 0;
    List<String> campanhas = new List();
    for (Corrida c in corridas) {
      bool contains = false;
      for (String s in campanhas) {
        if (s == c.campanha) {
          contains = true;
        }
      }
      if (!contains && c.campanha != null) {
        campanhas.add(c.campanha);
      }
    }
    if (campanhasList == null) {
      List<Campanha> campanhasList = new List();
      for (String s in campanhas) {
        print('BUSCANDO CAMPANHA LALAL');
        Campanha c = Campanha.fromJson((await campanhasRef.document(s).get()).data);
        campanhasList.add(c);
        print('AQUI CAMPANHAS ${campanhasList.length}');
      }
      for (Campanha c in campanhasList) {
        double dist = 0;
        double valorTemp = 0;
        for (Corrida cor in corridas) {
          if (c.id == cor.campanha) {
            dist += cor.dist == null ? 0 : cor.dist;
          }
        }
        if (c.precomes != null && c.kmMinima != null) {
          if(c.kmMinima != 0) {
            valorTemp += ((dist/1000) /c.kmMinima);
            print('AQUI LOL $valorTemp e ${dist/1000} e ${c.kmMinima} ');
          }
        }
        print('Porcentagem ${valorTemp}');
        if (valorTemp > 100) {
          valorTemp = c.precomes;
        } else {
          valorTemp = c.precomes*valorTemp;
        }
        if(valorTemp > c.precomes){
          valorTemp = c.precomes;
        }
        valor += valorTemp;
      }

      print('AQUI CAMPANHAS ${campanhasList} ${campanhasList.length}');
      print("AQUI LOLOLOLO ${valor}");

      return Center(
        child: hText('R\$: ${valor.toStringAsFixed(2)}', context,
            color: corPrimaria, style: FontStyle.normal, weight: FontWeight.bold),
      );
    }
    else{
      return Container();
    }

  }
}
