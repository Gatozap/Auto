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

import 'ListaCarroController.dart';
import 'VisualizarCarroPage.dart';




class ListaCarroUserPage extends StatefulWidget {
  Carro carro;
  User user;
  Campanha campanha;
  ListaCarroUserPage({
    Key key,this.carro, this.user, this.campanha
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: myAppBar('Lista de Carros', context),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<Carro>>(
              builder: (context, AsyncSnapshot<List<Carro>> snapshot) {

                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Carros'));
                }
                if (snapshot.data.length == 0) {
                  return Loading(
                      completed: Text('Nenhum Carro encontrado'));
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
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VisualizarCarroPage(
                carro: p, user: pp,
            )));
      },
      child: Stack(
        children:<Widget>[ Card(
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
                    image: CachedNetworkImageProvider('https://images.vexels.com/media/users/3/155395/isolated/preview/3ced49c3448bede9f79d9d57bff35586-silhueta-de-vista-frontal-de-carro-esporte-by-vexels.png'),
                  )),
              Container(
                width: getLargura(context) * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: hText('${p.modelo}', context,
                          size: 44, weight: FontWeight.bold),
                    ),
                    hText('Placa: ${p.placa}', context, size: 44),
                    hText(
                      'Cor: ${p.cor}',
                      context,
                      size: 44,

                    ),
                    hText('Ano: ${p.ano}', context,
                        size: 44, color: Colors.blueAccent),

                  ],
                ),

              ),

            ],
          ),
        ),]
      ),
    );
  }
}
