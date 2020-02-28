import 'dart:io';

import 'package:bocaboca/Helpers/Helper.dart';
import 'package:short_stream_builder/short_stream_builder.dart';
import 'package:bocaboca/Objetos/Campanha.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Telas/Admin/TelasAdmin/CampanhaController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class CriarCampanhaPage extends StatefulWidget {

  Campanha campanha;
  CriarCampanhaPage({this.campanha});

  @override
  _CriarCampanhaPageState createState() {
    return _CriarCampanhaPageState();
  }
}
CampanhaController campanhaController;
var controllerEmpresa = new TextEditingController(text: '');
Campanha campanha;
class _CriarCampanhaPageState extends State<CriarCampanhaPage> {

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print('aqui é campanha ${widget.campanha}');
    if (campanhaController == null) {
      campanhaController = CampanhaController(campanha: widget.campanha);
    }
    // TODO: implement build
    return Scaffold(appBar: myAppBar('Criar Campanha', context, showBack: true),

    body:

    Container(child: SingleChildScrollView(child: SSB(
        isList: false,
      stream: campanhaController.outCampanha,
        buildfunction: (context, AsyncSnapshot snap) {

               campanha = snap.data;

        return Form(
          key: _formKey,
          child: Container(child: Column(children: <Widget>[

            Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: <Widget>[
                  campanha.fotos != null
                      ? campanha.fotos.length != 1
                      ? Swiper(
                    itemBuilder: (BuildContext context,
                        int index) {
                      return Container(
                        child: campanha.fotos[index]
                            .contains('http')
                            ? Image(
                            image:
                            CachedNetworkImageProvider(
                                campanha.fotos[
                                index]),
                            height: 200,
                            fit: BoxFit.fitHeight,
                            width: 300)
                            : Image.file(
                            File(
                                campanha.fotos[index]),
                            height: 200,
                            fit: BoxFit.fitHeight,
                            width: 300),
                        height: 200,
                        width: 300,
                      );
                    },
                    itemHeight: 200,
                    itemWidth: 300,
                    containerWidth: 300,
                    itemCount: campanha.fotos.length,
                    scrollDirection: Axis.horizontal,
                    pagination: new SwiperPagination(),
                    control: new SwiperControl(),
                  )
                      : Container(
                      child: Center(
                          child:campanha.fotos[0]
                              .contains('http')
                              ? Image(
                            image:
                            CachedNetworkImageProvider(
                                campanha.fotos[0]),
                            height: 200,
                          )
                              : Image.file(
                              File(campanha.fotos[0]))))
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
                        getImage(campanha);
                      },
                      shape: CircleBorder(
                          side: BorderSide(
                              color: Colors.transparent)),
                    ),
                  )
                ])),
            DefaultField(
                controller: controllerEmpresa,
                hint: 'RBSoftware',
                context: context,
                label: 'Nome Empresa',
                icon: FontAwesomeIcons.adn,
                validator: (v) {},
                keyboardType: TextInputType.text,
                capitalization: TextCapitalization.words,
                onSubmited: (s) {}),
          ],),),
        );
      }
    ))));

  }

  Future getImage(Campanha e) async {
    if (e == null) {
      e = new Campanha.Empty();
    }
    if (e.fotos == null) {
      e.fotos = new List();
    }
    showDialog(context:context, builder: (context) {
      return AlertDialog( shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            defaultActionButton('Camera', context, () {
              ImagePicker.pickImage(
                source: ImageSource.camera,
              ).timeout(Duration(seconds: 30)).then((image) {
                print('AQUI FOTO ${image}');
                if (image != null) {
                  if (image.path != null) {
                    e.fotos.add(image.path);
                    campanhaController.inCampanha.add(e);
                    dToast('Salvando Foto!');
                  }
                }
              }).catchError((err) {
                print('ERRO NO IMAGE PICKER ${err.toString()}');
              });
            },icon:Icons.camera),
            defaultActionButton('Galeria', context, () {
              ImagePicker.pickImage(
                source: ImageSource.gallery,
              ).timeout(Duration(seconds: 30)).then((image) {
                print('AQUI FOTO ${image}');
                if (image != null) {
                  if (image.path != null) {
                    e.fotos.add(image.path);
                    campanhaController.inCampanha.add(e);
                    dToast('Salvando Foto!');
                  }
                }
              }).catchError((err) {
                print('ERRO NO IMAGE PICKER ${err.toString()}');
              });
            },icon:Icons.photo),
          ],
        ),
      );
    });
  }

}