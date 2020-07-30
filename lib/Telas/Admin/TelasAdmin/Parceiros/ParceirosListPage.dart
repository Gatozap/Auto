import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/Agendamento/AgendamentoPage.dart';
import 'package:autooh/Telas/Admin/Agendamento/agendamento_list_page.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Parceiros/parceiros_cadastrar_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ParceirosBloc.dart';

class ParceirosListPage extends StatefulWidget {
  Campanha campanha;
  Parceiro parceiro;
  ParceirosListPage({Key key, this.campanha, Parceiro this.parceiro})
      : super(key: key);

  @override
  ParceirosListPageState createState() {
    return ParceirosListPageState();
  }
}

class ParceirosListPageState extends State<ParceirosListPage> {
  ParceirosBloc pc;

  User id_usuario;
  Carro id_carro;
  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new ParceirosBloc(widget.campanha);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Locais de instalação', context),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<Parceiro>>(
              builder: (context, AsyncSnapshot<List<Parceiro>> snapshot) {
                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Parceiros'));
                }
                if (snapshot.data.length == 0) {
                  return Loading(completed: Text('Nenhum Parceiro encontrado'));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      Parceiro p = snapshot.data[index];
                      if (p.deleted_at == null) {
                        return ParceirosList(p);
                      } else {
                        return Container();
                      }
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              },
              stream: pc.outParceiros,
            )
          ],
        ),
      ),
    );
  }

  Widget ParceirosList(Parceiro p) {
    return StreamBuilder<Parceiro>(
        stream: pc.outParceiroSelecionado,
        builder: (context, snapshot) {
          Parceiro parceiros = snapshot.data;
          if (parceiros == null) {
            parceiros = new Parceiro();
          }
          if (parceiros == null) {
            return Container(
              child: Text('erro ao buscar'),
            );
          }
          return GestureDetector(
            onTap: () {
              if (widget.campanha != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AgendamentoPage(
                        campanha: widget.campanha, parceiro: p)));
              } else {}
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: p.foto != null
                            ? Image(
                                image: CachedNetworkImageProvider(p.foto),
                              )
                            : Image(
                                image:
                                    AssetImage('assets/campanha_sem_foto.png'),
                              )),
                  ),
                  Container(
                    width: getLargura(context) * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        sb,
                        Container(
                          child: hText('${p.nome}', context,
                              size: 44, weight: FontWeight.bold),
                        ),
                        sb,
                        hText(
                          '${p.telefone}',
                          context,
                          size: 44,
                        ),
                        sb,
                        hText('Endereço: ${p.endereco.endereco}', context,
                            size: 40),
                        hText(
                          'Abre: ${p.hora_ini.hour}:${p.hora_ini.minute}',
                          context,
                          size: 44,
                        ),
                        hText(
                          'Fecha: ${p.hora_fim.hour}:${p.hora_fim.minute}',
                          context,
                          size: 44,
                        ),
                        sb,
                      ],
                    ),
                  ),
                  Helper.localUser.permissao == 10
                      ? PopupMenuButton<String>(
                          onSelected: (String s) {
                            switch (s) {
                              case 'instalacoes':
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AgendamentoListPage(parceiro: p)));
                                break;
                              case 'editar':
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ParceirosCadastrarPage(parceiro: p)));
                                break;

                              case 'deletar':
                                p.deleted_at = DateTime.now();
                                parceirosRef
                                    .document(p.id)
                                    .updateData(p.toJson())
                                    .then((d) {
                                  print('Deletado com sucesso com sucesso');
                                  dToast('Deletado com sucesso com sucesso');
                                }).catchError((err) {
                                  print('Error: ${err}');
                                  return err;
                                });
                                break;
                            }
                          },
                          itemBuilder: (context) {
                            List<PopupMenuItem<String>> itens = new List();
                            itens.add(PopupMenuItem(
                              child: hText('Instalações', context),
                              value: 'instalacoes',
                            ));
                            itens.add(PopupMenuItem(
                              child: hText('Editar', context),
                              value: 'editar',
                            ));
                            itens.add(PopupMenuItem(
                              child: hText('Deletar', context),
                              value: 'deletar',
                            ));
                            return itens;
                          },
                          icon: Icon(Icons.more_vert))
                      : PopupMenuButton<String>(
                          onSelected: (String s) {
                            switch (s) {
                              case 'agendar':
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AgendamentoPage()));
                                break;
                            }
                          },
                          itemBuilder: (context) {
                            List<PopupMenuItem<String>> itens = new List();

                            itens.add(PopupMenuItem(
                              child: hText('Agendar', context),
                              value: 'agendar',
                            ));

                            return itens;
                          },
                          icon: Icon(
                            Icons.more_vert,
                          ))
                ],
              ),
            ),
          );
        });
  }
}
