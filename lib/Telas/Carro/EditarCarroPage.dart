import 'dart:convert';
import 'dart:io';

import 'package:autooh/Helpers/Bairros.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/PhotoScroller.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Documento.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/CampanhaController.dart';
import 'package:autooh/Telas/Cadastro/CadastroController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'CarroController.dart';

class EditarCarroPage extends StatefulWidget {
  User user;

  Carro carro;
  EditarCarroPage({Key key, this.user, this.carro}) : super(key: key);

  @override
  _EditarCarroPageState createState() => _EditarCarroPageState();
}

class _EditarCarroPageState extends State<EditarCarroPage> {
  @override
  void initState() {
    super.initState();
    if (carroController == null) {
      carroController = CarroController(carro: widget.carro);
    }

    if (userController == null) {
      userController = CadastroController();
    }
  }

  CadastroController cc = new CadastroController();
  Carro carro;
  var controllerConta_bancaria = new TextEditingController(text: '');
  var controllerDataNascimento =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerDataExpedicao =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerSenha = new TextEditingController(text: '');
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerCor = new TextEditingController(text: '');
  var controllerAno = new TextEditingController(text: '');
  var controllerModelo = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  var controllerPlaca = new TextEditingController(text: '');
  var controllerComplemento = new TextEditingController(text: '');
  var controllerAgencia = new TextEditingController(text: '');
  var controllerKmmin = new TextEditingController(text: '');
  var controllerKmmax = new TextEditingController(text: '');

  var controllerNumero_conta = new TextEditingController(text: '');
  CarroController carroController;
  CampanhaController campanhaController;
  CadastroController userController;
  bool isPressed = false;
  bool onLoad = true;

