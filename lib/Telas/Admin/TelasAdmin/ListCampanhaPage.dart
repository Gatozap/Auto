import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/CriarCampanhaPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaCarroUserPage.dart';
import 'package:autooh/Telas/Carro/EditarCarroPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';

import 'EstatisticaPage.dart';
import 'ListCampanhaController.dart';
import 'ListaCarroController.dart';
import 'VisualizarCarroPage.dart';

class ListaCampanhaPage extends StatefulWidget {
  Carro carro;
  User user;
  Campanha campanha;
  ListaCampanhaPage({Key key, this.carro, this.user, this.campanha})
      : super(key: key);

  @override
  ListaCampanhaPageState createState() {
    return ListaCampanhaPageState();
  }
}

class ListaCampanhaPageState extends State<ListaCampanhaPage> {
  ListaCampanhaController pc;
  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new ListaCampanhaController(campanha: widget.campanha);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Lista de Campanha', context),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<Campanha>>(
              stream: pc.outCampanhas,
              builder: (context, AsyncSnapshot<List<Campanha>> snapshot) {

                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Campanhas'));
                }
                if (snapshot.data.length == 0) {
                  return Loading(
                      completed: Text('Nenhuma Campanha encontrado'));
                }

                /* List<Campanha> campanhasItens = new List();
                for (Campanha p in snapshot.data) {
                  if(p.deleted_at == null) {
                    campanhasItens.add(p);
                  }
                }*/

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      Campanha p = snapshot.data[index];
                                 //if(p.datafim.isAfter(DateTime.now())) {
                                   return CampanhaListItem(p);
                                /* }else{
                                   return Container();
                                 }*/
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              },

            )
          ],
        ),
      ),
    );
  }

  Widget CampanhaListItem(Campanha p, {User pp}) {
    return GestureDetector(
      onTap: () {

      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            CircleAvatar(
                radius: (((getAltura(context) + getLargura(context)) / 2) * .1),
                backgroundColor: Colors.transparent,
                child: p.fotos != null
                    ? Image(
                        image: CachedNetworkImageProvider(p.fotos[0]),
                      )
                    : Image(
                        image: AssetImage('assets/autooh.png'),
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
                  hText('Empresa: ${p.empresa}', context, size: 44),
                  hText(
                    'CNPJ: ${p.cnpj}',
                    context,
                    size: 44,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (String s){
                switch(s){
                  case 'editar':
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CriarCampanhaPage(campanha: p)));
                    break;
                  case 'estatisticas':
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EstatisticaPage(campanha: p)));
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
    );
  }


}
