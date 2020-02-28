//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'dart:io';

import 'package:autooh/Helpers/Rekonizer.dart';
import 'package:autooh/Objetos/Documento.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Compartilhados/LocationController.dart';
import 'package:autooh/Telas/Login/Login.dart';
import 'package:autooh/Telas/Perfil/PerfilController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Prestador.dart';
import 'package:autooh/Objetos/Endereco.dart';
import 'package:autooh/Telas/Dialogs/addEnderecoController.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../main.dart';
import 'CadastroController.dart';
import 'Estabelecimento/CadastrarEstabelecimentoPage.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() {
    return _CadastroState();
  }

  User user;
  Cadastro({this.user});
}

class _CadastroState extends State<Cadastro> {
  CadastroController cc = new CadastroController();
  SwiperController sc = new SwiperController();
  String barcode = "";
  var codigo = TextEditingController();
  PerfilController perfilController;
  var controller = new MaskedTextController(mask: '000', text: '1');
  Endereco ue;
  bool isPrestador;
  Prestador prestador;
  bool isCadastrarPressed = false;
  var controllercpf =
      new MaskedTextController(text: '', mask: '000.000.000-00');
  var controllerTelefone =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');
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

  ProgressDialog pr;
  Future getDocumentoCamera() async {
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
    if (cc.documento == null) {
      cc.documento = Documento();
    }
    if (cc.documento.frente != null && cc.documento.verso == null) {
      cc.documento.verso = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      for (String s in plavras) {
        print(text);
      }
    }

    if (cc.documento.frente == null) {
      cc.documento.frente = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      String sequencial = text.replaceAll('\n', ' ');
      var s = sequencial.validarDocumento;
      if (s != null) {
        switch (s) {
          case documentos.RG:
            cc.documento.tipo = 'RG';
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
          case documentos.CPF:
            cc.CPF = sequencial.getCPF;
            cc.documento.tipo = 'CPF';
            print("AQUI CPF${sequencial.getCPF}");
            cc.inCPF.add(cc.CPF);
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
          case documentos.CNH:
            cc.documento.tipo = 'CNH';
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
          case documentos.PASSAPORTE:
            cc.documento.tipo = 'PASSAPORTE';
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
        }
        ;
      } else {
        cc.documento.isValid = true;
        cc.inDocumento.add(cc.documento);
      }
    }

    cc.inDocumento.add(cc.documento);
    pr.dismiss();
    dToast('Salvando Foto!');
  }

  Future getDocumento() async {
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
    if (cc.documento == null) {
      cc.documento = Documento();
    }
    if (cc.documento.frente != null && cc.documento.verso == null) {
      cc.documento.verso = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      for (String s in plavras) {
        print(text);
      }
    }

    if (cc.documento.frente == null) {
      cc.documento.frente = await uploadPicture(
        image.path,
      );
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      vision.BatchAnnotateImagesResponse result =
          await RekognizeProvider().search(base64Image);
      print('AQUI RECONHECIMENTO ${result.toJson()}');

      List<Map<String, Object>> r = result.toJson()['responses'];
      Map<String, Object> r2 = r[0]['fullTextAnnotation'];
      String text = r2['text'];
      List<String> plavras = text.split('\n');
      String sequencial = text.replaceAll('\n', ' ');
      var s = sequencial.validarDocumento;
      if (s != null) {
        switch (s) {
          case documentos.RG:
            cc.documento.tipo = 'RG';
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
          case documentos.CPF:
            cc.CPF = sequencial.getCPF;
            cc.documento.tipo = 'CPF';
            print("AQUI CPF${sequencial.getCPF}");
            cc.inCPF.add(cc.CPF);
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
          case documentos.CNH:
            cc.documento.tipo = 'CNH';
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
          case documentos.PASSAPORTE:
            cc.documento.tipo = 'PASSAPORTE';
            cc.documento.isValid = true;
            cc.documento.data = sequencial;
            cc.inDocumento.add(cc.documento);
            break;
        }
        ;
      } else {
        cc.documento.isValid = true;
        cc.inDocumento.add(cc.documento);
      }
    }

    cc.inDocumento.add(cc.documento);
    pr.dismiss();
    dToast('Salvando Foto!');
  }