  @override
  Widget build(BuildContext context) {
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
      appBar: myAppBar(
          widget.carro == null ? 'Cadastrar Carro' : 'Editar Carro', context),
      body: Stack(children: <Widget>[
        Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.4,
            child: Container(
              height: getAltura(context),
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              child: Container(
                decoration: linearGradient,
                height: getAltura(context),
                child: StreamBuilder<Carro>(
                  stream: carroController.outCarroSelecionado,
                  builder: (context, AsyncSnapshot<Carro> snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: hText('vazio', context),
                      );
                    }
                    carro = snapshot.data;

                    if (onLoad) {
                      controllerAno.text = carro.ano.toString();
                      controllerCor.text = carro.cor;
                      controllerModelo.text = carro.modelo;
                      controllerPlaca.text = carro.placa;

                      onLoad = false;
                    }
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                              getImage(carro);
                                              Navigator.of(context).pop();
                                            }, icon: MdiIcons.face),
                                            sb,
                                            defaultActionButton(
                                                'Camera', context, () {
                                              getImageCamera(carro);
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
                                child: carro.foto != null
                                    ? Image(
                                        image: CachedNetworkImageProvider(
                                            carro.foto),
                                      )
                                    : Stack(children: <Widget>[
                                        Positioned(
                                          child: Image(
                                              image: AssetImage(
                                                  'assets/carro_foto.png')),
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
                              controller: controllerModelo,
                              hint: 'Prisma',
                              context: context,
                              label: 'Modelo',
                              icon: FontAwesomeIcons.carSide,
                            ),
                          ),sb,
                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 30),
                            child: DefaultField(
                              controller: controllerCor,
                              hint: 'Preto',
                              context: context,
                              label: 'Cor',
                              icon: FontAwesomeIcons.palette,
                            ),
                          ),
                             sb,
                           DefaultField(
                                padding: EdgeInsets.only(left: 60, right: 35),
                                controller: controllerAno,
                                hint: '1990',
                                context: context,
                                label: 'Ano',
                                expands: false,
                                icon: FontAwesomeIcons.calendar,
                                keyboardType: TextInputType.number),

                             sb,
                           Row(

                             children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 60, right: 15),
                                    child: Container(height: 25, width: 25, child: Image(image: AssetImage('assets/placa_veiculo.png'),),),
                                  ),
                               Expanded(
                                 child: DefaultField(
                                   padding: EdgeInsets.only(right: 35),
                                    controller: controllerPlaca,
                                    hint: 'AAA-9999',
                                    context: context,
                                    label: 'Placa',

                                    icon: null,
                                  ),
                               ),
                             ],
                           ),
                          sb,
                          Divider(color: corPrimaria),
                          sb,
                          hText('Foto da Semana', context),
                          sb,
                          Divider(color: corPrimaria),
                          sb,
                          GestureDetector(
                            onTap: () {
                              getImageCamera(carro, isConfirmacao: true);
                            },
                            child: CircleAvatar(
                                radius: (((getAltura(context) +
                                            getLargura(context)) /
                                        2) *
                                    .2),
                                backgroundColor: Colors.transparent,
                                child: carro.confirmacao != null
                                    ? Image(
                                        image: CachedNetworkImageProvider(
                                            carro.confirmacao),
                                      )
                                    : Stack(children: <Widget>[
                                  Positioned(
                                    child: Image(
                                        image: AssetImage(
                                            'assets/carro_foto.png')),
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

                          hText(
                              'Tire uma foto do seu carro para que possamos contabilizar suas corridas',
                              context,
                              size: 30),
                            sb,Divider(color: corPrimaria),sb,
                          Container(
                            child: hText(
                                'Áreas que você quer disponibilizar para os anúncios',
                                context,
                                textaling: TextAlign.start),
                          ),
                          sb,Divider(color: corPrimaria),sb,
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(left: 50, right: 8),
                              child: Container(
                                child:
                                seletorAnunciosCarro(),
                              ),
                            ),
                          ),sb,sb,
                          Container(
                            child:
                                defaultActionButton('Atualizar', context, () {
                              carro.placa = controllerPlaca.text.toUpperCase();
                              carro.ano = int.parse(controllerAno.text);
                              carro.modelo = controllerModelo.text;
                              carro.cor = controllerCor.text;
                              carro.dono_nome = Helper.localUser.nome;
                              carro.anuncio_laterais =
                                  carro == null ? null : carro.anuncio_laterais;
                              carro.anuncio_bancos =
                                  carro == null ? null : carro.anuncio_bancos;
                              carro.anuncio_traseira_completa = carro == null
                                  ? null
                                  : carro.anuncio_traseira_completa;
                              carro.anuncio_vidro_traseiro = carro == null
                                  ? null
                                  : carro.anuncio_vidro_traseiro;
                              carro.is_anuncio_laterais = carro == null
                                  ? false
                                  : carro.is_anuncio_laterais;
                              carro.is_anuncio_traseira_completa = carro == null
                                  ? false
                                  : carro.is_anuncio_traseira_completa;
                              carro.is_anuncio_vidro_traseiro = carro == null
                                  ? false
                                  : carro.is_anuncio_vidro_traseiro;
                              carro.is_anuncio_bancos = carro == null
                                  ? false
                                  : carro.is_anuncio_bancos;
                              if (widget.carro == null) {
                                carro.updated_at = DateTime.now();
                              } else {
                                carro = widget.carro;
                              }
                              onLoad = true;

                              carroController.updateCarro(carro).then((v) {
                                dToast('Dados atualizados com sucesso!');
                                Navigator.of(context).pop();
                              } );
                            }, icon: null, size: 90),
                          ),sb,sb,
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

  Widget seletorAnunciosCarro() {
    return StreamBuilder<Carro>(
      stream: carroController.outCarroSelecionado,
      builder: (context, car) {
        Carro carro = car.data;
        if (car.data == null) {
          carro = new Carro();
        }
        if (carro.is_anuncio_bancos == null) {
          carro.is_anuncio_bancos = false;
        }

        if (carro.is_anuncio_laterais == null) {
          carro.is_anuncio_laterais = false;
        }
        if (carro.is_anuncio_traseira_completa == null) {
          carro.is_anuncio_traseira_completa = false;
        }
        if (carro.is_anuncio_vidro_traseiro == null) {
          carro.is_anuncio_vidro_traseiro = false;
        }

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[


              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/bancos.jpeg'),
                          fit: BoxFit.cover),
                      border: carro.is_anuncio_bancos == false
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0),
                            child: defaultCheckBox(carro.is_anuncio_bancos,
                                'Bancos Traseiros', context, () {
                              carro.is_anuncio_bancos =
                                  !carro.is_anuncio_bancos;
                              carroController.carroSelecionado = carro;
                              carroController.inCarroSelecionado
                                  .add(carroController.carroSelecionado);
                            }, size: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/lateral.jpg'),
                          fit: BoxFit.cover),
                      border: carro.is_anuncio_laterais == false
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: defaultCheckBox(
                          carro.is_anuncio_laterais, 'Laterais', context, () {
                        carro.is_anuncio_laterais = !carro.is_anuncio_laterais;
                        carroController.carroSelecionado = carro;
                        carroController.inCarroSelecionado
                            .add(carroController.carroSelecionado);
                      }, size: 10),
                    ),
                  ),
                ],
              ),
              sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/traseira_completa.png'),
                          fit: BoxFit.cover),
                      border: carro.is_anuncio_traseira_completa == false
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: defaultCheckBox(carro.is_anuncio_traseira_completa,
                          'Traseira Completa', context, () {
                        carro.is_anuncio_traseira_completa =
                            !carro.is_anuncio_traseira_completa;
                        carroController.carroSelecionado = carro;
                        carroController.inCarroSelecionado
                            .add(carroController.carroSelecionado);
                      }, size: 10),
                    ),
                  ),
                ],
              ),
              sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: getAltura(context) * .15,
                    width: getLargura(context) * .30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/vidro_traseiro.jpg',),
                          fit: BoxFit.fill),
                      border: carro.is_anuncio_vidro_traseiro == false
                          ? Border.all(color: Colors.black, width: 3)
                          : Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                      child: defaultCheckBox(carro.is_anuncio_vidro_traseiro,
                          'Vidro traseira', context, () {
                        carro.is_anuncio_vidro_traseiro =
                            !carro.is_anuncio_vidro_traseiro;
                        carroController.carroSelecionado = carro;
                        carroController.inCarroSelecionado
                            .add(carroController.carroSelecionado);
                      }, size: 10),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<List<DropdownMenuItem<Campanha>>> getDropDownMenuItemsCampanha() {
    List<DropdownMenuItem<Campanha>> items = List();
    return campanhasRef
        .where('datafim', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .getDocuments()
        .then((v) {
      List campanhas = new List();
      for (var d in v.documents) {
        campanhas.add(Campanha.fromJson(d.data));
      }
      for (Campanha z in campanhas) {
        items.add(DropdownMenuItem(value: z, child: Text('${z.nome}')));
      }
      return items;
    }).catchError((err) {
      print('aqui erro 1 ${err}');
      return null;
    });
  }

  Future getImageCamera(Carro carro, {bool isConfirmacao = false}) async {
    if (!isConfirmacao) {
      File image = await ImagePicker.pickImage(source: ImageSource.camera);

      carro.foto = await uploadPicture(
        image.path,
      );
      carroController.updateCarro(carro);
      dToast('Salvando Foto!');
    } else {
      File image = await ImagePicker.pickImage(source: ImageSource.camera);
      carro.confirmacao = await uploadPicture(
        image.path,
      );
      carro.ultima_confirmacao = DateTime.now();
      carroController.updateCarro(carro);
      dToast('Salvando Foto!');
    }
  }

  Future getImage(Carro carro) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(carro == null){
      carro = Carro();
    }
    carro.foto = await uploadPicture(
      image.path,
    );

    carroController.updateCarro(carro);
    dToast('Salvando Foto!');
  }
}
