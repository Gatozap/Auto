import 'dart:convert';
import 'dart:io';



import 'package:bocaboca/Helpers/Bairros.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/PhotoScroller.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Campanha.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/Documento.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Objetos/Zona.dart';
import 'package:bocaboca/Telas/Admin/TelasAdmin/CampanhaController.dart';
import 'package:bocaboca/Telas/Cadastro/CadastroController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'CarroController.dart';

class EditarCarroPage extends StatefulWidget {
  User user;

  Carro carro;
  EditarCarroPage({Key key, this.user, this.carro}) : super(key: key);

  @override
  _EditarCarroPageState createState() => _EditarCarroPageState();
}

class _EditarCarroPageState extends State<EditarCarroPage> {
  @override
  void initState() {
    super.initState();
    if (carroController == null) {
      carroController = CarroController(carro: widget.carro);
    }

    if (userController == null) {
      userController = CadastroController();
    }


  }

  CadastroController cc = new CadastroController();
  Carro carro;
  var controllerConta_bancaria = new TextEditingController(text: '');
  var controllerDataNascimento =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerDataExpedicao =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerSenha = new TextEditingController(text: '');
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerCor = new TextEditingController(text: '');
  var controllerAno = new TextEditingController(text: '');
  var controllerModelo = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  var controllerPlaca = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  var controllerAgencia = new TextEditingController(text: '');
  var controllerKmmin = new TextEditingController(text: '');
  var controllerKmmax = new TextEditingController(text: '');

  var controllerNumero_conta = new TextEditingController(text: '');
  CarroController carroController;
  CampanhaController campanhaController;
  CadastroController userController;
  bool isPressed = false;
  bool onLoad = true;

