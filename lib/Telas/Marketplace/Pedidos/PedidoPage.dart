import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/CieloController.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Pagamento.dart';
import 'package:bocaboca/Telas/Marketplace/Carrinho/CarrinhoDetails/ProdutoPedidoItem.dart';
import 'package:bocaboca/Telas/Marketplace/Pacotes/PacoteItem.dart';

class PedidoPage extends StatefulWidget {
  Pagamento p;

  PedidoPage(this.p);

  @override
  _PedidoPageState createState() {
    return _PedidoPageState(p);
  }
}

class _PedidoPageState extends State<PedidoPage> {
  Pagamento p;

  _PedidoPageState(this.p);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('Pedido', context, showBack: true, actions: [
        IconButton(
          icon: Icon(
            Icons.cancel,
            color: corPrimaria,
          ),
          onPressed: () {
            CancelarPedido();
          },
        )
      ]),
      body: Column(
        children: <Widget>[
          PagamentoItem(p, context, false,widget.p.comprador == Helper.localUser.id),
          p.produtos != null
              ? Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ProdutoPedidoItem(
                        pp: p.produtos[index],
                        id: p.comprador,
                        action: false,
                      );
                    },
                    itemCount: p.produtos.length,
                  ),
                )
              : PacoteItem(p.pacote)
        ],
      ),
    );
  }

  Future CancelarPedido() async {
    CieloController().CancelarPedido(p.paymentId);
    dToast('Compra Cancelada!');
    Navigator.of(context).pop();
  }
}
