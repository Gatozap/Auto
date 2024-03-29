import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Objetos/Solicitacao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Telas/Perfil/PerfilController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/VisualizarUserPage.dart';
import '../Parceiros/ParceirosListPage.dart';

class SolicitacaoListItem extends StatefulWidget {
  Solicitacao s;
  bool isUser;
  User user;
  Parceiro parceiro;
  SolicitacaoListItem(this.s,{ this.user,this.isUser = false, this.parceiro, });

  @override
  _SolicitacaoListItemState createState() => _SolicitacaoListItemState();
}

class _SolicitacaoListItemState extends State<SolicitacaoListItem> {
  PerfilController pc;
  @override
  Widget build(BuildContext context) {
         if(widget.user == null){                  
           widget.user = User();
         }
    if (pc == null) {
      pc = new PerfilController(widget.user);
    }
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Color(0xFFE8F5E9),
          Color(0xFFE0F7FA),
        ],
      ),
    );
    return Container(
      decoration: linearGradient,
      child: GestureDetector(
        onTap: () {
          if (widget.isUser) {
            if (widget.s.isAprovado != null) {
              if(widget.s.isAprovado){
                campanhasRef.document(widget.s.campanha).get().then((v){
                  Campanha c = Campanha.fromJson(v.data);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ParceirosListPage(campanha: c,)));
                });

              }else{
                dToast('É Necessario aguardar aprovação');
              }
            } else {
              dToast('É Necessario aguardar aprovação');
            }
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Center(child: hText('Aprovar Solicitação?', context)),
                    actions: <Widget>[

                      Row(
                            mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          defaultActionButton('Não', context, () {
                            widget.s.isAprovado = false;
                            solicitacoesRef.document(widget.s.id).updateData(widget.s.toJson()).then((v){
                              sendNotificationUsuario('Sua Solicitação para ${widget.s.nome_campanha} não foi aprovada', 'Agora é só agendar um horario', null, 'user${widget.s.usuario}',widget.s.campanha, widget.s.id);
                              dToast('Solicitação Negada');

                              Navigator.of(context).pop();

                            });
                          }, icon: null),
                          defaultActionButton('Sim', context, () {
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

              Container(
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    hText(
                        'Status: ${widget.s.isAprovado == null ? 'Aguardando' : widget.s.isAprovado ? 'Aprovado' : 'Negado'}',
                        context,
                        color: widget.s.isAprovado == null
                            ? Colors.red
                            : widget.s.isAprovado ? Colors.green : Colors.red),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.user, color: corPrimaria),sb,
                        Expanded(child: hText('Usuario:${widget.s.nome_usuario}', context)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.compass),sb,
                        hText('Campanha: ${widget.s.nome_campanha}', context),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.carSide, color: corPrimaria,),sb,
                        hText('Modelo: ${widget.s.carro.modelo}', context),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.palette, color: corPrimaria,),sb,
                        hText('Cor: ${widget.s.carro.cor}', context),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.calendar),sb,
                        hText('Ano: ${widget.s.carro.ano}', context),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        hText('Placa: ${widget.s.carro.placa}', context),
                        hText(Helper().readTimestamp(widget.s.created_at), context,
                            color: Colors.grey, size: 35),
                      ],
                    ),sb,
                     GestureDetector(
                              onTap: () async {
                                User u = User.fromJson((await userRef.document(widget.s.usuario).get()).data);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VisualizarUserPage(user: u)));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    Icon(Icons.remove_red_eye, color: Colors.blue, size: 30,),sb,
                                  hText('Visualizar perfil do usuário', context),

                                ],
                              ),
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


}
