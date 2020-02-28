import 'package:bocaboca/Objetos/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Pacote.dart';
import 'package:bocaboca/Telas/Marketplace/PagamentoPage/PagamentoPacotePage.dart';

class PacoteItem extends StatefulWidget {
  Pacote p;
  User c;
  PacoteItem(this.p, {this.c});

  @override
  _PacoteItemState createState() {
    return _PacoteItemState();
  }
}

class _PacoteItemState extends State<PacoteItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Pacote p = widget.p;
    return Container(
        width: MediaQuery.of(context).size.width * .9,
        height: MediaQuery.of(context).size.height * .33,
        child: Card(
            child: MaterialButton(
          onPressed: () {
            if (widget.c != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PagamentoPacotePage(p, null, cliente: widget.c.id)));
            } else {
              userRef
                  .where('nome', isEqualTo: Helper.localUser.nome)
                  .where('email', isEqualTo: Helper.localUser.email)
                  .getDocuments()
                  .then((v) {
                User c = User.fromJson(v.documents[0]);
                if (c != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PagamentoPacotePage(p, null, cliente: c.id)));
                }
              });
            }
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: p.foto != null
                    ? CachedNetworkImage(
                        imageUrl: p.foto,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Text(
                        p.titulo,
                        style: TextStyle(
                          fontSize: 22,
                          color: corPrimaria,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              p.foto != null
                  ? Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * .01),
                      child: Text(
                        p.titulo,
                        style: TextStyle(
                          color: corPrimaria,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                  : Container(),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * .01),
                child: Text(
                  'Pague R\$ ${(p.preco / 100).toStringAsFixed(2).replaceAll('.', ',')} e Consuma R\$ ${(p.valor / 100).toStringAsFixed(2).replaceAll('.', ',')} Em Produtos!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              )
            ],
          ),
        )));
  }
}
