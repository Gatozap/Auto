import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/DiceKeyboard.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/ListaEquipamentos.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';
import 'package:autooh/Telas/Personagens/PersonagensController.dart';

import 'EquipamentosController.dart';

class EquiparPage extends StatefulWidget {
  Personagem personagem;
  Equipamento equipamento;
  EquiparPage({Key key, this.personagem, this.equipamento}) : super(key: key);

  @override
  _EquiparPageState createState() {
    return _EquiparPageState();
  }
}

enum EscolhaInventario { equipar, editar, remover, criar }

List<DropdownMenuItem<String>> _dropDownMenuItems;
String _statusSel;


List<DropdownMenuItem<String>> _getDropDownMenuItems() {
  List<DropdownMenuItem<String>> items = List();

  items.add(DropdownMenuItem(value: 'Cabeça', child: Text('Cabeça')));
  items.add(DropdownMenuItem(value: 'Ombros', child: Text('Ombros')));
  items.add(DropdownMenuItem(value: 'Peitoral', child: Text('Peitoral')));
  items.add(DropdownMenuItem(value: 'Arma', child: Text('Arma')));
  items.add(DropdownMenuItem(value: 'Escudo', child: Text('Escudo')));
  items.add(DropdownMenuItem(value: 'Munição', child: Text('Munição')));
  items.add(DropdownMenuItem(value: 'Bracelete', child: Text('Bracelete')));
  items.add(DropdownMenuItem(value: 'Calça', child: Text('Calça')));
  items.add(DropdownMenuItem(value: 'Capa', child: Text('Capa')));

  items.add(DropdownMenuItem(value: 'Luvas', child: Text('Luvas')));
  items.add(DropdownMenuItem(value: 'Botas', child: Text('Botas')));
  items.add(DropdownMenuItem(value: 'Arco', child: Text('Arco')));
  items.add(DropdownMenuItem(value: 'Anel', child: Text('Anel')));
  items.add(DropdownMenuItem(value: 'Colar', child: Text('Colar')));
  items.add(DropdownMenuItem(value: 'Aparatos', child: Text('Aparatos')));
  items.add(DropdownMenuItem(value: 'NA', child: Text('NA')));

  return items;
}

void changedDropDownItem(String selectedItem) {

    _statusSel = selectedItem;


}

class _EquiparPageState extends State<EquiparPage> {
  PersonagensController personagensController;
  EquipamentosController equipamentosController;

