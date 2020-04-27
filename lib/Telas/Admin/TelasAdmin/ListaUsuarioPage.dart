import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/VisualizarUserPage.dart';
import 'package:autooh/Telas/Carro/EditarCarroPage.dart';
import 'package:autooh/Telas/Perfil/PerfilController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';

import 'EstatisticaPage.dart';
import 'ListaCarroController.dart';
import 'VisualizarCarroPage.dart';

class ListaUsuarioPage  extends StatefulWidget {
  Carro carro;
  User user;
  Campanha campanha;
  ListaUsuarioPage({Key key, this.carro, this.user, this.campanha})
      : super(key: key);

  @override
  ListaUsuarioPageState createState() {
    return ListaUsuarioPageState();
  }
}

class ListaUsuarioPageState extends State<ListaUsuarioPage> {
  PerfilController  pc;
  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new PerfilController(widget.user);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  String selectedCategoria = 'Nenhuma';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Lista de Usuários', context,actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PopupMenuButton(
            onSelected: (String s) {
              selectedCategoria = s;
              pc.FilterByCategoria(selectedCategoria);
            },
            itemBuilder: (context) {
              return getCategoriasMenuButton();
            },
            initialValue: selectedCategoria,
            icon: Icon(Icons.filter_list, color: Colors.white),
          ),
        ),
      ],),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<User>>(
                stream: pc.outUsers,
                builder: (context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.data == null) {
                    return Loading(completed: Text('Erro ao Buscar Usuários'));
                  }

                  if (snapshot.data.length == 0) {
                    return Loading(completed: Text('Nenhum Usuário encontrado'));
                  }
                  return hText('Total de Usuários: ${snapshot.data.length}', context,) ;

                }),
            StreamBuilder<List<User>>(
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Usuário'));
                }

                if (snapshot.data.length == 0) {
                  return Loading(completed: Text('Nenhum Usuário encontrado'));
                }
                return Expanded(
                  child:  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      User p = snapshot.data[index];

                      return UsuarioList(p);

                    },
                    itemCount: snapshot.data.length,
                  ),

                );
              },
              stream: pc.outUsers,
            )
          ],
        ),
      ),
    );
  }

  Widget UsuarioList(User p) {
    return Stack(children: <Widget>[
      Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            CircleAvatar(
                radius: (((getAltura(context) + getLargura(context)) / 2) * .1),
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
            PopupMenuButton<String>(
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
                          builder: (context) => EstatisticaPage(user: p)));
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
                  return itens;
                },
                icon: Icon(Icons.more_vert))
          ],
        ),
      ),
    ]);

  }
  List<PopupMenuItem<String>> getCategoriasMenuButton() {
    {
      List<PopupMenuItem<String>> items = List();
      items.add(PopupMenuItem(value: 'Nenhuma', child: Text('Nenhuma')));
      items.add(PopupMenuItem(value: 'manha', child: Text('manha')));
      items.add(PopupMenuItem(value: 'tarde', child: Text('tarde')));
      items.add(PopupMenuItem(value: 'noite', child: Text('noite')));
      items.add(PopupMenuItem(value: 'atende_final_de_semana', child: Text('atende final de semana ')));
      items.add(PopupMenuItem(value: 'atende_festas', child: Text('atende festas')));
      return items;
    }
  }
}
