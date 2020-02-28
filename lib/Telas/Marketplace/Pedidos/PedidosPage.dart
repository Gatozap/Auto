import 'package:bocaboca/Helpers/Styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/ShortStreamBuilder.dart';
import 'package:bocaboca/Objetos/Pagamento.dart';

import '../../../main.dart';
import 'EstatisticasPage.dart';

class PedidosPage extends StatefulWidget {
  @override
  _PedidosPageState createState() {
    return _PedidosPageState();
  }
}

class _PedidosPageState extends State<PedidosPage> {
  bool isCompras = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('Pedidos', context, showBack: true, actions: [
        Helper.localUser.isPrestador
            ? IconButton(
                icon: Icon(LineAwesomeIcons.bar_chart),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EstatisticasPage()));
                },
              )
            : Container(),
      ]),
      body: Container(
        child: Column(
          children: <Widget>[
            Helper.localUser.isPrestador
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        defaultActionButton('Compras', context, () {
                          setState(() {
                            isCompras = true;
                          });
                        },
                            textColor: isCompras ? Colors.white : corPrimaria,
                            color: isCompras ? corPrimaria : Colors.white,icon: null),
                        sb,
                        defaultActionButton('Vendas', context, () {
                          setState(() {
                            isCompras = false;
                          });
                        }, textColor: !isCompras ? Colors.white : corPrimaria,
                                                color: !isCompras ? corPrimaria : Colors.white,icon: null)
                      ],
                    ),
                  )
                : Container(),
            StreamBuilder(
                stream: isCompras
                    ? pagamentoRef
                        .where('comprador',
                            isEqualTo: Helper.localUser.id)
                        .snapshots()
                    : pagamentoRef
                        .where('prestador', isEqualTo: Helper.localUser.id)
                        .snapshots(),
                builder: (context, snap) {
                  print('BUSCANDO COMPRAS ${snap.data}');
                  if (snap.data == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              sb,
                              sb,
                              sb,
                              hText('Carregando Pedidos',context),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (snap.data.documents.length == 0) {
                    return Center(
                      child: hText('Sem pedidos no momento',context),
                    );
                  }
                  List<DocumentSnapshot> snaps = snap.data.documents;
                  List<Pagamento> pagamentos = List();
                  for (var s in snaps) {
                    Pagamento p = Pagamento.fromJson(s.data);
                    p.id = s.documentID;
                    pagamentos.add(p);
                  }
                  pagamentos.sort((Pagamento a, Pagamento b) =>
                      b.data_venda.compareTo(a.data_venda));
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PagamentoItem(pagamentos[index], context, true, isCompras);
                      },
                      itemCount: pagamentos.length,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
