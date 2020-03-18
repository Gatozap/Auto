import 'package:bocaboca/Objetos/Carro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Equipamento.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:bocaboca/Telas/FichaPersonagem/BackgroundPage.dart';

import 'package:bocaboca/Telas/FichaPersonagem/EquiparPage.dart';
import 'package:bocaboca/Telas/FichaPersonagem/FichaPersonagemPage.dart';
import 'package:bocaboca/Telas/FichaPersonagem/PericiasPage.dart';
import 'package:bocaboca/Telas/FichaPersonagem/TalentoPage.dart';

import 'PersonagensController.dart';

class PersonagensListaPage extends StatefulWidget {
  PersonagensListaPage({
    Key key,
  }) : super(key: key);

  @override
  PersonagensListaPageState createState() {
    return PersonagensListaPageState();
  }
}

class PersonagensListaPageState extends State<PersonagensListaPage> {
  PersonagensController pc;
  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new PersonagensController();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Lista de Personagens', context),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<Personagem>>(
              builder: (context, AsyncSnapshot<List<Personagem>> snapshot) {

                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Personagem'));
                }
                if (snapshot.data.length == 0) {
                  return Loading(
                      completed: Text('Nenhum Personagem encontrado'));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Personagem p = snapshot.data[index];
                      return PersonagemListItem( p);
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              },
              stream: pc.outPersonagens,
            )
          ],
        ),
      ),
    );
  }

  Widget PersonagemListItem(Personagem p) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                  : Image(
                      image: AssetImage('assets/no_pic_character.png'),
                    )),
          Container(
            width: getLargura(context) * .4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: hText('${p.nome}', context,
                      size: 44, weight: FontWeight.bold),
                ),
                hText('Aventura: ${p.aventura}', context, size: 44),
                hText(
                  'Nível: ${p.nivel}',
                  context,
                  size: 44,
                  color: Colors.deepOrange,
                ),
                hText('Classe: ${p.classe}', context,
                    size: 44, color: Colors.blueAccent),
                sb
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      MdiIcons.viewList,
                      color: corPrimaria,
                    ),
                    tooltip: 'Ficha',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FichaPersonagemPage(
                                p: p,
                              )));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      MdiIcons.text,
                      color: corPrimaria,
                    ),
                    tooltip: 'Background',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BackgroundPage(
                                personagem: p,
                              )));
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      MdiIcons.script,
                      color: corPrimaria,
                    ),
                    tooltip: 'Pericias',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PericiasPage(
                                personagem: p,
                              )));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      MdiIcons.redhat,
                      color: corPrimaria,
                    ),
                    tooltip: 'Talentos',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TalentoPage(
                                personagem: p,
                              )));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      MdiIcons.account,
                      color: corPrimaria,
                    ),
                    tooltip: 'Equipamentos',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EquiparPage(
                                personagem: p,
                              )));
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
