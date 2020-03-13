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
  Carro carro;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: myAppBar('${widget.carro.dono_nome}', context),

      body: StreamBuilder<Carro>(
        stream: carroController.outCarroSelecionado,
        builder: (context, snapshot) {
          carro = snapshot.data;
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




                
                Padding(   padding:
                const EdgeInsets.all(10.0),
                    child:
                    seletorAnunciosCarro()),
                Center(
                  child: Container(
                    child: defaultActionButton(

                        'Cadastrar Anúncios',
                        context, () {


                      carro.anuncio_laterais = carro == null? null : carro.anuncio_laterais;
                      carro.anuncio_bancos = carro == null? null : carro.anuncio_bancos;
                      carro.anuncio_traseira_completa = carro == null? null : carro.anuncio_traseira_completa;
                      carro.anuncio_vidro_traseiro = carro == null? null : carro.anuncio_vidro_traseiro;



                      carroController.updateCarro(carro).then((v) {

                        dToast('Dados atualizados com sucesso!');
                        Navigator.of(context).pop();

                      });

                    }),
                  ),
                ),
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
                    'Escolha as campanhas e suas respectivas posições', context, textaling: TextAlign.center),
              ),
              sb,sb,
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
                              'https://cdn.shopify.com/s/files/1/2809/6686/products/sz10523_grande.jpg?v=1533527533'),
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
                            child: FutureBuilder(
                                future: getDropDownMenuItemsCampanha(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Container();
                                  }
                                  if (carro == null) {
                                    carro = new Carro();
                                  }

                                  return DropdownButton(
                                    hint: Row(
                                      children: <Widget>[
                                        sb,
                                        hText(
                                          carro.anuncio_bancos == null
                                              ? 'Anuncios nos bancos'
                                              : carro.anuncio_bancos.nome,
                                          context,
                                          size: 40,
                                          color: corPrimaria,
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        color: corPrimaria,
                                        fontSize:
                                        ScreenUtil.getInstance().setSp(40),
                                        fontWeight: FontWeight.bold),
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: corPrimaria),
                                    items: snapshot.data,
                                    onChanged: (value) {
                                      Campanha c = value;
                                      if (c == null) {
                                        c = Campanha();
                                      }

                                      if (carro == null) {
                                        carro = new Carro();
                                      }

                                      carro.anuncio_bancos = value;

                                      carroController.inCarroSelecionado
                                          .add(carro);
                                    },
                                  );
                                }),
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
                            child: FutureBuilder(
                                future: getDropDownMenuItemsCampanha(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Container();
                                  }
                                  if (carro == null) {
                                    carro = new Carro();
                                  }

                                  return DropdownButton(
                                    hint: Row(
                                      children: <Widget>[
                                        sb,
                                        hText(
                                          carro.anuncio_laterais == null
                                              ? 'Anuncios nas laterais'
                                              : carro.anuncio_laterais.nome,
                                          context,
                                          size: 40,
                                          color: corPrimaria,
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        color: corPrimaria,
                                        fontSize:
                                        ScreenUtil.getInstance().setSp(40),
                                        fontWeight: FontWeight.bold),
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: corPrimaria),
                                    items: snapshot.data,
                                    onChanged: (value) {
                                      Campanha c = value;
                                      if (c == null) {
                                        c = Campanha();
                                      }

                                      if (carro == null) {
                                        carro = new Carro();
                                      }

                                      carro.anuncio_laterais = value;

                                      carroController.inCarroSelecionado
                                          .add(carro);
                                    },
                                  );
                                }),
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
                            child: FutureBuilder(
                                future: getDropDownMenuItemsCampanha(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Container();
                                  }
                                  if (carro == null) {
                                    carro = new Carro();
                                  }

                                  return DropdownButton(
                                    hint: Row(
                                      children: <Widget>[
                                        sb,
                                        hText(
                                          carro.anuncio_traseira_completa == null
                                              ? 'Anuncios na Traseira'
                                              : carro
                                              .anuncio_traseira_completa.nome,
                                          context,
                                          size: 40,
                                          color: corPrimaria,
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        color: corPrimaria,
                                        fontSize:
                                        ScreenUtil.getInstance().setSp(40),
                                        fontWeight: FontWeight.bold),
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: corPrimaria),
                                    items: snapshot.data,
                                    onChanged: (value) {
                                      Campanha c = value;
                                      if (c == null) {
                                        c = Campanha();
                                      }

                                      if (carro == null) {
                                        carro = new Carro();
                                      }

                                      carro.anuncio_traseira_completa = value;

                                      carroController.inCarroSelecionado
                                          .add(carro);
                                    },
                                  );
                                }),
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
                              'https://images.tcdn.com.br/img/img_prod/372162/112_1_20140325180457.jpg'),
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
                            child: FutureBuilder(
                                future: getDropDownMenuItemsCampanha(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Container();
                                  }
                                  if (carro == null) {
                                    carro = new Carro();
                                  }

                                  return DropdownButton(
                                    hint: Row(
                                      children: <Widget>[
                                        sb,
                                        hText(
                                          carro.anuncio_vidro_traseiro == null
                                              ? 'Vidro Traseiro'
                                              : carro.anuncio_vidro_traseiro.nome,
                                          context,
                                          size: 40,
                                          color: corPrimaria,
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        color: corPrimaria,
                                        fontSize:
                                        ScreenUtil.getInstance().setSp(40),
                                        fontWeight: FontWeight.bold),
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: corPrimaria),
                                    items: snapshot.data,
                                    onChanged: (value) {
                                      Campanha c = value;
                                      if (c == null) {
                                        c = Campanha();
                                      }

                                      if (carro == null) {
                                        carro = new Carro();
                                      }

                                      carro.anuncio_vidro_traseiro = value;

                                      carroController.inCarroSelecionado
                                          .add(carro);
                                    },
                                  );
                                }),
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