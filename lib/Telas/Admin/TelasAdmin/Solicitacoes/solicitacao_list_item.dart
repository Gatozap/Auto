import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Solicitacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SolicitacaoListItem extends StatefulWidget {
  Solicitacao s;
  bool isUser;
  SolicitacaoListItem(this.s, {this.isUser = false});

  @override
  _SolicitacaoListItemState createState() => _SolicitacaoListItemState();
}

class _SolicitacaoListItemState extends State<SolicitacaoListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isUser) {
          if (widget.s.isAprovado != null) {

          } else {
            dToast('É Nescessario aguardar aprovação');
          }
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: hText('Aprovar ou Negar?', context),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        defaultActionButton('Negar', context, () {}, icon: null),
                        defaultActionButton('Aprovar', context, () {
                          widget.s.isAprovado = true;
                         solicitacoesRef.document(widget.s.id).updateData(widget.s.toJson()).then((v){
                           sendNotificationUsuario('Sua Solicitação para ${widget.s.nome_campanha} foi aprovada', 'Agora é só agendar um horario', null, 'user${widget.s.usuario}',widget.s.campanha, widget.s.id);
                           dToast('Solicitação Aprovada');
                           Navigator.of(context).pop();
                         });
                        }, icon: null),
                      ],
                    ),

                  ],
                );
              });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.isUser && widget.s.isAprovado != null
                ? widget.s.isAprovado
                    ? hText('Clique na solicitação para Agendar um horario',
                        context)
                    : Container()
                : Container(),
            hText(
                'Status: ${widget.s.isAprovado == null ? 'Aguardando' : widget.s.isAprovado ? 'Aprovado' : 'Negado'}',
                context,
                color: widget.s.isAprovado == null
                    ? Colors.red
                    : widget.s.isAprovado ? Colors.green : Colors.red),
            hText('Usuario:${widget.s.nome_usuario}', context),
            hText('Campanha: ${widget.s.nome_campanha}', context),
            hText('Modelo: ${widget.s.carro.modelo}', context),
            hText('Cor: ${widget.s.carro.cor}', context),
            hText('Ano: ${widget.s.carro.ano}', context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                hText('Placa: ${widget.s.carro.placa}', context),
                hText(Helper().readTimestamp(widget.s.created_at), context,
                    color: Colors.grey, size: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
