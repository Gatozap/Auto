import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Campanha.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Carro/CarroController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisualizarCarroPage extends StatefulWidget {
  Carro carro;
  User user;
  VisualizarCarroPage({Key key, this.carro, this.user}) : super(key: key);

  @override
  _VisualizarCarroPageState createState() {
    return _VisualizarCarroPageState();
  }
}

class _VisualizarCarroPageState extends State<VisualizarCarroPage> {
  @override
  void initState() {
    if(carroController == null){
      carroController = new CarroController();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
    CarroController carroController;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: myAppBar('Carro de ', context),

      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: widget.carro.id,
                child: widget.carro.foto != null
                    ? CircleAvatar(
                    radius: ScreenUtil.getInstance().setSp(200),
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                    CachedNetworkImageProvider(widget.carro.foto))
                    : CircleAvatar(
                    radius: ScreenUtil.getInstance().setSp(200),
                    backgroundColor: Colors.transparent,
                    child: Image(
                      image: CachedNetworkImageProvider(
                          'https://images.vexels.com/media/users/3/155395/isolated/preview/3ced49c3448bede9f79d9d57bff35586-silhueta-de-vista-frontal-de-carro-esporte-by-vexels.png'),
                    )),

              ),

            ],
          ),
          Padding(padding: EdgeInsets.all(8.0),
              child: hText('Modelo: ${widget.carro.modelo}', context)),
          Padding(padding: EdgeInsets.all(8.0),
              child: hText('Cor: ${widget.carro.cor}', context)),
          Padding(padding: EdgeInsets.all(8.0),
              child: hText('Ano: ${widget.carro.ano}', context)),
          Padding(padding: EdgeInsets.all(8.0),
              child: hText('Placa: ${widget.carro.placa}', context)),

          Padding(
            padding: const EdgeInsets.only(top:15.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[hText('Campanhas', context, color: corPrimaria)],),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 5.0),
            child: FutureBuilder(
                future: getDropDownMenuItemsCampanha(),
                builder: (context, snapshot) {
                  if(snapshot.data == null){
                    return Container();
                  }

                  return   widget.carro == null
                      ? Container()
                      : widget.carro.campanhas == null
                      ? Container()
                      : widget.carro.campanhas.length > 0
                      ? Container(
                    width: getLargura(context),
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                      widget.carro.campanhas.length,
                      scrollDirection:
                      Axis.horizontal,
                      itemBuilder: (context, index) {
                        print(
                            'MONTANDO CHIP ${widget.carro.campanhas[index]}');
                        return Padding(
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal: 8.0),
                          child: Container(

                            child: Chip(
                              label: hText(
                                  capitalize(widget.carro.campanhas[index]
                                      .nome),
                                  context,
                                  color:
                                  Colors.white),
                              backgroundColor:
                              corPrimaria,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Container();
                }
            ),
          ),


        ],),);
  }
  Future <List<DropdownMenuItem<Campanha>>> getDropDownMenuItemsCampanha() {
    List<DropdownMenuItem<Campanha>> items = List();
    return campanhasRef.where('datafim',isGreaterThan: DateTime.now().millisecondsSinceEpoch).getDocuments().then((v){
      List campanhas = new List();
      for(var d in v.documents){
        campanhas.add(Campanha.fromJson(d.data));
      }
      for (Campanha z in campanhas) {
        items.add(DropdownMenuItem(value: z, child: Text('${z.nome}')));

      }
      return items;
    }
    ).catchError((err) {
      print('aqui erro 1 ${err}');
      return null;
    });
  }
}