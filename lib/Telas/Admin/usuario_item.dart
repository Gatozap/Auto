import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'TelasAdmin/EstatisticaPage.dart';
import 'TelasAdmin/VisualizarUserPage.dart';

class UsuarioItem extends StatelessWidget {
  User p;

  Campanha anunciantes;
  UsuarioItem(this.p, {this.anunciantes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: anunciantes != null
          ? () {
              if (anunciantes.anunciantes == null) {
                anunciantes.anunciantes = new List();
              }
              if (p.campanhas == null) {
                p.campanhas = new List();
              }
              p.campanhas.add(anunciantes.id);
              p.permissao = 5;
              anunciantes.anunciantes.add(p.id);
              userRef.document(p.id).setData(p.toJson());
              campanhasRef
                  .document(anunciantes.id)
                  .setData(anunciantes.toJson())
                  .then((value) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                dToast("Anunciante adicionado com sucesso!");
              });
            }
          : () {},
      child: Stack(children: <Widget>[
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                  radius:
                      (((getAltura(context) + getLargura(context)) / 2) * .1),
                  backgroundColor: Colors.transparent,
                  child: p.foto != null
                      ? Image(
                          image: CachedNetworkImageProvider(p.foto),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/editar_perfil.png',
                          ),
                        )),
              Container(
                width: getLargura(context) * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: hText('NOME: ${p.nome}', context,
                          size: 44, weight: FontWeight.bold),
                    ),
                    hText('${p.celular}', context, size: 44),
                    hText(
                      'Banco: ${p.conta_bancaria}',
                      context,
                      size: 44,
                    ),
                  ],
                ),
              ),
              anunciantes == null
                  ? Helper.localUser.permissao == 5? Container():PopupMenuButton<String>(
                      onSelected: (String s) {
                        switch (s) {
                          case 'editar':
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VisualizarUserPage(
                                      user: p,
                                    )));
                            break;
                          case 'estatisticas':
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EstatisticaPage(user: p)));
                            break;
                          case 'alterar':
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Alterar Permissão'),
                                    content: PopupMenuButton<String>(
                                      child: Row(
                                        children: [
                                          Text('Selecione a Permissao'),
                                          sb,
                                          Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                      onSelected: (String s) {
                                        p.permissao = int.parse(s);
                                        userRef
                                            .document(p.id)
                                            .updateData(p.toJson())
                                            .then((value) {
                                          Navigator.of(context).pop();
                                          dToast('Permissão atualizada');
                                        });
                                      },
                                      itemBuilder: (context) {
                                        List<PopupMenuItem<String>> itens =
                                            new List();
                                        itens.add(PopupMenuItem(
                                          child: hText('Usuario', context),
                                          value: '0',
                                        ));
                                        itens.add(PopupMenuItem(
                                          child: hText('Anunciante', context),
                                          value: '5',
                                        ));
                                        itens.add(PopupMenuItem(
                                          child:
                                              hText('Administrador', context),
                                          value: '10',
                                        ));
                                        return itens;
                                      },
                                    ),
                                  );
                                });
                            break;
                        }
                      },
                      itemBuilder: (context) {
                        List<PopupMenuItem<String>> itens = new List();
                        itens.add(PopupMenuItem(
                          child: hText('Estatisticas', context),
                          value: 'estatisticas',
                        ));
                        itens.add(PopupMenuItem(
                          child: hText('Editar', context),
                          value: 'editar',
                        ));
                        itens.add(PopupMenuItem(
                          child: hText('Alterar Permissão', context),
                          value: 'alterar',
                        ));
                        return itens;
                      },
                      icon: Icon(Icons.more_vert))
                  : Container(),
            ],
          ),
        ),
      ]),
    );
  }
}
