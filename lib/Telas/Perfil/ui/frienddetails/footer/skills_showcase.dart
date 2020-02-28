import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/ShortStreamBuilder.dart';
import 'package:bocaboca/Objetos/Pacote.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Marketplace/Pacotes/PacoteItem.dart';
import 'package:bocaboca/Telas/Marketplace/Pacotes/PacotesListController.dart';
import 'package:bocaboca/Telas/Marketplace/Produto/ProdutoList/ProdutoItem.dart';
import 'package:bocaboca/Telas/Marketplace/Produto/ProdutoList/ProdutoListController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SkillsShowcase extends StatelessWidget {
  User user;
  Produto produto;


  SkillsShowcase({this.user, this.produto});
  ProdutoListController pc;
  PacoteListController pacoteListController;
  @override
  Widget build(BuildContext context) {
    if (pc == null) {
      pc = ProdutoListController();
    }
    if (pacoteListController == null) {
      pacoteListController = PacoteListController();
    }


    return  SingleChildScrollView(
      child: Container(
          
        height: getAltura(context),
        width: getLargura(context)*.2,
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

                          scrollDirection: Axis.vertical,
                          autoplay: true,
                          itemBuilder: (context, index) {
                            return PacoteItem(pacoteItems[index],
                                c: user);
                          },
                          itemCount: pacoteItems.length,
                        ),
                      );
                    },
                    stream: pacoteListController.outPacotes,
                    isList: true,
                    error: Container(),
                    emptylist: Container())),
            SingleChildScrollView(
              child: Container(

                height: MediaQuery.of(context).size.height*.4,

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
                      if(p.criador == user.id) {
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
