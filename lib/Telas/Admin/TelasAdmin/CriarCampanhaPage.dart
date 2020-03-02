import 'dart:io';

import 'package:bocaboca/Helpers/Bairros.dart';
import 'package:bocaboca/Helpers/DateSelector.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Bairro.dart';
import 'package:bocaboca/Objetos/Zona.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:short_stream_builder/short_stream_builder.dart';
import 'package:bocaboca/Objetos/Campanha.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Telas/Admin/TelasAdmin/CampanhaController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CriarCampanhaPage extends StatefulWidget {
  Campanha campanha;
  Zona zonas;
  CriarCampanhaPage({this.campanha, this.zonas});

  @override
  _CriarCampanhaPageState createState() {
    return _CriarCampanhaPageState();
  }
}

CampanhaController campanhaController;
var controllerEmpresa = new TextEditingController(text: '');
var controllerNome = new TextEditingController(text: '');
var controllerCNPJ =
    new MaskedTextController(text: '', mask: '00.000.000/0000-00');
var controllerLimite = new TextEditingController(text: '');
Campanha campanha;

BasicDateTimeField datainiField = BasicDateTimeField(
    label: 'Data de Início', icon: FontAwesomeIcons.solidCalendarPlus);
BasicDateTimeField datafimField = BasicDateTimeField(
    label: 'Data de Fim', icon: FontAwesomeIcons.solidCalendarPlus);

class _CriarCampanhaPageState extends State<CriarCampanhaPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (campanhaController == null) {
      campanhaController = CampanhaController(campanha: widget.campanha);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('aqui é campanha ${widget.campanha}');

