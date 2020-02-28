import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bocaboca/Helpers/CircleIconButton.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/PhotoScroller.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Prestador.dart';
import 'package:bocaboca/Objetos/Estoque.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Telas/Marketplace/Produto/ProdutoList/ProdutoListController.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:short_stream_builder/short_stream_builder.dart';

import '../../../main.dart';
import 'addEstoqueController.dart';

class EstoquePage extends StatefulWidget {
  @override
  _EstoquePageState createState() {
    return _EstoquePageState();
  }
}

class _EstoquePageState extends State<EstoquePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar(
        'Estoque',
        context,
        showBack: true,
      ),
      body: SSB(
          stream: prestadorRef.document(Helper.localUser.prestador).snapshots(),
          buildfunction: (context, snap) {
            DocumentSnapshot sp = snap.data;
            if (sp == null) {
              return Container();
            }
            Prestador c = Prestador.fromJson(sp.data);
            if (c.isEstoque) {
              return ControlleDeEstoqueWidget(c);
            } else {
              return AtivarControlleWidget(c);
            }
          },
          isList: false,
          error: Container()),
    );
  }

  Widget ControlleDeEstoqueWidget(Prestador c) {
    TextStyle defaultTS = TextStyle(fontStyle: FontStyle.normal, fontSize: 12);
    return SSB(
        stream: estoquesRef
            .where('prestador', isEqualTo: Helper.localUser.prestador)
            .snapshots(),
        buildfunction: (context, snap) {
          QuerySnapshot qs = snap.data;

          if (qs == null) {
            return Container();
          } else {
            List<Estoque> estoque = new List();
            for (DocumentSnapshot ds in qs.documents) {
              estoque.add(Estoque.fromJson(ds.data));
            }
            estoque.sort((Estoque a, Estoque b) {
              return (a.disponivel - a.minimo)
                  .compareTo((b.disponivel - b.minimo));
            });

            return Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            sb,
                            Text.rich(
                              TextSpan(
                                  text: 'Controle de Estoque Ativado\n\n',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontStyle: FontStyle.italic),
                                  children: [
                                    TextSpan(
                                        text:
                                            'Produtos só aparecerão se estiverem com estoque positivo\n',
                                        style: defaultTS),
                                    TextSpan(
                                        text:
                                            'Clique no produto para edita-lo.\n',
                                        style: defaultTS),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: EstoqueItem(estoque[index], c)),
                          ]);
                    } else {
                      return EstoqueItem(estoque[index], c);
                    }
                  },
                  itemCount: estoque.length,
                ));
          }
        });
  }

  Widget AtivarControlleWidget(Prestador c) {
    TextStyle defaultTS = TextStyle(fontStyle: FontStyle.normal, fontSize: 12);
    ProdutoListController plc = new ProdutoListController();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          sb,
          Text.rich(
            TextSpan(
                text: 'Controle de Estoque desativado\n\n',
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                children: [
                  TextSpan(
                      text: 'Clique no botão abaixo para ativar\n',
                      style: defaultTS),
                  TextSpan(
                      text: 'Uma vez ativado não poderá ser desativado.\n',
                      style: defaultTS),
                ]),
            textAlign: TextAlign.center,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .8,
            decoration: BoxDecoration(
                color: corPrimaria, borderRadius: BorderRadius.circular(60)),
            child: MaterialButton(
                onPressed: () {
                  ProgressDialog pr = new ProgressDialog(context,
                      type: ProgressDialogType.Download,
                      isDismissible: false,
                      showLogs: true);
                  c.isEstoque = true;
                  pr.show();
                  prestadorRef
                      .document(Helper.localUser.prestador)
                      .setData(c.toJson())
                      .then((v) {
                    dToast('Ativando Controle de Estoque');
                    plc.outProdutos.first.then((List<Produto> v) {
                      pr.style(
                          message: 'Criando Estoque',
                          borderRadius: 10.0,
                          backgroundColor: Colors.white,
                          progressWidget: CircularProgressIndicator(),
                          elevation: 10.0,
                          insetAnimCurve: Curves.easeInOut,
                          progress: 0.0,
                          maxProgress: v.length.toDouble(),
                          progressTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400),
                          messageTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600));

                      for (int i = 0; i < v.length; i++) {
                        pr.update(
                          progress: i.toDouble(),
                          message: "Criando Estoque de : ${v[i].titulo}",
                          progressWidget: Container(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator()),
                          maxProgress: 100.0,
                          progressTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400),
                          messageTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600),
                        );
                        Estoque e = Estoque(
                            prestador: Helper.localUser.prestador,
                            produto: v[i].id,
                            disponivel: 100,
                            updated_at: DateTime.now(),
                            created_at: DateTime.now(),
                            deleted_at: null,
                            isHerbaLife: v[i].isHerbaLife,
                            last_purchased_at: null,
                            minimo: 0);
                        estoquesRef.add(e.toJson()).then((doc) {
                          e.id = doc.documentID;
                          pr.update(
                            progress: i.toDouble(),
                            message: "Criado : ${v[i].titulo}",
                            progressWidget: Container(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator()),
                            maxProgress: 100.0,
                            progressTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400),
                            messageTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w600),
                          );
                          estoquesRef
                              .document(e.id)
                              .updateData(e.toJson())
                              .then((updated) {
                            pr.update(
                              progress: i.toDouble(),
                              message: "Atualizado : ${v[i].titulo}",
                              progressWidget: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator()),
                              maxProgress: 100.0,
                              progressTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400),
                              messageTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w600),
                            );
                          });
                        });
                      }
                    });
                    pr.dismiss();
                    dToast('Estoque Criado Com Sucesso!');
                  });
                },
                child: Text('Ativar Controle de Estoque',
                    style: estiloTextoBotao)),
          ),
        ],
      ),
    );
  }

  Widget EstoqueItem(Estoque estoque, Prestador c) {
    Stream s = produtosRef.document(estoque.produto).snapshots();
    if (s != null) {
      return SSB(
        error: SpinKitFadingCircle(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        ),
        buildfunction: (context, snap) {
          DocumentSnapshot ds = snap.data;
          if (ds.data == null) {
            return SpinKitFadingCircle(
              itemBuilder: (_, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.red : Colors.green,
                  ),
                );
              },
            );
          }
          Produto p = Produto.fromJson(ds.data);
          print('AQUI PRODUTO ${p.toString()}');
          return ProdutoWidget(p, context, estoque);
        },
        stream: s,
      );
    } else {
      return Container(child: Text('Stream Nula'));
    }
  }


  ProdutoWidget(Produto p, context, Estoque e) {
    double midleWidth = MediaQuery.of(context).size.width * .5;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: p.fotos != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: CachedNetworkImage(
                        imageUrl: p.fotos[0],
                        width: MediaQuery.of(context).size.width * .2,
                        height: MediaQuery.of(context).size.height * .15,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ),
            p.fotos != null ? sb : Container(),
            GestureDetector(
              onTap: () {},
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: midleWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            p.titulo,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: midleWidth,
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: new Text(p.descricao,
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    )))
                          ])),
                  Container(
                      width: midleWidth,
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Text.rich(
                              TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: '${e.disponivel}',
                                    style: TextStyle(
                                        color: e.minimo < e.disponivel
                                            ? corPrimaria
                                            : myOrange,
                                        fontWeight: FontWeight.bold)),
                              ], text: 'Disponivel: '),
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey[700]),
                              softWrap: true,
                              textAlign: TextAlign.start,
                            ))
                          ])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                  Container(
                      width: midleWidth,
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Text.rich(
                              TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: (e.minimo).toString(),
                                    style: TextStyle(
                                        fontFamily: 'Cour',
                                        color: e.minimo < e.disponivel
                                            ? corPrimaria
                                            : myOrange,
                                        fontWeight: FontWeight.bold)),
                              ], text: 'Minimo: '),
                              style: TextStyle(
                                  fontFamily: 'Cour',
                                  fontSize: 14.0,
                                  color: Colors.grey[700]),
                              softWrap: true,
                              textAlign: TextAlign.start,
                            ))
                          ])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                  Container(
                      width: midleWidth,
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Text.rich(
                              TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: (e.last_purchased_at != null
                                            ? Helper().readTimestamp(
                                                e.last_purchased_at)
                                            : ''),
                                        style: TextStyle(
                                            fontFamily: 'Cour',
                                            color: corPrimaria,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                  text: e.last_purchased_at != null
                                      ? 'Comprado a ultima vez '
                                      : 'Nenhuma venda Registrada des do inicio do controle de Estoque'),
                              style: TextStyle(
                                  fontFamily: 'Cour',
                                  fontSize: 14.0,
                                  color: Colors.grey[700]),
                              softWrap: true,
                              textAlign: TextAlign.start,
                            ))
                          ])),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                new IconButton(
                    color: corPrimaria,
                    icon: Container(
                      height: 25,
                      width: 25,
                      decoration: new BoxDecoration(
                        color: corPrimaria,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      showDlgConfirmacao(
                          produto: p,
                          context: context,
                          id: e.id,
                          e: e,
                          startingDisponivel: e.disponivel,
                          startingMinimo: e.minimo);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void showDlgConfirmacao({
  Produto produto,
  context,
  String id,
  int startingMinimo = 0,
  @required Estoque e,
  int startingDisponivel = 0,
}) {
  AddEstoqueController apc;

  if (apc == null) {
    apc = AddEstoqueController();
  }
  TextEditingController controllerMinimo =
      TextEditingController(text: startingMinimo.toString());
  TextEditingController controllerDisponivel =
      TextEditingController(text: startingDisponivel.toString());
  apc.inDisponivel.add(startingDisponivel);
  apc.inMinimo.add(startingMinimo);

  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          content: StreamBuilder(
              stream: apc.outDisponivel,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                print('CHEGOU AQUI LOLOLO' + snapshot.data.toString());
                if (snapshot.data != null) {
                  return StreamBuilder(
                      stream: apc.outDisponivel,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> minimo) {
                        if (minimo.data == null) {
                          return Container();
                        }
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(produto.titulo,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            )),
                                        produto.unidade == "KG"
                                            ? new Text(
                                                "R\$" +
                                                    (produto.preco
                                                            .toStringAsFixed(
                                                                2) +
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
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    child: TextField(
                                      readOnly: false,
                                      autofocus: false,
                                      controller: controllerDisponivel,
                                      onChanged: (s) {
                                        if (snapshot.data - 1 < 0) {
                                          apc.inDisponivel.add(0);
                                        } else {
                                          apc.inDisponivel.add(int.parse(
                                              controllerDisponivel.text));
                                        }
                                      },
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      decoration: InputDecoration(
                                          hintText: "1",
                                          labelText: 'Disponivel',
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
                                                          controllerDisponivel
                                                              .text) +
                                                      1);
                                                  controllerDisponivel.text =
                                                      v.toString();
                                                  apc.inDisponivel.add(v);
                                                },
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              CircleIconButton(
                                                icon: Icons.remove,
                                                onPressed: () {
                                                  if (int.parse(
                                                              controllerDisponivel
                                                                  .text) -
                                                          1 <
                                                      0) {
                                                    int v = 0;
                                                    controllerDisponivel.text =
                                                        '0';
                                                    apc.inDisponivel.add(v);
                                                  } else {
                                                    int v = (int.parse(
                                                            controllerDisponivel
                                                                .text) -
                                                        1);
                                                    controllerDisponivel.text =
                                                        v.toString();
                                                    apc.inDisponivel.add(v);
                                                  }
                                                },
                                                size: 20,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  sb,
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    child: TextField(
                                      readOnly: false,
                                      autofocus: false,
                                      controller: controllerMinimo,
                                      onChanged: (s) {
                                        if (minimo.data - 1 < 0) {
                                          apc.inMinimo.add(0);
                                        } else {
                                          apc.inMinimo.add(
                                              int.parse(controllerMinimo.text));
                                        }
                                      },
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      decoration: InputDecoration(
                                          hintText: "1",
                                          labelText: 'Minimo',
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
                                                          controllerMinimo
                                                              .text) +
                                                      1);
                                                  controllerMinimo.text =
                                                      v.toString();
                                                  apc.inMinimo.add(v);
                                                },
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              CircleIconButton(
                                                icon: Icons.remove,
                                                onPressed: () {
                                                  if (int.parse(controllerMinimo
                                                              .text) -
                                                          1 <
                                                      0) {
                                                    int v = 0;
                                                    controllerMinimo.text = '0';
                                                    apc.inMinimo.add(v);
                                                  } else {
                                                    int v = (int.parse(
                                                            controllerMinimo
                                                                .text) -
                                                        1);
                                                    controllerMinimo.text =
                                                        v.toString();
                                                    apc.inMinimo.add(v);
                                                  }
                                                },
                                                size: 20,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      });
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
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 10),
                          MaterialButton(
                              color: corPrimaria,
                              child: new Text(
                                "Atualizar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () {
                                if (int.parse(controllerDisponivel.text) > 0 ||
                                    int.parse(controllerMinimo.text) >= 0) {
                                  //TODO ATUALIZAR DISPONIVEL
                                  e.disponivel =
                                      int.parse(controllerDisponivel.text);
                                  e.minimo = int.parse(controllerMinimo.text);
                                  e.updated_at = DateTime.now();
                                  estoquesRef
                                      .document(id)
                                      .updateData(e.toJson())
                                      .then((v) {
                                    dToast('Atualizado com Sucesso!');
                                    Navigator.of(context).pop();
                                  });
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
