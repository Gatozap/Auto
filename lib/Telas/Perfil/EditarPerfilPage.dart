import 'dart:convert';
import 'dart:io';

import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/PhotoScroller.dart';
import 'package:bocaboca/Helpers/Rekonizer.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Documento.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Cadastro/CadastroController.dart';
import 'package:bocaboca/Telas/Perfil/PerfilController.dart';
import 'package:bocaboca/Telas/Perfil/addEndereco.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditarPerfilPage extends StatefulWidget {
  User user;
  EditarPerfilPage({Key key, this.user}) : super(key: key);

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  CadastroController cc = new CadastroController();
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
  var controllerNome = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  var controllerEmail = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  var controllerAgencia = new TextEditingController(text: '');
  var controllerKmmin = new TextEditingController(text: '');
  var controllerKmmax = new TextEditingController(text: '');

  var controllerNumero_conta = new TextEditingController(text: '');
  PerfilController perfilController;

  bool isPressed = false;
  bool onLoad = true;

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
                      onLoad = false;
                    }
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () =>  showDialog(
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
                                radius: (((getAltura(context) +
                                            getLargura(context)) /
                                        2) *
                                    .2),
                                backgroundColor: Colors.transparent,
                                child: u.foto != null
                                    ? Image(
                                        image:
                                            CachedNetworkImageProvider(u.foto),
                                      )
                                    : Image(
                                        image: CachedNetworkImageProvider(
                                            'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'),
                                      )),
                          ),
                          sb,
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: DefaultField(
                                controller: controllerNome,
                                hint: u.nome,
                                context: context,
                                label: 'Nome',
                                icon: Icons.account_box,
                              ))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: DefaultField(
                                controller: controllerEmail,
                                hint: u.email,
                                context: context,
                                label: 'Email',
                                icon: Icons.email,
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
                              ))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: DefaultField(
                                      controller: controllerTelefone,
                                      hint: u.celular,
                                      context: context,
                                      label: 'Telefone',
                                      icon: Icons.add_call,
                                      keyboardType: TextInputType.phone))
                            ],
                          ),
                         Row(  mainAxisSize: MainAxisSize.max,
                             mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[hText('Dados da sua conta Bancaria',
                              context, size: 35)]),sb,

                               Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Expanded(
                                      child: DefaultField(
                                          controller: controllerConta_bancaria,
                                          hint: u.conta_bancaria,
                                          context: context,
                                          label: 'Conta Bancaria',
                                          icon: MdiIcons.bank,
                                          ))
                                ],
                              ),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                  child: DefaultField(
                                    controller: controllerAgencia,
                                    hint: u.agencia,
                                    context: context,
                                    label: 'Agência',
                                    icon: MdiIcons.creditCard,
                                  ))
                            ],
                          ),  Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                  child: DefaultField(
                                    controller: controllerNumero_conta,
                                    hint: u.numero_conta,
                                    context: context,
                                    label: 'Número da Conta',
                                    icon: MdiIcons.creditCard,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                  child: DefaultField(
                                    keyboardType:
                                    TextInputType
                                        .number,
                                    controller: controllerKmmin,
                                    hint: '${u.kmmin}',
                                    context: context,
                                    label: 'Quilometros percorridos no Mínimo',
                                    icon: MdiIcons.run,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                  child: DefaultField(
                                    keyboardType:
                                    TextInputType
                                        .number,
                                    controller: controllerKmmax,
                                    hint: '${u.kmmax}',
                                    context: context,
                                    label: 'Quilometros percorridos Máximo',
                                    icon: MdiIcons.run,
                                  ))
                            ],
                          ),
                           sb,
                          StreamBuilder(
                            stream: cc.outUser,
                            builder: (context, snapshot) {
                              return defaultCheckBox(
                                  Helper.localUser.atende_fds, 'Atende Final de Semana', context, () {
                                Helper.localUser.atende_fds = !Helper.localUser.atende_fds;
                                cc.user = Helper.localUser;
                                cc.inUser.add(cc.user);

                              });
                            }
                          ),
                          sb,
                          StreamBuilder(
                            stream: cc.outUser,
                            builder: (context, snapshot) {
                              return defaultCheckBox(
                                  Helper.localUser.atende_festa, 'Atende em Festas', context, () {
                                Helper.localUser.atende_festa = !Helper.localUser.atende_festa;
                                cc.user = Helper.localUser;
                                cc.inUser.add(cc.user);

                              } );
                            }
                          ),
                           Container(


                            child: defaultActionButton('Atualizar', context,
                                    () {
                                  u.nome = controllerNome.text;
                                  u.celular = controllerTelefone.text;
                                  u.email = controllerEmail.text;
                                  u.numero_conta = controllerNumero_conta.text
                                  ;
                                  u.agencia = controllerAgencia.text;
                                  u.conta_bancaria = controllerConta_bancaria.text;
                                  u.kmmin = int.parse(controllerKmmin.text);
                                  u.kmmax = int.parse(controllerKmmax.text);
                                  u.updated_at = DateTime.now();
                                  onLoad = true;
                                  perfilController.updateUser(u).then((v) {
                                    if (v == 'Atualizado com sucesso!') {
                                      dToast('Dados atualizados com sucesso!');
                                    } else {
                                      dToast('Dados atualizados com sucesso!');
                                    }
                                  });
                                }),
                          ),


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

    if (d.frente == null) {
      d.frente = await uploadPicture(
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
            d.tipo = 'RG';
            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
            perfilController.updateUser(u);

            break;
          case documentos.CPF:
            u.cpf = sequencial.getCPF;
            d.tipo = 'CPF';
            print("AQUI CPF${sequencial.getCPF}");

            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
            perfilController.updateUser(u);
            break;
          case documentos.CNH:
            d.tipo = 'CNH';
            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
            perfilController.updateUser(u);
            break;
          case documentos.PASSAPORTE:
            d.tipo = 'PASSAPORTE';
            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
            perfilController.updateUser(u);
            break;
        }

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

    if (d.frente == null) {
      d.frente = await uploadPicture(
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
            d.tipo = 'RG';
            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
              perfilController.updateUser(u);

            break;
          case documentos.CPF:
            u.cpf = sequencial.getCPF;
            d.tipo = 'CPF';
            print("AQUI CPF${sequencial.getCPF}");

            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
            perfilController.updateUser(u);
            break;
          case documentos.CNH:
            d.tipo = 'CNH';
            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
            perfilController.updateUser(u);
            break;
          case documentos.PASSAPORTE:
            d.tipo = 'PASSAPORTE';
            d.isValid = true;
            d.data = sequencial;
            u.documentos.add(d);
            perfilController.updateUser(u);
            break;
        }

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
