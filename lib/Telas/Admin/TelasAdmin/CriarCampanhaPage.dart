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

class _CriarCampanhaPageState extends State<CriarCampanhaPage> {
  CampanhaController campanhaController;
  var controllerEmpresa = new TextEditingController(text: '');
  var controllerNome = new TextEditingController(text: '');
  var controllerCNPJ =
      new MaskedTextController(text: '', mask: '00.000.000/0000-00');
  var controllerLimite = new TextEditingController(text: '');
  Campanha campanha;
  final _formKey = GlobalKey<FormState>();
  bool isCadastrarPressed = false;
  @override
  void initState() {
    campanhaController = CampanhaController(campanha: widget.campanha);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  DateTime dataini;
  DateTime datafim;

  @override
  Widget build(BuildContext context) {
    BasicDateTimeField datainiField = BasicDateTimeField(
        label: 'Data de Início', icon: FontAwesomeIcons.solidCalendarPlus);
    BasicDateTimeField datafimField = BasicDateTimeField(
        label: 'Data de Fim', icon: FontAwesomeIcons.solidCalendarPlus);


    if (widget.campanha != null) {
      controllerEmpresa.text = widget.campanha.empresa;
      controllerNome.text = widget.campanha.nome;
      controllerCNPJ.text = widget.campanha.cnpj;
      controllerLimite.text = widget.campanha.limite.toString();
      if (widget.campanha.dataini != null) {
        dataini = widget.campanha.dataini;
        datainiField = BasicDateTimeField(
            label: 'Data de Início',
            icon: FontAwesomeIcons.solidCalendarPlus,
            startingdate:
                '${widget.campanha.dataini.day.toString().length == 1 ? '0' + widget.campanha.dataini.day.toString() : widget.campanha.dataini.day}/${widget.campanha.dataini.month.toString().length == 1 ? '0' + widget.campanha.dataini.month.toString() : widget.campanha.dataini.month}/${widget.campanha.dataini.year} ${widget.campanha.dataini.hour.toString().length == 1?'0'+widget.campanha.dataini.hour.toString():widget.campanha.dataini.hour.toString() }:${widget.campanha.dataini.minute.toString().length == 1?'0'+widget.campanha.dataini.minute.toString():widget.campanha.dataini.minute.toString() }');
      }

      if (widget.campanha.datafim != null) {
        datafim = widget.campanha.datafim;
        datafimField = BasicDateTimeField(
            label: 'Data de Fim',
            icon: FontAwesomeIcons.solidCalendarPlus,
            startingdate:
            '${widget.campanha.datafim.day.toString().length == 1 ? '0' + widget.campanha.datafim.day.toString() : widget.campanha.datafim.day}/${widget.campanha.datafim.month.toString().length == 1 ? '0' + widget.campanha.datafim.month.toString() : widget.campanha.datafim.month}/${widget.campanha.datafim.year} ${widget.campanha.datafim.hour.toString().length == 1?'0'+widget.campanha.datafim.hour.toString():widget.campanha.datafim.hour.toString() }:${widget.campanha.datafim.minute.toString().length == 1?'0'+widget.campanha.datafim.minute.toString():widget.campanha.datafim.minute.toString() }');
      }
      campanha = widget.campanha;
      campanhaController.inCampanha.add(campanha);
    }

    // TODO: implement build
    return Scaffold(
        appBar: myAppBar(
            widget.campanha == null ? 'Criar Campanha' : 'Editar Campanha',
            context,
            showBack: true),
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
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher o Nome da Empresa';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  onSubmited: (s) {}),
                              DefaultField(
                                  controller: controllerNome,
                                  hint: 'Campanha seja feliz!',
                                  context: context,
                                  label: 'Nome da Campanha',
                                  icon: FontAwesomeIcons.adn,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher Nome da Campanha';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  onSubmited: (s) {}),
                              DefaultField(
                                  controller: controllerCNPJ,
                                  hint: '00.000.000/0000-00',
                                  context: context,
                                  label: 'CNPJ',
                                  icon: FontAwesomeIcons.atlas,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher o CNPJ';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  onSubmited: (s) {}),
                              datainiField,
                              datafimField,

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
                                    for (Zona z in c.zonas) {
                                      if (z.nome == value.nome) {
                                        contains = true;
                                      }
                                    }
                                    if (!contains) {
                                      c.zonas.add(value);
                                    }
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
                                                            capitalize(campanha
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
                                        widget.campanha == null
                                            ? 'Cadastrar Campanha'
                                            : 'Editar Campanha',
                                        context, () {
                                      if (campanha == null) {
                                        campanha = new Campanha();
                                      }
                                      campanha.empresa = controllerEmpresa.text;
                                      campanha.cnpj = controllerCNPJ.text;

                                      campanha.dataini =
                                          datainiField.selectedDate;
                                      campanha.datafim =
                                          datafimField.selectedDate;

                                      campanha.nome = controllerNome.text;
                                      campanha.updated_at = DateTime.now();
                                      if (widget.campanha == null) {
                                        campanha.created_at = DateTime.now();
                                      }

                                      if (widget.campanha != null) {

                                        if(campanha.dataini == null){
                                          campanha.dataini = dataini;
                                        }
                                        if(campanha.datafim == null){
                                          campanha.datafim = datafim;
                                        }

                                        campanhaController.EditarCampanha(
                                                campanha)
                                            .then((v) {
                                          dToast(
                                              'Campanha editada com sucesso!');
                                          Navigator.of(context).pop();
                                        });
                                      } else {
                                        campanhaController.CriarCampanha(
                                                campanha: campanha)
                                            .then((v) {
                                          dToast(
                                              'Campanha criada com sucesso!');
                                          Navigator.of(context).pop();

                                          dToast(
                                              'Erro ao Criar Campanha! ${v.toString()}');

                                          Navigator.of(context).pop();
                                        });
                                      }
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
                  ).timeout(Duration(seconds: 30)).then((image) async {

                    if (image != null) {
                      if (image.path != null) {
                        e.fotos.add(await uploadPicture(
                          image.path,
                        ));
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
                  ).timeout(Duration(seconds: 30)).then((image) async {

                    if (image != null) {
                      if (image.path != null) {
                        e.fotos.add(await uploadPicture(
                          image.path,
                        ));
                        campanhaController.inCampanha.add(e);
                        dToast('Salvando Foto!');
                      }
                    }
                  }
                  ).catchError((err) {
                    print('ERRO NO IMAGE PICKER ${err.toString()}');
                  }
                  );
                }, icon: Icons.photo),
              ],
            ),
          );
        }
        );

  }

  List<DropdownMenuItem<Zona>> getDropDownMenuItemsCampanha() {
    List<DropdownMenuItem<Zona>> items = List();

    for (Zona z in zonas) {
      items.add(DropdownMenuItem(value: z, child: Text('${z.nome}')));
    }

    return items;
  }
}
