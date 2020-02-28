import 'package:autooh/Objetos/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/PhotoScroller.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Telas/Dialogs/addProduto.dart';

import '../../../../main.dart';
import '../produto_page.dart';

class ProdutoListItem extends StatefulWidget {
  Produto produto;
  ExpandableController ec;

  static bool s;
  User c;
  String id;
  ProdutoListItem({this.produto, bool startExpanded, this.c}) {
    if (c == null) {
      id = Helper.localUser.id;
    } else {
      id = c == null ? c.id : c.id;
    }
    ec = new ExpandableController();
  }

  @override
  _ProdutoListItemState createState() => _ProdutoListItemState();
}

class _ProdutoListItemState extends State<ProdutoListItem> {
  MoneyMaskedTextController controllerPreco;

  @override
  Widget build(BuildContext context) {
    //return old();

    controllerPreco = new MoneyMaskedTextController(
      initialValue: widget.produto.preco,
      precision: 2,
      leftSymbol: 'R\$',
    );

    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        /*AddProduto().showDlgConfirmacao(
            produto: widget.produto, context: context, id: widget.id);*/
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProdutoPage(produto: widget.produto,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child:
              /*
          VERSÂO PEQUENA
          */
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*.9,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: hText(
                                widget.produto.titulo,
                                context,
                                textaling: widget.ec.value
                                    ? TextAlign.start
                                    : TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        sb,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: hText(
                                controllerPreco.text,
                                context,
                                  size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              widget.produto.fotos == null ? Container() : sb,
              widget.produto.fotos == null
                  ? Container()
                  : Center(
                      child: widget.produto.fotos != null
                          ? widget.produto.fotos.length != 1
                              ? PhotoScroller(
                                  widget.produto.fotos,
                                  hide: true,
                                  altura: MediaQuery.of(context).size.height *
                                      .3,
                                  fractionsize: 1,
                                  largura:
                                      MediaQuery.of(context).size.width,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.produto.fotos[0],
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height *
                                            .3,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                          : Container(),
                    ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: hText(
                        widget.produto.descricao == null
                            ? widget.produto.titulo
                            : widget.produto.descricao,
                        context,
                          size: 40,
                        color: Colors.black),
                      )
                  ],
                ),
              ),
              widget.produto.created_at == null ? Container() : sb,
              widget.produto.created_at == null
                  ? Container()
                  : Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: hText(
                              widget.produto.created_at == null
                                  ? ''
                                  : 'Publicado ${Helper().readTimestamp(widget.produto.created_at).replaceAll('Há', 'há')}',context,
                              textaling: TextAlign.end,
                              size: 40,
                              color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
/*
  Widget old() {
    controllerPreco = new MoneyMaskedTextController(
      initialValue: widget.produto.preco,
      precision: 2,
      leftSymbol: 'R\$',
    );

    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProdutoPage(produto: widget.produto,)));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child:

                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.produto.titulo,
                          textAlign: widget.ec.value
                              ? TextAlign.start
                              : TextAlign.start,
                          style: TextStyle(
                            fontSize: widget.ec.value ? 32 : 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sb,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        controllerPreco.text,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ],
                ),
                sb,
                widget.produto.fotos != null
                    ? PhotoScroller(
                        widget.produto.fotos,
                        hide: true,
                        altura: MediaQuery.of(context).size.height * .25,
                        fractionsize: .7,
                        largura: MediaQuery.of(context).size.width,
                      )
                    : Container(),
                sb,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.produto.descricao,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                sb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Publicado ${Helper().readTimestamp(widget.produto.created_at).replaceAll('Há', 'há')}',
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                sb,
                Helper.localUser.isPrestador
                    ? MaterialButton(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: widget.produto.visivel
                                  ? corPrimaria
                                  : Colors.blueGrey,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  widget.produto.visivel
                                      ? 'Disponivel'
                                      : 'Vendido',
                                  style: TextStyle(color: Colors.white),
                                ))),
                        onPressed: () {
                          widget.produto.visivel = !widget.produto.visivel;
                          produtosRef
                              .document(widget.produto.id)
                              .updateData(widget.produto.toJson())
                              .then((v) {
                            print('Atualizado!');
                          });
                        },
                      )
                    : Container(),
                Helper.localUser.isPrestador ? sb : Container(),

                /* //TEST BUTTON
                  Helper.localUser.isCoach
                      ? MaterialButton(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: myGreen,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'NOTIFICAR RAWRRR',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                          onPressed: () {
                            sendNotificationProduto(produto);
                          },
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Helper.localUser.isCoach
                        ? Text('NÂO APERTE ESSE BOTÃO + DE UMA VEZ')
                        : Container(),
                  ),
                  Helper.localUser.isCoach ? sb : Container(),*/
              ],
            ),
          ),
        ),
      ),
    );
  }*/
}
