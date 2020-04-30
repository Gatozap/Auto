import 'dart:io';

import 'package:autooh/Helpers/Bairros.dart';
import 'package:autooh/Helpers/DateSelector.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';

import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Bairro.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Solicitacao.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:autooh/Objetos/Campanha.dart';

import 'package:autooh/Telas/Admin/TelasAdmin/CampanhaController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VisualizarCampanhaUserPage extends StatefulWidget {
  Campanha campanha;
  Zona zonas;
  VisualizarCampanhaUserPage({this.campanha, this.zonas});

  @override
  _VisualizarCampanhaUserPageState createState() {
    return _VisualizarCampanhaUserPageState();
  }
}

class _VisualizarCampanhaUserPageState
    extends State<VisualizarCampanhaUserPage> {
  var controllerEmpresa = new TextEditingController(text: '');
  var controllerNome = new TextEditingController(text: '');
  var controllerCNPJ =
      new MaskedTextController(text: '', mask: '00.000.000/0000-00');
  var controllerSobre = new TextEditingController(text: '');
  var controllerLimite = new TextEditingController(text: '');
  Campanha campanha;
  final _formKey = GlobalKey<FormState>();
  bool isCadastrarPressed = false;
  @override
  void initState() {
    super.initState();
    if (campanhaController == null) {
      campanhaController = CampanhaController(campanha: widget.campanha);
    }
  }

  CampanhaController campanhaController;
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
      controllerSobre.text = widget.campanha.sobre;
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
                '${widget.campanha.dataini.day.toString().length == 1 ? '0' + widget.campanha.dataini.day.toString() : widget.campanha.dataini.day}/${widget.campanha.dataini.month.toString().length == 1 ? '0' + widget.campanha.dataini.month.toString() : widget.campanha.dataini.month}/${widget.campanha.dataini.year} ${widget.campanha.dataini.hour.toString().length == 1 ? '0' + widget.campanha.dataini.hour.toString() : widget.campanha.dataini.hour.toString()}:${widget.campanha.dataini.minute.toString().length == 1 ? '0' + widget.campanha.dataini.minute.toString() : widget.campanha.dataini.minute.toString()}');
      }

      if (widget.campanha.datafim != null) {
        datafim = widget.campanha.datafim;
        datafimField = BasicDateTimeField(
            label: 'Data de Fim',
            icon: FontAwesomeIcons.solidCalendarPlus,
            startingdate:
                '${widget.campanha.datafim.day.toString().length == 1 ? '0' + widget.campanha.datafim.day.toString() : widget.campanha.datafim.day}/${widget.campanha.datafim.month.toString().length == 1 ? '0' + widget.campanha.datafim.month.toString() : widget.campanha.datafim.month}/${widget.campanha.datafim.year} ${widget.campanha.datafim.hour.toString().length == 1 ? '0' + widget.campanha.datafim.hour.toString() : widget.campanha.datafim.hour.toString()}:${widget.campanha.datafim.minute.toString().length == 1 ? '0' + widget.campanha.datafim.minute.toString() : widget.campanha.datafim.minute.toString()}');
      }
      campanha = widget.campanha;
      campanhaController.inCampanha.add(campanha);
    }

    // TODO: implement build
    return Scaffold(
        appBar: myAppBar(campanha.nome, context, showBack: true),
        body: Container(
            child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: campanhaController.outCampanha,
                    builder: (context, AsyncSnapshot snap) {
                      Campanha campanha = snap.data;

                      if (campanha == null) {
                        campanha = new Campanha();
                      }

                      if (campanha.final_de_semana == null) {
                        campanha.final_de_semana = false;
                      }

                      if (campanha.atende_festas == null) {
                        campanha.atende_festas = false;
                      }

                      if (campanha.tarde == null) {
                        campanha.tarde = false;
                      }
                      if (campanha.manha == null) {
                        campanha.manha = false;
                      }

                      if (campanha.noite == null) {
                        campanha.noite = false;
                      }

                      return Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
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
                                                          child: campanha
                                                                  .fotos[0]
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
                                                  'assets/images/autooh.png',
                                                  height: 200,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                )
                                          : Image.asset(
                                              'assets/images/autooh.png',
                                              height: 200,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                    ])),
                              ),
                              sb,
                              sb,
                              Divider(color: corPrimaria),
                              sb,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: hText(
                                    'Informações de Empresa e Campanha',
                                    context),
                              ),
                              sb,
                              Divider(color: corPrimaria),
                              sb,
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.building,
                                        color: corPrimaria),
                                    sb,
                                    hText('Empresa: ', context,
                                        color: corPrimaria),
                                    hText('${campanha.empresa}', context)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.mapMarkedAlt,
                                        color: corPrimaria),
                                    sb,
                                    hText('Campanha: ', context,
                                        color: corPrimaria),
                                    hText('${campanha.nome}', context)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.idCard,
                                        color: corPrimaria),
                                    sb,
                                    hText('CNPJ: ', context,
                                        color: corPrimaria),
                                    hText('${campanha.cnpj}', context)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.prescription,
                                        color: corPrimaria),
                                    sb,
                                    Column(
                                      children: <Widget>[],
                                    ),
                                    hText('Sobre a Campanha: ', context,
                                        color: corPrimaria)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 30, top: 20),
                                child: hText('${campanha.sobre}', context),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.calendarMinus,
                                        color: corPrimaria),
                                    sb,
                                    hText('Campanha iniciou-se: ', context,
                                        color: corPrimaria),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 10),
                                child: hText(' ${campanha.dataini}', context),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.calendarMinus,
                                        color: corPrimaria),
                                    sb,
                                    hText('Campanha termina em: ', context,
                                        color: corPrimaria),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 10),
                                child: hText(' ${campanha.datafim}', context),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.carSide,
                                        color: corPrimaria),
                                    sb,
                                    hText('Limite de carros: ', context,
                                        color: corPrimaria),
                                    hText('${campanha.limite}', context)
                                  ],
                                ),
                              ),
                              sb,
                              Divider(color: corPrimaria),
                              sb,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: hText(
                                    'Preferências para Campanha', context),
                              ),
                              sb,
                              Divider(color: corPrimaria),
                              sb,
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        campanha.final_de_semana == true
                                            ? Icon(MdiIcons.checkBold,
                                                color: Colors.green)
                                            : Icon(MdiIcons.close,
                                                color: Colors.red),
                                        sb,
                                        hText('Atende final de semana', context,
                                            color: corPrimaria)
                                      ],
                                    ),
                                    sb,
                                    Row(
                                      children: <Widget>[
                                        campanha.atende_festas == true
                                            ? Icon(MdiIcons.checkBold,
                                                color: Colors.green)
                                            : Icon(MdiIcons.close,
                                                color: Colors.red),
                                        sb,
                                        hText('Atende em festas', context,
                                            color: corPrimaria)
                                      ],
                                    ),
                                    sb,
                                    Row(
                                      children: <Widget>[
                                        campanha.tarde == true
                                            ? Icon(MdiIcons.checkBold,
                                                color: Colors.green)
                                            : Icon(MdiIcons.close,
                                                color: Colors.red),
                                        sb,
                                        hText('Atende a Tarde', context,
                                            color: corPrimaria)
                                      ],
                                    ),
                                    sb,
                                    Row(
                                      children: <Widget>[
                                        campanha.manha == true
                                            ? Icon(MdiIcons.checkBold,
                                                color: Colors.green)
                                            : Icon(MdiIcons.close,
                                                color: Colors.red),
                                        sb,
                                        hText('Atende de Manhã', context,
                                            color: corPrimaria)
                                      ],
                                    ),
                                    sb,
                                    Row(
                                      children: <Widget>[
                                        campanha.noite == true
                                            ? Icon(MdiIcons.checkBold,
                                                color: Colors.green)
                                            : Icon(MdiIcons.close,
                                                color: Colors.red),
                                        sb,
                                        hText('Atende de Noite', context,
                                            color: corPrimaria)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              sb,
                              Divider(color: corPrimaria),
                              sb,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: hText(
                                    'Preferências de onde colocar o anúncio desta Campanha',
                                    context),
                              ),
                              sb,
                              Divider(color: corPrimaria),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 8, top: 10),
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: seletorAnunciosCampanhas(),
                                  ),
                                ),
                              ),
                              sb,
                              Divider(color: corPrimaria),
                              sb,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: hText(
                                    'Zonas que a Campanha Abrangê ', context),
                              ),
                              sb,
                              Divider(color: corPrimaria),
                              sb,
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
                                        'Solicitar Participação', context, () {
                                          carrosRef.where("dono",isEqualTo: Helper.localUser.id).getDocuments().then((carro){
                                            Carro c = Carro.fromJson(carro.documents[0].data);

                                      Solicitacao s = Solicitacao(
                                        updated_at: DateTime.now(),
                                        created_at: DateTime.now(),
                                        usuario: Helper.localUser.id,
                                        nome_campanha: widget.campanha.nome,
                                        nome_usuario: Helper.localUser.nome,
                                        campanha: widget.campanha.id,
                                        carro: c,
                                        isAprovado: false,
                                      );
                                      solicitacoesRef.add(s.toJson()).then((v) {
                                        s.id = v.documentID;
                                        solicitacoesRef
                                            .document(s.id)
                                            .updateData(s.toJson())
                                            .then((v) {
                                          sendNotificationUsuario(
                                              '${Helper.localUser.nome} quer participar da campanha',
                                              '${widget.campanha.nome}',
                                              null,
                                              'Administrador',
                                              widget.campanha,
                                              s.id);
                                          dToast(
                                              'Solicitação enviada com Sucesso! Um Administrador irá analisar e entrará em contato');
                                          Navigator.of(context).pop();
                                        });
                                        });
                                      });
                                    }, icon: null, size: 60),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }))));
  }

  Widget seletorAnunciosCampanhas() {
    return StreamBuilder<Campanha>(
      stream: campanhaController.outCampanha,
      builder: (context, camp) {
        Campanha campanha = camp.data;
        if (camp.data == null) {
          campanha = new Campanha();
        }
        if (campanha.anuncio_bancos == null) {
          campanha.anuncio_bancos = false;
        }

        if (campanha.anuncio_laterais == null) {
          campanha.anuncio_laterais = false;
        }
        if (campanha.anuncio_traseira_completa == null) {
          campanha.anuncio_traseira_completa = false;
        }
        if (campanha.anuncio_vidro_traseiro == null) {
          campanha.anuncio_vidro_traseiro = false;
        }

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
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
                              'https://cdn.shopify.com/s/files/1/2809/6686/products/sz10523_grande.jpg?v=1533527533'),
                          fit: BoxFit.cover),
                      border: campanha.anuncio_bancos == false
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: <Widget>[
                                campanha.anuncio_bancos == true
                                    ? Icon(
                                        MdiIcons.checkBold,
                                        color: Colors.green,
                                        size: 60,
                                      )
                                    : Icon(MdiIcons.close,
                                        color: Colors.red, size: 60),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                              'https://images.vexels.com/media/users/3/145586/isolated/preview/8f11dbfb5ce1e294f79a0f9aea6b36bf-silhueta-de-vista-lateral-de-carro-de-cidade-by-vexels.png'),
                          fit: BoxFit.cover),
                      border: campanha.anuncio_laterais == false
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Row(
                        children: <Widget>[
                          campanha.anuncio_laterais == true
                              ? Icon(
                                  MdiIcons.checkBold,
                                  color: Colors.green,
                                  size: 60,
                                )
                              : Icon(MdiIcons.close,
                                  color: Colors.red, size: 60),
                        ],
                      ),
                    ),
                  ),
                ],
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
                              'https://images.vexels.com/media/users/3/145707/isolated/preview/d3c27524358f5186c045e7f03d1f8d8e-silhueta-de-vista-traseira-de-hatchback-by-vexels.png'),
                          fit: BoxFit.cover),
                      border: campanha.anuncio_traseira_completa == false
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Row(
                        children: <Widget>[
                          campanha.anuncio_traseira_completa == true
                              ? Icon(
                                  MdiIcons.checkBold,
                                  color: Colors.green,
                                  size: 60,
                                )
                              : Icon(MdiIcons.close,
                                  color: Colors.red, size: 60),
                        ],
                      ),
                    ),
                  ),
                ],
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
                              'https://images.tcdn.com.br/img/img_prod/372162/112_1_20140325180457.jpg'),
                          fit: BoxFit.cover),
                      border: campanha.anuncio_vidro_traseiro == false
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Row(
                        children: <Widget>[
                          campanha.anuncio_vidro_traseiro == true
                              ? Icon(
                                  MdiIcons.checkBold,
                                  color: Colors.green,
                                  size: 60,
                                )
                              : Icon(MdiIcons.close,
                                  color: Colors.red, size: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
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
