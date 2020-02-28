import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/ListaEquipamentos.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Pericia.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:bocaboca/Telas/FichaPersonagem/TalentoPage.dart';
import 'package:bocaboca/Telas/Macros/MacroPage.dart';
import 'package:bocaboca/Telas/Personagens/PersonagensController.dart';

import 'PericiasController.dart';

class PericiasPage extends StatefulWidget {
  Personagem personagem;
  PericiasPage({Key key, this.personagem}) : super(key: key);

  @override
  _PericiasPageState createState() {
    return _PericiasPageState();
  }
}

class _PericiasPageState extends State<PericiasPage> {
  PericiasController pc;
  PersonagensController personagensController;

  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new PericiasController();
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

  TextEditingController controllerPericias = TextEditingController();

  String forca = '';
  String dex = '';
  String con = '';
  String car = '';
  String inte = '';
  String sab = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Perícias de ${widget.personagem.nome}', context),
      body: Container(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: controllerPericias,
                      keyboardType: TextInputType.text,
                      decoration: DefaultInputDecoration(
                        context,
                        icon: MdiIcons.scriptText,
                        hintText: 'Acrobacia',
                        labelText: 'Adicionar Pericia',
                      ),
                      textCapitalization: TextCapitalization.words,
                      enabled: true),
                  suggestionsCallback: (String pattern) async {
                    return pc.getSuggestions(pattern, widget.personagem);
                  },
                  itemBuilder: (context, Pericia suggestion) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          getAtributeIcon(suggestion.atributo),
                          color: corPrimaria,
                        ),
                        title: Text(suggestion.nome),
                      ),
                    );
                  },
                  onSuggestionSelected: AdicionarPericia,
                  noItemsFoundBuilder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Nenhuma perícia encontrada!'),
                    );
                  },
                ),
              ),

              StreamBuilder<Personagem>(
                builder: (context, AsyncSnapshot<Personagem> snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  if (snapshot.data.pericias == null) {
                    return Container();
                  }
                  if (snapshot.data.pericias.length == 0) {
                    return Container();
                  }
                  int graduacaoTotal = 0;
                  for (Pericia p in snapshot.data.pericias) {
                    graduacaoTotal += p.graduacao != null ? p.graduacao : 0;
                  }
                  return hText(
                      'Pontos de Graduação Usados: ${graduacaoTotal}', context,
                      color: Colors.black,
                      size: 52,
                      style: FontStyle.italic,
                      textaling: TextAlign.start);
                },
                stream: personagensController.outPersonagenSelecionado,

              ),
              sb,

              StreamBuilder<Personagem>(
                builder: (context, AsyncSnapshot<Personagem> snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  if (snapshot.data.pericias == null) {
                    return Container();
                  }
                  if (snapshot.data.pericias.length == 0) {
                    return Container();
                  }
                  int maxGraduacao = 0;
                  for (Pericia p in snapshot.data.pericias) {
                    if (p.graduacao != null) {
                      maxGraduacao = p.graduacao >= maxGraduacao
                          ? p.graduacao
                          : maxGraduacao;
                    }
                  }
                  return hText('Graduação mais alta: ${maxGraduacao}', context,
                      color: Colors.black,
                      size: 52,
                      style: FontStyle.italic,
                      textaling: TextAlign.start);
                },
                stream: personagensController.outPersonagenSelecionado,
              ),
                Row(children: <Widget>[defaultActionButton('Ir para os Talentos', context, (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TalentoPage(personagem: widget.personagem))) ;
                })],) ,
              StreamBuilder<Personagem>(
                builder: (context, AsyncSnapshot<Personagem> snapshot) {
                  if (snapshot.data == null) {
                    return Loading(completed: Text('Erro ao buscar Pericias'));
                  }
                  if (snapshot.data.pericias == null) {
                    return Loading(
                        completed: Text('Nenhuma pericia disponivel'));
                  }
                  if (snapshot.data.pericias.length == 0) {
                    return Loading(
                        completed: Text('Nenhuma pericia disponivel'));
                  }

                  return Expanded(



                      child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return PericiasListItem(
                          snapshot.data.pericias[index], snapshot.data);
                    },
                    itemCount: snapshot.data.pericias.length,

                  )
                      );

                },
                stream: personagensController.outPersonagenSelecionado,
              ),
            ],

          ),
        ),
      ),
    );
  }

  Widget PericiasListItem(Pericia p, Personagem data) {
    TextEditingController graduacaoController = TextEditingController();
    TextEditingController totalController = TextEditingController();
    TextEditingController modificadorController = TextEditingController();
    TextEditingController bonusController = TextEditingController();
    if (p.graduacao != null) {
      graduacaoController.text = p.graduacao.toString();
    }
    if (p.total != null) {
      totalController.text = p.total.toString();
    }
    if (p.bonus != null) {
      bonusController.text = p.bonus.toString();
    }

    modificadorController.text = p.modificador == null
        ? getPericiaModificador(p.atributo, data).toString()
        : p.modificador.toString();
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        hText('${p.nome}', context, size: 50),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: getLargura(context) * .15,
                child: DefaultField(
                  label: 'Total',
                  hint: '8',
                  context: context,
                  style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(48),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  onChange: (String s) {
                    setPericia(p, graduacaoController.text,
                        modificadorController.text, bonusController.text, data);
                  },
                  controller: totalController,
                ),
              ),
              hText('=', context, size: 54),
              Container(
                width: getLargura(context) * .15,
                child: DefaultField(
                  label: 'Graduação',
                  hint: '4',
                  context: context,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  onChange: (String s) {
                    setPericia(p, graduacaoController.text,
                        modificadorController.text, bonusController.text, data);
                  },
                  controller: graduacaoController,
                ),
              ),
              hText('+', context, size: 54),
              Container(
                width: getLargura(context) * .25,
                child: DefaultField(
                  label: 'Mod (${p.atributo})',
                  hint: '4',
                  context: context,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  onChange: (String s) {},
                  controller: modificadorController,
                ),
              ),
              hText('+', context, size: 54),
              Container(
                width: getLargura(context) * .15,
                child: DefaultField(
                  label: 'Bonus',
                  hint: '2',
                  context: context,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  onChange: (String s) {
                    setPericia(p, graduacaoController.text,
                        modificadorController.text, bonusController.text, data);
                  },
                  controller: bonusController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void SalvarPericias(Pericia p) {
    try {} catch (err) {}
  }

  void AdicionarPericia(Pericia suggestion) {
    if (widget.personagem.pericias == null) {
      widget.personagem.pericias = new List<Pericia>();
    }
    suggestion.modificador =
        getPericiaModificador(suggestion.atributo, widget.personagem);
    suggestion.total = suggestion.modificador;
    widget.personagem.pericias.add(suggestion);
    widget.personagem.pericias
        .sort((Pericia a, Pericia b) => a.nome.compareTo(b.nome));
    personagensController.inPersonagenSelecionado.add(widget.personagem);
    personagensRef
        .document(widget.personagem.id)
        .updateData(widget.personagem.toJson())
        .then((v) {
      print('Personagem Atualizado');
    });
    controllerPericias.text = '';
  }

  void setPericia(Pericia p, String graduacao, String modificador, String bonus,
      Personagem personagem) {
    int grad;
    int mod;
    int bon;
    try {
      grad = int.parse(graduacao);
    } catch (err) {
      print(err);
    }
    try {
      mod = int.parse(modificador);
    } catch (err) {
      print(err);
    }
    try {
      bon = int.parse(bonus);
    } catch (err) {
      print(err);
    }
    try {
      p.graduacao = grad;
      p.modificador = mod;
      p.bonus = bon;
      grad = grad == null ? 0 : grad;
      mod = mod == null ? 0 : mod;
      bon = bon == null ? 0 : bon;
      p.total = grad + mod + bon;
      for (Pericia pericia in personagem.pericias) {
        if (pericia.nome == p.nome) {
          pericia = p;
        }
      }
      widget.personagem.pericias
          .sort((Pericia a, Pericia b) => a.nome.compareTo(b.nome));
      personagensController.inPersonagenSelecionado.add(widget.personagem);
      personagensRef
          .document(widget.personagem.id)
          .updateData(widget.personagem.toJson())
          .then((v) {
        print('Personagem Atualizado');
      });
    } catch (err) {
      print('Erro ao atualizar');
    }
  }
}
