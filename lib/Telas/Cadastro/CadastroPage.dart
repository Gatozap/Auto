//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'dart:io';

import 'package:bocaboca/Helpers/Bancos.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Rekonizer.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/Documento.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Compartilhados/LocationController.dart';
import 'package:bocaboca/Telas/Login/Login.dart';
import 'package:bocaboca/Telas/Perfil/PerfilController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Prestador.dart';
import 'package:bocaboca/Objetos/Endereco.dart';
import 'package:bocaboca/Telas/Dialogs/addEnderecoController.dart';
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

List<DropdownMenuItem<String>> _dropDownMenuItemsTipoConta;

List<DropdownMenuItem<String>> _getDropDownMenuItemsTipoConta() {
  List<DropdownMenuItem<String>> items = List();

  items.add(DropdownMenuItem(value: 'Poupança', child: Text('Poupança')));
  items.add(DropdownMenuItem(value: 'Corrente', child: Text('Corrente')));

  return items;
}

class _CadastroState extends State<Cadastro> {
  String selectTipo;
  void onChangeDropDownItens(String selectedItem) {
    setState(() {
      selectTipo = selectedItem;
    });
  }

  @override
  void initState() {
    _dropDownMenuItemsTipoConta = _getDropDownMenuItemsTipoConta();
    selectTipo = _dropDownMenuItemsTipoConta[0].value;
     if(perfilController == null){
       perfilController == PerfilController(widget.user);
     }
    super.initState();
  }

  CadastroController cc = new CadastroController();
  SwiperController sc = new SwiperController();
  String barcode = "";
  var codigo = TextEditingController();
  PerfilController perfilController;
  var controller = new MaskedTextController(mask: '000', text: '1');
  Endereco ue;
  bool isPrestador;
  Prestador prestador;
  Banco bancoSelecionado;
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
  var controllerConta_bancaria = new TextEditingController(text: '');
  var controllerTipocarro = new TextEditingController(text: '');
  var controllerCor = new TextEditingController(text: '');
  var controllerPlaca = new TextEditingController(text: '');
  var controllerAno = new TextEditingController(text: '');
  var controllerKmsmin = new TextEditingController(text: '');
  var controllerKmsmax = new TextEditingController(text: '');
  var controllerNumero_conta = new TextEditingController(text: '');
  var controllerAgencia = new TextEditingController(text: '');

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
                        var CPF = TextEditingController(text: cc.CPF);
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
                                          'Insira sua foto de CPF para validar documentação',
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

                                                    if (!snapshot.data) {
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

                                                  if (!snapshot.data) {
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
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            hText(
                                                'Anexe seu Documento CPF, para sistema preencher automaticamente o campo, porém você pode preencher manualmente o CPF. ',
                                                context,
                                                textaling: TextAlign.justify),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      case 1:
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 45),
                                hText('Insira os dados de sua conta Bancaria',
                                    context),
                                sb,
                                sb,
                                Padding(
                                  padding: ei,
                                  child: TypeAheadField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                        controller: controllerConta_bancaria,
                                        style: TextStyle(color: Colors.black),
                                        decoration: DefaultInputDecoration(
                                          context,
                                            icon: MdiIcons.bank,
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
                                new Padding(
                                  padding: ei,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: controllerAgencia,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        if(isCadastrarPressed) {
                                          return 'É necessário preencher Agencia';
                                        }
                                      }
                                    },
                                    decoration: DefaultInputDecoration(
                                      context,
                                      icon: MdiIcons.creditCard,
                                      hintText: '0999-9',
                                      labelText: 'Número da Agência com dígito',
                                    ),
                                    autovalidate: true,
                                  ),
                                ),
                                SizedBox(height: 20),
                                new Padding(
                                  padding: ei,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: controllerNumero_conta,
                                    validator: (value) {
                                      if (value.isEmpty) {
                    if(isCadastrarPressed) {
                      return 'É necessário preencher Conta Bancaria';
                    }
                                      }
                                    },
                                    decoration: DefaultInputDecoration(
                                      context,
                                      icon: MdiIcons.creditCard,
                                      hintText: '36.356-93',
                                      labelText: 'Número da conta',
                                    ),
                                    autovalidate: true,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    hText('Tipo de conta: ', context,
                                        color: corPrimaria, size: 40),
                                    sb,
                                    DropdownButton(
                                      style: TextStyle(
                                          color: corPrimaria,
                                          fontSize: ScreenUtil.getInstance()
                                              .setSp(40),
                                          fontWeight: FontWeight.bold),
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: corPrimaria),
                                      value: selectTipo,
                                      items: _dropDownMenuItemsTipoConta,
                                      onChanged: onChangeDropDownItens,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );

