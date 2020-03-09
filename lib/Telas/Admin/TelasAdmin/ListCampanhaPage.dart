import 'package:bocaboca/Objetos/Campanha.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Admin/TelasAdmin/CriarCampanhaPage.dart';
import 'package:bocaboca/Telas/Admin/TelasAdmin/ListaCarroUserPage.dart';
import 'package:bocaboca/Telas/Carro/EditarCarroPage.dart';
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

import 'ListCampanhaController.dart';
import 'ListaCarroController.dart';
import 'VisualizarCarroPage.dart';




class ListaCampanhaPage extends StatefulWidget {
  Carro carro;
  User user;
  Campanha campanha;
  ListaCampanhaPage({
    Key key,this.carro, this.user, this.campanha
  }) : super(key: key);

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
      appBar: myAppBar('Filtro por Campanha', context),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<Campanha>>(
              builder: (context, AsyncSnapshot<List<Campanha>> snapshot) {

                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Campanhas'));
                }
                if (snapshot.data.length == 0) {
                  return Loading(
                      completed: Text('Nenhuma Campanha encontrado'));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Campanha p = snapshot.data[index];

                      return CampanhaListItem( p);
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
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CriarCampanhaPage(
              campanha: p
            )));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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

          ],
        ),
      ),
    );
  }
}
