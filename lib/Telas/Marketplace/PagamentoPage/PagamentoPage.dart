import 'dart:convert';

import 'package:bocaboca/Helpers/ListaEquipamentos.dart';
import 'package:bocaboca/Telas/Card/cartoes_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_checkbox/flare_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Cielo/src/Sale.dart';
import 'package:bocaboca/Helpers/Cielo/src/Subordinate.dart';
import 'package:bocaboca/Helpers/CieloController.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/ShortStreamBuilder.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Cartao.dart';
import 'package:bocaboca/Objetos/Carteira.dart';
import 'package:bocaboca/Objetos/Prestador.dart';
import 'package:bocaboca/Objetos/Estoque.dart';
import 'package:bocaboca/Objetos/Pagamento.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Objetos/ProdutoPedido.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Card/card_list_controller.dart';
import 'package:bocaboca/Telas/Marketplace/Produto/ProdutoGeneralController.dart';

import '../../../main.dart';
import '../CarteiraController.dart';

class PagamentoPage extends StatefulWidget {
  List<ProdutoPedido> ppl;
  Produto produto;
  User u;
  String cliente;

  PagamentoPage(this.ppl, this.u, {this.cliente, this.produto});
  @override
  _PagamentoPageState createState() {
    return _PagamentoPageState();
  }
}

class _PagamentoPageState extends State<PagamentoPage> {
  User u;
  bool isBuyer;
  List<Cartao> cartoes = new List();
  int selected;
  @override
  Widget build(BuildContext context) {
    u = widget.u;
    isBuyer = false;
    if (u != null) {
      isBuyer = u.id == Helper.localUser.id;
    }
    // TODO: implement build
    return Scaffold(
        appBar: myAppBar('Efetuar Pagamento', context, showBack: true),
        body: SingleChildScrollView(child: CompradorWidget()));
  }