                      case 2:
                        return Stack(children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .85,
                                  child: SingleChildScrollView(
                                      child: Form(
                                          key: _formKey,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                sb,
                                                sb,
                                                sb,
                                                Text(
                                                  'Cadastre seu Carro',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                                sb,
                                                sb,
                                                new Padding(
                                                  padding: ei,
                                                  child: TextFormField(
                                                    controller:
                                                        controllerTipocarro,
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                    if(isCadastrarPressed) {
                      return 'É necessário preencher o tipo de carro';
                    }
                                                      }
                                                    },
                                                    decoration:
                                                        DefaultInputDecoration(
                                                      context,
                                                      icon:
                                                          Icons.directions_car,
                                                      hintText: 'Prisma',
                                                      labelText:
                                                          'Modelo de Carro',
                                                    ),
                                                    autovalidate: true,
                                                  ),
                                                ),
                                                new Padding(
                                                  padding: ei,
                                                  child: TextFormField(
                                                    controller: controllerCor,
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                    if(isCadastrarPressed) {
                      return 'É necessário preencher a cor do veículo';
                    }
                                                      }
                                                    },
                                                    decoration:
                                                        DefaultInputDecoration(
                                                      context,
                                                      icon: Icons.color_lens,
                                                      hintText: 'Azul',
                                                      labelText:
                                                          'Cor do veículo',
                                                    ),
                                                    autovalidate: true,
                                                  ),
                                                ),
                                                new Padding(
                                                  padding: ei,
                                                  child: TextFormField(
                                                    controller: controllerPlaca,
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                    if(isCadastrarPressed) {
                      return 'É necessário preencher a Placa do carro';
                    }
                                                      }
                                                    },
                                                    decoration:
                                                        DefaultInputDecoration(
                                                      context,
                                                      icon: MdiIcons.carBack,
                                                      hintText: 'AAA-9999',
                                                      labelText:
                                                          'Placa do carro',
                                                    ),
                                                    autovalidate: true,
                                                  ),
                                                ),
                                                sb,
                                                new Padding(
                                                  padding: ei,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: controllerAno,
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                    if(isCadastrarPressed) {
                      return 'É necessário preencher o ano do vínculo';
                    }
                                                      }
                                                    },
                                                    decoration:
                                                        DefaultInputDecoration(
                                                      context,
                                                      icon: Icons.today,
                                                      hintText: '2000',
                                                      labelText: 'Ano',
                                                    ),
                                                  ),
                                                ),
                                                sb,
                                                hText(
                                                    'Quanto quilometros você em média anda por mês?',
                                                    context,
                                                    color: corPrimaria,
                                                    size: 50),
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: ei,
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            controllerKmsmin,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                    if(isCadastrarPressed) {
                      return 'É necessário preencher a quantia de Kms rodados';
                    }}
                                                        },
                                                        decoration:
                                                            DefaultInputDecoration(
                                                          context,
                                                          icon:
                                                              MdiIcons.runFast,
                                                          hintText: '400',
                                                          labelText:
                                                              'Km Mínimo',
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: ei,
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            controllerKmsmax,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                    if(isCadastrarPressed) {
                      return 'É necessário preencher a quantia de Kms rodados';
                    } }
                                                        },
                                                        decoration:
                                                            DefaultInputDecoration(
                                                          context,
                                                          icon:
                                                              MdiIcons.runFast,
                                                          hintText: '1500',
                                                          labelText:
                                                              'Km Máximo',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: ei,
                                                  child: StreamBuilder(
                                                      stream: cc.outUser,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Column(
                                                          children: <Widget>[
                                                            defaultCheckBox(
                                                                Helper.localUser
                                                                    .atende_fds,
                                                                'Atende Final de Semana',
                                                                context, () {
                                                              Helper.localUser
                                                                      .atende_fds =
                                                                  !Helper
                                                                      .localUser
                                                                      .atende_fds;
                                                              cc.user = Helper
                                                                  .localUser;
                                                              cc.inUser
                                                                  .add(cc.user);
                                                            }),
                                                            sb,
                                                            defaultCheckBox(
                                                                Helper.localUser
                                                                    .atende_festa,
                                                                'Atende em Festas',
                                                                context, () {
                                                              Helper.localUser
                                                                      .atende_festa =
                                                                  !Helper
                                                                      .localUser
                                                                      .atende_festa;
                                                              cc.user = Helper
                                                                  .localUser;
                                                              cc.inUser
                                                                  .add(cc.user);
                                                            }),
                                                            sb,sb,sb,sb,
                                                          ],
                                                        );
                                                      }),
                                                )
                                              ]))))),
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
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: AlertDialog(
                                                          title: hText(
                                                              "Selecione uma opção",
                                                              context),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                                defaultActionButton(
                                                                    'Galeria',
                                                                    context,
                                                                    () {
                                                                  getImage();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                    icon: MdiIcons
                                                                        .face),
                                                                sb,
                                                                defaultActionButton(
                                                                    'Camera',
                                                                    context,
                                                                    () {
                                                                  getImageCamera();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                    icon: MdiIcons
                                                                        .camera)
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
                                        MaterialButton(
                                          color: corPrimaria,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60)),
                                          onPressed: () async {
                                            print(
                                                'gravou conta_bancaria aqui ${controllerConta_bancaria.text}');
                                            Helper.localUser.conta_bancaria =
                                                controllerConta_bancaria.text;
                                            Helper.localUser.agencia =
                                                controllerAgencia.text;
                                            Helper.localUser.numero_conta =
                                                controllerNumero_conta.text;

                                            Helper.localUser.tipo_conta =
                                                selectTipo;
                                            Helper.localUser.kmmin = int.parse(
                                                controllerKmsmin.text);
                                            Helper.localUser.kmmax = int.parse(
                                                controllerKmsmax.text);
                                            userRef
                                                .document(Helper.localUser.id)
                                                .updateData(
                                                    Helper.localUser.toJson())
                                                .then((v) {
                                              dToast(
                                                  'Banco salvo com sucesso !');
                                              sc.next(animation: true);
                                            });
                                            List<Carro> carros = new List();
                                            Carro c = new Carro(
                                              created_at: DateTime.now(),
                                              updated_at: DateTime.now(),
                                              cor: controllerCor.text,
                                              ano:
                                                  int.parse(controllerAno.text),
                                              placa: controllerPlaca.text,
                                              dono: Helper.localUser.id,
                                              modelo: controllerTipocarro.text,
                                            );
                                            carros.add(c);
                                            User u = new User(carros: carros);

                                            cc.CriarCarros(carros: c);
                                            cc.atualizarDados(sc, context, 1);
                                          },
                                          child: Text(
                                            'Concluir Cadastro',
                                            style: estiloTextoBotao,
                                          ),
                                        ),
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
