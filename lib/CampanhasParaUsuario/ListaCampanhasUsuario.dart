import 'package:autooh/CampanhasParaUsuario/VisualizarCampanhaUserPage.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListCampanhaController.dart';
import 'package:autooh/Telas/Carro/EditarCarroPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';


class ListaCampanhasUsuarioPage extends StatefulWidget {
  Carro carro;
  User user;
  Campanha campanha;
  ListaCampanhasUsuarioPage({Key key, this.carro, this.user, this.campanha})
      : super(key: key);

  @override
  ListaCampanhasUsuarioPageState createState() {
    return ListaCampanhasUsuarioPageState();
  }
}
ListaCampanhaController pc;
class ListaCampanhasUsuarioPageState extends State<ListaCampanhasUsuarioPage> {

  @override
  void initState() {
    super.initState();
     if(pc == null){
       pc = new ListaCampanhaController();
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
      appBar: myAppBar('Lista de Campanhas', context,actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),

        ),
      ],),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<Campanha>>(
              builder: (context, AsyncSnapshot<List<Campanha>> snapshot) {
                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Campanha'));
                }
                if (snapshot.data.length == 0) {
                  return Loading(completed: Text('Nenhum Campanha encontrada'));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Campanha p = snapshot.data[index];
      if(p.datafim.isAfter(DateTime.now())) {
        return CampanhaListItem(p);
      }
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              },
              stream: pc.outCampanhas,
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
                    case 'visualizar':
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VisualizarCampanhaUserPage(campanha: p)));
                      break;


                  }
                },
                itemBuilder: (context) {
                  List<PopupMenuItem<String>> itens = new List();
                  itens.add(PopupMenuItem(
                    child: hText('Visualizar Campanha', context),
                    value: 'visualizar',
                  ));
                
                  return itens;
                },
                icon: Icon(Icons.more_vert))
          ],
        ),
      ),
    );
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
}
