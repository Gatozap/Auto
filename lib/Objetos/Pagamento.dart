import 'dart:ui';

import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Telas/Marketplace/Pedidos/PedidoPage.dart';
import 'package:bocaboca/Telas/Perfil/PerfilVistoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Telas/Marketplace/Pedidos/PedidoPage.dart';

import 'Cartao.dart';
import 'Pacote.dart';
import 'ProdutoPedido.dart';
import 'User.dart';

class Pagamento {
  String id;
  String comprador;
  String vendedor;
  String id_merchant;
  DateTime data_venda;
  double total;
  List<ProdutoPedido> produtos;
  Pacote pacote;
  String prestador;
  String forma_pagamento;
  Cartao cartao;
  String paymentId;
  var meta;

  Pagamento(
      {this.id,
      this.comprador,
      this.vendedor,
      this.id_merchant,
      this.data_venda,
      this.total,
      this.produtos,
      this.forma_pagamento,
      this.prestador,
      this.pacote,
      this.cartao,
      this.meta,
      this.paymentId});

  @override
  String toString() {
    return 'Pagamento{id: $id,paymentId: $paymentId ,prestador: $prestador, comprador: $comprador, vendedor: $vendedor, id_merchant: $id_merchant, data_venda: $data_venda, total: $total, produtos: $produtos, forma_pagamento: $forma_pagamento, cartao: $cartao}';
  }

  factory Pagamento.fromJson(json) {
    return Pagamento(
      id: json["id"],
      comprador: json["comprador"],
      vendedor: json["vendedor"],
      prestador: json['prestador'],
      id_merchant: json["id_merchant"],
      data_venda: DateTime.fromMillisecondsSinceEpoch(json["data_venda"]),
      total: json["total"],
      pacote: json['pacote'] == null ? null : Pacote.fromJson(json['pacote']),
      meta: json['meta'],
      paymentId: json['paymentId'],
      produtos: json["produtos"] == null
          ? null
          : List.of(json["produtos"])
              .map((i) => ProdutoPedido.fromJson(i))
              .toList(),
      forma_pagamento: json["forma_pagamento"],
      cartao: json['cartao'] == null ? null : Cartao.fromJson(json["cartao"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "comprador": this.comprador,
      "vendedor": this.vendedor,
      'prestador': this.prestador,
      "id_merchant": this.id_merchant,
      "data_venda": this.data_venda.millisecondsSinceEpoch,
      "total": this.total,
      'paymentId': this.paymentId,
      'meta': this.meta,
      'pacote': this.pacote == null ? null : this.pacote.toJson(),
      "produtos": this.produtos != null ? listToJson(this.produtos) : null,
      "forma_pagamento": this.forma_pagamento,
      "cartao": this.cartao != null ? this.cartao.toJson() : null,
    };
  }

  listToJson(List<ProdutoPedido> produtos) {
    List l = new List();
    for (ProdutoPedido p in produtos) {
      l.add(p.toJson());
    }
    return l;
  }
}

Widget PagamentoItem(
    Pagamento pagamento, context, bool abrirPedido, bool isComprador) {
  var chars = pagamento.cartao.number.split('');
  String initials = '';

  return MaterialButton(
    onPressed: () {
      if (abrirPedido) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PedidoPage(pagamento)));
      }
    },
    child: Card(
        elevation: abrirPedido ? 10 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder(
                    builder: (context, snap) {
                      if (snap.data == null) {
                        return Container();
                      }
                      print(snap.data.toString());
                      DocumentSnapshot d = snap.data;
                      print(d.data);
                      if (d.data == null) {
                        return Container();
                      }
                      User c = User.fromJson(d.data);
                      var words = c.nome.split(' ');
                      for (String word in words) {
                        initials += word.split('')[0].toUpperCase();
                      }
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PerfilVistoPage(user: c)));
                          },
                          child: ListTile(
                            leading: Hero(
                              tag: c.id,
                              child: c.foto != null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.purple,
                                      radius: 25,
                                      backgroundImage:
                                          CachedNetworkImageProvider(c.foto))
                                  : CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.purple,
                                      child: hText(initials, context,
                                          color: Colors.white)),
                            ),
                            title: hText(c.nome, context, size: 60),
                          ));
                    },

                    future: userRef
                        .document(isComprador
                            ? pagamento.prestador
                            : pagamento.comprador)
                        .get()),
                sb,
                hText('Total: R\$${(pagamento.total).toStringAsFixed(2)}',
                    context),
                pagamento.cartao != null
                    ? hText(
                        'Cartão: **** **** **** ${chars[chars.length - 4]}${chars[chars.length - 3]}${chars[chars.length - 2]}${chars[chars.length - 1]}',
                        context)
                    : hText('Forma de Pagamento: ${pagamento.forma_pagamento}',
                        context),
                hText(
                    'Data da compra: ${Helper().readTimestamp(pagamento.data_venda)}',
                    context)
              ],
            ),
          ),
        )),
  );
}
