import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Bonus.dart';
import 'package:bocaboca/Objetos/Equipamento.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:bocaboca/Objetos/Talento.dart';
import 'package:bocaboca/Telas/FichaPersonagem/EquiparPage.dart';
import 'package:bocaboca/Telas/FichaPersonagem/TalentoController.dart';
import 'package:bocaboca/Telas/Personagens/PersonagensController.dart';

class TalentoPage extends StatefulWidget {
  Personagem personagem;
  TalentoPage({Key key, this.personagem}) : super(key: key);

  @override
  _TalentoPageState createState() {
    return _TalentoPageState();
  }
}

class _TalentoPageState extends State<TalentoPage> {
  TalentoController tc;
  PersonagensController personagensController;
  @override
  void initState() {
    super.initState();

    if (tc == null) {
      tc = new TalentoController();
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

  TextEditingController controllerTalento = TextEditingController();

  String forca = '';
  String dex = '';
  String con = '';
  String car = '';
  String inte = '';
  String sab = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Talentos de ${widget.personagem.nome}', context),
      body: Container(

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: controllerTalento,
                        keyboardType: TextInputType.text,
                        decoration: DefaultInputDecoration(
                          context,
                          icon: MdiIcons.scriptText,
                          hintText: 'Atletismo',
                          labelText: 'Adicionar Talento',
                        ),
                        textCapitalization: TextCapitalization.words,
                        enabled: true),
                    suggestionsCallback: (String pattern) async {
                      return tc.getSuggestions(pattern, widget.personagem);
                    },
                    itemBuilder: (context, Talento suggestion) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            getAtributeIcon(suggestion.nome),
                            color: corPrimaria,
                          ),
                          title: Text(suggestion.nome),
                        ),

                      );

                      },

                    onSuggestionSelected: AdicionarTalentos,
                    noItemsFoundBuilder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Nenhum talento encontrado!'),
                      );

                    },

                  )
              ),Row(children: <Widget>[defaultActionButton('Ir para Equipamentos', context, (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EquiparPage(personagem: widget.personagem))) ;
              })],) ,
              StreamBuilder<Personagem>(
                stream: personagensController.outPersonagenSelecionado,
                builder: (context, AsyncSnapshot<Personagem> snapshot) {
                  if (snapshot.data == null) {
                    return Loading(completed: Text('Erro ao buscar Talentos'));
                  }
                  if (snapshot.data.talentos == null) {
                    return Loading(
                        completed: Text('Nenhum talento disponivel'));
                  }
                  if (snapshot.data.talentos.length == 0) {
                    return Loading(
                        completed: Text('Nenhum talento disponivel'));
                  }
                  return Expanded(
                      child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TalentosListItem(
                          snapshot.data.talentos[index], snapshot.data);
                    },
                    itemCount: snapshot.data.talentos.length,
                  ));
                },
              )
            ])

      ),
    );
  }

  Widget TalentosListItem(Talento t, Personagem data) {
    TextEditingController nomeController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();
    TextEditingController requerimentosController = TextEditingController();
    TextEditingController bonusController = TextEditingController();
    if (t.nome != null) {
      nomeController.text = t.nome;
    }
    if (t.descricao != null) {
      descricaoController.text = t.descricao;
    }
    if (t.bonus != null) {
      bonusController.text = t.bonus.toString();
    }
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);

    return Card(
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
                MdiIcons.bookOpenPageVariant,
                textDirection: TextDirection.rtl,
                color: corPrimaria,
                size: 35,
              ),
              sb,
              sb,
              hText('${t.nome}', context, size: 55, textaling: TextAlign.start),
            ],
          ),
          sb,
          hText('Descrição: ${t.descricao}', context,
              size: 55, textaling: TextAlign.justify),
          sb,
          Container(
            width: getLargura(context),
            child: hText(
                'Requerimentos: ${t.requerimentos == null ? 'NA' : t.requerimentos}',
                context,
                size: 55,
                textaling: TextAlign.justify),
          ),
          sb,
          t.bonus == null
              ? Container()
              : Container(
                  height: getAltura(context) * (t.bonus.length * .05),
                  child: ListView.builder(
                    itemBuilder: (context, i) {
                      return Container(
                        width: getLargura(context),
                        child: hText(
                            'Bonus: +${t.bonus[i].bonus} em ${t.bonus[i].atributo}',
                            context),
                      );
                    },
                    itemCount: t.bonus.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                )
        ],
      ),
    );
  }

  void AdicionarTalentos(Talento suggestion) {
    if (widget.personagem.talentos == null) {
      widget.personagem.talentos = new List<Talento>();
    }

    widget.personagem.talentos.add(suggestion);

    personagensController.inPersonagenSelecionado.add(widget.personagem);
    personagensRef
        .document(widget.personagem.id)
        .updateData(widget.personagem.toJson())
        .then((v) {
      print('Personagem Atualizado');
    });
    controllerTalento.text = '';
  }

  void VerificarBonus(Bonus b, Talento t) {
    if (b.isActive == true) {
      hText('Bonus: ${t.bonus}', context, size: 55);
    } else {}
  }
}
