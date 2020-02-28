import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Objetos/ProdutoPedido.dart';
import 'package:autooh/Telas/Dialogs/addProduto.dart';
import 'package:autooh/Telas/Marketplace/Produto/ProdutoGeneralController.dart';

import '../../../../main.dart';

class ProdutoPedidoItem extends StatelessWidget {
  ProdutoPedido pp;
  String local = 'ProdutoPedidoItem';
  String id;

  bool action;
  ProdutoPedidoItem({this.pp, this.id, this.action = true});
  double midleWidth;
  @override
  Widget build(BuildContext context) {
    if (id == null) {
      id = Helper.localUser.id;
    }
    // TODO: implement build
    midleWidth = MediaQuery.of(context).size.width * .4;
    /*if (pp.isHerbaLife) {
      print(pp.toString());
      return StreamBuilder(
          stream: produtosHerbaLifeRef
              .document(pp.estado)
              .collection(pp.estado)
              .document(pp.id.toString().replaceAll('//', ''))
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
            try {
              ProdutoHerbaLife phl =
                  new ProdutoHerbaLife.fromJson(snap.data.data);
              Produto p = Produto.fromHebalife(phl: phl, type: 0, e: pp.estado);
              if (action) {
                if (pp.preco_unitario != p.preco) {
                  pp.preco_unitario = p.preco;
                  pp.preco_final = p.preco * pp.quantidade;
                  AdicionarProdutoAoCarrinho(user: id, produto: pp);
                }
              }
              return ProdutoWidget(p, context);
            } catch (er) {
              Err(er, local);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[LoadingScreen('Buscando Produto')],
                  ),
                ),
              );
            }
          });
    }*/
    return StreamBuilder(
        stream: produtosRef.document(pp.produto).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> v) {
          try {
            Produto p = Produto.fromJson(v.data.data);
            if (pp.preco_unitario != p.preco) {
              pp.preco_unitario = p.preco;
              pp.preco_final = p.preco * pp.quantidade;
              AdicionarProdutoAoCarrinho(user: id, produto: pp);
            }
            return ProdutoWidget(p, context);
          } catch (er) {
            Err(er, local);
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[LoadingScreen('Buscando Produto')],
                ),
              ),
            );
          }
        });
  }

  ProdutoWidget(Produto p, context) {
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
            sb,
            GestureDetector(
              onTap: () {
                /*if (action) {
                  AddProduto().showDlgConfirmacao(
                      produto: p,
                      context: context,
                      id: id,
                      startingQuantidade: pp.quantidade);
                }*/
              },
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
                  /*Container(
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
                                    text: '${pp.quantidade.toString()}',
                                    style: TextStyle(
                                        color: corPrimaria,
                                        fontWeight: FontWeight.bold)),
                              ], text: 'Quantidade: '),
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey[700]),
                              softWrap: true,
                              textAlign: TextAlign.start,
                            ))
                          ])),*/
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
                                    text: 'R\$' +
                                        (pp.quantidade * p.preco)
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontFamily: 'Cour',
                                        color: corPrimaria,
                                        fontWeight: FontWeight.bold)),
                              ], text: 'Total: '),
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
            action
                ? Column(
                    children: <Widget>[
                     /* new IconButton(
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
                            AddProduto().showDlgConfirmacao(
                                produto: p,
                                context: context,
                                id: id,
                                startingQuantidade: pp.quantidade);
                          }),*/
                      new IconButton(
                          icon: Container(
                            height: 25,
                            width: 25,
                            decoration: new BoxDecoration(
                              color: myOrange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          onPressed: () {
                            print('Ontap Info Estabelecimento');
                            RemoverProdutoCarrinho(user: id, produto: pp);
                          }),
                    ],
                  )
                : Container(
                    height: 1,
                    width: 1,
                  ),
          ],
        ),
      ),
    );
  }
}
