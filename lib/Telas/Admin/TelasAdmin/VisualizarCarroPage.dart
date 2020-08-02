import 'dart:io';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Carro/CarroController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VisualizarCarroPage extends StatefulWidget {
  Carro carro;
  User user;
  VisualizarCarroPage({Key key, this.carro, this.user}) : super(key: key);

  @override
  _VisualizarCarroPageState createState() {
    return _VisualizarCarroPageState();
  }
}

class _VisualizarCarroPageState extends State<VisualizarCarroPage> {
  @override
  void initState() {
    if (carroController == null) {
      carroController = new CarroController(carro: widget.carro);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  CarroController carroController;
  Carro carro;


  Future<String> _findLocalPath() async {
    final directory = !isIOS
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('${widget.carro.dono_nome}', context,),
      body: StreamBuilder<Carro>(
          stream: carroController.outCarroSelecionado,
          builder: (context, snapshot) {
            carro = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.carro.foto != null
                            ? CircleAvatar(
                                radius: ScreenUtil.getInstance().setSp(200),
                                backgroundColor: Colors.transparent,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.carro.foto))
                            : CircleAvatar(
                                radius: ScreenUtil.getInstance().setSp(200),
                                backgroundColor: Colors.transparent,
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                      'https://images.vexels.com/media/users/3/155395/isolated/preview/3ced49c3448bede9f79d9d57bff35586-silhueta-de-vista-frontal-de-carro-esporte-by-vexels.png'),
                                )),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.user, color: corPrimaria,),sb,
                          hText('Dono: ${widget.carro.dono_nome}', context),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.carSide, color: corPrimaria,),sb,
                          hText('Modelo: ${widget.carro.modelo}', context),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.palette, color: corPrimaria,),sb,
                          hText('Cor: ${widget.carro.cor}', context),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.calendar, color: corPrimaria,),sb,
                          hText('Ano: ${widget.carro.ano}', context),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          Container(width: 25, height: 30,child: Image.asset('assets/placa_veiculo.png')),sb,
                          hText('Placa: ${widget.carro.placa}', context),
                        ],
                      )),
                  sb,sb,sb,
                  sb,Divider(color: corPrimaria,),sb,
                  Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      hText('Foto de confirmação', context, size: 70),

                    ],
                  )),

                  sb,Divider(color: corPrimaria,),sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.carro.confirmacao != null
                          ? GestureDetector(onTap: () async {
                        Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                        ].request();
                        if (statuses[Permission.storage] == PermissionStatus.granted) {
                        // code of read or write file in external storage (SD card)

                        dToast('Baixando Foto');
                        String _localPath = (await _findLocalPath()) + Platform.pathSeparator;

                        await FlutterDownloader.enqueue(
                        url:  widget.carro.confirmacao,
                        savedDir: _localPath,
                        showNotification: true,
                        openFileFromNotification: true,
                        );

                        dToast('Foto Salva em ${_localPath}');
                        } else {
                        dToast('o App não tem permissão para gravar arquivos =/');
                        }
                      },
                            child: CircleAvatar(
                                radius: ScreenUtil.getInstance().setSp(200),
                                backgroundColor: Colors.transparent,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.carro.confirmacao)),
                          )
                          : Column(
                            children: <Widget>[
                              Container(width: 200,height: 200,child: Image.asset('assets/carro_foto.png')),sb,
                              hText('Sem foto de confirmação.', context),
                            ],
                          ),
                    ],
                  ),
                  sb,sb,sb,
                  sb,Divider(color: corPrimaria,),sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.carro.ultima_confirmacao != null
                          ? hText(
                              'Foto enviada em: ${widget.carro.ultima_confirmacao.day.toString().length == 1 ? '0' + widget.carro.ultima_confirmacao.day.toString() : widget.carro.ultima_confirmacao.day}/${widget.carro.ultima_confirmacao.month.toString().length == 1 ? '0' + widget.carro.ultima_confirmacao.month.toString() : widget.carro.ultima_confirmacao.month}/${widget.carro.ultima_confirmacao.year} ${widget.carro.ultima_confirmacao.hour.toString().length == 1 ? '0' + widget.carro.ultima_confirmacao.hour.toString() : widget.carro.ultima_confirmacao.hour.toString()}:${widget.carro.ultima_confirmacao.minute.toString().length == 1 ? '0' + widget.carro.ultima_confirmacao.minute.toString() : widget.carro.ultima_confirmacao.minute.toString()}',
                              context)
                          : Column(
                            children: <Widget>[
                              Icon(Icons.close, size: 60, color: Colors.red), sb,
                              hText('Sem data de confirmacao', context),
                            ],
                          ),
                    ],
                  ),
                  sb,Divider(color: corPrimaria,),sb,
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: seletorAnunciosCarro()),
                  sb,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: defaultCheckBox(
                            carro.isAprovado, 'Carro Liberado?', context, () {
                          carro.isAprovado = !carro.isAprovado;
                          carroController.inCarroSelecionado.add(carro);
                        }),
                      ),
                    ],
                  ),
                  sb,
                  Center(
                    child: Container(
                      child: defaultActionButton('Cadastrar Anúncios', context,
                          () {
                        carro.anuncio_laterais =
                            carro == null ? null : carro.anuncio_laterais;
                        carro.anuncio_bancos =
                            carro == null ? null : carro.anuncio_bancos;
                        carro.anuncio_traseira_completa = carro == null
                            ? null
                            : carro.anuncio_traseira_completa;
                        carro.anuncio_vidro_traseiro =
                            carro == null ? null : carro.anuncio_vidro_traseiro;

                        carroController.updateCarro(carro).then((v) {
                          dToast('Dados atualizados com sucesso!');
                          Navigator.of(context).pop();
                        });
                      }, icon: null),
                    ),
                  ),
                ],
              ),
            );
          }),
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

  Widget seletorAnunciosCarro() {
    return StreamBuilder(
      stream: carroController.outCarroSelecionado,
      builder: (context, car) {
        Carro carro = car.data;
        if (car.data == null) {
          carro = new Carro();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                child: hText(
                    'Escolha as campanhas e suas respectivas posições', context,
                    textaling: TextAlign.center),
              ),
              sb,
              sb,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  carro.is_anuncio_bancos == false
                      ? Container()
                      : Container(
                          height: getAltura(context) * .15,
                          width: getLargura(context) * .30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/bancos.png'),
                                fit: BoxFit.cover),
                            border: carro.is_anuncio_bancos == false
                                ? Border.all(color: Colors.black, width: 3)
                                : Border.all(color: Colors.green, width: 3),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                  carro.is_anuncio_bancos == false
                      ? Container()
                      : Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, top: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: FutureBuilder(
                                      future: getDropDownMenuItemsCampanha(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null) {
                                          return Container();
                                        }
                                        if (carro == null) {
                                          carro = new Carro();
                                        }

                                        return DropdownButton(
                                          hint: Row(
                                            children: <Widget>[
                                              sb,
                                              hText(
                                                carro.anuncio_bancos == null
                                                    ? 'Anuncios nos bancos'
                                                    : carro.anuncio_bancos.nome,
                                                context,
                                                size: 40,
                                                color: corPrimaria,
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(
                                              color: corPrimaria,
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(40),
                                              fontWeight: FontWeight.bold),
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: corPrimaria),
                                          items: snapshot.data,
                                          onChanged: (value) {
                                            Campanha c = value;
                                            if (c == null) {
                                              c = Campanha();
                                            }

                                            if (carro == null) {
                                              carro = new Carro();
                                            }

                                            carro.anuncio_bancos = value;

                                            carroController.inCarroSelecionado
                                                .add(carro);
                                          },
                                        );
                                      }),
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
                  carro.is_anuncio_laterais == false
                      ? Container()
                      : Container(
                          height: getAltura(context) * .15,
                          width: getLargura(context) * .30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/lateral.png'),
                                fit: BoxFit.cover),
                            border: carro.is_anuncio_laterais == false
                                ? Border.all(color: Colors.black, width: 3)
                                : Border.all(color: Colors.green, width: 3),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                  carro.is_anuncio_laterais == false
                      ? Container()
                      : Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, top: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: FutureBuilder(
                                      future: getDropDownMenuItemsCampanha(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null) {
                                          return Container();
                                        }
                                        if (carro == null) {
                                          carro = new Carro();
                                        }

                                        return DropdownButton(
                                          hint: Row(
                                            children: <Widget>[
                                              sb,
                                              hText(
                                                carro.anuncio_laterais == null
                                                    ? 'Anuncios nas laterais'
                                                    : carro
                                                        .anuncio_laterais.nome,
                                                context,
                                                size: 40,
                                                color: corPrimaria,
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(
                                              color: corPrimaria,
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(40),
                                              fontWeight: FontWeight.bold),
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: corPrimaria),
                                          items: snapshot.data,
                                          onChanged: (value) {
                                            Campanha c = value;
                                            if (c == null) {
                                              c = Campanha();
                                            }

                                            if (carro == null) {
                                              carro = new Carro();
                                            }

                                            carro.anuncio_laterais = value;

                                            carroController.inCarroSelecionado
                                                .add(carro);
                                          },
                                        );
                                      }),
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
                  carro.is_anuncio_traseira_completa == false
                      ? Container()
                      : Container(
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
                  carro.is_anuncio_traseira_completa == false
                      ? Container()
                      : Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, top: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: FutureBuilder(
                                      future: getDropDownMenuItemsCampanha(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null) {
                                          return Container();
                                        }
                                        if (carro == null) {
                                          carro = new Carro();
                                        }

                                        return DropdownButton(
                                          hint: Row(
                                            children: <Widget>[
                                              sb,
                                              hText(
                                                carro.anuncio_traseira_completa ==
                                                        null
                                                    ? 'Anuncios na Traseira'
                                                    : carro
                                                        .anuncio_traseira_completa
                                                        .nome,
                                                context,
                                                size: 40,
                                                color: corPrimaria,
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(
                                              color: corPrimaria,
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(40),
                                              fontWeight: FontWeight.bold),
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: corPrimaria),
                                          items: snapshot.data,
                                          onChanged: (value) {
                                            Campanha c = value;
                                            if (c == null) {
                                              c = Campanha();
                                            }

                                            if (carro == null) {
                                              carro = new Carro();
                                            }

                                            carro.anuncio_traseira_completa =
                                                value;

                                            carroController.inCarroSelecionado
                                                .add(carro);
                                          },
                                        );
                                      }),
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
                  carro.is_anuncio_vidro_traseiro == false
                      ? Container()
                      : Container(
                          height: getAltura(context) * .15,
                          width: getLargura(context) * .30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/vidro_traseiro.png'),
                                fit: BoxFit.cover),
                            border: carro.is_anuncio_vidro_traseiro == false
                                ? Border.all(color: Colors.black, width: 3)
                                : Border.all(color: Colors.green, width: 3),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                  carro.is_anuncio_vidro_traseiro == false
                      ? Container()
                      : Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, top: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: FutureBuilder(
                                      future: getDropDownMenuItemsCampanha(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null) {
                                          return Container();
                                        }
                                        if (carro == null) {
                                          carro = new Carro();
                                        }

                                        return DropdownButton(
                                          hint: Row(
                                            children: <Widget>[
                                              sb,
                                              hText(
                                                carro.anuncio_vidro_traseiro ==
                                                        null
                                                    ? 'Vidro Traseiro'
                                                    : carro
                                                        .anuncio_vidro_traseiro
                                                        .nome,
                                                context,
                                                size: 40,
                                                color: corPrimaria,
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(
                                              color: corPrimaria,
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(40),
                                              fontWeight: FontWeight.bold),
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: corPrimaria),
                                          items: snapshot.data,
                                          onChanged: (value) {
                                            Campanha c = value;
                                            if (c == null) {
                                              c = Campanha();
                                            }

                                            if (carro == null) {
                                              carro = new Carro();
                                            }

                                            carro.anuncio_vidro_traseiro =
                                                value;

                                            carroController.inCarroSelecionado
                                                .add(carro);
                                          },
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


}
