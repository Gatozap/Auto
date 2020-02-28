import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/ShortStreamBuilder.dart';
import 'package:bocaboca/Helpers/Steper.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/ProdutoPedido.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Marketplace/PagamentoPage/PagamentoPage.dart';
import 'package:bocaboca/Telas/Marketplace/Produto/ProdutoGeneralController.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

import 'ProdutoPedidoItem.dart';

class CarrinhoDetails extends StatefulWidget {
  User u;

  CarrinhoDetails({this.u});

  @override
  _CarrinhoDetailsState createState() {
    return _CarrinhoDetailsState();
  }
}

class _CarrinhoDetailsState extends State<CarrinhoDetails> {
  List<ProdutoPedido> PPL;
  BehaviorSubject<List<ProdutoPedido>> pplController =
      BehaviorSubject<List<ProdutoPedido>>();

  Stream<List<ProdutoPedido>> get outPPL => pplController.stream;

  Sink<List<ProdutoPedido>> get inPPL => pplController.sink;

  @override
  Widget build(BuildContext context) {
    User u = widget.u == null ? Helper.localUser : widget.u;
    // TODO: implement build
    return Scaffold(
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * .07,
          width: MediaQuery.of(context).size.width,
          color: corPrimaria,
          child: SSB(
              stream: outPPL,
              isList: true,
              buildfunction: (context, snap) {
                double total = 0;
                for (ProdutoPedido pp in snap.data) {
                  total = total + pp.preco_final;
                }
                return StepperTouch(
                  onChanged: (v) {
                    //dToast('Qual o lanchinho você vai levar hoje?');
                    userRef
                        .where('nome', isEqualTo: Helper.localUser.nome)
                        .where('email', isEqualTo: Helper.localUser.email)
                        .getDocuments()
                        .then((v) {
                      User u = User.fromJson(v.documents[0]);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PagamentoPage(
                                snap.data,
                                u,
                              )));
                    });
                  },
                  iconCenter: Shimmer.fromColors(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      baseColor: Colors.white,
                      highlightColor: myOrange),
                  height: MediaQuery.of(context).size.height * .07,
                  text: Shimmer.fromColors(
                      child: Text(
                        'Efetuar Compra',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                      baseColor: Colors.white,
                      highlightColor: myOrange),
                  fontSize: 30,
                  iconRight: Shimmer.fromColors(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      baseColor: Colors.white,
                      highlightColor: myOrange),
                  width: MediaQuery.of(context).size.width,
                  initialValue: total,
                );
                /*Container(
                    child: Center(
                        child: Swiper(
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .07,
                                      width: MediaQuery.of(context).size.width,
                                      color: myGreen,
                                      child: Shimmer.fromColors(
                                          baseColor: Colors.white,
                                          highlightColor: myOrange,
                                          child: Center(
                                              child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  'Efetuar Compra',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 32),
                                                ),
                                              ),
                                              Icon(
                                                Icons.navigate_next,
                                                color: Colors.white,
                                              ),
                                              Icon(
                                                Icons.navigate_next,
                                                color: Colors.white,
                                              ),
                                              Icon(
                                                Icons.navigate_next,
                                                color: Colors.white,
                                              ),
                                              Icon(
                                                Icons.navigate_next,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ))));
                                case 1:
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        .07,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(' '),
                                    color: Colors.white,
                                  );
                              }
                            })));*/
              },
              error: Container(child: Text('Carrinho vazio')),
              emptylist: Container(child: Text('Carrinho vazio'))),
        ),
        appBar: myAppBar('Carrinho', context, showBack: true, actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        title: hText('Limpar Carrinho?', context,
                            color: corPrimaria),
                        actions: <Widget>[
                          defaultActionButton('Não', context, () {
                            Navigator.of(context).pop();
                          }, icon: null),
                          defaultActionButton('Sim', context, () {
                            LimparCarrinho(user: Helper.localUser.id);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }, icon: null),
                        ],
                      );
                    });
              })
        ]),
        body: Column(children: <Widget>[
          new Flexible(
              child: FirebaseAnimatedList(
                  query: GetCarrinho(user: u.id),
                  sort: (DataSnapshot a, DataSnapshot b) =>
                      b.key.compareTo(a.key),
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int i) {
                    if (snapshot.value == null) {
                      return Container();
                    }
                    ProdutoPedido pp =
                        new ProdutoPedido.fromJson(snapshot.value);
                    if (i == 0) {
                      PPL = new List();
                    }
                    PPL.add(pp);
                    inPPL.add(PPL);

                    return ProdutoPedidoItem(pp: pp);
                  }))
        ]));
  }
}
