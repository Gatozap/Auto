import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Personagem.dart';
import 'package:bocaboca/Telas/Dice/DiceWidget.dart';
import 'package:bocaboca/Telas/Macros/MacroPage.dart';

import 'BackgroundPage.dart';

class FichaPersonagemPage extends StatefulWidget {
  Personagem p;
  FichaPersonagemPage({Key key, this.p}) : super(key: key);

  @override
  _FichaPersonagemPageState createState() {
    return _FichaPersonagemPageState();
  }
}

class _FichaPersonagemPageState extends State<FichaPersonagemPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ProgressDialog pr;
  Future getImage() async {
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
            child: new FlareActor("assets/dice20.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Spin20")),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    pr.show();
    foto = await uploadPicture(
      image.path,
    );
    setState(() {});
    if (isEditar) {
      SalvarPersonagem(false);
    }
    pr.dismiss();
    dToast('Salvando Foto!');
  }

  double ticone = .05;
  TextEditingController aventuraController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController racaController = TextEditingController();
  MoneyMaskedTextController idadeController = MoneyMaskedTextController(
      rightSymbol: ' Anos',
      precision: 0,
      decimalSeparator: '',
      initialValue: 0);
  MoneyMaskedTextController alturaController = MoneyMaskedTextController(
      rightSymbol: ' cm', precision: 2, decimalSeparator: '.', initialValue: 0);
  MoneyMaskedTextController pesoController = MoneyMaskedTextController(
      rightSymbol: ' kg', precision: 1, decimalSeparator: '.', initialValue: 0);
  TextEditingController forcaController = TextEditingController();
  TextEditingController dexController = TextEditingController();
  TextEditingController conController = TextEditingController();
  TextEditingController carController = TextEditingController();
  TextEditingController inteController = TextEditingController();
  TextEditingController sabController = TextEditingController();
  TextEditingController caController = TextEditingController();
  TextEditingController baController = TextEditingController();
  TextEditingController cacController = TextEditingController();
  TextEditingController adController = TextEditingController();
  TextEditingController pvController = TextEditingController();
  TextEditingController reflController = TextEditingController();
  TextEditingController fortController = TextEditingController();
  TextEditingController vontController = TextEditingController();
  TextEditingController nivelController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController classeController = TextEditingController();

  bool isEditar = false;
  String forca = '';
  String dex = '';
  String con = '';
  String car = '';
  String inte = '';
  String sab = '';
  String ad = '';
  String cac = '';
  String foto;
  bool hasDone = false;
  @override
  Widget build(BuildContext context) {
    if (widget.p != null) {
      if (!hasDone) {
        aventuraController.text = widget.p.aventura;
        nomeController.text = widget.p.nome;
        idadeController.text = widget.p.idade.toString();
        alturaController.text = widget.p.altura.toStringAsFixed(2);
        pesoController.text = widget.p.peso.toStringAsFixed(1);
        forcaController.text = widget.p.forca.toString();
        dexController.text = widget.p.dex.toString();
        conController.text = widget.p.con.toString();
        carController.text = widget.p.car.toString();
        inteController.text = widget.p.inte.toString();
        sabController.text = widget.p.sab.toString();
        caController.text = widget.p.ca.toString();
        baController.text = widget.p.ba.toString();
        cacController.text = widget.p.cac.toString();
        adController.text = widget.p.ad.toString();
        pvController.text = widget.p.pv.toString();
        reflController.text = widget.p.refl.toString();
        fortController.text = widget.p.fort.toString();
        vontController.text = widget.p.vont.toString();
        nivelController.text = widget.p.nivel.toString();
        expController.text = widget.p.exp.toString();
        classeController.text = widget.p.classe;
        racaController.text = widget.p.raca;

        forca = getModificador(widget.p.forca).isNegative
            ? getModificador(widget.p.forca).toString()
            : '+${getModificador(widget.p.forca)}';
        dex = getModificador(widget.p.dex).isNegative
            ? getModificador(widget.p.dex).toString()
            : '+${getModificador(widget.p.dex)}';
        con = getModificador(widget.p.con).isNegative
            ? getModificador(widget.p.con).toString()
            : '+${getModificador(widget.p.con)}';
        car = getModificador(widget.p.car).isNegative
            ? getModificador(widget.p.car).toString()
            : '+${getModificador(widget.p.car)}';
        inte = getModificador(widget.p.inte).isNegative
            ? getModificador(widget.p.inte).toString()
            : '+${getModificador(widget.p.inte)}';
        sab = getModificador(widget.p.sab).isNegative
            ? getModificador(widget.p.sab).toString()
            : '+${getModificador(widget.p.sab)}';
        ad = widget.p.ad.toString();
        cac = widget.p.cac.toString();
        foto = widget.p.foto;
        isEditar = true;
        hasDone = true;
      }
    }
    return Scaffold(
      appBar: myAppBar('Cadastro de Personagem', context, showBack: true),
      body: Container(
        height: getAltura(context),
        width: getLargura(context),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: DefaultField(
                                controller: aventuraController,
                                hint: "One Piece",
                                context: context,
                                label: 'Aventura',
                                icon: Icons.map),
                            width: getLargura(context) * .5,
                          ),
                          sb,
                          sb,
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: DefaultField(
                                controller: nomeController,
                                hint: "João",
                                context: context,
                                label: 'Nome do Personagem',
                                icon: Icons.person),
                            width: getLargura(context) * .5,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: DefaultField(
                                controller: classeController,
                                hint: "Guerreiro",
                                context: context,
                                label: 'Classe',
                                icon: Icons.category),
                            width: getLargura(context) * .5,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: DefaultField(
                                controller: racaController,
                                hint: "Humano",
                                context: context,
                                label: 'Raça',
                                icon: LineAwesomeIcons.heart),
                            width: getLargura(context) * .5,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: DefaultField(
                                controller: nivelController,
                                context: context,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                                hint: "1",
                                label: 'Nivel',
                                icon: Icons.category),
                            width: getLargura(context) * .3,
                          ),
                          Container(
                              child: DefaultField(
                                  controller: expController,
                                  context: context,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                                  hint: "1000",
                                  label: 'Experiência',
                                  icon: Icons.explicit),
                              width: getLargura(context) * .6)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: getLargura(context) * .30,
                              child: DefaultField(
                                  controller: idadeController,
                                  label: "Idade",
                                  icon: Icons.add,
                                  context: context,
                                  hint: "25",
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true))),
                          Container(
                              width: getLargura(context) * .30,
                              child: DefaultField(
                                  controller: pesoController,
                                  label: "Peso",
                                  icon: Icons.add,
                                  context: context,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true))),
                          Container(
                              width: getLargura(context) * .30,
                              child: DefaultField(
                                  controller: alturaController,
                                  label: "Altura",
                                  icon: Icons.add,
                                  context: context,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true))),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: getLargura(context),
                            child: hText("Atributos", context,
                                size: 54, textaling: TextAlign.start)),
                      ),
                      Row(
                        children: <Widget>[
                          getAtributosFisicosWidget(),
                          getAtributosMentaisWidget()
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: getLargura(context),
                            child: hText("Combate", context,
                                size: 54, textaling: TextAlign.start)),
                      ),
                      getCombatesWidget(),
                      getAtaquesWidget(),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: getLargura(context),
                            child: hText("Resistências", context,
                                size: 54, textaling: TextAlign.start)),
                      ),
                      getResistencias(),
                      sb,
                      sb,
                      Row(
                        children: <Widget>[
                          defaultActionButton(
                              isEditar
                                  ? 'Atualizar Personagem'
                                  : "Salvar personagem",
                              context, () {
                            SalvarPersonagem(true);
                          }),
                          defaultActionButton("Macros", context, () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    TutorialMacroPage(personagem: widget.p)));
                          }),
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => getImage(),
                      child: CircleAvatar(
                          radius: (((getAltura(context) + getLargura(context)) /
                                  2) *
                              .2),
                          backgroundColor: Colors.transparent,
                          child: foto != null
                              ? Image(
                                  image: CachedNetworkImageProvider(foto),
                                )
                              : Image(
                                  image:
                                      AssetImage('assets/no_pic_character.png'),
                                )),
                    ),
                  ),
                ],
              ),
            ),
            DicesWidget(context).getDiceWidget()
          ],
        ),
      ),
    );
  }

  getAtributosFisicosWidget() {
    return Container(
      width: getLargura(context) * .5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image(
                  image: AssetImage('assets/for.png'),
                  width: getLargura(context) * ticone,
                  color: corPrimaria,
                  height: getLargura(context) * ticone,
                ),
                Container(
                    width: getLargura(context) * .2,
                    child: DefaultField(
                        context: context,
                        padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                        onChange: (String s) {
                          try {
                            setState(() {
                              forca = getModificador(int.parse(s)).isNegative
                                  ? getModificador(int.parse(s)).toString()
                                  : '+${getModificador(int.parse(s))}';
                            });
                          } catch (err) {
                            print('Erro: ${err.toString()}');
                          }
                          try {
                            String corpoacorpo = '';
                            List<String> bas = baController.text.split(',');
                            for (int i = 0; i < bas.length; i++) {
                              int cac = int.parse(bas[i]) +
                                  getModificador(
                                      int.parse(forcaController.text));
                              corpoacorpo += cac.toString() +
                                  (i != bas.length - 1 ? ',' : '');
                            }
                            setState(() {
                              cacController.text = corpoacorpo;
                            });
                          } catch (err) {
                            print("erro ${err.toString()}");
                          }
                          try {
                            int dist = int.parse(baController.text) +
                                getModificador(int.parse(dexController.text));
                            setState(() {
                              adController.text = dist.toString();
                            });
                          } catch (err) {
                            print("erro ${err.toString()}");
                          }
                        },
                        label: 'For',
                        controller: forcaController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: false))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: hText(forca, context, size: 44)),
              ],
            ),
            Row(
              children: <Widget>[
                Image(
                  image: AssetImage('assets/agi.png'),
                  width: getLargura(context) * ticone,
                  color: corPrimaria,
                  height: getLargura(context) * ticone,
                ),
                Container(
                    width: getLargura(context) * .2,
                    child: DefaultField(
                        context: context,
                        padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                        onChange: (String s) {
                          try {
                            setState(() {
                              dex = getModificador(int.parse(s)).isNegative
                                  ? getModificador(int.parse(s)).toString()
                                  : '+${getModificador(int.parse(s))}';
                            });
                          } catch (err) {
                            print('Erro: ${err.toString()}');
                          }
                          try {
                            int cac = int.parse(baController.text) +
                                getModificador(int.parse(forcaController.text));

                            setState(() {
                              cacController.text = cac.toString();
                            });
                          } catch (err) {
                            print("erro ${err.toString()}");
                          }
                          try {
                            String distancia = '';
                            List<String> bas = baController.text.split(',');
                            for (int i = 0; i < bas.length; i++) {
                              int ad = int.parse(bas[i]) +
                                  getModificador(int.parse(dexController.text));
                              distancia += ad.toString() +
                                  (i != bas.length - 1 ? ',' : '');
                            }
                            setState(() {
                              adController.text = distancia;
                            });
                          } catch (err) {
                            print("erro ${err.toString()}");
                          }
                        },
                        label: 'Dex',
                        controller: dexController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: false))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: hText(dex, context, size: 44)),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  MdiIcons.heart,
                  size: getLargura(context) * .05,
                  color: corPrimaria,
                ),
                Container(
                    width: getLargura(context) * .2,
                    child: DefaultField(
                        context: context,
                        padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                        onChange: (String s) {
                          try {
                            setState(() {
                              con = getModificador(int.parse(s)).isNegative
                                  ? getModificador(int.parse(s)).toString()
                                  : '+${getModificador(int.parse(s))}';
                            });
                          } catch (err) {
                            print('Erro: ${err.toString()}');
                          }
                        },
                        label: 'Con',
                        controller: conController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: false))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: hText(con, context, size: 44))
              ],
            ),
          ],
        ),
      ),
    );
  }

  getAtributosMentaisWidget() {
    return Container(
      width: getLargura(context) * .5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/sab.png'),
                    width: getLargura(context) * ticone,
                    color: corPrimaria,
                    height: getLargura(context) * ticone,
                  ),
                  Container(
                      width: getLargura(context) * .2,
                      child: DefaultField(
                          context: context,
                          padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                          onChange: (String s) {
                            try {
                              setState(() {
                                sab = getModificador(int.parse(s)).isNegative
                                    ? getModificador(int.parse(s)).toString()
                                    : '+${getModificador(int.parse(s))}';
                              });
                            } catch (err) {
                              print('Erro: ${err.toString()}');
                            }
                          },
                          label: 'Sab',
                          controller: sabController,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: hText(sab, context, size: 44)),
                ],
              ),
              Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/int.png'),
                    width: getLargura(context) * ticone,
                    color: corPrimaria,
                    height: getLargura(context) * ticone,
                  ),
                  Container(
                      width: getLargura(context) * .2,
                      child: DefaultField(
                          context: context,
                          padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                          onChange: (String s) {
                            try {
                              setState(() {
                                inte = getModificador(int.parse(s)).isNegative
                                    ? getModificador(int.parse(s)).toString()
                                    : '+${getModificador(int.parse(s))}';
                              });
                            } catch (err) {
                              print('Erro: ${err.toString()}');
                            }
                          },
                          label: 'Int',
                          controller: inteController,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: hText(inte, context, size: 44)),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    LineAwesomeIcons.money,
                    size: getLargura(context) * .05,
                    color: corPrimaria,
                  ),
                  Container(
                      width: getLargura(context) * .2,
                      child: DefaultField(
                          context: context,
                          padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                          onChange: (String s) {
                            try {
                              setState(() {
                                car = getModificador(int.parse(s)).isNegative
                                    ? getModificador(int.parse(s)).toString()
                                    : '+${getModificador(int.parse(s))}';
                              });
                            } catch (err) {
                              print('Erro: ${err.toString()}');
                            }
                          },
                          label: 'Car',
                          controller: carController,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: hText(car, context, size: 44))
                ],
              ),
            ]),
      ),
    );
  }

  getResistencias() {
    return Container(
      width: getLargura(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              MdiIcons.gestureTapHold,
              size: getLargura(context) * .05,
              color: corPrimaria,
            ),
            Container(
              width: getLargura(context) * .2,
              child: DefaultField(
                  context: context,
                  label: 'Fortitude',
                  hint: 'Base+Con',
                  controller: fortController,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false)),
            ),
            sb,
            Icon(
              MdiIcons.alarmMultiple,
              size: getLargura(context) * .05,
              color: corPrimaria,
            ),
            Container(
              width: getLargura(context) * .2,
              child: DefaultField(
                  context: context,
                  label: 'Reflexo',
                  hint: 'Base+dex',
                  controller: reflController,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false)),
            ),
            sb,
            Icon(
              MdiIcons.fire,
              size: getLargura(context) * .05,
              color: corPrimaria,
            ),
            Container(
              width: getLargura(context) * .2,
              child: DefaultField(
                  context: context,
                  label: 'Vontade',
                  hint: 'Base+sab',
                  controller: vontController,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false)),
            )
          ],
        ),
      ),
    );
  }

  getCombatesWidget() {
    return Container(
        width: getLargura(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                MdiIcons.swordCross,
                size: getLargura(context) * .05,
                color: corPrimaria,
              ),
              Container(
                width: getLargura(context) * .2,
                child: DefaultField(
                    context: context,
                    label: 'BA',
                    hint: "17,12,7 (Multiplas BA's são separadas por virgula",
                    onChange: (String a) {
                      try {
                        String corpoacorpo = '';
                        List<String> bas = a.split(',');
                        for (int i = 0; i < bas.length; i++) {
                          int cac = int.parse(bas[i]) +
                              getModificador(int.parse(forcaController.text));
                          corpoacorpo +=
                              cac.toString() + (i != bas.length - 1 ? ',' : '');
                        }
                        setState(() {
                          cacController.text = corpoacorpo;
                        });
                      } catch (err) {
                        print("erro ${err.toString()}");
                      }
                      try {
                        String distancia = '';
                        List<String> bas = a.split(',');
                        for (int i = 0; i < bas.length; i++) {
                          int ad = int.parse(bas[i]) +
                              getModificador(int.parse(dexController.text));
                          distancia +=
                              ad.toString() + (i != bas.length - 1 ? ',' : '');
                        }
                        setState(() {
                          adController.text = distancia;
                        });
                      } catch (err) {
                        print("erro ${err.toString()}");
                      }
                    },
                    controller: baController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false)),
              ),
              sb,
              Icon(
                MdiIcons.shield,
                size: getLargura(context) * .05,
                color: corPrimaria,
              ),
              Container(
                width: getLargura(context) * .2,
                child: DefaultField(
                    context: context,
                    label: 'CA',
                    hint: 'Defesa',
                    controller: caController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false)),
              ),
              sb,
              IconButton(
                  icon: Icon(
                MdiIcons.turtle,
                color: corPrimaria,
              )),
              Container(
                width: getLargura(context) * .2,
                child: DefaultField(
                    context: context,
                    label: 'PV',
                    hint: 'Pontos de Vida',
                    controller: pvController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false)),
              )
            ],
          ),
        ));
  }

  getAtaquesWidget() {
    return Container(
        width: getLargura(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                MdiIcons.axe,
                size: getLargura(context) * .05,
                color: corPrimaria,
              ),
              Container(
                width: getLargura(context) * .4,
                child: DefaultField(
                    context: context,
                    label: 'CAC',
                    hint: 'BA + For',
                    controller: cacController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false)),
              ),
              sb,
              Icon(
                MdiIcons.target,
                size: getLargura(context) * .05,
                color: corPrimaria,
              ),
              Container(
                width: getLargura(context) * .4,
                child: DefaultField(
                    label: 'AD',
                    hint: 'BA + Dex',
                    context: context,
                    controller: adController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false)),
              )
            ],
          ),
        ));
  }

  void  SalvarPersonagem(bool pop) {
    if (isEditar) {
      widget.p.nome = nomeController.text;
      widget.p.foto = '';
      widget.p.altura = StringToDouble(alturaController.text);
      widget.p.peso = StringToDouble(pesoController.text);
      widget.p.ca = StringToInt(caController.text);
      widget.p.updated_at = DateTime.now();
      widget.p.created_at = DateTime.now();
      widget.p.user = Helper.localUser.id;
      widget.p.ad = adController.text;
      widget.p.aventura = aventuraController.text;
      widget.p.ba = baController.text;
      widget.p.raca = racaController.text;

      widget.p.cac = cacController.text;
      widget.p.car = StringToInt(carController.text);
      widget.p.classe = classeController.text;
      widget.p.con = StringToInt(conController.text);
      widget.p.dex = StringToInt(dexController.text);
      widget.p.exp = StringToInt(expController.text);
      widget.p.forca = StringToInt(forcaController.text);
      widget.p.fort = StringToInt(fortController.text);
      widget.p.idade = StringToInt(idadeController.text);
      widget.p.inte = StringToInt(inteController.text);
      widget.p.nivel = StringToInt(nivelController.text);
      widget.p.pv = StringToInt(pvController.text);
      widget.p.refl = StringToInt(reflController.text);
      widget.p.sab = StringToInt(sabController.text);
      widget.p.foto = foto;
      widget.p.vont = StringToInt(vontController.text);
      widget.p.pv_total = StringToInt(pvController.text);
      personagensRef
          .document(widget.p.id)
          .updateData(widget.p.toJson())
          .then((v) {
        dToast('Personagem Salvo com sucesso!');
        //TODO ABRIR PROXIMA TELA;

        if (pop) {
          Navigator.of(context).pop();
        }
      });
    } else {
      try {
        Personagem p = Personagem(
            nome: nomeController.text,
            foto: foto,
            altura: StringToDouble(alturaController.text),
            peso: StringToDouble(pesoController.text),
            ca: StringToInt(caController.text),
            updated_at: DateTime.now(),
            created_at: DateTime.now(),
            user: Helper.localUser.id,
            ad: adController.text,
            pv_total: StringToInt(pvController.text),
            aventura: aventuraController.text,
            ba: baController.text,
            raca: racaController.text,
            cac: cacController.text,
            car: StringToInt(carController.text),
            classe: classeController.text,
            con: StringToInt(conController.text),
            dex: StringToInt(dexController.text),
            exp: StringToInt(expController.text),
            forca: StringToInt(forcaController.text),
            fort: StringToInt(fortController.text),
            idade: StringToInt(idadeController.text),
            inte: StringToInt(inteController.text),
            nivel: StringToInt(nivelController.text),
            pv: StringToInt(pvController.text),
            refl: StringToInt(reflController.text),
            sab: StringToInt(sabController.text),
            vont: StringToInt(vontController.text));
        personagensRef.add(p.toJson()).then((v) {
          p.id = v.documentID;
          personagensRef
              .document(v.documentID)
              .updateData(p.toJson())
              .then((v) {
            dToast('Personagem Salvo com sucesso!');
            //TODO ABRIR PROXIMA TELA;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BackgroundPage(personagem: p)));
          });
        }).catchError((err) {
          print('Erro Ao salvar ${err.toString()}');
        });
      } catch (err) {
        print('Erro ao converter valores ${err.toString()}');
      }
    }
  }
}
