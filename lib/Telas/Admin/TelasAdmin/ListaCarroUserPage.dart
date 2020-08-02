import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Carro/EditarCarroPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/VisualizarUserPage.dart';
import 'EstatisticaPage.dart';
import 'ListaCarroController.dart';
import 'VisualizarCarroPage.dart';

class ListaCarroUserPage extends StatefulWidget {
  Carro carro;
  User user;
  Campanha campanha;
  ListaCarroUserPage({Key key, this.carro, this.user, this.campanha})
      : super(key: key);

  @override
  ListaCarroUserPageState createState() {
    return ListaCarroUserPageState();
  }
}

class ListaCarroUserPageState extends State<ListaCarroUserPage> {
  ListaCarroController pc;
  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new ListaCarroController();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  var searchController = TextEditingController();
  FocusNode myFocusNode;
  String selectedCategoria = 'Nenhuma';

  String selectedCidade = 'Todos';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        'Lista de Carros',
        context,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              onSelected: (String s) {
                selectedCidade = s;
                pc.FilterByCidade(selectedCidade);
              },
              itemBuilder: (context) {
                return getCidadesMenuButton();
              },
              initialValue: selectedCidade,
              icon: Icon(MdiIcons.city, color: Colors.yellowAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              onSelected: (var s) {
                pc.FilterByHorarios();
              },
              itemBuilder: (context) {
                return getHorariosMenuButton();
              },
              initialValue: {},
              icon: Icon(MdiIcons.clock, color: Colors.yellowAccent),
            ),
          ),
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
              icon: Icon(Icons.filter_list, color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 35,
                child: TextFormField(
                    onTap: () {},
                    onChanged: (s) {
                      pc.inSearchText.add(s);
                      pc.FilterByNome(s);
                    },
                    validator: (s) {
                      return null;
                    },
                    scrollPadding: EdgeInsets.all(5),
                    controller: searchController,
                    focusNode: myFocusNode,
                    onFieldSubmitted: (s) {
                      pc.inSearchText.add(s);
                      pc.FilterByNome(s);
                      myFocusNode.unfocus();
                    },
                    autofocus: false,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                        //isCollapsed: true,
                        hintText: 'Procurando alguém?',
                        contentPadding: new EdgeInsets.fromLTRB(8, 8, 4, 8),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              StreamBuilder(
                                  stream: pc.outSearchText,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == '0') {
                                      return Container();
                                    }
                                    return Container(
                                      child: MaterialButton(
                                        onPressed: () {
                                          pc.inSearchText.add('0');
                                          searchController.text = '';
                                          myFocusNode.unfocus();
                                        },
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                        ),
                                        elevation: 0,
                                        padding: EdgeInsets.all(0),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                      ),
                                      height: 25,
                                      width: 25,
                                    );
                                  })
                            ])))),
            SizedBox(
              width: 5,
            ),
            StreamBuilder<List<Carro>>(
                stream: pc.outCarros,
                builder: (context, AsyncSnapshot<List<Carro>> snapshot) {
                  if (snapshot.data == null) {
                    return Loading(completed: Text('Erro ao Buscar Carros'));
                  }

                  if (snapshot.data.length == 0) {
                    return Loading(completed: Text('Nenhum Carro encontrado'));
                  }
                  return hText(
                    'Total de Carros: ${snapshot.data.length}',
                    context,
                  );
                }),
            StreamBuilder<List<Carro>>(
              builder: (context, AsyncSnapshot<List<Carro>> snapshot) {
                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Carros'));
                }

                if (snapshot.data.length == 0) {
                  return Loading(completed: Text('Nenhum Carro encontrado'));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Carro p = snapshot.data[index];

                      return CarroListItem(p);
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              },
              stream: pc.outCarros,
            )
          ],
        ),
      ),
    );
  }

  Widget CarroListItem(Carro p, {User pp}) {

    if(pc.users != null) {
      for (User u in pc.users) {
        if (u.id == p.dono) {
          pp = u;
        }
      }
    }
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
                    : Image.asset(
                        'assets/carro_foto.png',
                      )),
            Container(
              width: getLargura(context) * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Helper.localUser.permissao == 5? Container():Container(
                    child: hText('${p.modelo}', context,
                        size: 44, weight: FontWeight.bold),
                  ),
                  hText('Placa: ${p.placa}', context, size: 44),
                  Helper.localUser.permissao == 5? Container():pp == null
                      ? Container()
                      : hText('Dono: ${pp.nome}', context, size: 44),
                  Helper.localUser.permissao == 5? Container():hText(
                    'Cor: ${p.cor}',
                    context,
                    size: 44,
                  ),
                  Helper.localUser.permissao == 5? Container():hText('Ano: ${p.ano}', context,
                      size: 44, color: Colors.blueAccent),
                ],
              ),
            ),
            Helper.localUser.permissao == 5? Container():PopupMenuButton<String>(
                onSelected: (String s) {
                  switch (s) {
                    case 'Ver Motorista':
                      for (User u in pc.users) {
                        if (u.id == p.dono) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VisualizarUserPage(
                                    user: u,
                                  )));
                        }
                      }
                      break;
                    case 'editar':
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VisualizarCarroPage(
                                carro: p,
                                user: pp,
                              )));
                      break;
                    case 'estatisticas':
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EstatisticaPage(carro: p)));
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
                    child: hText('Ver Motorista', context),
                    value: 'Ver Motorista',
                  ));
                  return itens;
                },
                icon: Icon(Icons.more_vert)),
            /*IconButton(
              color: Colors.red,
              icon: Icon(Icons.remove),
              onPressed: () {
                carrosRef.document(p.id).delete();
              },
            ),*/
          ],
        ),
      ),
    ]);
  }

  List<PopupMenuItem<String>> getCategoriasMenuButton() {
    {
      List<PopupMenuItem<String>> items = List();
      items.add(PopupMenuItem(value: 'Nenhuma', child: Text('Nenhuma')));
      items.add(PopupMenuItem(value: 'lateral', child: Text('Lateral')));
      items.add(PopupMenuItem(value: 'banco', child: Text('Banco')));
      items.add(PopupMenuItem(value: 'traseira', child: Text('Traseira')));
      items.add(PopupMenuItem(
          value: 'vidro_traseiro', child: Text('Vidro Traseiro')));
      return items;
    }
  }

  List<PopupMenuItem> getHorariosMenuButton() {
    List<PopupMenuItem> items = List();
    items.add(PopupMenuItem(
        value: pc.horarios[0],
        child: StreamBuilder(
            stream: pc.outHorarios,
            builder: (context, horarios) {
              return defaultCheckBox(
                  horarios.data[0]['manha'], 'Manha', context, () {
                print("CLICK LALAL");
                horarios.data[0]['manha'] = !horarios.data[0]['manha'];
                pc.horarios = horarios.data;
                pc.inHorarios.add(horarios.data);
                pc.FilterByHorarios();
              });
            })));
    items.add(PopupMenuItem(
        value: pc.horarios[1],
        child: StreamBuilder(
            stream: pc.outHorarios,
            builder: (context, horarios) {
              return defaultCheckBox(
                  horarios.data[1]['tarde'], 'Tarde', context, () {
                print("CLICK LALAL");
                horarios.data[1]['tarde'] = !horarios.data[1]['tarde'];
                pc.horarios = horarios.data;
                pc.inHorarios.add(horarios.data);
                pc.FilterByHorarios();
              });
            })));
    items.add(PopupMenuItem(
        value: pc.horarios[2],
        child: StreamBuilder(
            stream: pc.outHorarios,
            builder: (context, horarios) {
              return defaultCheckBox(
                  horarios.data[2]['noite'], 'Noite', context, () {
                print("CLICK LALAL");
                horarios.data[2]['noite'] = !horarios.data[2]['noite'];
                pc.horarios = horarios.data;
                pc.inHorarios.add(horarios.data);
                pc.FilterByHorarios();
              });
            })));
    return items;
  }

  List<PopupMenuItem<String>> getCidadesMenuButton() {
    List<PopupMenuItem<String>> items = List();
    items.add(PopupMenuItem(value: 'Todos', child: Text('Todos')));
    items.add(PopupMenuItem(
        value: 'Aparecida de Goiânia', child: Text('Aparecida de Goiânia')));
    items.add(PopupMenuItem(value: 'Goiânia', child: Text('Goiânia')));
    return items;
  }
}