  AddEnderecoController aec;
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode;
  @override
  Widget build(BuildContext context) {
    int duracao = 300;
    return Scaffold(
        body: StreamBuilder<bool>(
            stream: cc.outIsPrestadorSelected,
            builder: (context, isPrestador) {
              if (isPrestador == null) {
                return Container();
              }
              if (isPrestador.hasData) {
                return Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    print('Pagina $index');
                    switch (index) {
                      case 0:
                        return Stack(
                          children: <Widget>[
                            Positioned(
                              child: MaterialButton(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                  color: corPrimaria,
                                  onPressed: index != null
                                      ? index < 4 - 1
                                          ? () {
                                              sc.next(animation: true);
                                            }
                                          : null
                                      : null,
                                  shape: new CircleBorder(
                                      side: BorderSide(color: corPrimaria))),
                              bottom: 5,
                              right: 10,
                            ),
                            Positioned(
                              child: MaterialButton(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  color: corPrimaria,
                                  onPressed: index != 0
                                      ? () {
                                          sc.previous(animation: true);
                                        }
                                      : null,
                                  shape: new CircleBorder(
                                      side: BorderSide(color: corPrimaria))),
                              bottom: 5,
                              left: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Bem vindo(a) ao Autooh!',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 32),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Você é ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        cc.inIsPrestadorSelected.add(true);
                                        Future.delayed(
                                                Duration(milliseconds: duracao))
                                            .then((v) {
                                          sc.next(animation: true);
                                        });
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          /* Image(
                                              image: AssetImage(
                                                  'assets/images/prestador.jpg'),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .45),*/
                                          Text('Prestador',
                                              style: TextStyle(
                                                  color: corPrimaria,
                                                  fontSize: 32)),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: isPrestador.data
                                                    ? corPrimaria
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                border: Border.all(
                                                    color: corPrimaria,
                                                    width: 2)),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            ),
                                            height: 35,
                                            width: 35,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 60),
                                    GestureDetector(
                                      onTap: () {
                                        cc.inIsPrestadorSelected.add(false);
                                        Future.delayed(
                                                Duration(milliseconds: duracao))
                                            .then((v) {
                                          sc.next(animation: true);
                                        });
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Text('Cliente',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 32)),
                                          /*Image(
                                              image: AssetImage(
                                                  'assets/images/customer.jpg'),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .45),*/
                                          Container(
                                            decoration: BoxDecoration(
                                                color: !isPrestador.data
                                                    ? Colors.blue
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                border: Border.all(
                                                    color: Colors.blue,
                                                    width: 2)),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            ),
                                            height: 35,
                                            width: 35,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                )
                              ],
                            ),
                          ],
                        );
                      case 1:
                        return StreamBuilder<bool>(
                            stream: cc.outIsMale,
                            builder: (context, gender) {
                              if (gender.data == null) {
                                return Container();
                              }
                              return Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: MaterialButton(
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                        color: corPrimaria,
                                        onPressed: index != null
                                            ? index < 4 - 1
                                                ? () {
                                                    sc.next(animation: true);
                                                  }
                                                : null
                                            : null,
                                        shape: new CircleBorder(
                                            side: BorderSide(
                                                color: corPrimaria))),
                                    bottom: 5,
                                    right: 10,
                                  ),
                                  Positioned(
                                    child: MaterialButton(
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        color: corPrimaria,
                                        onPressed: index != 0
                                            ? () {
                                                sc.previous(animation: true);
                                              }
                                            : null,
                                        shape: new CircleBorder(
                                            side: BorderSide(
                                                color: corPrimaria))),
                                    bottom: 5,
                                    left: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Você nasceu ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              cc.inIsMale.add(true);
                                              Future.delayed(Duration(
                                                      milliseconds: duracao))
                                                  .then((v) {
                                                sc.next(animation: true);
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'Menino',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(height: 10),
                                                Icon(
                                                  MdiIcons.humanMale,
                                                  size: (MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3 +
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .3) /
                                                      2,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: gender.data
                                                          ? Colors.blue
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.blue,
                                                          width: 2)),
                                                  child: Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  ),
                                                  height: 35,
                                                  width: 35,
                                                )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              cc.inIsMale.add(false);
                                              Future.delayed(Duration(
                                                      milliseconds: duracao))
                                                  .then((v) {
                                                sc.next(animation: true);
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'Menina',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(height: 10),
                                                Icon(MdiIcons.humanFemale,
                                                    color: Colors.pink,
                                                    size: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                .3 +
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .3) /
                                                        2),
                                                SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: !gender.data
                                                          ? Colors.pink
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      border: Border.all(
                                                          color: Colors.pink,
                                                          width: 2)),
                                                  child: Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  ),
                                                  height: 35,
                                                  width: 35,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                      )
                                    ],
                                  ),
                                ],
                              );
                            });
                      case 2:
                        if (ue == null) {
                          ue = new Endereco.Empty();
                        }
                        if (aec == null) {
                          aec = new AddEnderecoController(ue);
                        }

                        return Stack(children: <Widget>[
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
                                            controllerCEP.text =
                                                ue.cep != null ? ue.cep : '';
                                            controllerCidade.text =
                                                ue.cidade != null
                                                    ? ue.cidade
                                                    : '';
                                            controllerEndereco.text =
                                                ue.endereco != null
                                                    ? ue.endereco
                                                    : '';
                                            controllerBairro.text =
                                                ue.bairro != null
                                                    ? ue.bairro
                                                    : '';
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
                                                      sb,
                                                      Text(
                                                        'Cadastre seu endereço',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      ),
                                                      sb,
                                                      sb,
                                                      defaultActionButton(
                                                          'Buscar pela minha localização',
                                                          context, () async {
                                                        aec.inEndereco.add(
                                                            await lc
                                                                .getEndereco());
                                                        Future.delayed(Duration(seconds:1)).then((v) async {
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
                                                      sb,
                                                    ])));
                                      }))),
                          Positioned(
                            child: MaterialButton(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                color: corPrimaria,
                                onPressed: index != 0
                                    ? () {
                                        sc.previous(animation: true);
                                      }
                                    : null,
                                shape: new CircleBorder(
                                    side: BorderSide(color: corPrimaria))),
                            bottom: 5,
                            left: 10,
                          ),
                          Positioned(
                            child: MaterialButton(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                                color: corPrimaria,
                                onPressed: index != null
                                    ? index < 5 - 1
                                        ? () {
                                            sc.next(animation: true);
                                          }
                                        : null
                                    : null,
                                shape: new CircleBorder(
                                    side: BorderSide(color: corPrimaria))),
                            bottom: 5,
                            right: 10,
                          ),
                        ]);
                      case 3:
                        var telefone = MaskedTextController(
                            text: cc.telefone, mask: '(00) 0 0000-0000');
                        var dataNascimento = MaskedTextController(
                            text: cc.datanascimento, mask: '00/00/0000');
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .84,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        sb,
                                        sb,
                                        sb,
                                        hText('Foto do seu Perfil', context),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[

                                              GestureDetector(
                                                onTap: () =>    showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(
                                                            15.0),
                                                        child:
                                                        AlertDialog(
                                                          title: hText(
                                                              "Selecione uma opção",
                                                              context),
                                                          content:
                                                          SingleChildScrollView(
                                                            child:
                                                            ListBody(
                                                              children: <
                                                                  Widget>[
                                                                defaultActionButton(
                                                                    'Galeria',
                                                                    context,
                                                                        () {
                                                                      getImage();
                                                                      Navigator.of(context)
                                                                          .pop();
                                                                    },
                                                                    icon:
                                                                    MdiIcons.face),
                                                                sb,
                                                                defaultActionButton(
                                                                    'Camera',
                                                                    context,
                                                                        () {
                                                                      getImageCamera();
                                                                      Navigator.of(context)
                                                                          .pop();
                                                                    },
                                                                    icon:
                                                                    MdiIcons.camera)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: CircleAvatar(
                                                    radius: (((getAltura(
                                                                    context) +
                                                                getLargura(
                                                                    context)) /
                                                            2) *
                                                        .2),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child:
                                                        Helper.localUser.foto !=
                                                                null
                                                            ? Image(
                                                                image: CachedNetworkImageProvider(
                                                                    Helper
                                                                        .localUser
                                                                        .foto),
                                                              )
                                                            : Image(
                                                                image: CachedNetworkImageProvider(
                                                                    'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'),
                                                              )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        sb,
                                        StreamBuilder<String>(
                                            stream: cc.outTelefone,
                                            builder: (context, snapshot) {
                                              return TextField(
                                                  onChanged: (value) {
                                                    cc.updateTelefone(value);
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: 'Telefone',
                                                      hintText:
                                                          '(11) 9 9999-9999 (Oom WhatsApp)',
                                                      icon: Icon(
                                                          Icons.phone_iphone)),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onSubmitted: (tel) {
                                                    cc.updateTelefone(tel);
                                                    Future.delayed(Duration(
                                                            milliseconds:
                                                                duracao))
                                                        .then((v) {
                                                      sc.next(animation: true);
                                                    });
                                                  },
                                                  controller: telefone);
                                            }),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder<String>(
                                            stream: cc.outDatanascimento,
                                            builder: (context, snapshot) {
                                              return TextField(
                                                  onChanged: (value) {
                                                    cc.updateDataNascimento(
                                                        value);
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Data de Nascimento',
                                                      hintText: '29/01/1990',
                                                      icon: Icon(
                                                          Icons.date_range)),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onSubmitted: (data) {
                                                    cc.updateDataNascimento(
                                                        data);
                                                    Future.delayed(Duration(
                                                            milliseconds:
                                                                duracao))
                                                        .then((v) {
                                                      sc.next(animation: true);
                                                    });
                                                  },
                                                  controller: dataNascimento);
                                            }),
                                        sb,
                                        sb,
                                        StreamBuilder<bool>(
                                          stream: cc.outIsPrestadorSelected,
                                            builder: (context, snapshot) {
                                          if (snapshot.data == null) {
                                            return Container();
                                          }

                                          if (!snapshot.data) {
                                            return MaterialButton(
                                              color: corPrimaria,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          60)),
                                              onPressed: () async {
                                                Endereco e =
                                                    await aec.BuscarLatLng(
                                                        await aec
                                                            .outEndereco.first);
                                                e.numero =
                                                    controllerNumero.text;
                                                cc.atualizarDados(
                                                    sc, context, e, 1);
                                              },
                                              child: Text(
                                                'Concluir Cadastro',
                                                style: estiloTextoBotao,
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                      ],
                                    ),
                                  )),
                            ),
                            Positioned(
                              child: MaterialButton(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  color: corPrimaria,
                                  onPressed: index != 0
                                      ? () {
                                          sc.previous(animation: true);
                                        }
                                      : null,
                                  shape: new CircleBorder(
                                      side: BorderSide(color: corPrimaria))),
                              bottom: 5,
                              left: 10,
                            ),
                            StreamBuilder<bool>(
                                stream: cc.outIsPrestadorSelected,
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Container();
                                  }

                                  if (snapshot.data) {
                                    return Positioned(
                                      child: MaterialButton(
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          ),
                                          color: corPrimaria,
                                          onPressed: index != null
                                              ? index < 6 - 1
                                                  ? () {
                                                      sc.next(animation: true);
                                                    }
                                                  : null
                                              : null,
                                          shape: new CircleBorder(
                                              side: BorderSide(
                                                  color: corPrimaria))),
                                      bottom: 5,
                                      right: 10,
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        );

                      case 4:
                        var CPF = TextEditingController(text: cc.CPF);
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .84,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        sb,
                                        sb,
                                        Text(
                                          'Falta pouco, Preencha os seus dados',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder<Documento>(
                                            stream: cc.outDocumento,
                                            builder: (context, snapshot) {
                                              if (snapshot.data == null) {
                                                return Container();
                                              }
                                              if (snapshot.data.isValid) {
                                                return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                snapshot.data
                                                                            .verso !=
                                                                        null
                                                                    ? hText(
                                                                        'Frente',
                                                                        context)
                                                                    : Container(),
                                                                snapshot.data
                                                                            .frente ==
                                                                        null
                                                                    ? Container(
                                                                        width: snapshot.data.verso !=
                                                                                null
                                                                            ? getLargura(context) *
                                                                                .3
                                                                            : getLargura(context) *
                                                                                .6,
                                                                        height:
                                                                            getAltura(context) *
                                                                                .2,
                                                                        color: Colors
                                                                            .grey[300])
                                                                    : fotoDocumento(
                                                                        snapshot
                                                                            .data
                                                                            .frente,
                                                                        isValid: snapshot
                                                                            .data
                                                                            .isValid,
                                                                        largura: snapshot.data.verso != null
                                                                            ? getLargura(context) *
                                                                                .3
                                                                            : getLargura(context) *
                                                                                .6,
                                                                      ),
                                                                defaultActionButton(
                                                                    'Refazer',
                                                                    context,
                                                                    () {
                                                                  cc.documento
                                                                          .frente =
                                                                      null;
                                                                  cc.inDocumento
                                                                      .add(cc
                                                                          .documento);
                                                                }, icon: null),
                                                              ],
                                                            ),
                                                          ),
                                                          sb,
                                                          snapshot.data.verso !=
                                                                  null
                                                              ? Container(
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      hText(
                                                                          'Verso',
                                                                          context),
                                                                      snapshot.data.verso ==
                                                                              null
                                                                          ? Container(
                                                                              width: getLargura(context) *
                                                                                  .3,
                                                                              height: getAltura(context) *
                                                                                  .2,
                                                                              color: Colors.grey[
                                                                                  300])
                                                                          : fotoDocumento(
                                                                              snapshot.data.verso,
                                                                              isValid: snapshot.data.isValid),
                                                                      defaultActionButton(
                                                                          'Refazer',
                                                                          context,
                                                                          () {
                                                                        cc.documento.verso =
                                                                            null;
                                                                        cc.inDocumento
                                                                            .add(cc.documento);
                                                                      },
                                                                          icon:
                                                                              null),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      )
                                                    ]);
                                              }
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            hText('Frente',
                                                                context),
                                                            snapshot.data
                                                                        .frente ==
                                                                    null
                                                                ? Container(
                                                                    width: getLargura(
                                                                            context) *
                                                                        .3,
                                                                    height:
                                                                        getAltura(context) *
                                                                            .2,
                                                                    color: Colors
                                                                            .grey[
                                                                        300])
                                                                : fotoDocumento(
                                                                    snapshot
                                                                        .data
                                                                        .frente),
                                                            defaultActionButton(
                                                                'Refazer',
                                                                context, () {
                                                              cc.documento
                                                                      .frente =
                                                                  null;
                                                              cc.inDocumento.add(
                                                                  cc.documento);
                                                            }, icon: null),
                                                          ],
                                                        ),
                                                      ),
                                                      sb,
                                                      Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            hText('Verso',
                                                                context),
                                                            snapshot.data
                                                                        .verso ==
                                                                    null
                                                                ? Container(
                                                                    width: getLargura(
                                                                            context) *
                                                                        .3,
                                                                    height:
                                                                        getAltura(context) *
                                                                            .2,
                                                                    color: Colors
                                                                            .grey[
                                                                        300])
                                                                : fotoDocumento(
                                                                    snapshot
                                                                        .data
                                                                        .verso),
                                                            defaultActionButton(
                                                                'Refazer',
                                                                context, () {
                                                              cc.documento
                                                                  .verso = null;
                                                              cc.inDocumento.add(
                                                                  cc.documento);
                                                            }, icon: null),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }),
                                        StreamBuilder<String>(
                                            stream: cc.outCPF,
                                            builder: (context, snapshot) {
                                              if (snapshot.data != null &&
                                                  controllercpf.text.isEmpty) {
                                                controllercpf.text =
                                                    snapshot.data;
                                              }
                                              return StreamBuilder<bool>(
                                                  stream:
                                                      cc.outIsPrestadorSelected,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data == null) {
                                                      return Container();
                                                    }

                                                    if (snapshot.data) {
                                                      return TextField(
                                                          onChanged: (value) {
                                                            cc.updateCPF(value);
                                                          },
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  'CPF/CNPJ',
                                                              hintText:
                                                                  '000.000.000-00',
                                                              icon: Icon(Icons
                                                                  .perm_identity)),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onSubmitted: (tel) {
                                                            cc.updateCPF(tel);
                                                          },
                                                          controller: CPF);
                                                    } else {
                                                      return Container();
                                                    }
                                                  });
                                            }),
                                        sb,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            StreamBuilder<bool>(
                                                stream:
                                                    cc.outIsPrestadorSelected,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Container();
                                                  }

                                                  if (snapshot.data) {
                                                    return defaultActionButton(
                                                        'Anexar Documento',
                                                        context, () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child:
                                                                  AlertDialog(
                                                                title: hText(
                                                                    "Selecione uma opção",
                                                                    context),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      ListBody(
                                                                    children: <
                                                                        Widget>[
                                                                      defaultActionButton(
                                                                          'Galeria',
                                                                          context,
                                                                          () {
                                                                        getDocumento();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                          icon:
                                                                              MdiIcons.face),
                                                                      sb,
                                                                      defaultActionButton(
                                                                          'Camera',
                                                                          context,
                                                                          () {
                                                                        getDocumentoCamera();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                          icon:
                                                                              MdiIcons.camera)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    }, icon: null);
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                            StreamBuilder<bool>(
                                                stream:
                                                    cc.outIsPrestadorSelected,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Container();
                                                  }
                                                  if (snapshot.data) {
                                                    return defaultActionButton(
                                                        'Concluir', context,
                                                        () async {
                                                      bool isCPF =
                                                          CPFValidator.isValid(
                                                              CPF.text);
                                                      bool isCNPJ =
                                                          CNPJValidator.isValid(
                                                              CPF.text);
                                                      if (!isCPF && !isCNPJ) {
                                                        dToast(
                                                            'CPF ou CNPJ Invalido');
                                                        return;
                                                      }
                                                      Endereco e = await aec
                                                          .BuscarLatLng(
                                                              await aec
                                                                  .outEndereco
                                                                  .first);
                                                      e.numero =
                                                          controllerNumero.text;
                                                      cc.atualizarDados(
                                                          sc, context, e, 1);
                                                    }, icon: null);
                                                  } else {
                                                    return MaterialButton(
                                                      color: corPrimaria,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60)),
                                                      onPressed: () async {
                                                        Endereco e = await aec
                                                            .BuscarLatLng(
                                                                await aec
                                                                    .outEndereco
                                                                    .first);
                                                        e.numero =
                                                            controllerNumero
                                                                .text;
                                                        cc.atualizarDados(
                                                            sc, context, e, 1);
                                                      },
                                                      child: Text(
                                                        'Concluir Cadastro',
                                                        style: estiloTextoBotao,
                                                      ),
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            StreamBuilder<bool>(
                                                stream:
                                                    cc.outIsPrestadorSelected,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Container();
                                                  }

                                                  if (snapshot.data) {
                                                    return hText(
                                                        'Anexe seus Documentos para verificação de veracidade, contendo primeiro anexo a frente e segundo anexo o verso da sua documentação, em específico seu CPF. ',
                                                        context,
                                                        textaling:
                                                            TextAlign.justify);
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: MaterialButton(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  color: corPrimaria,
                                  onPressed: index != 0
                                      ? () {
                                          sc.previous(animation: true);
                                        }
                                      : null,
                                  shape: new CircleBorder(
                                      side: BorderSide(color: corPrimaria))),
                              bottom: 5,
                              left: 10,
                            ),
                          ],
                        );

                        break;
                      default:
                        return Container();
                    }
                  },
                  itemCount: isPrestador.data == true ? 5 : 4,
                  loop: false,
                  scrollDirection: Axis.horizontal,
                  controller: sc,
                  onIndexChanged: (i) {
                    cc.Validar(i, sc, context);
                  },
                  pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: FractionPaginationBuilder(
                        color: Colors.grey[400],
                        activeColor: corPrimaria,
                        fontSize: 22,
                        activeFontSize: 26,
                      )),
                );
              } else {
                cc.inIsPrestadorSelected.add(false);
                return Center(
                  child: SpinKitCircle(
                    color: corPrimaria,
                    size: 80,
                  ),
                );
              }
            }));
  }

  Future scan() async {
    print('INICIOU SCAN');
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      codigo.text = barcode;
      cc.updateCodigo(barcode);
      return;
    } on PlatformException catch (e) {
      this.barcode = 'Erro desconhecido: $e';
    } on FormatException {
      this.barcode =
          'null (Usuário retornou usando o botão de voltar antes de escanear o código. Resultado)';
    } catch (e) {
      this.barcode = 'Erro desconhecido: $e';
    }
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

  Widget fotoDocumento(String foto, {isValid = false, largura = null}) {
    largura = largura == null ? getLargura(context) * .3 : largura;
    if (isValid) {
      return Container(
          width: largura,
          height: getAltura(context) * .2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: corPrimaria,
              width: 8,
            ),
          ),
          child: Image(
              image: CachedNetworkImageProvider(foto), fit: BoxFit.fitHeight));
    }
    return Container(
        width: largura,
        height: getAltura(context) * .2,
        child: Image(
            image: CachedNetworkImageProvider(foto), fit: BoxFit.fitHeight));
  }
}