  @override
  void initState() {
    _dropDownMenuItems = _getDropDownMenuItems();
    _statusSel = _dropDownMenuItems[0].value;
    super.initState();

    if (equipamentosController == null) {
      equipamentosController = new EquipamentosController();
    }
    if (personagensController == null) {
      personagensController =
          PersonagensController(personagem: widget.personagem);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController nomeController = TextEditingController();
  TextEditingController slotController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController requerimentoController = TextEditingController();
  bool hasDone = false;
  bool isEditar = false;

  TextEditingController controllerEquipamentos = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar('Equipar: ${widget.personagem.nome}', context),
        body: StreamBuilder(
            stream: personagensController.outPersonagenSelecionado,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Loading(completed: Text('Erro ao buscar Equipamentos'));
              }
              if (personagensController.personagemSelecionado.equipamentos ==
                  null) {
                personagensController.personagemSelecionado.equipamentos =
                    new List<Equipamento>();
              }
              if (snapshot.data.equipamentos == null) {
                return Loading(
                    completed: Text('Nenhum equipamento disponivel!'));
              }

              if (snapshot.data.equipamentos.length == 0) {
                Container(
                  height: getLargura(context),
                  width: getAltura(context),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: controllerEquipamentos,
                                  keyboardType: TextInputType.text,
                                  decoration: DefaultInputDecoration(
                                    context,
                                    icon: MdiIcons.shopping,
                                    hintText: 'Laterna',
                                    labelText: 'Adicionar Equipamento',
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  enabled: true),
                              suggestionsCallback: (String pattern) async {
                                return equipamentosController.getSuggestions(
                                    pattern, widget.personagem);
                              },
                              itemBuilder: (context, Equipamento suggestion) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Icon(
                                      getSlotItem(suggestion.nome),
                                      color: corPrimaria,
                                    ),
                                    title: Text(suggestion.nome),
                                  ),
                                );
                              },
                              onSuggestionSelected: AdicionarEquipamentos,
                              noItemsFoundBuilder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Nenhum equipamento encontrado!'),
                                );
                              },
                            )),
                        Expanded(
                            child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return EquipamentosListItem(
                                snapshot.data.equipamentos[index],
                                snapshot.data);
                          },
                          itemCount: snapshot.data.equipamentos.length,
                        ))
                      ]),
                );
              }

              Equipamento Elmo;
              Equipamento Ombreira;
              Equipamento Peitoral;
              Equipamento Luva;
              Equipamento Bracelete;
              Equipamento Bota;
              Equipamento Capa;
              Equipamento Calca;
              Equipamento Arma;
              Equipamento Escudo;
              Equipamento Arco;
              Equipamento Anel;
              Equipamento Vazio;
              Equipamento Colar;
              Equipamento Municao;
              Equipamento Aparato;

              for (Equipamento e in snapshot.data.equipamentos) {
                if (e.isEquipado) {
                  switch (e.slot) {
                    case 'Cabeça':
                      Elmo = e;
                      break;
                    case 'Ombros':
                      Ombreira = e;
                      break;
                    case 'Peitoral':
                      Peitoral = e;
                      break;
                    case 'Arma':
                      Arma = e;
                      break;
                    case 'Escudo':
                      Escudo = e;
                      break;
                    case 'Munição':
                      Municao = e;
                      break;
                    case 'Bracelete':
                      Bracelete = e;
                      break;
                    case 'Calça':
                      Calca = e;
                      break;
                    case 'Capa':
                      Capa = e;
                      break;
                    case 'Luvas':
                      Luva = e;
                      break;
                    case 'Botas':
                      Bota = e;
                      break;
                    case 'Arco':
                      Arco = e;
                      break;
                    case 'Anel':
                      Anel = e;
                      break;
                    case 'Colar':
                      Colar = e;
                      break;
                    case 'Aparatos':
                      Aparato = e;
                      break;
                    default:
                      Vazio = e;
                      break;
                  }
                }
              }
              return Container(
                  height: getAltura(context),
                  width: getLargura(context),
                  child: Stack(children: <Widget>[
                    SingleChildScrollView(
                        child: Stack(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: getAltura(context) / 2 * .8,
                              width: getLargura(context) / 2 * .8,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(widget
                                                .personagem.foto ==
                                            null
                                        ? 'https://publicdomainvectors.org/photos/Man-With-Shield-Silhouette.png'
                                        : widget.personagem.foto),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            )
                          ]),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .10,
                                  width: getLargura(context) * .20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/Elmo.png'),
                                        fit: BoxFit.cover),
                                    border: Elmo == null
                                        ? Border.all(
                                            color: Colors.black, width: 3)
                                        : Border.all(
                                            color: Colors.green, width: 3),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                sb,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .05,
                                      width: getLargura(context) * .1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                'https://st3.depositphotos.com/2585479/16553/v/1600/depositphotos_165532946-stock-illustration-necklace-silhouette-illustration.jpg'),
                                            fit: BoxFit.cover),
                                        border: Colar == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .10,
                                      width: getLargura(context) * .20,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/Ombreira.png'),
                                            fit: BoxFit.cover),
                                        border: Ombreira == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                            sb,
                            Row(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .10,
                                  width: getLargura(context) * .20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/Peitoral.png'),
                                        fit: BoxFit.cover),
                                    border: Peitoral == null
                                        ? Border.all(
                                            color: Colors.black, width: 3)
                                        : Border.all(
                                            color: Colors.green, width: 3),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                sb,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .05,
                                      width: getLargura(context) * .1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                'https://st4.depositphotos.com/2585479/20257/v/1600/depositphotos_202575132-stock-illustration-isolated-silhouette-of-a-ring.jpg'),
                                            fit: BoxFit.cover),
                                        border: Anel == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .10,
                                      width: getLargura(context) * .20,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/Bracelete.png'),
                                            fit: BoxFit.cover),
                                        border: Bracelete == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                            sb,
                            Row(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .10,
                                  width: getLargura(context) * .20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/Calça.png'),
                                        fit: BoxFit.cover),
                                    border: Calca == null
                                        ? Border.all(
                                            color: Colors.black, width: 3)
                                        : Border.all(
                                            color: Colors.green, width: 3),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                sb,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .05,
                                      width: getLargura(context) * .1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                'https://st4.depositphotos.com/2585479/20257/v/1600/depositphotos_202575132-stock-illustration-isolated-silhouette-of-a-ring.jpg'),
                                            fit: BoxFit.cover),
                                        border: Anel == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .10,
                                      width: getLargura(context) * .20,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage('assets/Luva.png'),
                                            fit: BoxFit.cover),
                                        border: Luva == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                            sb,
                            Row(
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .10,
                                  width: getLargura(context) * .20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/Perna.png'),
                                        fit: BoxFit.cover),
                                    border: Bota == null
                                        ? Border.all(
                                            color: Colors.black, width: 3)
                                        : Border.all(
                                            color: Colors.green, width: 3),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                sb,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .05,
                                      width: getLargura(context) * .1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                'https://thumbs.dreamstime.com/z/silhueta-su%C3%AD%C3%A7a-simples-preta-do-canivete-111788801.jpg'),
                                            fit: BoxFit.cover),
                                        border: Aparato == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                ),
                                sb,
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .10,
                                      width: getLargura(context) * .20,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                'http://www.wizards.com/dnd/images/mic_gallery/103359.jpg'),
                                            fit: BoxFit.cover),
                                        border: Capa == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                            sb,
                            sb,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .10,
                                  width: getLargura(context) * .20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            'https://cdn.pixabay.com/photo/2018/10/16/15/51/sword-3751698_960_720.png'),
                                        fit: BoxFit.cover),
                                    border: Arma == null
                                        ? Border.all(
                                            color: Colors.black, width: 3)
                                        : Border.all(
                                            color: Colors.green, width: 3),
                                  ),
                                ),
                                Expanded(
                                    flex: -2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .10,
                                          width: getLargura(context) * .20,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    'https://us.123rf.com/450wm/martialred/martialred1605/martialred160500092/57038913-medieval-shield-of-protection-flat-icon-for-apps-and-games.jpg?ver=6'),
                                                fit: BoxFit.cover),
                                            border: Escudo == null
                                                ? Border.all(
                                                    color: Colors.black,
                                                    width: 3)
                                                : Border.all(
                                                    color: Colors.green,
                                                    width: 3),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        )
                                      ],
                                    )),
                                sb,
                                Expanded(
                                    flex: -2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: getAltura(context) * .10,
                                          width: getLargura(context) * .20,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    'https://img2.gratispng.com/20180328/ezw/kisspng-bow-and-arrow-silhouette-clip-art-bow-and-arrow-5abbbc94adb975.2337549515222529487116.jpg'),
                                                fit: BoxFit.cover),
                                            border: Arco == null
                                                ? Border.all(
                                                    color: Colors.black,
                                                    width: 3)
                                                : Border.all(
                                                    color: Colors.green,
                                                    width: 3),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        )
                                      ],
                                    )),
                                sb,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: getAltura(context) * .05,
                                      width: getLargura(context) * .1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                'https://media.istockphoto.com/vectors/black-isolated-icon-of-arrow-on-white-background-silhouette-of-arrow-vector-id1061700680'),
                                            fit: BoxFit.cover),
                                        border: Municao == null
                                            ? Border.all(
                                                color: Colors.black, width: 3)
                                            : Border.all(
                                                color: Colors.green, width: 3),
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    )
                                  ],
                                ),
                                sb,
                              ],
                            ),
                            sb,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: getAltura(context) * .10,
                                  width: getLargura(context) * .20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://i.kinja-img.com/gawker-media/image/upload/wueskkgoofh3s4ypqyt9.jpg'),
                                        fit: BoxFit.cover),
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: getLargura(context),
                              width: getAltura(context),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TypeAheadField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                                  controller:
                                                      controllerEquipamentos,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration:
                                                      DefaultInputDecoration(
                                                    context,
                                                    icon: MdiIcons.shopping,
                                                    hintText: 'Laterna',
                                                    labelText:
                                                        'Adicionar Equipamento',
                                                  ),
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  enabled: true),
                                          suggestionsCallback:
                                              (String pattern) async {
                                            return equipamentosController.getSuggestions(
                                                pattern, widget.personagem);
                                          },
                                          itemBuilder: (context,
                                              Equipamento suggestion) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                leading: Icon(
                                                  getSlotItem(suggestion.nome),
                                                  color: corPrimaria,
                                                ),
                                                title: Text(suggestion.nome),
                                              ),
                                            );
                                          },
                                          onSuggestionSelected:
                                              AdicionarEquipamentos,
                                          noItemsFoundBuilder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  'Nenhum equipamento encontrado!'),
                                            );
                                          },
                                        )),
                                    Expanded(
                                        child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return EquipamentosListItem(
                                            snapshot.data.equipamentos[index],
                                            snapshot.data);
                                      },
                                      itemCount:
                                          snapshot.data.equipamentos.length,
                                    )),
                                  ]),
                            )
                          ])
                    ])),
                  ]));
            }));
  }

  Widget EquipamentosListItem(Equipamento e, Personagem data) {
    TextEditingController nomeController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();
    TextEditingController requerimentosController = TextEditingController();
    TextEditingController bonusController = TextEditingController();

    if (e.nome != null) {
      nomeController.text = e.nome;
    }
    if (e.descricao != null) {
      descricaoController.text = e.descricao;
    }
    if (e.bonus != null) {
      bonusController.text = e.bonus.toString();
    }
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);

    return Container(
        decoration: BoxDecoration(
            color: Colors.black,
            gradient: LinearGradient(colors: [Colors.black, Colors.white])),
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    MdiIcons.shoppingSearch,
                    textDirection: TextDirection.rtl,
                    color: corPrimaria,
                    size: 35,
                  ),
                  sb,
                  sb,
                  hText('${e.nome}', context,
                      size: 55, textaling: TextAlign.start),
                  Expanded(
                    flex: 6,
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      PopupMenuButton<EscolhaInventario>(
                          onSelected: (EscolhaInventario result) {
                            switch (result) {
                              case EscolhaInventario.editar:
                                EditarEquipamentos(e);
                                break;
                              case EscolhaInventario.remover:
                                break;
                              case EscolhaInventario.equipar:
                                equiparItem(e);
                                break;
                              case EscolhaInventario.criar:
                                CriacaoDeEquipamentos(e);
                                break;
                            }
                          },
                          icon: Icon(
                            MdiIcons.viewHeadline,
                            color: corPrimaria,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<EscolhaInventario>>[
                                const PopupMenuItem<EscolhaInventario>(
                                    value: EscolhaInventario.equipar,
                                    child: Text('Equipar')),
                                const PopupMenuItem<EscolhaInventario>(
                                    value: EscolhaInventario.criar,
                                    child: Text('Criar')),
                                const PopupMenuItem<EscolhaInventario>(
                                    value: EscolhaInventario.editar,
                                    child: Text('Editar')),
                                const PopupMenuItem<EscolhaInventario>(
                                    value: EscolhaInventario.remover,
                                    child: Text('Remover')),
                              ])
                    ],
                  )),
                ],
              ),
              sb,
              Container(
                width: getLargura(context),
                child: hText('Descrição: ${e.descricao}', context,
                    size: 55, textaling: TextAlign.justify),
              ),
              sb,
              Container(
                width: getLargura(context),
                child: hText(
                    'Requerimentos: ${e.requerimentos == null ? 'NA' : e.requerimentos}',
                    context,
                    size: 55,
                    textaling: TextAlign.justify),
              ),
              sb,
              Container(
                decoration: BoxDecoration(
                    color: e.isEquipado == false
                        ? Colors.transparent
                        : Colors.green,
                    gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.green])),
                width: getLargura(context),
                child: hText(
                    'Slot: ${e.slot == null ? 'Objetos do inventário' : e.slot}',
                    context,
                    size: 55,
                    textaling: TextAlign.justify),
              ),
              sb,
              e.bonus == null
                  ? Container()
                  : Container(
                      height: getAltura(context) * (e.bonus.length * .05),
                      child: ListView.builder(
                        itemBuilder: (context, i) {
                          return Container(
                            width: getLargura(context),
                            child: hText(
                                'Bonus: +${e.bonus[i].bonus} em ${e.bonus[i].atributo}',
                                context),
                          );
                        },
                        itemCount: e.bonus.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    )
            ],
          ),
        ));
  }

  void CriarEquipamentos() {

    Equipamento p = Equipamento(
        nome: nomeController.text,
        requerimentos: requerimentoController.text,
        descricao: descricaoController.text,
        slot: _statusSel
    );
    equipamentosRef.add(p.toJson()).then((v) {

      p.id = v.documentID;
      personagensRef.document(v.documentID).updateData(p.toJson()).then((v) {
        dToast('Personagem Salvo com sucesso!');
        setState(() {

        });
        //TODO ABRIR PROXIMA TELA;
      });
    });
  }

  void AlterarEquipamentos() {

    widget.equipamento.slot = _statusSel;
    widget.equipamento.nome = nomeController.text;
    widget.equipamento.descricao = descricaoController.text;
    widget.equipamento.requerimentos = requerimentoController.text;
    widget.equipamento.updated_at = DateTime.now();
    widget.equipamento.created_at = DateTime.now();
     print(_statusSel);
    equipamentosRef
        .document(widget.equipamento.id)
        .updateData(widget.equipamento.toJson())
        .then((v) {
      dToast('Equipamento Salvo com sucesso!');
      setState(() {

      });
      //TODO ABRIR PROXIMA TELA;
    });
  }

  void AdicionarEquipamentos(Equipamento suggestion) {
    if (widget.personagem.equipamentos == null) {
      widget.personagem.equipamentos = new List<Equipamento>();
    }

    widget.personagem.equipamentos.add(suggestion);

    personagensController.inPersonagenSelecionado.add(widget.personagem);
    personagensRef
        .document(widget.personagem.id)
        .updateData(widget.personagem.toJson())
        .then((v) {
      print('Personagem Atualizado');
    });
    controllerEquipamentos.text = '';
  }

  void CriacaoDeEquipamentos(Equipamento e) {


    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              color: Colors.white,
              width: getLargura(context) * .9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  hText('Criar seu equipamento', context),
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DefaultField(
                              label: 'Nome',
                              minLines: 1,
                              context: context,
                              maxLines: 2,
                              hint: e.nome,
                              controller: nomeController),
                          DefaultField(
                              label: 'Descrição',
                              minLines: 1,
                              context: context,
                              controller: descricaoController,
                              maxLines: 20,
                              hint: e.descricao),
                          DefaultField(
                              label: "Requerimentos",
                              minLines: 1,
                              context: context,
                              controller: requerimentoController,
                              maxLines: 3,
                              hint: e.requerimentos),

                       
                          DropdownButton(
                              style: TextStyle(
                                  color: corPrimaria,
                                  fontWeight: FontWeight.bold),
                              value: _statusSel,

                              items: _dropDownMenuItems,
                              onChanged: (v){
                                _statusSel = v;
                                print(v);
                              }),

                          defaultActionButton('Criar equipamento', context, () {
                            CriarEquipamentos();
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void EditarEquipamentos(Equipamento e) {

      widget.equipamento = e;
    showDialog(

        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              color: Colors.white,
              width: getLargura(context) * .9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  hText('Edite seu equipamento', context),
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DefaultField(
                              label: 'Nome',
                              minLines: 1,
                              context: context,
                              maxLines: 2,
                              hint: e.nome,
                              controller: nomeController),
                          DefaultField(
                              label: 'Descrição',
                              minLines: 1,
                              context: context,
                              controller: descricaoController,
                              maxLines: 20,
                              hint: e.descricao),
                          DefaultField(
                              label: "Requerimentos",
                              minLines: 1,
                              context: context,
                              controller: requerimentoController,
                              maxLines: 3,
                              hint: e.requerimentos),
                          DropdownButton(

                            style: TextStyle(
                                color: corPrimaria,
                                fontWeight: FontWeight.bold),
                            value: _statusSel,
                            items: _dropDownMenuItems,
                            onChanged: (v){
                              _statusSel = v;
                            },
                          ),
                          defaultActionButton('Atualizar equipamento', context,
                              () {

                            AlterarEquipamentos();
                            Navigator.of(context).pop();
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void equiparItem(Equipamento e) {
    for (Equipamento eitem in widget.personagem.equipamentos) {
      if (e.slot == eitem.slot && eitem.isEquipado) {
        eitem.isEquipado = false;
      }
      e.isEquipado = true;
      if (eitem.id == e.id) {
        eitem = e;
      }
    }
    personagensController.inPersonagenSelecionado.add(widget.personagem);
    personagensRef
        .document(widget.personagem.id)
        .updateData(widget.personagem.toJson())
        .then((v) {
      print('Personagem Atualizado');
    });
  }
}