  VenderButton(String text) {
    return MaterialButton(
        onPressed: () async {
          if (selected == null) {
            dToast('Selecione a forma de pagamento!');
          } else {
            double total = 0;
            for (ProdutoPedido pp in widget.ppl) {
              total += pp.preco_unitario * pp.quantidade;
            }
            List prestadores = new List();
            for(ProdutoPedido pp in widget.ppl){
              prestadores.add(pp.prestador);
            }
            String formaPagamento = selected == 512
                ? 'Maquininha'
                : selected == 256 ? 'Dinheiro' : 'Cartao';
            String paymentId = DateTime.now().millisecondsSinceEpoch.toString();
            if (selected != 256 && selected != 512 && selected != 1024) {
              print('AQUI SELECTED $selected');
                  Cartao c = cartoes[selected];
                  c.number = c.number
                      .toString()
                      .replaceAll(' ', '')
                      .replaceAll('-', '');
                  Pagamento p = new Pagamento(
                    comprador: u == null ? widget.cliente : u.id,
                    vendedor: u.id,
                    cartao: c,
                    data_venda: DateTime.now(),
                    forma_pagamento: formaPagamento,
                    produtos: widget.ppl,
                    pacote: null,
                    meta: {'Prestadores':json.encode(prestadores)},
                    prestador: widget.ppl[0].prestador,
                    paymentId: paymentId,
                    total: total,
                  );
                  pagamentoRef.add(p.toJson()).then((v) {
                    dToast('Venda efetuada com Sucesso!');
                    LimparCarrinho(user: widget.u.id);

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                });
            } else {
              if (selected == 1024) {
                try {
                  DocumentSnapshot ds = await carteirasRef
                      .document(widget.cliente != null ? widget.cliente : u.id)
                      .get();
                  Carteira c = Carteira.fromJson(ds.data);
                  if (c.saldo > (total * 100).toInt()) {
                    RemoverSaldo(widget.cliente != null ? widget.cliente : u.id,
                        (total * 100).toInt());

                    Pagamento p = new Pagamento(
                      comprador: u == null ? widget.cliente : u.id,
                      vendedor: Helper.localUser.id,
                      cartao: null,
                      data_venda: DateTime.now(),
                      forma_pagamento: formaPagamento,
                      id_merchant: null,
                      meta: {'Prestadores':json.encode(prestadores)},
                      prestador: widget.ppl[0].prestador,
                      produtos: widget.ppl,
                      paymentId: paymentId,
                      total: total,
                    );
                    pagamentoRef.add(p.toJson()).then((v) {
                      dToast('Venda efetuada com Sucesso!');
                      LimparCarrinho(user: u == null ? widget.cliente : u.id);

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  } else {
                    dToast(
                        'Saldo Insuficiente para pagar por esse carrinho, por favor selecione outra forma de pagamento');
                  }
                } catch (err) {
                  print('ERRO :${err.toString()}');
                  return;
                }
              } else {
                Pagamento p = new Pagamento(
                  comprador: u == null ? widget.cliente : u.id,
                  vendedor: Helper.localUser.id,
                  cartao: null,
                  data_venda: DateTime.now(),
                  forma_pagamento: formaPagamento,
                  id_merchant: null,
                  prestador: Helper.localUser.prestador,
                  produtos: widget.ppl,
                  paymentId: paymentId,
                  total: total,
                );
                pagamentoRef.add(p.toJson()).then((v) {
                  dToast('Venda efetuada com Sucesso!');
                  prestadorRef
                      .document(Helper.localUser.prestador)
                      .get()
                      .then((v) {
                    Prestador c = Prestador.fromJson(v.data);
                    if (c.isEstoque) {
                      for (ProdutoPedido pp in widget.ppl) {
                        estoquesRef
                            .where('prestador',
                                isEqualTo: Helper.localUser.prestador)
                            .where('produto', isEqualTo: pp.produto)
                            .getDocuments()
                            .then((s) {
                          if (s.documents != null) {
                            Estoque e = Estoque.fromJson(s.documents[0]);
                            e.disponivel = e.disponivel - pp.quantidade;
                            e.last_purchased_at = DateTime.now();
                            estoquesRef
                                .document(s.documents[0].documentID)
                                .updateData(e.toJson())
                                .then((v) {
                              print('Estoque Atualizado');
                            });
                          }
                        });
                      }
                    }
                  });
                  LimparCarrinho(user: u == null ? widget.cliente : u.id);

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              }
            }

            // Navigator.of(context).pop();
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .9,
          height: MediaQuery.of(context).size.height * .08,
          decoration: BoxDecoration(
              color: corPrimaria,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
          child: Center(
              child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 22),
          )),
        ));
  }

  CompradorWidget() {
    /*return SSB(
        error: Container(),
        isList: false,
        buildfunction: (context, snap) {
          DocumentSnapshot ds = snap.data;
          if (ds.exists) {
            Subordinate s = Subordinate.fromJson(ds.data);*/
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FormaPagamentoWidget(),
        sb,
        sb,
        TotalWidget(),
        sb,
        VenderButton('Efetuar Compra'),
      ],
    );
    /*} else {
            print('Não é revendedor Braspag');
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FormaPagamentoSemCartaoWidget(),
                sb,
                sb,
                TotalWidget(),
                sb,
                VenderButton('Efetuar Compra'),
              ],
            );*/
    /*  }
        },
        stream: vendedoresRef.document(u.prestador).snapshots());*/
  }

  Widget _formatCardNumber(String cardNumber, String marca, context) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    List<Widget> numberList = new List<Widget>();

    var counter = 0;
    for (var i = 0; i < cardNumber.length; i++) {
      if (i == 0) {
        numberList.add(
          hText(
            '${marca[0].toUpperCase()}${marca.substring(1)}:',
            context,
            color: Colors.black,
          ),
        );
      }
      counter += 1;
      numberList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: hText(
            i > 11 ? cardNumber[i] : '*',
            context,
            color: Colors.black,
          ),
        ),
      );
      if (counter == 4) {
        counter = 0;
        numberList.add(SizedBox(width: 8.0));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numberList,
    );
  }

  FormaPagamentoWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LimitedBox(
        maxHeight: MediaQuery.of(context).size.height * .3,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              hText('Escolha a forma de pagamento', context,
                  color: corPrimaria, size: 60, style: FontStyle.italic),
              sb,
              defaultActionButton('Adicionar Cartão de Credito', context, () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartoesPage()));
              }),
              FutureBuilder(
                  builder: (context, future) {
                    if (future.data != null) {
                      cartoes = future.data;
                    }
                    return StreamBuilder(
                        stream:
                            carteirasRef.document(widget.cliente).snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> carteira) {
                          Carteira c;
                          if (carteira.data != null) {
                            DocumentSnapshot ds = carteira.data;
                            if (ds.data != null) {
                              c = Carteira.fromJson(ds.data);
                            }
                          }
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (index == cartoes.length + 2) {
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: defaultCheckBox(
                                          selected == 1024,
                                          'Pagar com Pacote Especial',
                                          context, () {
                                        setState(() {
                                          selected = 1024;
                                        });
                                      }));
                                }
                                if (index == cartoes.length + 1) {
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: defaultCheckBox(selected == 512,
                                          'Pagar Na Maquininha', context, () {
                                        setState(() {
                                          selected = 512;
                                        });
                                      }));
                                }
                                if (index == cartoes.length) {
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: defaultCheckBox(selected == 256,
                                          'Pagar em Dinheiro', context, () {
                                        setState(() {
                                          selected = 256;
                                        });
                                      }));
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = index;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        defaultCheckBox(selected == index,'', context,(){}),
                                        SizedBox(width: 5),
                                        _formatCardNumber(
                                            cartoes[index].number.toString(),
                                            cartoes[index].marca,
                                            context)
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: c == null
                                  ? cartoes.length + 2
                                  : cartoes.length + 3,
                            ),
                          );
                        });
                  },
                  future: getCartoes()),
            ],
          ),
        ),
      ),
    );
  }

  TotalWidget() {
    double total = 0;
    for (ProdutoPedido pp in widget.ppl) {
      total += pp.preco_final;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LimitedBox(
        maxHeight: MediaQuery.of(context).size.height * .4,
        child: Card(
          elevation: 10,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: hText('Produtos Consumidos', context,
                          textaling: TextAlign.center,
                          color: corPrimaria,
                          size: 60,
                          style: FontStyle.italic),
                    ),
                    sb,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: hText(
                        'Total: R\$ ${total.toStringAsFixed(2)}',
                        context,
                        textaling: TextAlign.center,
                        color: Colors.black,
                        weight: FontWeight.bold,
                      ),
                    ),
                    sb,
                    FutureBuilder(
                      future:
                          produtosRef.document(widget.ppl[index].produto).get(),
                      builder: (context, future) {
                        if (future.data != null) {
                          DocumentSnapshot d = future.data;
                          if (d.data != null) {
                            Produto p = Produto.fromJson(d.data);
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                child: produtoWidget(p, index));
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                );
              }
              return FutureBuilder(
                future: produtosRef.document(widget.ppl[index].produto).get(),
                builder: (context, future) {
                  if (future.data != null) {
                    DocumentSnapshot d = future.data;
                    if (d.data != null) {
                      Produto p = Produto.fromJson(d.data);
                      return Container(
                          width: MediaQuery.of(context).size.width * .9,
                          child: produtoWidget(p, index));
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                },
              );
            },
            itemCount: widget.ppl.length,
          ),
        ),
      ),
    );
  }

  Widget produtoWidget(Produto p, index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          hText(
            p.titulo,
            context,
            color: Colors.black,
          ),
          hText(
            'Total: R\$ ${widget.ppl[index].preco_final.toStringAsFixed(2)}',
            context,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
