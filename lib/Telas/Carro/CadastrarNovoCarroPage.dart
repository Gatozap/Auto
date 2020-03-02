import 'dart:convert';
import 'dart:io';

import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/PhotoScroller.dart';
import 'package:bocaboca/Helpers/References.dart';

import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/Documento.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Cadastro/CadastroController.dart';
import 'package:bocaboca/Telas/Carro/CarroController.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:image_picker/image_picker.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CadastrarNovoCarroPage extends StatefulWidget {
  User user;

  Carro carro;
  CadastrarNovoCarroPage({Key key, this.user, this.carro}) : super(key: key);

  @override
  _CadastrarNovoCarroPageState createState() => _CadastrarNovoCarroPageState();
}

class _CadastrarNovoCarroPageState extends State<CadastrarNovoCarroPage> {

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
      appBar: myAppBar('Cadastrar Carro', context),
      body: Stack(children: <Widget>[
        Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.4,
            child: Container(
              decoration: linearGradient,
              height: getAltura(context),
              padding: EdgeInsets.all(1),
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: carroController.outCarro,
                builder: (context, snapshot) {


                  return Container(
                    height: getAltura(context),
                    child: SingleChildScrollView(
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

                                                      getImage(snapshot.data);
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
                                                      getImageCamera(snapshot.data);
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
                                    child:
                                     snapshot.data != null?
                                     snapshot.data.foto != null
                                        ? Image(
                                      image:
                                      CachedNetworkImageProvider(snapshot.data.foto),
                                    )
                                        : Image(
                                      image: CachedNetworkImageProvider(
                                          'https://images.vexels.com/media/users/3/155395/isolated/preview/3ced49c3448bede9f79d9d57bff35586-silhueta-de-vista-frontal-de-carro-esporte-by-vexels.png'),
                                    )
                                         : Image(
                                       image: CachedNetworkImageProvider(
                                           'https://images.vexels.com/media/users/3/155395/isolated/preview/3ced49c3448bede9f79d9d57bff35586-silhueta-de-vista-frontal-de-carro-esporte-by-vexels.png'),


                                     ),

                              )),
                              sb,
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: DefaultField(
                                        controller: controllerModelo,
                                        hint: 'Prisma',
                                        context: context,
                                        label: 'Modelo',
                                        icon: Icons.directions_car,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: DefaultField(
                                        controller: controllerCor,
                                        hint: 'Preto',
                                        context: context,
                                        label: 'Cor',
                                        icon: Icons.color_lens,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: DefaultField(
                                          controller: controllerAno,
                                          hint: '2000',
                                          context: context,
                                          label: 'Ano',
                                          icon: Icons.assignment,
                                          keyboardType: TextInputType.number))
                                ],
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Expanded(
                                      child: DefaultField(
                                        controller: controllerPlaca,
                                        hint:'AAA-9999',
                                        context: context,
                                        label: 'Placa',
                                        icon: MdiIcons.carBack,
                                      ))
                                ],
                              ),

                              sb,

                              Container(


                                child: defaultActionButton('Cadastrar', context,
                                        () {

                                  List carros = new List();
                                  Carro c = new Carro(
                                    ano: int.parse(controllerAno.text),cor: controllerCor.text ,
                                    dono: Helper.localUser.id,
                                    modelo: controllerModelo.text,
                                    placa:controllerPlaca.text,
                                    created_at: DateTime.now(),
                                    updated_at: DateTime.now(),

                                  );
                                  carros.add(c);

                                      onLoad = true;
                                      cc.CriarCarros(carros: c).then((v){
                                        dToast('Carro cadastrado com Sucesso!');
                                      });
                                       Helper.localUser.carros = carros;
                                        userRef.document(Helper.localUser.id).updateData(Helper.localUser.toJson()).then((v){

                                        });
                                      Navigator.of(context).pop();
                                    }),
                              ),


                            ],
                          ),
                        ),

                  );
                }
              ),
            ))
      ]),
    );
  }
  Widget documentosWidget (List<Documento> documentos){
    List fotos = new List();
    for(Documento d in documentos){
      if(d.frente != null){
        fotos.add(d.frente);
      }
      if (d.verso != null) {
        fotos.add(d.verso);

      }

    }
    return Hero( tag: fotos[0],child: PhotoScroller(fotos, largura: getLargura(context), altura: 374.0, fractionsize: 1,));
  }


  ProgressDialog pr;


  Future getImageCamera(Carro c) async {
    if(c == null){
      c = new Carro();
    }


    
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
    c.foto = await uploadPicture(
      image.path,
    );
    carroController.inCarro.add(c);
    pr.dismiss();
    dToast('Salvando Foto!');
  }

  Future getImage(Carro c) async {

    if(c == null){
      c = new Carro();
    }


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
   c.foto = await uploadPicture(
      image.path,
    );
   carroController.inCarro.add(c);
    pr.dismiss();
    dToast('Salvando Foto!');
  }
}
