import 'dart:convert';

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
import 'package:bocaboca/Objetos/Pacote.dart';
import 'package:bocaboca/Objetos/Pagamento.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Card/card_list_controller.dart';

import '../../../main.dart';
import '../CarteiraController.dart';

class PagamentoPacotePage extends StatefulWidget {
  Pacote pacote;

  User u;
  String cliente;
  PagamentoPacotePage(this.pacote, this.u, {this.cliente});
  @override
  _PagamentoPacotePageState createState() {
    return _PagamentoPacotePageState();
  }
}

class _PagamentoPacotePageState extends State<PagamentoPacotePage> {
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
        body: SingleChildScrollView(
            child: isBuyer ? CompradorWidget() : CoachWidget()));
  }

  CoachWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FormaPagamentoSemCartaoWidget(),
        sb,
        sb,
        TotalWidget(),
        sb,
        VenderButton('Efetuar Venda'),
      ],
    );
  }

  VenderButton(String text) {
    return MaterialButton(
        onPressed: () async {
          if (selected == null) {
            dToast('Selecione a forma de pagamento!');
          } else {
            double total = (widget.pacote.valor / 100);
            String formaPagamento = selected == 512
                ? 'Maquininha'
                : selected == 256 ? 'Dinheiro' : 'Cartao';
            String paymentId = DateTime.now().millisecondsSinceEpoch.toString();
            if (selected != 256 && selected != 512) {
              print('AQUI SELECTED $selected');
              DocumentSnapshot d = await vendedoresRef.document(u.prestador).get();
              if (d.data != null) {
                Subordinate s = Subordinate.fromJson(d.data);
                //TODO USAR PARA TESTES >> CieloController().ComprarProdutosBraspagTeste(
                CieloController()
                    .ComprarPacote(
                  s,
                  widget.pacote,
                  cartoes[selected],
                  s.subordinateMeta.MerchantId,
                )
                    .then((v) {
                  Sale sale = Sale.fromJson(json.decode(v));
                  Cartao c = cartoes[selected];
                  c.number = c.number
                      .toString()
                      .replaceAll(' ', '')
                      .replaceAll('-', '');
                  Pagamento p = new Pagamento(
                      comprador: u == null ? widget.cliente : u.id,
                      vendedor: Helper.localUser.id,
                      cartao: c,
                      data_venda: DateTime.now(),
                      forma_pagamento: formaPagamento,
                      id_merchant: s.subordinateMeta.MerchantId,
                      produtos: null,
                      pacote: widget.pacote,
                      prestador: Helper.localUser.prestador,
                      paymentId: paymentId,
                      total: total,
                      meta: sale.toJson());
                  pagamentoRef.add(p.toJson()).then((v) {
                    dToast('Compra efetuada com Sucesso!');
                    AdicionarSaldo(
                        u == null ? widget.cliente : u.id, widget.pacote.valor);
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                  });
                });
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
                produtos: null,
                pacote: widget.pacote,
                paymentId: paymentId,
                total: total,
              );
              pagamentoRef.add(p.toJson()).then((v) {
                dToast('Compra efetuada com Sucesso!');
                AdicionarSaldo(
                    u == null ? widget.cliente : u.id, widget.pacote.valor);
                Navigator.of(context).pop();
                //Navigator.of(context).pop();
              });
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
    return SSB(
        error: Container(),
        isList: false,
        buildfunction: (context, snap) {
          DocumentSnapshot ds = snap.data;
          if (ds.exists) {
            Subordinate s = Subordinate.fromJson(ds.data);
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
          } else {
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
            );
          }
        },
        stream: vendedoresRef.document(u.prestador).snapshots());
  }

  Widget _formatCardNumber(String cardNumber, String marca, context) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    List<Widget> numberList = new List<Widget>();

    var counter = 0;
    for (var i = 0; i < cardNumber.length; i++) {
      if (i == 0) {
        numberList.add(
          Text(
            '${marca[0].toUpperCase()}${marca.substring(1)}:',
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * .04),
          ),
        );
      }
      counter += 1;
      numberList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Text(
            i > 11 ? cardNumber[i] : '*',
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * .04),
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

  FormaPagamentoSemCartaoWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LimitedBox(
        maxHeight: MediaQuery.of(context).size.height * .4,
        child: Card(
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Escolha a forma de pagamento',
                style: TextStyle(
                    color: corPrimaria, fontSize: 18, fontStyle: FontStyle.italic),
              ),
              sb,
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 512;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    border: Border.all(color: corPrimaria),
                                    borderRadius: BorderRadius.circular(60)),
                                child: FlareCheckbox(
                                  animation: 'assets/my_check_box.flr',
                                  onChanged: (b) {
                                    setState(() {
                                      selected = 512;
                                    });
                                  },
                                  value: selected == 512,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Pagar na Maquininha',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            .04),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              setState(() {
                                selected = 256;
                              });
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    border: Border.all(color: corPrimaria),
                                    borderRadius: BorderRadius.circular(60)),
                                child: FlareCheckbox(
                                  animation: 'assets/my_check_box.flr',
                                  onChanged: (b) {
                                    setState(() {
                                      selected = 256;
                                    });
                                  },
                                  value: selected == 256,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Pagamento em Dinheiro',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            .04),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: 2,
                ),
              ),
            ],
          ),
        ),
      ),
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
              Text(
                'Escolha a forma de pagamento',
                style: TextStyle(
                    color: corPrimaria, fontSize: 18, fontStyle: FontStyle.italic),
              ),
              sb,
              FutureBuilder(
                  builder: (context, future) {
                    if (future.data != null) {
                      cartoes = future.data;
                    }
                    if(cartoes == null){
                      cartoes = new List();
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == cartoes.length + 1) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 512;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: corPrimaria),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: FlareCheckbox(
                                        animation: 'assets/my_check_box.flr',
                                        onChanged: (b) {
                                          setState(() {
                                            selected = 512;
                                          });
                                        },
                                        value: selected == 512,
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Pagar na Maquininha',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .04),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (index == cartoes.length) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 256;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: corPrimaria),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: FlareCheckbox(
                                        animation: 'assets/my_check_box.flr',
                                        onChanged: (b) {
                                          setState(() {
                                            selected = 256;
                                          });
                                        },
                                        value: selected == 256,
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Pagamento em Dinheiro',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .04),
                                    ),
                                  ],
                                ),
                              ),
                            );
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: corPrimaria),
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: FlareCheckbox(
                                      animation: 'assets/my_check_box.flr',
                                      onChanged: (b) {
                                        setState(() {
                                          selected = index;
                                        });
                                      },
                                      value: selected == index,
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
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
                        itemCount: cartoes.length + 2,
                      ),
                    );
                  },
                  future: getCartoes()),
            ],
          ),
        ),
      ),
    );
  }

  TotalWidget() {
    double total = (widget.pacote.preco / 100);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * .4,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 10,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Pacote Adquirido ${widget.pacote.titulo}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: corPrimaria,
                            fontSize: 18,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    sb,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total: R\$ ${total.toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * .04)),
                    ),
                    sb,
                  ]),
            ),
          ),
        ));
  }
}