    // TODO: implement build
    return Scaffold(
        appBar: myAppBar('Criar Campanha', context, showBack: true),
        body: Container(
            child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: campanhaController.outCampanha,
                    builder: (context, AsyncSnapshot snap) {
                      campanha = snap.data;
                      return Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(children: <Widget>[
                                    campanha != null
                                        ? campanha.fotos != null
                                            ? campanha.fotos.length != 1
                                                ? Swiper(
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        child: campanha
                                                                .fotos[index]
                                                                .contains(
                                                                    'http')
                                                            ? Image(
                                                                image: CachedNetworkImageProvider(
                                                                    campanha.fotos[
                                                                        index]),
                                                                height: 200,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                width: 300)
                                                            : Image.file(
                                                                File(campanha
                                                                        .fotos[
                                                                    index]),
                                                                height: 200,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                width: 300),
                                                        height: 200,
                                                        width: 300,
                                                      );
                                                    },
                                                    itemHeight: 200,
                                                    itemWidth: 300,
                                                    containerWidth: 300,
                                                    itemCount:
                                                        campanha.fotos.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    pagination:
                                                        new SwiperPagination(),
                                                    control:
                                                        new SwiperControl(),
                                                  )
                                                : Container(
                                                    child: Center(
                                                        child: campanha.fotos[0]
                                                                .contains(
                                                                    'http')
                                                            ? Image(
                                                                image: CachedNetworkImageProvider(
                                                                    campanha
                                                                        .fotos[0]),
                                                                height: 200,
                                                              )
                                                            : Image.file(File(
                                                                campanha.fotos[
                                                                    0]))))
                                            : Image.asset(
                                                'assets/images/nutrannoLogo.png',
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              )
                                        : Image.asset(
                                            'assets/images/nutrannoLogo.png',
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                    Center(
                                      child: MaterialButton(
                                        child: Icon(
                                          MdiIcons.cameraOutline,
                                          color: Colors.white,
                                        ),
                                        color: Colors.transparent,
                                        onPressed: () {
                                          getImage(campanha);
                                        },
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                color: Colors.transparent)),
                                      ),
                                    )
                                  ])),
                              DefaultField(
                                  controller: controllerEmpresa,
                                  hint: 'RBSoftware',
                                  context: context,
                                  label: 'Nome Empresa',
                                  icon: FontAwesomeIcons.adn,
                                  validator: (v) {},
                                  keyboardType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  onSubmited: (s) {}),
                              DefaultField(
                                  controller: controllerNome,
                                  hint: 'Campanha seja feliz!',
                                  context: context,
                                  label: 'Nome da Campanha',
                                  icon: FontAwesomeIcons.adn,
                                  validator: (v) {},
                                  keyboardType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  onSubmited: (s) {}),
                              DefaultField(
                                  controller: controllerCNPJ,
                                  hint: '00.000.000/0000-00',
                                  context: context,
                                  label: 'CNPJ',
                                  icon: FontAwesomeIcons.atlas,
                                  validator: (v) {},
                                  keyboardType: TextInputType.number,
                                  onSubmited: (s) {}),
                              datainiField,
                              datafimField,
                              DefaultField(
                                  controller: controllerLimite,
                                  hint: '100',
                                  context: context,
                                  label: 'Limite de Carros',
                                  icon: FontAwesomeIcons.car,
                                  validator: (v) {},
                                  keyboardType: TextInputType.number,
                                  onSubmited: (s) {}),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: DropdownButton(
                                  hint: Row(
                                    children: <Widget>[
                                      Icon(Icons.map, color: corPrimaria),
                                      sb,
                                      hText(
                                        'Selecione as Zonas da Campanha',
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
                                  items: getDropDownMenuItemsCampanha(),
                                  onChanged: (value) {
                                    Campanha c = snap.data;
                                    if (c == null) {
                                      c = Campanha();
                                    }
                                    if (c.zonas == null) {
                                      c.zonas = new List();
                                    }
                                     bool contains = false;
                                       for(Zona z in c.zonas){
                                         if(z.nome == value.nome){
                                           contains = true;
                                         }
                                       }
                                    if(!contains) {
                                      c.zonas.add(value);
                                    }
                                    print(
                                        "AQUI QUANTAS ZONAS ${c.zonas.length}");
                                    campanhaController.inCampanha.add(c);
                                  },
                                ),
                              ),
                              snap.data == null
                                  ? Container()
                                  : snap.data.zonas == null
                                      ? Container()
                                      : snap.data.zonas.length > 0
                                          ? Container(
                                              width: getLargura(context),
                                              height: 100,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    snap.data.zonas.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  print(
                                                      'MONTANDO CHIP ${snap.data.zonas[index]}');
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: MaterialButton(
                                                      onLongPress: () {
                                                        String s = 'Zonas: ';
                                                        for (Bairro b in snap
                                                            .data
                                                            .zonas[index]
                                                            .bairros) {
                                                          s += capitalize(
                                                                  b.bairro) +
                                                              ', ';
                                                        }
                                                        s = s.substring(
                                                            0, s.length - 2);
                                                        dToast(s);
                                                      },
                                                      onPressed: () {
                                                        Campanha c = snap.data;
                                                        List<Zona> zonasTemp =
                                                            new List();
                                                        for (Zona z
                                                            in c.zonas) {
                                                          if (z.nome !=
                                                              c.zonas[index]
                                                                  .nome) {
                                                            zonasTemp.add(z);
                                                          }
                                                        }
                                                        c.zonas = zonasTemp;
                                                        campanhaController
                                                            .inCampanha
                                                            .add(c);
                                                      },
                                                      child: Chip(
                                                        label: hText(
                                                            capitalize(snap
                                                                .data
                                                                .zonas[index]
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
                              sb,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: defaultActionButton(
                                        'Cadastrar Campanha', context, () {
                                      campanha.empresa = controllerEmpresa.text;
                                      campanha.cnpj = controllerCNPJ.text;
                                      campanha.dataini =
                                          datainiField.selectedDate;
                                      campanha.datafim =
                                          datafimField.selectedDate;
                                     campanha.limite =
                                          int.parse(controllerLimite.text);
                                           campanha.nome = controllerNome.text;
                                           campanha.updated_at = DateTime.now();
                                           campanha.created_at = DateTime.now();
                                         campanhaController.CriarCampanha(campanha: campanha).then((v){
                                           Navigator.of(context).pop();
                                         });


                                    }),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }))));
  }

  Future getImage(Campanha e) async {
    if (e == null) {
      e = new Campanha.Empty();
    }
    if (e.fotos == null) {
      e.fotos = new List();
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                defaultActionButton('Camera', context, () {
                  ImagePicker.pickImage(
                    source: ImageSource.camera,
                  ).timeout(Duration(seconds: 30)).then((image) {
                    print('AQUI FOTO ${image}');
                    if (image != null) {
                      if (image.path != null) {
                        e.fotos.add(image.path);
                        campanhaController.inCampanha.add(e);
                        dToast('Salvando Foto!');
                      }
                    }
                  }).catchError((err) {
                    print('ERRO NO IMAGE PICKER ${err.toString()}');
                  });
                }, icon: Icons.camera),
                defaultActionButton('Galeria', context, () {
                  ImagePicker.pickImage(
                    source: ImageSource.gallery,
                  ).timeout(Duration(seconds: 30)).then((image) {
                    print('AQUI FOTO ${image}');
                    if (image != null) {
                      if (image.path != null) {
                        e.fotos.add(image.path);
                        campanhaController.inCampanha.add(e);
                        dToast('Salvando Foto!');
                      }
                    }
                  }).catchError((err) {
                    print('ERRO NO IMAGE PICKER ${err.toString()}');
                  });
                }, icon: Icons.photo),
              ],
            ),
          );
        });
  }

  List<DropdownMenuItem<Zona>> getDropDownMenuItemsCampanha() {
    List<DropdownMenuItem<Zona>> items = List();

    for (Zona z in zonas) {
      items.add(DropdownMenuItem(value: z, child: Text('${z.nome}')));

    }

    return items;
  }
}
