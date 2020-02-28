import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Pacote.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:short_stream_builder/short_stream_builder.dart';

import '../../../main.dart';
import 'CadastrarPacoteController.dart';

class CadastrarPacotePage extends StatefulWidget {
  @override
  _CadastrarPacotePageState createState() {
    return _CadastrarPacotePageState();
  }
}

class _CadastrarPacotePageState extends State<CadastrarPacotePage> {
  final _formKey = GlobalKey<FormState>();
  var controllerTitulo = new TextEditingController(text: '');
  var controllerDescricao = TextEditingController(text: '');

  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerEstado = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  bool isCadastrarPressed = false;
  var controllerPreco = new TextEditingController();
  var controllerValor = new TextEditingController();
  CadastrarPacoteController cpc;
  Pacote produto;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    /*Future.delayed(Duration(seconds: 4)).then((v) {
      coachRef.document(Helper.localUser.prestador).get().then((v) {
        prestador c = prestador.fromJson(v.data);
        if (!c.isMerchant) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CadastrarMerchantPage(
                        c: c,
                      )));
        }
      });
    });*/
  }

  Future getImage(Pacote e) async {
    if (e == null) {
      e = new Pacote.Empty();
    }
    File image = await ImagePicker.pickImage(source: ImageSource.gallery)
        .timeout(Duration(seconds: 30))
        .catchError((err) {
      print('ERRO NO IMAGE PICKER ${err.toString()}');
    });
    if (image != null) {
      if (image.path != null) {
        e.foto = image.path;
        cpc.inPacote.add(e);
        dToast('Salvando Foto!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cpc == null) {
      cpc = CadastrarPacoteController();
    }
    if (produto == null) {
      produto = new Pacote.Empty();
      cpc.inPacote.add(produto);
    }

    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawerWidget(),
      appBar: myAppBar('Novo Crédito Antecipado', context, showBack: true),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: SSB(
                isList: false,
                stream: cpc.outPacote,
                buildfunction: (context, AsyncSnapshot snap) {
                  produto = snap.data;
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        sb,
                        Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(children: <Widget>[
                              snap.data.foto != null
                                  ? Container(
                                      child: Center(
                                          child: snap.data.foto.contains('http')
                                              ? Image(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          snap.data.foto),
                                                  height: 200,
                                                )
                                              : Image.file(
                                                  File(snap.data.foto))))
                                  : Image.asset(
                                      'assets/images/nutrannoLogo.png',
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                              Center(
                                child: MaterialButton(
                                  child: Icon(
                                    MdiIcons.cameraOutline,
                                    color: Colors.white,
                                  ),
                                  color: Colors.transparent,
                                  onPressed: () {
                                    getImage(snap.data);
                                  },
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color: Colors.transparent)),
                                ),
                              )
                            ])),
                        DefaultField(
                            controller: controllerTitulo,
                            hint: 'Crédito antecipado de R\$180',
                            label: 'Título',
                            context: context,
                            icon: FontAwesomeIcons.adn,
                            validator: (v) {},
                            keyboardType: TextInputType.text,
                            capitalization: TextCapitalization.words,
                            onSubmited: (s) {}),
                        sb,
                        DefaultField(
                            controller: controllerValor,
                            hint: 'R\$200,00',
                            context: context,
                            label: 'Crédito em Produtos',
                            enabled: true,
                            icon: FontAwesomeIcons.cashRegister,
                            capitalization: TextCapitalization.none,
                            validator: (v) {
                              if (isCadastrarPressed) {
                                try {
                                  if (v.isEmpty ||
                                      double.parse(v
                                                  .replaceAll(',', '.')
                                                  .replaceAll('cm', '')
                                                  .replaceAll('c', '')
                                                  .replaceAll('m', '')) ==
                                              0 &&
                                          isCadastrarPressed) {
                                    return 'É necessário preencher o Valor';
                                  } else {}
                                } catch (err) {
                                  print(err.toString());
                                  return 'Erro: Formato numérico inválido!';
                                }
                              }
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            onSubmited: (s) {}),
                        DefaultField(
                            controller: controllerPreco,
                            hint: 'R\$180,00',
                            context: context,
                            label: 'Preço (custo)',
                            enabled: true,
                            icon: FontAwesomeIcons.cashRegister,
                            capitalization: TextCapitalization.none,
                            validator: (v) {
                              if (isCadastrarPressed) {
                                try {
                                  if (v.isEmpty ||
                                      double.parse(v
                                                  .replaceAll(',', '.')
                                                  .replaceAll('cm', '')
                                                  .replaceAll('c', '')
                                                  .replaceAll('m', '')) ==
                                              0 &&
                                          isCadastrarPressed) {
                                    return 'É necessário preencher o Preço';
                                  } else {}
                                } catch (err) {
                                  print(err.toString());
                                  return 'Erro: Formato numérico inválido!';
                                }
                              }
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            onSubmited: (s) {}),
                        sb,
                        defaultActionButton(
                            'Cadastrar',context,
                         () {
                              isCadastrarPressed = true;
                              if (_formKey.currentState.validate()) {
                                dToast(
                                    'Cadastrando Crédito antecipado que pode ser vendido aos clientes.');
                                produto.titulo = controllerTitulo.text;
                                produto.prestador = Helper.localUser.prestador;
                                produto.preco =
                                    (double.parse(controllerPreco.text) * 100)
                                        .toInt();
                                produto.valor =
                                    (double.parse(controllerValor.text) * 100)
                                        .toInt();
                                produto.updated_at = DateTime.now();
                                produto.created_at = DateTime.now();

                                cpc.CadastrarPacote(produto).then((v) {
                                  if (v.titulo == produto.titulo) {
                                    dToast('Produto criado com sucesso!');
                                    Navigator.of(context).pop();
                                  } else {
                                    dToast(
                                        'Erro ao cadastrar Crédito antecipado! ${v.toString()}');
                                  }
                                });
                              }
                            },),
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
