import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Telas/Carro/EditarCarroPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';

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

  String selectedCategoria = 'Nenhuma';
  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Lista de Carros', context, ),
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
                    : 
                Image(image: AssetImage('assets/carro_foto.png'))),
            sb,
            Container(
              width: getLargura(context)*.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.carSide, size: 20, color: Colors.blue,), sb,sb,
                        hText('Modelo: ${p.modelo}', context,
                            size: 44, weight: FontWeight.bold),
                      ],
                    ),
                  ),SizedBox(height: 2,),
                  Row(

                    children: <Widget>[
                     Container(
                          width: 30, height: 30,
                         child: Image(image: AssetImage('assets/placa_veiculo.png'),)),sb,
                      hText('Placa: ${p.placa}', context, size: 44),
                    ],
                  ),SizedBox(height: 2,),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.palette, color: Colors.blue, size: 20,), sb,sb,
                      hText(
                        'Cor: ${p.cor}',
                        context,
                        size: 44,
                      ),
                    ],
                  ),SizedBox(height: 2,),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.calendar, color: Colors.blue, size: 20),sb,sb,
                      hText('Ano: ${p.ano}', context,
                          size: 44, color: Colors.blueAccent),
                    ],
                  ),
                  sb
                ],
              ),
            ),
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
      items.add(PopupMenuItem(value: 'vidro_traseiro', child: Text('Vidro Traseiro')));
      return items;
    }
  }
}
