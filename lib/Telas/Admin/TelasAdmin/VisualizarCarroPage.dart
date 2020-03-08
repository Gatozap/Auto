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
      carroController = new CarroController(carro:  widget.carro);
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
    return Scaffold(appBar: myAppBar('${widget.carro.dono_nome}', context),

      body: StreamBuilder<Carro>(
        stream: carroController.outCarroSelecionado,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: hText('Dono: ${widget.carro.dono_nome}', context)),
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
                
                Padding(   padding:
                const EdgeInsets.all(10.0),
                    child:
                    seletorAnunciosCarro()),

              ],),
          );
        }
      ),);
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

  Widget seletorAnunciosCarro() {
    return StreamBuilder(
      stream: carroController.outCarroSelecionado,
      builder: (context, car) {
        Carro carro = car.data;
        if (car.data == null) {
          carro = new Carro();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                child: hText(
                    'Anuncios nos bancos', context, textaling: TextAlign.center),
              ),
              sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              'https://http2.mlstatic.com/capa-banco-carro-D_NQ_NP_625021-MLB20699986131_052016-F.jpg'),
                          fit: BoxFit.cover),
                      border: carro.anuncio_bancos == null
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(child: carro.anuncio_bancos == null ? Container(child: hText('Sem Anúncio', context)):hText('${carro.anuncio_bancos.nome}', context),)
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              'https://images.vexels.com/media/users/3/145586/isolated/preview/8f11dbfb5ce1e294f79a0f9aea6b36bf-silhueta-de-vista-lateral-de-carro-de-cidade-by-vexels.png'),
                          fit: BoxFit.cover),
                      border: carro.anuncio_laterais == null
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(child: carro.anuncio_laterais == null? Container(child: hText('Sem Anúncio', context)):hText('${carro.anuncio_laterais.nome}', context),)
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              'https://images.vexels.com/media/users/3/145707/isolated/preview/d3c27524358f5186c045e7f03d1f8d8e-silhueta-de-vista-traseira-de-hatchback-by-vexels.png'),
                          fit: BoxFit.cover),
                      border: carro.anuncio_traseira_completa == null
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(child: carro.anuncio_traseira_completa==null? Container(child: hText('Sem Anúncio', context)):hText('${carro.anuncio_traseira_completa.nome}', context),)
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              'https://lh3.googleusercontent.com/proxy/e6MtotEzLXKCXlLTrlcXb8fF_SHWFkBjXnOGA4BAunHB_eDmns-MDEdLHihluBKfP75oA-khquXAuKYMMnDvHpNWVTBjEbuux9-z-dCApKuIx4gXca8LuajyK3Ax51ZQFhc47GC2WhkK7rRb'),
                          fit: BoxFit.cover),
                      border: carro.anuncio_vidro_traseiro == null
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(child: carro.anuncio_vidro_traseiro == null? Container(child: hText('Sem Anúncio', context)):hText('${carro.anuncio_vidro_traseiro.nome}', context),)
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}