import 'dart:io';
import 'dart:math';

import 'package:bocaboca/Helpers/Bancos.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Prestador.dart';
import 'package:bocaboca/Objetos/Endereco.dart';
import 'package:bocaboca/Telas/Dialogs/addEnderecoController.dart';
import 'package:bocaboca/Telas/Home/Home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flare_checkbox/flare_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../../main.dart';

class CadastrarEstabelecimentoPage extends StatefulWidget {
  String estabelecimento;
  CadastrarEstabelecimentoPage({Key key, this.estabelecimento})
      : super(key: key);

  @override
  _CadastrarEstabelecimentoPageState createState() {
    return _CadastrarEstabelecimentoPageState();
  }
}

class _CadastrarEstabelecimentoPageState
    extends State<CadastrarEstabelecimentoPage> {
  AddEnderecoController aec;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getImageCoach(Prestador c) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                FlatButton.icon(
                  icon: const Icon(Icons.camera_alt, size: 18.0),
                  label: const Text('Camera', semanticsLabel: 'Camera'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    c.logo = image.path;
                    c.logo = await Helper().uploadPicture(c.logo);
                    dToast('Salvando nova foto de Perfil!');
                  },
                ),
                FlatButton.icon(
                  icon: const Icon(Icons.photo, size: 18.0),
                  label: const Text('Galeria', semanticsLabel: 'Galeria'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    c.logo = image.path;
                    dToast('Salvando nova foto de Perfil');
                  },
                )
              ],
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  Banco bancoSelecionado = null;
  String tipoConta;

  TextEditingController ControllerCorporateName;
  TextEditingController ControllerFancyName;
  TextEditingController ControllerDocumentNumber;
  TextEditingController ControllerMerchantCategoryCode;
  TextEditingController ControllerContactName;
  MaskedTextController ControllerContactPhone;
  TextEditingController ControllerMailAddress;
  TextEditingController ControllerWebsite;

  TextEditingController ControllerNumber = TextEditingController();
  TextEditingController ControllerOperation = TextEditingController();
  TextEditingController ControllerVerifierDigit = TextEditingController();
  TextEditingController ControllerAgencyNumber = TextEditingController();
  TextEditingController ControllerAgencyDigit = TextEditingController();
  TextEditingController bancoController = TextEditingController();

  TextEditingController controllerNomeClinica = TextEditingController();
  TextEditingController controllerNumeroClinica = TextEditingController();
  TextEditingController controllerDocumento = TextEditingController();
  MaskedTextController controllerTelefoneClinica =
      MaskedTextController(mask: '(00) 0 0000-0000');
  TextEditingController controllerEmailClinica = TextEditingController();
  String base64Image;
  bool hasAlreadyRun = false;
  File image;
  Prestador c;

  var controller = new MaskedTextController(mask: '000', text: '1');
  Endereco ue;
  bool isCoach;
  Prestador prestador;

  bool isCadastrarPressed = false;
  var controllercpf =
      new MaskedTextController(text: '', mask: '000.000.000-00');
  var controllerDataNascimento =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerDataExpedicao =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerSenha = new TextEditingController(text: '');
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerEstado = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  FocusNode myFocusNode;

  @override
  Widget build(BuildContext context) {
    if (c == null) {
      c = Prestador.Empty();
      c.numero = widget.estabelecimento;
      c.isHerbalife = true;
    }
    if (widget.estabelecimento != null) {
      controllerNumeroClinica.text = widget.estabelecimento;
    }
    if (aec == null) {
      aec = AddEnderecoController(null);
    }
    //myFocusNode = FocusNode();

    // TODO: implement build
    return Scaffold(
        appBar: myAppBar('Cadastrar Estabelecimento', context),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: StreamBuilder<Endereco>(
                    stream: aec.outEndereco,
                    builder: (context, snapshot) {
                      ue = snapshot.data;
                      if (ue == null) {
                        ue = new Endereco.Empty();
                      }
                      if (controllerCEP.text.isEmpty) {
                        controllerCEP.text = ue.cep != null ? ue.cep : '';
                      }
                      controllerCidade.text =
                          ue.cidade != null ? ue.cidade : '';
                      controllerEndereco.text =
                          ue.endereco != null ? ue.endereco : '';
                      controllerBairro.text =
                          ue.bairro != null ? ue.bairro : '';
                      if (controllerNumero.text.isEmpty) {
                        controllerNumero.text =
                            ue.numero != null ? ue.numero : '';
                      }
                      controllerComplemento.text =
                          ue.complemento != null ? ue.complemento : '';
                      print('AQUI NUMERO FDP ${ue.numero}');
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            sb,
                            sb,
                            Container(
                              width: (MediaQuery.of(context).size.width),
                              height:
                                  (MediaQuery.of(context).size.height * .25),
                              child: Center(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(320),
                                          border: Border.all(
                                              color: Colors.grey[400],
                                              width: 9)),
                                      child: CircleAvatar(
                                        backgroundImage: c.logo != null
                                            ? c.logo.contains('http')
                                                ? CachedNetworkImageProvider(
                                                    c.logo)
                                                : FileImage(File(c.logo))
                                            : AssetImage(
                                                'assets/images/prestador.jpg'),
                                        // minRadius: MediaQuery.of(context).size.width * .125,
                                        radius: ((MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15) +
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .15)) /
                                            2,
                                        //maxRadius: MediaQuery.of(context).size.width * .25,
                                      ),
                                    ),
                                    Positioned(
                                      right:
                                          -(MediaQuery.of(context).size.width *
                                              .075),
                                      bottom:
                                          ((MediaQuery.of(context).size.width *
                                                      .15) +
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .15)) /
                                              3,
                                      child: MaterialButton(
                                        child: Icon(
                                          MdiIcons.cameraOutline,
                                          color: Colors.white,
                                        ),
                                        color: Colors.black54,
                                        onPressed: () {
                                          getImageCoach(c);
                                        },
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                color: Colors.black54)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              c.nome == null
                                  ? ''
                                  : '@${c.nome.replaceAll(' ', '.')}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontStyle: FontStyle.italic),
                            ),
                            sb,
                            GestureDetector(
                              onTap: () {
                                c.isHerbalife = !c.isHerbalife;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: corPrimaria),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: FlareCheckbox(
                                        animation: 'assets/my_check_box.flr',
                                        onChanged: (b) {
                                          c.isHerbalife = !c.isHerbalife;
                                        },
                                        value: c.isHerbalife == null
                                            ? false
                                            : c.isHerbalife,
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text.rich(
                                      TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: 'Herbalife',
                                            style: TextStyle(
                                                color: c.isHerbalife
                                                    ? corPrimaria
                                                    : Colors.grey[400],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ], text: 'Distrib. Independ. '),
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16),
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            sb,
                            widget.estabelecimento != null
                                ? DefaultField(
                                    icon: Icons.person,
                                    enabled: widget.estabelecimento == null,
                                    hint: '12345-a',
                                    label: 'Cód. Espaço',
                                    maxLength: 10,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        if (isCadastrarPressed) {
                                          return 'É necessário Preencher o Codigo';
                                        }
                                      }
                                    },
                                    controller: controllerNumeroClinica,
                                    keyboardType: TextInputType.text,
                                    capitalization: TextCapitalization.words,
                                  )
                                : Container(),
                            DefaultField(
                              icon: Icons.person,
                              enabled: true,
                              hint: 'Espaço bocaboca',
                              label: 'Nome do Espaço',
                              validator: (value) {
                                if (value.isEmpty) {
                                  if (isCadastrarPressed) {
                                    return 'É necessário Preencher o Nome';
                                  }
                                }
                              },
                              controller: controllerNomeClinica,
                              keyboardType: TextInputType.text,
                              capitalization: TextCapitalization.words,
                            ),
                            DefaultField(
                              icon: Icons.person,
                              enabled: true,
                              hint: '000.000.000-00',
                              label: 'CPF/CNPJ',
                              validator: (value) {
                                if (value.isEmpty) {
                                  if (isCadastrarPressed) {
                                    return 'É necessário Preencher o CPF/CNPJ';
                                  }
                                }
                              },
                              controller: controllerDocumento,
                              keyboardType: TextInputType.text,
                              capitalization: TextCapitalization.words,
                            ),
                            DefaultField(
                              icon: Icons.phone,
                              enabled: true,
                              hint: '(11) 9 9999-9999',
                              label: 'Telefone do Espaço',
                              validator: (value) {
                                if (value.isEmpty) {
                                  if (isCadastrarPressed) {
                                    return 'É necessário Preencher o Telefone';
                                  }
                                }
                              },
                              controller: controllerTelefoneClinica,
                              keyboardType: TextInputType.number,
                              capitalization: TextCapitalization.none,
                            ),
                            DefaultField(
                              icon: Icons.email,
                              enabled: true,
                              hint: 'contato@bocaboca.com',
                              label: 'E-mail do Espaço',
                              controller: controllerEmailClinica,
                              keyboardType: TextInputType.emailAddress,
                              capitalization: TextCapitalization.none,
                            ),
                            sb,
                            new Padding(
                              padding: ei,
                              child: TextFormField(
                                onFieldSubmitted: aec.FetchCep,
                                controller: controllerCEP,
                                keyboardType: TextInputType.numberWithOptions(),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    if (isCadastrarPressed) {
                                      return 'É necessário preencher o CEP';
                                    }
                                  } else {
                                    if (value.length != 9) {
                                      if (isCadastrarPressed) {
                                        return 'CEP inválido';
                                      }
                                    } else {
                                      if (value.length == 9) {
                                        if (ue.cep != value) {
                                          aec.FetchCep(value);
                                          ue.cep = value;
                                          aec.inEndereco.add(ue);
                                          FocusScope.of(context)
                                              .requestFocus(myFocusNode);
                                        }
                                      }
                                    }
                                  }
                                },
                                decoration: DefaultInputDecoration(context,
                                  icon: Icons.assistant_photo,
                                  hintText: '00000-000',
                                  labelText: 'CEP',
                                ),
                                autovalidate: true,
                              ),
                            ),
                            new Padding(
                              padding: ei,
                              child: TextFormField(
                                controller: controllerCidade,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'É necessário preencher a Cidade';
                                  } else {
                                    ue.cidade = value;
                                    aec.inEndereco.add(ue);
                                  }
                                },
                                decoration: DefaultInputDecoration(context,
                                  icon: Icons.location_city,
                                  hintText: 'São Paulo',
                                  labelText: 'Cidade',
                                ),
                              ),
                            ),
                            new Padding(
                              padding: ei,
                              child: TextFormField(
                                controller: controllerBairro,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'É necessário preencher o Bairro';
                                  } else {
                                    ue.bairro = value;
                                    aec.inEndereco.add(ue);
                                  }
                                },
                                decoration: DefaultInputDecoration(context,
                                  icon: Icons.home,
                                  hintText: 'Centro',
                                  labelText: 'Bairro',
                                ),
                              ),
                            ),
                            new Padding(
                              padding: ei,
                              child: TextFormField(
                                controller: controllerEndereco,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'É necessário preencher o Endereço';
                                  } else {
                                    ue.endereco = value;
                                    aec.inEndereco.add(ue);
                                  }
                                },
                                decoration: DefaultInputDecoration(context,
                                  icon: Icons.add_location,
                                  hintText: 'Rua da Saúde',
                                  labelText: 'Endereço',
                                ),
                              ),
                            ),
                            new Padding(
                              padding: ei,
                              child: TextFormField(
                                controller: controllerNumero,
                                focusNode: myFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'É necessário preencher o Número';
                                  } else {
                                    ue.numero = value;
                                    aec.inEndereco.add(ue);
                                  }
                                },
                                decoration: DefaultInputDecoration(context,
                                  icon: Icons.filter_1,
                                  hintText: '3001',
                                  labelText: 'Número',
                                ),
                              ),
                            ),
                            new Padding(
                              padding: ei,
                              child: TextFormField(
                                controller: controllerComplemento,
                                validator: (value) {
                                  ue.complemento = value;
                                  aec.inEndereco.add(ue);
                                },
                                decoration: DefaultInputDecoration(context,
                                  icon: Icons.help,
                                  hintText: 'Apto. 163',
                                  labelText: 'Complemento',
                                ),
                              ),
                            ),
                            sb,
                            MaterialButton(
                                onPressed: () async {
                                  isCadastrarPressed = true;
                                  if (_formKey.currentState.validate()) {
                                    if (CPFValidator.isValid(
                                            controllerDocumento.text) ||
                                        CNPJValidator.isValid(
                                            controllerDocumento.text)) {
                                      if (c.logo != null) {
                                        Helper()
                                            .uploadPicture(c.logo)
                                            .then((v) async {
                                          Random r = new Random();
                                          String s = randomAlphaNumeric(
                                              (5 + r.nextInt(5)));
                                          Endereco e = await aec.BuscarLatLng(
                                              snapshot.data);
                                          Prestador prestador = Prestador(
                                            numero: widget.estabelecimento ==
                                                    null
                                                ? s
                                                : controllerNumeroClinica.text,
                                            created_at: DateTime.now(),
                                            deleted_at: null,
                                            updated_at: DateTime.now(),
                                            email: controllerEmailClinica.text,
                                            nome:
                                                controllerNomeClinica.text,
                                            isHerbalife: true,
                                            cpf: controllerDocumento.text,
                                            endereco: e,
                                            usuario: Helper.localUser.id,
                                            logo: v,
                                            last_payed_at: null,
                                            telefone:
                                                controllerTelefoneClinica.text,
                                          );
                                          prestadorRef
                                              .document(prestador.numero)
                                              .get()
                                              .then((v) {
                                            if (v.exists) {
                                              dToast(
                                                  '${prestador.numero} já está em Uso!');
                                            } else {
                                              prestadorRef
                                                  .document(prestador.numero)
                                                  .setData(prestador.toJson());
                                              dToast(
                                                  'Estabelecimento Criado Com Sucesso!');
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomePage()));
                                            }
                                          });
                                        });
                                      } else {
                                        Endereco e = await aec.BuscarLatLng(
                                            snapshot.data);
                                        Prestador prestador = Prestador(
                                          numero: controllerNumeroClinica.text,
                                          created_at: DateTime.now(),
                                          deleted_at: null,
                                          updated_at: DateTime.now(),
                                          cpf: controllerDocumento.text,
                                          email: controllerEmailClinica.text,
                                          nome:
                                              controllerNomeClinica.text,
                                          isHerbalife: true,
                                          endereco: snapshot.data,
                                          usuario: Helper.localUser.id,
                                          logo: null,
                                          last_payed_at: null,
                                          telefone:
                                              controllerTelefoneClinica.text,
                                        );

                                        prestadorRef
                                            .document(prestador.numero)
                                            .get()
                                            .then((v) {
                                          if (v.exists) {
                                            dToast(
                                                '${prestador.numero} já está em Uso!');
                                          } else {
                                            prestadorRef
                                                .document(prestador.numero)
                                                .setData(prestador.toJson());
                                            dToast(
                                                'Estabelecimento Criado Com Sucesso!');
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HomePage()));
                                          }
                                        });
                                      }
                                    } else {
                                      dToast('Documento inválido');
                                    }
                                  }
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    height:
                                        MediaQuery.of(context).size.height * .2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .08,
                                          decoration: BoxDecoration(
                                              color: corPrimaria,
                                              borderRadius:
                                                  BorderRadiusDirectional.all(
                                                      Radius.circular(10))),
                                          child: Center(
                                              child: Text(
                                            'Cadastrar EHN',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22),
                                          )),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                        ),
                                        Text(
                                          'Antes de atualizar, verifique de todos os campos estão preenchidos corretamente!',
                                          style: estiloTextoRodape,
                                        ),
                                      ],
                                    )))
                          ]);
                    }))));
  }
}
