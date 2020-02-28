import 'package:autooh/Objetos/Comentario.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:autooh/Helpers/BadgerController.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Pacote.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Dialogs/addEndereco.dart';
import 'package:autooh/Telas/Dialogs/addEnderecoController.dart';
import 'package:autooh/Telas/Marketplace/Carrinho/CarrinhoDetails/CarrinhoDetails.dart';
import 'package:autooh/Telas/Marketplace/Pacotes/CadastrarPacotePage.dart';
import 'package:autooh/Telas/Marketplace/Pacotes/PacoteItem.dart';
import 'package:autooh/Telas/Marketplace/Pacotes/PacotesListController.dart';
import 'package:autooh/Telas/Marketplace/Produto/CadastrarProduto/CadastrarProdutoPage.dart';
import 'package:autooh/Telas/Marketplace/Produto/ProdutoList/ProdutoListController.dart';
import 'package:autooh/Telas/Marketplace/Produto/ProdutoList/ProdutoListItem.dart';
import 'package:short_stream_builder/short_stream_builder.dart';

import '../../../../main.dart';
import '../ProdutoGeneralController.dart';
import 'ProdutoItem.dart';


class ProdutoListPage extends StatefulWidget {
  User c;

  ProdutoListPage({this.c});

  @override
  _ProdutoListPageState createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends State<ProdutoListPage> {
  ProdutoListController pc;
  PacoteListController pacoteListController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  CarrinhoCountController ccc;
  @override
  Widget build(BuildContext context) {
    bc.removeBadges(
      2,
      );
    if (pc == null) {
      pc = ProdutoListController();
    }
    if (pacoteListController == null) {
      pacoteListController = PacoteListController();
    }
    if (ccc == null) {
      //TODO ADICIONAR CHECAGEM PARA REMOVER O CONTADOR DO prestador
      ccc = CarrinhoCountController(widget.c == null
                                    ? Helper.localUser.id
                                    : widget.c == null ? widget.c.id : widget.c.id);
    }

    return Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawerWidget(user: Helper.localUser),
        appBar:
        myAppBar('Serviços', context, showBack: widget.c != null, actions: [
          Helper.localUser.isPrestador
          ? IconButton(
            icon: Icon(LineAwesomeIcons.cart_plus, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastrarProdutoPage()));
            },
            )
          : Container(),
        ]),
        floatingActionButton: widget.c == null
                              ? Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Material(
                  shape: CircleBorder(),
                  color: Colors.white,
                  elevation: 5,
                  child: IconButton(
                    tooltip: 'Carrinho',
                    icon: Stack(
                      children: <Widget>[
                        new Icon(
                          LineAwesomeIcons.cart_arrow_down,
                          color: corPrimaria,
                          ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: SSB(
                                stream: ccc.outCount,
                                error: Container(),
                                isList: false,
                                buildfunction: (context, snap) {
                                  return Badge(snap.data);
                                })),
                      ],
                      ),
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarrinhoDetails()));
                    },
                    )))
        ])
                              : Container(),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                sb,
                sb,
                Container(
                    child: SSB(
                        buildfunction: (context, snap) {
                          List<Pacote> pacoteItems = new List();
                          for (Pacote p in snap.data) {
                            pacoteItems.add(p);
                          }
                          return Container(
                            height: MediaQuery.of(context).size.height * .33,
                            width: MediaQuery.of(context).size.width,
                            child: Swiper(
                              scrollDirection: Axis.horizontal,
                              autoplay: true,
                              itemBuilder: (context, index) {
                                return PacoteItem(pacoteItems[index],
                                                      c: widget.c);
                              },
                              itemCount: pacoteItems.length,
                              ),
                            );
                        },
                        stream: pacoteListController.outPacotes,
                        isList: true,
                        error: Container(),
                        emptylist: Container())),
                Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: StreamBuilder(
                    builder: (context, snap) {
                      if (snap.data == null) {
                        return FutureBuilder(
                            future:
                            Future.delayed(Duration(seconds: 5)).then((v) {
                              return 1;
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.data == 1) {
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: Center(
                                            child: Row(
                                              children: <Widget>[
                                                sb,
                                                sb,
                                                Text('Sem Produtos no momento')
                                              ],
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              ),
                                            )),
                                    ],
                                    ),
                                  );
                              } else {
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: Center(
                                            child: Row(
                                              children: <Widget>[
                                                CircularProgressIndicator(),
                                                sb,
                                                sb,
                                                Text('Carregando Produtos')
                                              ],
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              ),
                                            )),
                                    ],
                                    ),
                                  );
                              }
                            });
                      }
                      List<Produto> produtosItems = new List();
                      for (Produto p in snap.data) {
                        if(p.deleted_at == null) {
                          produtosItems.add(p);
                        }
                      }

                      if (snap.data == null) {
                        return Container();
                      }


                      return

                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: produtosItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            print('Produto ${produtosItems[index]}');
                            return ProdutoItem(
                              produto: produtosItems[index],);
                          });
                    },

                    stream: pc.outProdutos,
                    ),
                  )
              ],
              ),
            ),
          ));
  }
/*
  Widget _buildItemsList() {
    return SSB(
        buildfunction: (context, snap) {
          List<Widget> produtosItems = new List();
          for (Produto p in snap.data) {
            produtosItems.add(sb);
            produtosItems.add(Container(
                width: MediaQuery.of(context).size.width,
                child: ProdutoListItem(
                  produto: p,
                )));
          }
          Widget bufferZone = Container(
            height: Helper.localUser.isPrestador
                ? MediaQuery.of(context).size.height * .34
                : MediaQuery.of(context).size.height * .2,
          );
          produtosItems.add(bufferZone);
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: produtosItems,
            ),
          );
        },
        error: LoadingScreen('Carregando'),
        stream: pc.outProdutos,
        isList: true,
        emptylist: Container(
          child: Center(
            child: Text('Não há produtos no momento!'),
          ),
        ));
  }*/
}
