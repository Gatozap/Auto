import 'dart:convert';
import 'dart:io';

import 'package:autooh/Helpers/Bancos.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/PhotoScroller.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Documento.dart';
import 'package:autooh/Objetos/Endereco.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/LocationController.dart';
import 'package:autooh/Telas/Cadastro/CadastroController.dart';
import 'package:autooh/Telas/Perfil/PerfilController.dart';
import 'package:autooh/Telas/Perfil/addEndereco.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';  
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'PerfilVistoPage.dart';
import 'addEnderecoController.dart';

class EditarPerfilPage extends StatefulWidget {
  User user;
  EditarPerfilPage({Key key, this.user}) : super(key: key);

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  @override
  void initState() {
    if (perfilController == null) {
      perfilController == PerfilController(widget.user);
    }
    if (aec == null) {
      aec = AddEnderecoController(ue);
    }
    if (ue == null) {
      ue = new Endereco.Empty();
    }
    super.initState();
  }

  CadastroController cc = new CadastroController();
  AddEnderecoController aec;
  bool isCadastrarPressed = false;
  Endereco ue;
  Banco bancoSelecionado;
  var controllerTelefone =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');
  var controllerConta_bancaria = new TextEditingController(text: '');
  var controllerDataNascimento =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerDataExpedicao =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerSenha = new TextEditingController(text: '');
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerEstado = new TextEditingController(text: '');
  var controllerNomeBanco = new TextEditingController(text: '');
  var controllerCPFBanco = new TextEditingController(text: '');
  var controllerNome = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  var controllerEmail = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  var controllerAgencia = new TextEditingController(text: '');
  var controllerKmmin = new TextEditingController(text: '');
  var controllerKmmax = new TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  var controllerNumero_conta = new TextEditingController(text: '');
  PerfilController perfilController;
   User user;
  bool isPressed = false;
  bool onLoad = true;
  FocusNode myFocusNode;
  @override
  Widget build(BuildContext context) {
    if (perfilController == null) {
      perfilController = PerfilController(widget.user);
    }


    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Color(0xFFE8F5E9),
          Color(0xFFE0F7FA),
        ],
      ),
    );
    return Scaffold(
      appBar: myAppBar('Editar Perfil', context),
      body: Stack(children: <Widget>[
        Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.4,
            child: Container(
              decoration: linearGradient,
              height: getAltura(context),
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              child: Container(
                height: getAltura(context),
                child: StreamBuilder(
                  stream: perfilController.outUser,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container();
                    }
                    User u = snapshot.data;

                    if (onLoad) {
                      controllerNome.text = u.nome;
                      controllerTelefone.text = u.celular;
                      controllerEmail.text = u.email;
                      controllerConta_bancaria.text = u.conta_bancaria;
                      controllerAgencia.text = u.agencia;
                      controllerNumero_conta.text = u.numero_conta;
                      controllerCPFBanco.text = '${(u.cpf_conta == null? u.cpf: u.cpf_conta)}';
                      controllerNomeBanco.text = '${(u.nome_conta == null? u.nome: u.nome_conta)}';
                      controllerKmmin.text = u.kmmin.toString();
                      controllerKmmax.text = u.kmmax.toString();
                      print("AQUI ENDEREÇO ${u.endereco.toString()}");
                      if(controllerCEP.text.isEmpty){
                        controllerCEP.text = u.endereco.cep == null? '0': u.endereco.cep;
                      }

                      if (controllerCidade.text.isEmpty) {
                        controllerCidade.text =
                            u.endereco.cidade == null ? '0' : u.endereco.cidade;
                      }
                      if (controllerEndereco.text.isEmpty) {
                        controllerEndereco.text = u.endereco.endereco == null
                            ? '0'
                            : u.endereco.endereco;
                      }
                      if (controllerBairro.text.isEmpty) {
                        controllerBairro.text =
                            u.endereco.bairro == null ? '0' : u.endereco.bairro;
                      }
                      if (controllerComplemento.text.isEmpty) {
                        controllerComplemento.text =
                            u.endereco.complemento == null
                                ? ''
                                : u.endereco.complemento;
                      }

                      if (controllerNumero.text.isEmpty) {
                        controllerNumero.text =
                            u.endereco.numero == null ? '' : u.endereco.numero;
                      }
                      onLoad = false;
                    }
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: AlertDialog(
                                      title:
                                          hText("Selecione uma opção", context),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            defaultActionButton(
                                                'Galeria', context, () {
                                              getImage();
                                              Navigator.of(context).pop();
                                            }, icon: MdiIcons.face),
                                            sb,
                                            defaultActionButton(
                                                'Camera', context, () {
                                              getImageCamera();
                                              Navigator.of(context).pop();
                                            }, icon: MdiIcons.camera)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            child: CircleAvatar(
                                radius: (((getAltura(context) +
                                            getLargura(context)) /
                                        2) *
                                    .2),
                                backgroundColor: Colors.transparent,
                                child: u.foto != null
                                    ? Stack(
                                        children: <Widget>[
                                          Positioned(
                                            child: CircleAvatar(
                                              radius: 75,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      u.foto),
                                            ),
                                          ),
                                          Positioned(
                                            top: 100,
                                            left: 115,
                                            child: Center(
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.black,
                                                child: Icon(
                                                  MdiIcons.cameraOutline,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Stack(children: <Widget>[
                                        Positioned(
                                          child: Image(
                                              image: AssetImage(
                                                  'assets/editar_perfil.png')),
                                        ),
                                        Positioned(
                                          top: 35,
                                          left: 75,
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.black12,
                                              child: Icon(
                                                MdiIcons.cameraOutline,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])),
                          ),
                          sb,
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 30),
                            child: DefaultField(
                              controller: controllerNome,
                              hint: u.nome,
                              context: context,
                              label: 'Nome',
                              icon: FontAwesomeIcons.user,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 30),
                            child: DefaultField(
                              controller: controllerEmail,
                              hint: u.email,
                              context: context,
                              label: 'Email',
                              icon: FontAwesomeIcons.envelope,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (isPressed) {
                                  if (value.contains('@')) {
                                    u.email = value.removerAcentos;

                                    perfilController.inUser.add(u);
                                    return null;
                                  } else {
                                    return 'E-mail inválido!';
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 30),
                            child: DefaultField(
                                controller: controllerTelefone,
                                hint: u.celular,
                                context: context,
                                label: 'Telefone',
                                icon: FontAwesomeIcons.mobileAlt,
                                keyboardType: TextInputType.phone),
                          ),
                          sb,
                          Divider(color: corPrimaria),
                          sb,
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                hText('   Dados Bancários', context, size: 50)
                              ]),
                          sb,
                          Divider(color: corPrimaria),
                          sb,
                          Padding(
                            padding: EdgeInsets.only(left: 60, right: 30),
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: controllerConta_bancaria,
                                  style: TextStyle(color: Colors.black),
                                  decoration: DefaultInputDecoration(context,
                                      icon: FontAwesomeIcons.university,
                                      labelText: 'Banco',
                                      hintText: 'Caixa Economica Federal')),
                              suggestionsCallback: (pattern) async {
                                return await Banco.getSuggestions(pattern);
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion.nome),
                                );
                              },
                              onSuggestionSelected: (Banco suggestion) {
                                bancoSelecionado = suggestion;
                                controllerConta_bancaria.text = suggestion.nome;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 21),
                            child: DefaultField(
                              controller: controllerAgencia,
                              hint: u.agencia,
                              context: context,
                              label: 'Agência',
                              icon: FontAwesomeIcons.creditCard,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 21),
                            child: DefaultField(
                              controller: controllerNomeBanco,
                              hint: u.agencia,
                              context: context,
                              label: 'Nome do Titular',
                              icon: FontAwesomeIcons.user,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 21),
                            child: DefaultField(
                              controller: controllerCPFBanco,
                              hint: '000.000.000-00',
                              context: context,
                              label: 'Cpf do Titular',
                              icon: FontAwesomeIcons.dochub,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 21),
                            child: DefaultField(
                              controller: controllerNumero_conta,
                              hint: u.numero_conta,
                              context: context,
                              label: 'Número da Conta',
                              icon: FontAwesomeIcons.creditCard,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 55, right: 5),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/velocimetro_low.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(right: 21),
                                child: DefaultField(
                                  keyboardType: TextInputType.number,
                                  controller: controllerKmmin,
                                  hint: '${u.kmmin}',
                                  context: context,
                                  label: 'Quilometros percorridos no Mínimo',
                                  icon: null,
                                ),
                              )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 55, right: 5),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/velocimetro_fast.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 21),
                                      child: DefaultField(
                                        keyboardType: TextInputType.number,
                                        controller: controllerKmmax,
                                        hint: '${u.kmmax}',
                                        context: context,
                                        label: 'Quilometros percorridos Máximo',
                                        icon: null,
                                      ))),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .85,
                                  child: StreamBuilder<Endereco>(
                                      stream: aec.outEndereco,
                                      builder: (context, snapshot) {
                                        ue = snapshot.data;
                                        if (myFocusNode == null) {
                                          myFocusNode = FocusNode();
                                        }

                                        if (ue != null) {
                                          if (controllerCEP.text.isEmpty) {
                                            controllerCEP.text =
                                                ue.cep != null ? ue.cep : '';
                                          }
                                          if (controllerCidade.text.isEmpty) {
                                            controllerCidade.text =
                                                ue.cidade != null
                                                    ? ue.cidade
                                                    : '';
                                          }
                                          if (controllerEndereco.text.isEmpty) {
                                            controllerEndereco.text =
                                                ue.endereco != null
                                                    ? ue.endereco
                                                    : '';
                                          }
                                          if (controllerBairro.text.isEmpty) {
                                            controllerBairro.text =
                                                ue.bairro != null
                                                    ? ue.bairro
                                                    : '';
                                          }
                                          if (controllerNumero.text.isEmpty) {
                                            controllerNumero.text =
                                                ue.numero != null
                                                    ? ue.numero
                                                    : '';
                                          }
                                          if (controllerComplemento
                                              .text.isEmpty) {
                                            controllerComplemento.text =
                                                ue.complemento != null
                                                    ? ue.complemento
                                                    : '';
                                          }
                                        }
                                        return SingleChildScrollView(
                                            child: Form(
                                                key: _formKey,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      sb,
                                                      sb,
                                                      Divider(
                                                          color: corPrimaria),
                                                      sb,
                                                      Text(
                                                        'Cadastre seu endereço',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      ),
                                                      sb,
                                                      Divider(
                                                          color: corPrimaria),
                                                      sb,
                                                      defaultActionButton(
                                                          'Buscar Localização',
                                                          context, () async {
                                                        print('apertou');
                                                        aec.inEndereco.add(
                                                            await lc
                                                                .getEndereco());
                                                        Future.delayed(Duration(
                                                                seconds: 1))
                                                            .then((v) async {
                                                          aec.inEndereco.add(
                                                              await lc
                                                                  .getEndereco());
                                                        });
                                                      }, icon: null),
                                                      sb,
                                                      sb,
                                                      new Padding(
                                                        padding: ei,
                                                        child: TextFormField(
                                                          onFieldSubmitted:
                                                              aec.FetchCep,
                                                          controller:
                                                              controllerCEP,
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(),
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              if (isCadastrarPressed) {
                                                                return 'É necessário preencher o CEP';
                                                              }
                                                            } else {
                                                              if (value
                                                                      .length !=
                                                                  9) {
                                                                if (isCadastrarPressed) {
                                                                  return 'CEP inválido';
                                                                }
                                                              } else {
                                                                if (value
                                                                        .length ==
                                                                    9) {
                                                                  if (ue ==
                                                                      null) {
                                                                    ue = new Endereco
                                                                        .Empty();
                                                                  }
                                                                  if (ue.cep !=
                                                                      value) {
                                                                    aec.FetchCep(
                                                                        value);
                                                                    ue.cep =
                                                                        value;
                                                                    aec.inEndereco
                                                                        .add(
                                                                            ue);
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            myFocusNode);
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          },
                                                          decoration:
                                                              DefaultInputDecoration(
                                                            context,
                                                            icon: Icons
                                                                .assistant_photo,
                                                            hintText:
                                                                '00000-000',
                                                            labelText: 'CEP',
                                                          ),
                                                          autovalidate: true,
                                                        ),
                                                      ),
                                                      new Padding(
                                                        padding: ei,
                                                        child: TextFormField(
                                                          controller:
                                                              controllerCidade,
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'É necessário preencher a Cidade';
                                                            } else {
                                                              ue.cidade = value;
                                                              aec.inEndereco
                                                                  .add(ue);
                                                            }
                                                          },
                                                          decoration:
                                                              DefaultInputDecoration(
                                                            context,
                                                            icon: Icons
                                                                .location_city,
                                                            hintText:
                                                                'São Paulo',
                                                            labelText: 'Cidade',
                                                          ),
                                                        ),
                                                      ),
                                                      new Padding(
                                                        padding: ei,
                                                        child: TextFormField(
                                                          controller:
                                                              controllerBairro,
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'É necessário preencher o Bairro';
                                                            } else {
                                                              ue.bairro = value;
                                                              aec.inEndereco
                                                                  .add(ue);
                                                            }
                                                          },
                                                          decoration:
                                                              DefaultInputDecoration(
                                                            context,
                                                            icon: Icons.home,
                                                            hintText: 'Centro',
                                                            labelText: 'Bairro',
                                                          ),
                                                        ),
                                                      ),
                                                      new Padding(
                                                        padding: ei,
                                                        child: TextFormField(
                                                          controller:
                                                              controllerEndereco,
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'É necessário preencher o Endereço';
                                                            } else {
                                                              ue.endereco =
                                                                  value;
                                                              aec.inEndereco
                                                                  .add(ue);
                                                            }
                                                          },
                                                          decoration:
                                                              DefaultInputDecoration(
                                                            context,
                                                            icon: Icons
                                                                .add_location,
                                                            hintText:
                                                                'Rua da Saúde',
                                                            labelText:
                                                                'Endereço',
                                                          ),
                                                        ),
                                                      ),
                                                      new Padding(
                                                        padding: ei,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              controllerNumero,
                                                          focusNode:
                                                              myFocusNode,
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'É necessário preencher o Número';
                                                            } else {
                                                              ue.numero = value;
                                                              aec.inEndereco
                                                                  .add(ue);
                                                            }
                                                          },
                                                          decoration:
                                                              DefaultInputDecoration(
                                                            context,
                                                            icon:
                                                                Icons.filter_1,
                                                            hintText: '3001',
                                                            labelText: 'Número',
                                                          ),
                                                        ),
                                                      ),
                                                      new Padding(
                                                        padding: ei,
                                                        child: TextFormField(
                                                          controller:
                                                              controllerComplemento,
                                                          validator: (value) {
                                                            ue.complemento =
                                                                value;
                                                            aec.inEndereco
                                                                .add(ue);
                                                          },
                                                          decoration:
                                                              DefaultInputDecoration(
                                                            context,
                                                            icon: Icons.home,
                                                            hintText:
                                                                'Apto. 163',
                                                            labelText:
                                                                'Complemento',
                                                          ),
                                                        ),
                                                      ),
                                                    ])));
                                      }))),
                          sb,
                          Divider(color: corPrimaria),
                          sb,
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                hText('   Rotinas de Trabalho', context,
                                    size: 50)
                              ]),
                          sb,
                          Divider(color: corPrimaria),
                          sb,
                          sb,
                          StreamBuilder(
                              stream: perfilController.outUser,
                              builder: (context, snapshot) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, right: 30),
                                      child: defaultCheckBox(
                                          Helper.localUser.atende_fds,
                                          'Atende Final de Semana',
                                          context, () {
                                        Helper.localUser.atende_fds =
                                            !Helper.localUser.atende_fds;
                                        perfilController.u = Helper.localUser;
                                        perfilController.inUser
                                            .add(perfilController.u);
                                      }),
                                    ),
                                    sb,
                                    sb,
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, right: 30),
                                      child: defaultCheckBox(
                                          Helper.localUser.atende_festa,
                                          'Atende em Festas',
                                          context, () {
                                        Helper.localUser.atende_festa =
                                            !Helper.localUser.atende_festa;
                                        perfilController.u = Helper.localUser;
                                        perfilController.inUser
                                            .add(perfilController.u);
                                      }),
                                    ),
                                    sb,
                                    sb,
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          defaultCheckBox(
                                              Helper.localUser.manha,
                                              'Circula na parte da manhã',
                                              context, () {
                                            Helper.localUser.manha =
                                                !Helper.localUser.manha;
                                            perfilController.u =
                                                Helper.localUser;
                                            perfilController.inUser
                                                .add(perfilController.u);
                                          }),
                                        ],
                                      ),
                                    ),
                                    sb,
                                    sb,
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          defaultCheckBox(
                                              Helper.localUser.tarde,
                                              'Circula na parte da tarde',
                                              context, () {
                                            Helper.localUser.tarde =
                                                !Helper.localUser.tarde;
                                            perfilController.u =
                                                Helper.localUser;
                                            perfilController.inUser
                                                .add(perfilController.u);
                                          }),
                                        ],
                                      ),
                                    ),
                                    sb,
                                    sb,
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 50, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          defaultCheckBox(
                                            Helper.localUser.noite,
                                            'Circula na parte da noite',
                                            context,
                                            () {
                                              Helper.localUser.noite =
                                                  !Helper.localUser.noite;
                                              perfilController.u =
                                                  Helper.localUser;
                                              perfilController.inUser
                                                  .add(perfilController.u);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          sb,
                          sb,
                          Container(
                            child:
                                defaultActionButton('Atualizar', context, () {
                              if (int.parse(controllerKmmin.text) > 4000) {
                                u.nome = controllerNome.text;
                                u.celular = controllerTelefone.text;
                                u.email = controllerEmail.text;
                                u.numero_conta = controllerNumero_conta.text;
                                u.agencia = controllerAgencia.text;
                                u.conta_bancaria =
                                    controllerConta_bancaria.text;
                                u.kmmin = int.parse(controllerKmmin.text);
                                u.kmmax = int.parse(controllerKmmax.text);
                                u.updated_at = DateTime.now();
                                u.endereco = ue;
                                u.endereco.numero = controllerNumero.text;
                                u.endereco.complemento = controllerComplemento.text;
                                onLoad = true;
                                perfilController.updateUser(u).then((v) {
                                  if (v == 'Atualizado com sucesso!') {
                                    dToast('Dados atualizados com sucesso!');
                                    Navigator.of(context).pop();
                                  } else {
                                    dToast('Dados atualizados com sucesso!');
                                  }
                                });
                              } else {
                                dToast(
                                    'Kilometragem minima precisa ser superior a 4 mil!');
                              }
                            }, size: 90, icon: null),
                          ),
                          sb,
                          sb,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ))
      ]),
    );
  }

  ProgressDialog pr;
  Future getDocumentoCamera(User u) async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
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
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    pr.show();
    if (u.documentos == null) {
      u.documentos = new List();
    }
    Documento d = new Documento();
    if (d.frente != null && d.verso == null) {
      d.verso = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
    }

    if (d.frente == null) {
      d.frente = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
        d.isValid = true;
        u.documentos.add(d);
        perfilController.updateUser(u);
    }

    u.documentos.add(d);
    perfilController.updateUser(u);
    pr.dismiss();
    dToast('Salvando Documento!');
  }

  Future getDocumento(User u) async {
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
          child: SpinKitCircle(
            color: corPrimaria,
            size: 80,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    pr.show();
    if (u.documentos == null) {
      u.documentos = new List();
    }
    Documento d = new Documento();
    if (d.frente != null && d.verso == null) {
      d.verso = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

    if (d.frente == null) {
      d.frente = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      } else {
        d.isValid = true;
        u.documentos.add(d);
        perfilController.updateUser(u);
      }
    }

    u.documentos.add(d);
    perfilController.updateUser(u);
    pr.dismiss();
    dToast('Salvando Documento!');
  }

  Future getImageCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
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
        ));
    pr.show();
    Helper.localUser.foto = await uploadPicture(
      image.path,
    );
    perfilController.updateUser(Helper.localUser);
    pr.dismiss();
    dToast('Salvando Foto!');
  }

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
        ));
    pr.show();
    Helper.localUser.foto = await uploadPicture(
      image.path,
    );
    perfilController.updateUser(Helper.localUser);
    pr.dismiss();
    dToast('Salvando Foto!');
  }
}
