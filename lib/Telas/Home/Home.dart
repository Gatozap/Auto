import 'dart:io';

import 'package:autooh/Helpers/Bairros.dart';
import 'package:autooh/Helpers/ListaEquipamentos.dart';
import 'package:autooh/Helpers/NotificacoesHelper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Estatisticas/EstatisticasController.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Solicitacoes/SolicitacoesListPage.dart';
import 'package:autooh/Telas/CampanhasParaUsuario/ListaCampanhasUsuario.dart';
import 'package:autooh/Telas/Corrida/foreground.dart';
import 'package:autooh/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Grupo.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Home/GruposController.dart';
import 'package:autooh/Chat/ChatScreen/ChatPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

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

  Future getImageCamera(Carro carro, {bool isConfirmacao = false}) async {
    try {
      if (!isConfirmacao) {
        File image = await ImagePicker.pickImage(source: ImageSource.camera);

        carro.foto = await uploadPicture(
          image.path,
        );
        carrosRef.document(carro.id).updateData(carro.toJson());
        dToast('Salvando Foto!');
      } else {
        File image = await ImagePicker.pickImage(source: ImageSource.camera);

        carro.confirmacao = await uploadPicture(
          image.path,
        );
        carro.ultima_confirmacao = DateTime.now();
        carrosRef.document(carro.id).updateData(carro.toJson());
        dToast('Salvando Foto!');
      }
    } catch (err) {
      print('Error:${err.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((v) {
      /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntroPage()));*/
    });

    NotificacoesHelper().agendarNotificacao(
      Time(7, 0, 0),
    );
    NotificacoesHelper().agendarFimNotificacao(
      Time(22, 0, 0),
    );
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
    if (Helper.localUser.permissao == 5) {
      Helper.fbmsg.subscribeToTopic('Anunciante');
      if (Helper.localUser.campanhas != null) {
        for (String s in Helper.localUser.campanhas) {
          Helper.fbmsg.subscribeToTopic('Anunciante${s}');
        }
      }
    }
    carrosRef
        .where('dono', isEqualTo: Helper.localUser.id)
        .getDocuments()
        .then((v) {
      if (v.documents != null) {
        if (v.documents.length != 0) {
          Carro c = Carro.fromJson(v.documents[0].data);
          isAprovado(c);
        }
      }
    });
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
    return WillPopScope(
        onWillPop: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  shape: dialogShape,
                  title: new Text('Deseja Sair?'),
                  content:
                      Text('Tem Certeza? finalize sua corrida antes de sair'),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text(
                        'Cancelar',
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    MaterialButton(
                      child: Text(
                        'Sair',
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Scaffold(
          drawer: CustomDrawerWidget(),
          appBar: myAppBar('Bem-vindo, ${Helper.localUser.nome}', context),
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
                                hText('Saldo Atual', context,
                                    color: Colors.black),
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
                                            return hText('Saldo atual', context,
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
                                hText('Quilômetros atuais', context,
                                    color: Colors.black),
                                SizedBox(height: 5),
                                StreamBuilder(
                                    stream: ec.outCorridas,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return hText(
                                            'Quilômetros atuais\nsem corridas',
                                            context,
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Racing()));
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            height: getAltura(context) * .2,
                            width: getLargura(context) * .4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: Image.asset(
                                      'assets/iniciar_percurso.png',
                                      fit: BoxFit.fill),
                                ),
                                hText('Iniciar\nPercurso', context,
                                    color: Colors.white,
                                    textaling: TextAlign.center)
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: carrosRef
                                .where('dono', isEqualTo: Helper.localUser.id)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              Carro c;
                              if (snapshot.data != null) {
                                if (snapshot.data.documents != null) {
                                  if (snapshot.data.documents.length != 0) {
                                    c = Carro.fromJson(
                                        snapshot.data.documents[0].data);
                                  }
                                }
                              }
                              return GestureDetector(
                                onTap: () {
                                  getImageCamera(c, isConfirmacao: true);
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
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  height: getAltura(context) * .2,
                                  width: getLargura(context) * .4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                          width: 60,
                                          height: 60,
                                          child: c == null
                                              ? Icon(FontAwesomeIcons.camera,
                                                  color: Colors.yellowAccent,
                                                  size: 50)
                                              : c.confirmacao == null
                                                  ? Icon(
                                                      FontAwesomeIcons.camera,
                                                      color: Colors
                                                          .yellowAccent,
                                                      size: 50)
                                                  : c.ultima_confirmacao
                                                          .isBefore(DateTime
                                                                  .now()
                                                              .subtract(
                                                                  Duration(
                                                                      days: 7)))
                                                      ? Icon(
                                                          FontAwesomeIcons
                                                              .camera,
                                                          color: Colors
                                                              .yellowAccent,
                                                          size: 50)
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              c.confirmacao,
                                                        )),
                                      hText('Foto', context,
                                          color: Colors.white,
                                          textaling: TextAlign.center)
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            carrosRef
                                .where('dono', isEqualTo: Helper.localUser.id)
                                .getDocuments()
                                .then((v) {
                              if (v.documents != null) {
                                if (v.documents.length != 0) {
                                  Carro c = Carro.fromJson(v.documents[0].data);
                                  if (!isAprovado(c)) {
                                    if (!hasExpired(c)) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListaCampanhasUsuarioPage(
                                                    user: Helper.localUser,
                                                  )));
                                    } else {
                                      dToast(
                                          'Você ja possui uma campanha ativa!');
                                    }
                                  } else {
                                    dToast(
                                        'Você ja possui uma campanha ativa!');
                                  }
                                } else {
                                  print('Carro não encontrado');
                                }
                              } else {
                                print('Carro não encontrado');
                              }
                            });
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
                                hText('Solicitações', context,
                                    color: Colors.white,
                                    textaling: TextAlign.center)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  sb,
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(isFromHome:true)));
                      },
                      child: hText('Fale Conosco!', context,
                          size: 70,
                          color: Colors.blueAccent,
                          weight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ));
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

    dist = dist / 1000;
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
        //ChatListPage(),
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
        Campanha c =
            Campanha.fromJson((await campanhasRef.document(s).get()).data);
        campanhasList.add(c);
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
          if (c.kmMinima != 0) {
            valorTemp += ((dist / 1000) / c.kmMinima);
          }
        }
        if (valorTemp > 100) {
          valorTemp = c.precomes;
        } else {
          valorTemp = c.precomes * valorTemp;
        }
        if (valorTemp > c.precomes) {
          valorTemp = c.precomes;
        }
        valor += valorTemp;
      }
      return Center(
        child: hText('R\$: ${valor.toStringAsFixed(2)}', context,
            color: corPrimaria,
            style: FontStyle.normal,
            weight: FontWeight.bold),
      );
    } else {
      return Container();
    }
  }

  bool isAprovado(Carro c) {
    if (c.anuncio_traseira_completa == null &&
        c.anuncio_laterais == null &&
        c.anuncio_bancos == null &&
        c.anuncio_vidro_traseiro == null) {
      return false;
    } else {
      bool result = false;
      if (c.anuncio_traseira_completa != null) {
        if (c.anuncio_traseira_completa.datafim.isBefore(DateTime.now())) {
          print(
              'DATAS ${c.anuncio_traseira_completa.datafim} ${DateTime.now()}');
          c.anuncio_traseira_completa = null;
          result = true;
        }
      }

      if (c.anuncio_laterais != null) {
        if (c.anuncio_laterais.datafim.isBefore(DateTime.now())) {
          print('DATAS ${c.anuncio_laterais.datafim} ${DateTime.now()}');
          c.anuncio_laterais = null;
        }
      }

      if (c.anuncio_bancos != null) {
        if (c.anuncio_bancos.datafim.isBefore(DateTime.now())) {
          c.anuncio_bancos = null;
        }
      }
      if (c.anuncio_vidro_traseiro != null) {
        if (c.anuncio_vidro_traseiro.datafim.isBefore(DateTime.now())) {
          c.anuncio_vidro_traseiro = null;
        }
      }
      if (c.anuncio_traseira_completa == null &&
          c.anuncio_laterais == null &&
          c.anuncio_bancos == null &&
          c.anuncio_vidro_traseiro == null) {
        carrosRef.document(c.id).updateData(c.toJson());
      }
      return c.anuncio_traseira_completa == null &&
          c.anuncio_laterais == null &&
          c.anuncio_bancos == null &&
          c.anuncio_vidro_traseiro == null;
    }
  }
}