  @override
  Widget build(BuildContext context) {


    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Color(0xFFE8F5E9),
          Color(0xFFE0F7FA),
        ],
      ),
    );
    return Scaffold(
      appBar: myAppBar(
          widget.carro == null ? 'Cadastrar Carro' : 'Editar Carro', context),
      body: Stack(children: <Widget>[
        Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.4,
            child: Container(
              decoration: linearGradient,
              height: getAltura(context),
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              child: Container(
                height: getAltura(context),
                child: StreamBuilder<Carro>(
                  stream: carroController.outCarroSelecionado,
                  builder: (context, AsyncSnapshot<Carro> snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: hText('vazio', context),
                      );
                    }
                    carro = snapshot.data;
                      
                    if (onLoad) {
                      controllerAno.text = carro.ano.toString();
                      controllerCor.text = carro.cor;
                      controllerModelo.text = carro.modelo;
                      controllerPlaca.text = carro.placa;

                      onLoad = false;
                    }
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: AlertDialog(
                                      title:
                                          hText("Selecione uma opção", context),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            defaultActionButton(
                                                'Galeria', context, () {
                                              getImage(carro);
                                              Navigator.of(context).pop();
                                            }, icon: MdiIcons.face),
                                            sb,
                                            defaultActionButton(
                                                'Camera', context, () {
                                              getImageCamera(carro);
                                              Navigator.of(context).pop();
                                            }, icon: MdiIcons.camera)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            child: CircleAvatar(
                                radius: (((getAltura(context) +
                                            getLargura(context)) /
                                        2) *
                                    .2),
                                backgroundColor: Colors.transparent,
                                child: carro.foto != null
                                    ? Image(
                                        image: CachedNetworkImageProvider(
                                            carro.foto),
                                      )
                                    : Image(
                                        image: CachedNetworkImageProvider(
                                            'https://images.vexels.com/media/users/3/155395/isolated/preview/3ced49c3448bede9f79d9d57bff35586-silhueta-de-vista-frontal-de-carro-esporte-by-vexels.png'),
                                      )),
                          ),
                          sb,
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: DefaultField(
                                controller: controllerModelo,
                                hint: 'Prisma',
                                context: context,
                                label: 'Modelo',
                                icon: Icons.directions_car,
                              ))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: DefaultField(
                                controller: controllerCor,
                                hint: 'Preto',
                                context: context,
                                label: 'Cor',
                                icon: Icons.color_lens,
                              ))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: DefaultField(
                                      controller: controllerAno,
                                      hint: '1990',
                                      context: context,
                                      label: 'Ano',
                                      icon: Icons.assignment,
                                      keyboardType: TextInputType.number))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: DefaultField(
                                controller: controllerPlaca,
                                hint: 'AAA-9999',
                                context: context,
                                label: 'Placa',
                                icon: MdiIcons.carBack,
                              ))
                            ],
                          ),
                          sb,
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FutureBuilder(
                                future: getDropDownMenuItemsCampanha(),
                                builder: (context, snapshot) {
                                  if(snapshot.data == null){
                                    return Container();
                                  }

                                  return DropdownButton(
                                    hint: Row(
                                      children: <Widget>[
                                        Icon(Icons.map, color: corPrimaria),
                                        sb,
                                        hText(
                                          'Selecione Campanha',
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
                                      if (c.zonas == null) {
                                        c.zonas = new List();
                                      }
                                      bool contains = false;


                                      if(carro == null){
                                        carro = new Carro();
                                      }
                                      if(carro.campanhas == null){
                                        carro.campanhas = new List();
                                      }
                                      if(carro.campanhas != null) {

                                        for (Campanha cc in carro
                                            .campanhas) {
                                          if (cc.nome == value.nome) {
                                            contains = true;
                                          }
                                        }
                                      }
                                      if(!contains) {
                                        carro.campanhas.add(c);
                                      }

                                      carroController.inCarroSelecionado.add(carro);

                                    },
                                  );
                                }
                            ),
                          ),
                          carro == null
                              ? Container()
                              : carro.campanhas == null
                              ? Container()
                              : carro.campanhas.length > 0
                              ? Container(
                            width: getLargura(context),
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              carro.campanhas.length,
                              scrollDirection:
                              Axis.horizontal,
                              itemBuilder: (context, index) {
                                print(
                                    'MONTANDO CHIP ${carro.campanhas[index]}');
                                return Padding(
                                  padding: const EdgeInsets
                                      .symmetric(
                                      horizontal: 8.0),
                                  child: MaterialButton(
                                    onLongPress: () {


                                    },
                                    onPressed: () {

                                     /* List<Zona> zonasTemp =
                                      new List();
                                      for (Campanha cc in carro
                                          .campanhas) {
                                        if (cc.nome !=
                                            c.zonas[index]
                                                .nome) {
                                          zonasTemp.add(z);
                                        }
                                      }
                                      c.zonas = zonasTemp;
                                      campanhaController
                                          .inCampanha
                                          .add(c);*/

                                    },
                                    child:
                                    Chip(
                                      label: hText(
                                          capitalize(carro.campanhas[index]
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
                              : Container(),
                           

                           seletorAnunciosCarro(),
                          Container(
                            child: defaultActionButton(
                                widget.carro == null
                                    ? 'Cadastrar'
                                    : 'Atualizar',
                                context, () {
                                     print(' aqui anuncio bancos ${carro.anuncio_bancos}');
                                carro.placa = controllerPlaca.text;
                                carro.ano = int.parse(controllerAno.text);
                                carro.modelo = controllerModelo.text;
                                carro.cor = controllerCor.text;
                                carro.dono_nome = Helper.localUser.nome;
                                carro.anuncio_laterais = carro == null? null : carro.anuncio_laterais;
                                carro.anuncio_bancos = carro == null? null : carro.anuncio_bancos;
                                carro.anuncio_traseira_completa = carro == null? null : carro.anuncio_traseira_completa;
                                carro.anuncio_vidro_traseiro = carro == null? null : carro.anuncio_vidro_traseiro;
                                 if(widget.carro == null) {
                                   carro.updated_at = DateTime.now();
                                 }else{
                                   carro = widget.carro;
                                 }
                                onLoad = true;
                                if (widget.carro != null) {
                                carroController.updateCarro(carro).then((v) {

                                    dToast('Dados atualizados com sucesso!');
                                    Navigator.of(context).pop();

                                });
                              }else {

                                  Carro c = new Carro(

                                    dono_nome: Helper.localUser.nome,
                                    created_at: DateTime.now(),
                                    updated_at: DateTime.now(),
                                    cor: controllerCor.text,
                                    ano: int.parse(
                                        controllerAno.text),
                                    placa: controllerPlaca.text,
                                    dono: Helper.localUser.id,
                                    modelo: controllerModelo
                                        .text,
                                    campanhas: carro == null?null: carro.campanhas,
                                  );



                                  carroController.CriarCarros(c).then((v){
                                    dToast('Carro Editado com Sucesso!');


                                    Navigator.of(context).pop();
                                  });
                                }
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ))
      ]),
    );
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
                              'https://lh3.googleusercontent.com/proxy/hjG4FSqIYkUVW6YQTtLeh3E5aXt2AyEjB62_TxhN3aJnpzI5bD4sEW6h8Pc1aQhA3ggGapOi3tQ6OIj3RGXRd-AsA37X8ok-z-GJzT0lZsJUx2vLQ3zxX3tP35GCrqeZErq0v9l37-ridvwEZjw'),
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
  ProgressDialog pr;

  Future getImageCamera(Carro carro) async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
    carro.foto = await uploadPicture(
      image.path,
    );
    carroController.updateCarro(carro);
    pr.dismiss();
    dToast('Salvando Foto!');
  }

  Future getImage(Carro carro) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Salvando',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .15,
          color: Colors.transparent,
        ));
    pr.show();
    carro.foto = await uploadPicture(
      image.path,
    );
    carroController.updateCarro(carro);
    pr.dismiss();
    dToast('Salvando Foto!');
  }
}
