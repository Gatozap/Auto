import 'dart:io';

import 'package:autooh/Helpers/Bairros.dart';
import 'package:autooh/Helpers/DateSelector.dart';
import 'package:autooh/Helpers/Helper.dart';

import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Bairro.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:autooh/Objetos/Campanha.dart';

import 'package:autooh/Telas/Admin/TelasAdmin/CampanhaController.dart';
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

  var controllerDuracaoMinima = new TextEditingController(text: '');
  var controllerKmMinimo = new TextEditingController(text: '');
  var controllerPrecoMes = new TextEditingController(text: '');
  var controllerEmpresa = new TextEditingController(text: '');
  var controllerNome = new TextEditingController(text: '');
  var controllerCNPJ = new MaskedTextController(text: '', mask: '00.000.000/0000-00');
  var controllerSobre = new TextEditingController(text: '');
  var controllerLimite = new TextEditingController(text: '');
  Campanha campanha;
  final _formKey = GlobalKey<FormState>();
  bool isCadastrarPressed = false;
  @override
  void initState() {



    super.initState();
    if(campanhaController == null){
      campanhaController =  CampanhaController(campanha: widget.campanha);
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
        label: 'Data de Fim', icon: FontAwesomeIcons.solidCalendarPlus, );


    if (widget.campanha != null) {
           controllerDuracaoMinima.text = widget.campanha.duracaoMinima.toString();
           controllerKmMinimo.text = widget.campanha.kmMinima.toString();
           controllerPrecoMes.text = widget.campanha.precomes.toString();
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
                      Campanha campanha = snap.data;

                      if(campanha == null){
                        campanha = new Campanha();
                      }

                      if(campanha.final_de_semana == null){
                        campanha.final_de_semana = false;
                      }

                      if(campanha.atende_festas == null){
                        campanha.atende_festas = false;
                      }

                      if(campanha.tarde == null){
                        campanha.tarde = false;
                      }
                        if(campanha.manha == null){
                          campanha.manha = false;
                        }

                        if(campanha.noite == null){
                          campanha.noite = false;
                        }



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
                                                'assets/autooh.png',
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              )
                                        : Image.asset(
                                            'assets/autooh.png',
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

                              DefaultField(
                                  controller: controllerSobre,
                                  hint: 'Texto destinado a explicar como funciona a campanha, quem você representa e etc',
                                  context: context,
                                  label: 'Sobre',
                                  icon: MdiIcons.accountEdit,
                                  minLines: 1,
                                  maxLines: 15,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher Sobre o que se trata a Campanha';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  onSubmited: (s) {}),

                              DefaultField(
                                  controller: controllerLimite,
                                  hint: '50',
                                  context: context,
                                  label: 'Limite de carros',
                                  icon: FontAwesomeIcons.atlas,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher o Limite de carros por campanha';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  onSubmited: (s) {}),
                              DefaultField(
                                  controller: controllerPrecoMes,
                                  hint: 'R\$300.00',
                                  context: context,
                                  label: 'Valor da campanha ao mês',
                                  icon: FontAwesomeIcons.moneyBillAlt,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher Valor da Campanha';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  onSubmited: (s) {}),
                              DefaultField(
                                  controller: controllerKmMinimo,
                                  hint: '4000',
                                  context: context,
                                  label: "Km's minimos para atingir valor mês",
                                  icon: FontAwesomeIcons.route,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher Valor da Campanha';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  onSubmited: (s) {}),

                              DefaultField(
                                  controller: controllerDuracaoMinima,
                                  hint: '40',
                                  context: context,
                                  label: "Horas mínimas da campanha",
                                  icon: FontAwesomeIcons.clock,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      if (isCadastrarPressed) {
                                        return 'É necessário preencher as Horas mínimas';
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  onSubmited: (s) {}),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

                                  defaultCheckBox(
                                         campanha.final_de_semana
                                         ,
                                      'Atende aos finais de semana',
                                      context, () {
                                    campanha.final_de_semana =
                                    ! campanha.final_de_semana;
                                    campanhaController.campanha = campanha
                                        ;
                                    campanhaController.inCampanha
                                        .add(campanhaController.campanha);
                                  }), sb,
                                  defaultCheckBox(
                                      campanha.atende_festas
                                      ,
                                      'Atende em festas',
                                      context, () {
                                    campanha.atende_festas =
                                    ! campanha.atende_festas;
                                    campanhaController.campanha = campanha
                                    ;
                                    campanhaController.inCampanha
                                        .add(campanhaController.campanha);
                                  }),sb,


                                  defaultCheckBox(
                                      campanha.tarde
                                      ,
                                      'Atende à tarde',
                                      context, () {
                                    campanha.tarde =
                                    ! campanha.tarde;
                                    campanhaController.campanha = campanha
                                    ;
                                    campanhaController.inCampanha
                                        .add(campanhaController.campanha);
                                  }),  sb,
                                  defaultCheckBox(
                                      campanha.manha
                                      ,
                                      'Atende de manhã',
                                      context, () {
                                    campanha.manha =
                                    ! campanha.manha;
                                    campanhaController.campanha = campanha
                                    ;
                                    campanhaController.inCampanha
                                        .add(campanhaController.campanha);
                                  }),   sb,
                                  defaultCheckBox(
                                      campanha.noite
                                      ,
                                      'Atende à noite',
                                      context, () {
                                    campanha.noite =
                                    ! campanha.noite;
                                    campanhaController.campanha = campanha
                                    ;
                                    campanhaController.inCampanha
                                        .add(campanhaController.campanha);
                                  }),
                                ],),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: seletorAnunciosCampanhas(),
                                  ),
                                ),
                              ),
                              sb,Divider(color: corPrimaria,),sb,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: hText('Zonas da Campanha', context, textaling: TextAlign.center),
                              ),sb,Divider(color: corPrimaria,),sb,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: DropdownButton(
                                  hint: Row(
                                    children: <Widget>[
                                      Icon(Icons.map, color: corPrimaria),
                                      sb,
                                      hText(
                                        'Zonas que a campanha abrange',
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
                              sb,Divider(color: corPrimaria,),sb,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: hText('Data Inicial e Data Final da Campanha', context),
                              ),sb,Divider(color: corPrimaria,),sb,
                              datainiField,
                              datafimField,
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

                                      campanha.atende_festas == null? false: campanha.atende_festas;
                                      campanha.manha == null? false: campanha.manha;
                                      campanha.tarde == null? false: campanha.tarde;
                                      campanha.noite == null? false: campanha.noite;
                                      campanha.precomes = double.parse(controllerPrecoMes.text);
                                      campanha.kmMinima = double.parse(controllerKmMinimo.text);
                                      campanha.duracaoMinima = double.parse(controllerDuracaoMinima.text);


                                      campanha.anuncio_bancos == null? false: campanha.anuncio_bancos;
                                      campanha.anuncio_laterais == null? false: campanha.anuncio_laterais;
                                      campanha.anuncio_traseira_completa == null? false: campanha.anuncio_traseira_completa;
                                      campanha.anuncio_vidro_traseiro == null? false: campanha.anuncio_vidro_traseiro;

                                      campanha.sobre = controllerSobre.text;
                                      campanha.final_de_semana == null? false: campanha.final_de_semana;
                                      campanha.empresa = controllerEmpresa.text;
                                      campanha.cnpj = controllerCNPJ.text;
                                      campanha.limite = int.parse(controllerLimite.text);
                                        print('aqui data ${datafimField.selectedDate}');
                                      campanha.dataini = datainiField.selectedDate;
                                      campanha.datafim = datafimField.selectedDate;

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
                                    }, icon: null),
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
              Container(
                child: hText(
                    'Prioridade de Anúncios',
                    context,
                    textaling: TextAlign.center),
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
                          image: AssetImage(
                              'assets/bancos.png'),
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
                            child: defaultCheckBox(campanha.anuncio_bancos,
                                'Bancos Traseiros', context, () {
                                  campanha.anuncio_bancos =
                                  !campanha.anuncio_bancos;
                                  campanhaController.campanha = campanha;
                                  campanhaController.inCampanha
                                      .add(campanhaController.campanha);
                                  print('anuncio ${campanha.anuncio_bancos}');
                                }, size: 10),
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
                          image: AssetImage(
                              'assets/lateral.png'),
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
                      child: defaultCheckBox(
                          campanha.anuncio_laterais, 'Laterais', context, () {
                        campanha.anuncio_laterais = !campanha.anuncio_laterais;
                        campanhaController.campanha = campanha;
                        campanhaController.inCampanha
                            .add(campanhaController.campanha);
                      }, size: 10),
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
                          image: AssetImage(
                              'assets/traseira_completa.png'),
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
                      child: defaultCheckBox(campanha.anuncio_traseira_completa,
                          'Traseira Completa', context, () {
                            campanha.anuncio_traseira_completa =
                            !campanha.anuncio_traseira_completa;
                            campanhaController.campanha = campanha;
                            campanhaController.inCampanha
                                .add(campanhaController.campanha);
                          }, size: 10),
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
                          image: AssetImage(
                              'assets/vidro_traseiro.png'),
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
                      child: defaultCheckBox(campanha.anuncio_vidro_traseiro,
                          'Vidro traseira', context, () {
                            campanha.anuncio_vidro_traseiro =
                            !campanha.anuncio_vidro_traseiro;
                            campanhaController.campanha = campanha;
                            campanhaController.inCampanha
                                .add(campanhaController.campanha);
                          }, size: 10),
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
