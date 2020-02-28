import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:autooh/Helpers/CircleIconButton.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/PhotoScroller.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Objetos/ProdutoPedido.dart';
import 'package:autooh/Telas/Marketplace/Produto/ProdutoGeneralController.dart';

import '../../main.dart';
import 'addProdutoController.dart';

class AddProduto {
  var controller = new MaskedTextController(mask: '000', text: '1');
  AddProdutoController apc = new AddProdutoController();
  TextEditingController controllerQuantidade;

  void showDlgConfirmacao({
    Produto produto,
    context,
    String id,
    int startingQuantidade = 0,
  }) {
    controllerQuantidade =
        TextEditingController(text: startingQuantidade.toString());
    apc.inQuantidade.add(startingQuantidade);

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            content: StreamBuilder(
                stream: apc.outQuantidade,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  print('CHEGOU AQUI LOLOLO' + snapshot.data.toString());
                  if (snapshot.data != null) {
                    return SingleChildScrollView(
                      child: new Container(
                          width: MediaQuery.of(context).size.width,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(produto.titulo,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        )),
                                    produto.unidade == "KG"
                                        ? new Text(
                                            "R\$" +
                                                (produto.preco
                                                        .toStringAsFixed(2) +
                                                    " / Kg"),
                                            style: TextStyle(fontSize: 14),
                                          )
                                        : new Text(
                                            "R\$" +
                                                produto.preco
                                                    .toStringAsFixed(2) +
                                                " / Unidade",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              sb,
                              Center(
                                child: produto.fotos != null
                                    ? produto.fotos.length != 1
                                        ? PhotoScroller(
                                            produto.fotos,
                                            hide: true,
                                            altura: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .12,
                                            fractionsize: 1,
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            child: CachedNetworkImage(
                                              imageUrl: produto.fotos[0],
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .12,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                    : Container(),
                              ),
                              sb,
                              Container(
                                width: MediaQuery.of(context).size.width * .4,
                                child: TextField(
                                  readOnly: false,
                                  autofocus: false,
                                  controller: controllerQuantidade,
                                  onChanged: (s) {
                                    if (snapshot.data - 1 < 0) {
                                      apc.inQuantidade.add(0);
                                    } else {
                                      apc.inQuantidade.add(
                                          int.parse(controllerQuantidade.text));
                                    }
                                  },
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  decoration: InputDecoration(
                                      hintText: "1",
                                      labelText: 'Quantidade',
                                      suffixIcon: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          CircleIconButton(
                                            size: 20,
                                            icon: Icons.add,
                                            onPressed: () {
                                              int v = (int.parse(
                                                      controllerQuantidade
                                                          .text) +
                                                  1);
                                              controllerQuantidade.text =
                                                  v.toString();
                                              apc.inQuantidade.add(v);
                                            },
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          CircleIconButton(
                                            icon: Icons.remove,
                                            onPressed: () {
                                              if (int.parse(controllerQuantidade
                                                          .text) -
                                                      1 <
                                                  0) {
                                                int v = 0;
                                                controllerQuantidade.text = '0';
                                                apc.inQuantidade.add(v);
                                              } else {
                                                int v = (int.parse(
                                                        controllerQuantidade
                                                            .text) -
                                                    1);
                                                controllerQuantidade.text =
                                                    v.toString();
                                                apc.inQuantidade.add(v);
                                              }
                                            },
                                            size: 20,
                                          ),
                                        ],
                                      )),
                                ),
                              ),

                              /*new Container(
                                child: produto.unidade == 'KG'
                                    ? new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new ActionChip(
                                              label: new Text(
                                                '-1kg',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: myOrange,
                                              onPressed: () {
                                                if (snapshot.data - 1000 < 0) {
                                                  apc.inQuantidade.add(0);
                                                } else {
                                                  apc.inQuantidade.add(
                                                      snapshot.data - 1000);
                                                }
                                              }),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2)),
                                          new ActionChip(
                                              label: new Text(
                                                '-100g',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: myOrange,
                                              onPressed: () {
                                                if (snapshot.data - 100 < 0) {
                                                  apc.inQuantidade.add(0);
                                                } else {
                                                  apc.inQuantidade
                                                      .add(snapshot.data - 100);
                                                }
                                              }),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5)),
                                          new ActionChip(
                                              label: new Text(
                                                '+100g',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: myGreen,
                                              onPressed: () {
                                                apc.inQuantidade
                                                    .add(snapshot.data + 100);
                                              }),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2)),
                                          new ActionChip(
                                              label: new Text(
                                                '+1kg',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: myGreen,
                                              onPressed: () {
                                                apc.inQuantidade
                                                    .add(snapshot.data + 1000);
                                              }),
                                        ],
                                      )
                                    : new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new ActionChip(
                                              label: new Text(
                                                '-10',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Cour',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              backgroundColor: myOrange,
                                              onPressed: () {
                                                if (snapshot.data - 10 < 0) {
                                                  apc.inQuantidade.add(0);
                                                } else {
                                                  apc.inQuantidade
                                                      .add(snapshot.data - 10);
                                                }
                                              }),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2)),
                                          new ActionChip(
                                              label: new Text(
                                                '-1',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: myOrange,
                                              onPressed: () {
                                                if (snapshot.data - 1 < 0) {
                                                  apc.inQuantidade.add(0);
                                                } else {
                                                  apc.inQuantidade
                                                      .add(snapshot.data - 1);
                                                }
                                              }),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5)),
                                          new ActionChip(
                                              label: new Text(
                                                '+1',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: myGreen,
                                              onPressed: () {
                                                apc.inQuantidade
                                                    .add(snapshot.data + 1);
                                              }),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2)),
                                          new ActionChip(
                                              label: new Text(
                                                '+10',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: myGreen,
                                              onPressed: () {
                                                apc.inQuantidade
                                                    .add(snapshot.data + 10);
                                              }),
                                        ],
                                      ),
                              ),*/
                              /*Text(
                                produto.unidade == 'KG'
                                    ? apc.quantidade > 999
                                        ? (snapshot.data / 1000).toString() +
                                            'KGs'
                                        : snapshot.data.toString() + ' Gramas'
                                    : snapshot.data == 1
                                        ? snapshot.data.toString() + ' Unidade'
                                        : snapshot.data.toString() +
                                            ' Unidades',
                                style: TextStyle(
                                  fontFamily: 'Cour',
                                ),
                              ),*/
                              new Text(
                                  "Total: R\$" +
                                      (int.parse(controllerQuantidade.text) *
                                              produto.preco)
                                          .toStringAsFixed(2),
                                  style: TextStyle(fontSize: 14.0)),
                            ],
                          )),
                    );
                  } else {
                    apc.Fetch(produto.unidade == 'KG');
                    return new Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.4,
                    );
                  }
                }),
            actions: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Container(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MaterialButton(
                              color: myOrange,
                              child: new Text(
                                "Cancelar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(width: 10),
                            MaterialButton(
                                color: corPrimaria,
                                child: new Text(
                                  "Adicionar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: () {
                                  if (int.parse(controllerQuantidade.text) >
                                      0) {
                                    AdicionarProdutoAoCarrinho(
                                            produto: new ProdutoPedido(
                                              produto: produto.id,
                                              isHerbaLife: produto.isHerbaLife,
                                              estado: produto.estado,
                                              prestador: Helper.localUser.prestador,
                                              user: id,
                                              quantidade: int.parse(
                                                  controllerQuantidade.text),
                                              preco_unitario: produto.preco,
                                            ),
                                            user: id)
                                        .then(
                                      (r) {
                                        if (Helper.localUser.id != id) {
                                          sendNotificationAdicionarAoCarrinhoUsuario(
                                              '${Helper.localUser.nome} Adicionou um produto ao seu carrinho',
                                              '${produto.titulo}',
                                              null,
                                              id,
                                              id);
                                        }
                                        if (!Helper.localUser.isPrestador) {
                                          sendNotificationAdicionarAoCarrinhoUsuario(
                                              '${Helper.localUser.nome} Adicionou um produto ao carrinho',
                                              '${produto.titulo}',
                                              null,
                                              Helper.localUser.prestador,
                                              id);
                                        }

                                        if (r == 'ok ') {
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    );
                                  } else {
                                    print('Quantidade Invalida');
                                  }
                                })
                          ]))),
              // usually buttons at the bottom of the dialog
            ]);
      },
    );
  }
}
