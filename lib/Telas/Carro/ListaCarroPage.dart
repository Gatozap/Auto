import 'package:bocaboca/Objetos/Carro.dart';
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

import 'CarroController.dart';

class ListaCarroPage extends StatefulWidget {
  Carro carro;
  ListaCarroPage({
    Key key,
    this.carro,
  }) : super(key: key);

  @override
  ListaCarroPageState createState() {
    return ListaCarroPageState();
  }
}

class ListaCarroPageState extends State<ListaCarroPage> {
  CarroController pc;
  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new CarroController();
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
                  return Loading(completed: Text('Nenhum Carro encontrado'));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      Carro p = snapshot.data[i];
                      if (p.deleted_at == null) {
                        return CarroListItem(p);
                      } else {
                        return Container();
                      }
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

  Widget CarroListItem(Carro p) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditarCarroPage(carro: p)));
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
                child: p.foto != null
                    ? Image(
                        image: CachedNetworkImageProvider(p.foto),
                      )
                    : Image(
                        image: CachedNetworkImageProvider(
                            'https://images.vexels.com/media/users/3/155395/isolated/preview/3ced49c3448bede9f79d9d57bff35586-silhueta-de-vista-frontal-de-carro-esporte-by-vexels.png'),
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
                  sb
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
