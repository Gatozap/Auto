import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:autooh/Objetos/Relatorio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';
import 'package:autooh/Helpers/GeradorPdf.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Distancia.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Estatisticas/EstatisticasController.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:random_color/random_color.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'dart:ui' as ui;
import 'package:autooh/Telas/Admin/TelasAdmin/VisualizarCarroPage.dart';
import 'package:permission/permission.dart';

class EstatisticaPage extends StatefulWidget {
  Carro carro;
  User user;
  Campanha campanha;
  Corrida corrida;

  EstatisticaPage({Key key, this.carro, this.campanha, this.user, this.corrida})
      : super(key: key);

  @override
  _EstatisticaPageState createState() {
    return _EstatisticaPageState();
  }
}

class _EstatisticaPageState extends State<EstatisticaPage> {
  EstatisticaController estController;
  DateTime dataini = DateTime.now().subtract(Duration(days: 365));
  DateTime datafim = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  GlobalKey _globalKey = new GlobalKey();
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    return pngBytes;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Set<Heatmap> _heatmaps;
  void _addHeatmap(List localizacoes) {
    print('INICIANDO HEATMAPS ${localizacoes.length} ');
    List<WeightedLatLng> points = List<WeightedLatLng>();
    _heatmaps = {};
    for (int i = 0; i < localizacoes.length; i++) {
      var l = localizacoes[i];
      points.add(
          WeightedLatLng(point: LatLng(l.latitude, l.longitude), intensity: 1));
    }
    _heatmaps.add(Heatmap(
        heatmapId: HeatmapId('heatmap'),
        points: points,
        radius: 20,
        visible: true,
        gradient: HeatmapGradient(
            colors: <Color>[Colors.green, Colors.red],
            startPoints: <double>[0.2, 0.8])));
  }

  List<WeightedLatLng> _createPoints(LatLng location) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    //Can create multiple points here
    points.add(_createWeightedLatLng(location.latitude, location.longitude, 1));
    points.add(
        _createWeightedLatLng(location.latitude - 1, location.longitude, 1));
    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  void gerarExtratoMensal(corridas) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: hText('Gerar relatorio', context),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                defaultActionButton('Cancelar', context, () {
                  Navigator.of(context).pop();
                }, icon: null),
                sb,
                sb,
                defaultActionButton('Gerar PDF', context, () async {
                  ProgressDialog pr = ProgressDialog(context);
                  pr.show();

                  //  pr.hide();
                  final Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  final String appDocPath = appDocDir.path;
                  final File file = File(appDocPath + '/' + 'relatorio.png');
                  print('Save as file ${file.path} ...');
                  await file.writeAsBytes((await _controller.takeSnapshot()));

                  GeradorPDF()
                      .GerarPDF(corridas, file, dataini.millisecondsSinceEpoch,
                          datafim.millisecondsSinceEpoch)
                      .then((v) async {
                    pr.hide();
                    print("AQUI VOLTOU ${v}");
                    final Directory appDocDir =
                        await getApplicationDocumentsDirectory();
                    final String appDocPath = appDocDir.path;
                    final File file = File(appDocPath + '/' + 'relatorio.pdf');
                    print('Save as file ${file.path} ...');
                    await file.writeAsBytes(v);
                    ShareExtend.share(file.path, "file");
                  });
                  /*.catchError((err) {
                    print('Erro ao gerar relatorio ${err}');
                    dToast('Erro ao gerar relatorio ${err}');
                    pr.hide();
                  });*/
                }, icon: null)
              ],
            ),
          );
        });
  }

  Future uploadRelatorio(File file, Campanha c) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'Relatorios/${c == null ? '' : c.id}.${file.path.split('.')[1]}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File Uploaded');
    return storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (estController == null) {
      estController = new EstatisticaController(
          widget.campanha, widget.carro, widget.user, dataini, datafim);
    }
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar(
          '${widget.campanha != null ? widget.campanha.nome : widget.carro != null ? widget.carro.placa : widget.user == null ? 'Estatisticas Gerais' : widget.user.nome}',
          context,
          actions: [
            IconButton(
              icon: Icon(Icons.send, color: Colors.yellowAccent),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            hText('Enviar Relatorio para Anunciantes', context),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultActionButton('Selecionar Arquivo', context,
                                () async {
                              File file = await FilePicker.getFile();
                              if (file != null) {
                                Relatorio r = Relatorio(
                                    nome: widget.campanha == null
                                        ? ''
                                        : widget.campanha.nome +
                                            ' ' +
                                            FormatarHora(DateTime.now()),
                                    url: await uploadRelatorio(
                                        file, widget.campanha),
                                    campanha: widget.campanha == null
                                        ? ''
                                        : widget.campanha.id,
                                    sender: Helper.localUser.id,
                                    updated_at: DateTime.now(),
                                    created_at: DateTime.now());
                                relatoriosRef.add(r.toJson()).then((value) {
                                  dToast('Relatorio enviado com sucesso!');
                                  sendNotificationUsuario(
                                      'Um novo Relatorio está disponivel!',
                                      '${widget.campanha == null ? '' : widget.campanha.nome}',
                                      null,
                                      'Anunciante${widget.campanha == null? '': widget.campanha.id}',
                                      widget.campanha.id,
                                      '');
                                  Navigator.of(context).pop();
                                });
                              }
                            }, icon: null, size: 35),
                          ],
                        ),
                      );
                    });
              },
              color: Colors.yellowAccent,
            ),
            IconButton(
                color: Colors.yellowAccent,
                onPressed: () {
                  gerarExtratoMensal(estController.corridas);
                },
                icon: Icon(FontAwesomeIcons.filePdf)),
            Theme(
                data: Theme.of(context).copyWith(
                    accentColor: Colors.yellowAccent,
                    primaryColor: corPrimaria,
                    buttonColor: Colors.yellowAccent,
                    buttonTheme: ButtonThemeData(
                        highlightColor: Colors.yellowAccent,
                        buttonColor: Colors.yellowAccent,
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                            secondary: Colors.yellowAccent,
                            background: Colors.white,
                            primary: corPrimaria,
                            primaryVariant: Colors.yellowAccent,
                            onBackground: corPrimaria),
                        textTheme: ButtonTextTheme.accent)),
                child: Builder(
                    builder: (context) => IconButton(
                        color: Colors.yellowAccent,
                        onPressed: () async {
                          final List<DateTime> picked =
                              await DateRagePicker.showDatePicker(
                                  context: context,
                                  initialFirstDate: new DateTime.now(),
                                  initialLastDate: new DateTime.now()
                                      .add(new Duration(days: 7)),
                                  firstDate: new DateTime(2018),
                                  lastDate: new DateTime(2030));
                          if (picked != null && picked.length == 2) {
                            estController.FilterCorridas(picked[0], picked[1]);
                          }
                        },
                        icon: Icon(FontAwesomeIcons.calendarDay))))
          ]),
      body: Container(
        child: StreamBuilder(
            stream: estController.outCorridas,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Container(
                    child: hText('', context),
                  ),
                );
              }
              return getEstatisticasWidget(snapshot.data);
            }),
      ),
    );
  }

  GoogleMapController _controller;

  List localizacoes;
  List<Campanha> campanhasList;
  Future<Widget> ganhosWidget(corridas) async {
    if (corridas.length == 0) {
      return Center(child: Container(child: hText('Sem Corridas', context)));
    }
    Map<String, List<Localizacao>> zonas = Map();
    double valor = 0;
    List<String> campanhas = new List();
    for (Corrida c in corridas) {
      bool contains = false;
      for (String s in campanhas) {
        if (s == c.campanha) {
          contains = true;
        }
      }
      if (!contains && c.campanha != null) {
        campanhas.add(c.campanha);
      }
    }

      if (campanhasList == null) {
        List<Campanha> campanhasList = new List();
        if (widget.campanha == null) {
          for (String s in campanhas) {
            print('BUSCANDO CAMPANHA LALAL');
            Campanha c =
            Campanha.fromJson((await campanhasRef.document(s).get()).data);
            campanhasList.add(c);
            print('AQUI CAMPANHAS ${campanhasList.length}');
          }
        }else{
          campanhasList = new List();
        }
        for (Campanha c in campanhasList) {
          double dist = 0;
          double valorTemp = 0;
          for (Corrida cor in corridas) {
            if (c.id == cor.campanha) {
              print("AQUI DISTANCIA CORRIDA ${cor.dist}");
              dist += cor.dist == null ? 0 : cor.dist;
            }
          }
          if (c.precomes != null && c.kmMinima != null) {
            if (c.kmMinima != 0) {
              valorTemp += ((dist / 1000) / c.kmMinima);
              print('AQUI LOL $valorTemp e ${dist / 1000} e ${c.kmMinima} ');
            }
          }
          print('Porcentagem ${valorTemp}');
          if (valorTemp > 100) {
            valorTemp = c.precomes;
          } else {
            valorTemp = c.precomes * valorTemp;
          }
          if (valorTemp > c.precomes) {
            valorTemp = c.precomes;
          }
          valor += valorTemp;
        }

        print('AQUI CAMPANHAS ${campanhasList} ${campanhasList.length}');
        print("AQUI LOLOLOLO ${valor}");

        return Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.moneyCheck,
                color: corPrimaria,
              ),
              sb,
              hText('Valor: R\$: ${valor.toStringAsFixed(2)}', context),
            ],
          ),
        );
      } else {
        return Container();
      }
    }

  bool isMapOpen = false;
  ExpandableController expController = ExpandableController();
  Widget map;
  getEstatisticasWidget(List<Corrida> corridas) {
    print('Montando estatisticas');
    if (corridas.length == 0) {
      return Center(child: Container(child: hText('Sem Corridas', context)));
    }
    double visualizacoes = 0;
    double visualizacoesTempo = 0;
    double visualizacoesKm = 0;
    double dist = 0;
    List<Carro> carroIds = new List();
    String id_corrida = '';
    int countCorridas = 0;
    Map<String, List<Localizacao>> zonas = Map();
    countCorridas = corridas.length;
    var tempoNaRua = 0.0;

    localizacoes = new List();
    for (Corrida c in corridas) {
      visualizacoes += c.vizualizacoes == null ? 0 : c.vizualizacoes;
      visualizacoesTempo +=
          c.vizualizacoes_por_tempo == null ? 0 : c.vizualizacoes_por_tempo;
      visualizacoesKm += c.vizualizacoes_por_distancia == null
          ? 0
          : c.vizualizacoes_por_distancia;
      dist += c.dist == null ? 0 : c.dist;
      tempoNaRua += c.duracao;
      bool containsCarro = false;
      for (Carro s in carroIds) {
        if (s.placa == c.carro.placa) {
          containsCarro = true;
        }
      }

      for (Localizacao p in c.points) {
        if (zonas[p.zona] == null) {
          zonas[p.zona] = new List();
        }
        zonas[p.zona].add(p);
      }
      if (!containsCarro) {
        carroIds.add(c.carro);
      }
      localizacoes.addAll(c.points);
    }
    int carros = carroIds.length;

    corridas.sort((Corrida a, Corrida b) {
      return a.hora_ini.compareTo(b.hora_ini);
    });

    expController.addListener(() {
      if (expController.value != isMapOpen) {
        setState(() {
          isMapOpen = !isMapOpen;
        });
      }
    });

    if (widget.user == null) {
      if (_heatmaps == null && localizacoes.length != 0) {
        _addHeatmap(localizacoes);
      }
    }
    if (map == null) {
      map = Container(
        height: getAltura(context) * .5,
        child: widget.user != null
            ? GoogleMap(
                buildingsEnabled: true,
                //heatmaps: _heatmaps,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(-16.68045, -49.2686895),
                  zoom: 11,
                ),
                zoomGesturesEnabled: true,
                polylines: getPolyLines(corridas).toSet(),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              )
            : GoogleMap(
                heatmaps: _heatmaps,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(-16.68045, -49.2686895),
                  zoom: 11,
                ),
                zoomGesturesEnabled: true,
                //polylines: getPolyLines(corridas).toSet(),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
      );
    }
    return RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: Colors.white,
          height: getAltura(context),
          child: SingleChildScrollView(
            physics: isMapOpen
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  sb,
                  GestureDetector(
                    onTap: () {},
                    child: ExpandablePanel(
                        controller: expController,
                        header: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.mapSigns,
                                color: corPrimaria,
                              ),
                              sb,
                              hText(
                                '  Mapa',
                                context,
                              ),
                            ],
                          ),
                        ),
                        expanded: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: map))),
                  ),
                  sb, sb,
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.user,
                          color: corPrimaria,
                        ),
                        sb,
                        hText(
                            'Visualizações Rodando: ${visualizacoesKm.toStringAsFixed(0)}',
                            context),
                      ],
                    ),
                  ),
                  sb, sb,
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.user,
                          color: corPrimaria,
                        ),
                        sb,
                        hText(
                            'Visualizações por tempo: ${visualizacoesTempo.toStringAsFixed(0)}',
                            context),
                      ],
                    ),
                  ),
                  sb, sb,

                  ExpandablePanel(
                    controller: ExpandableController(),
                    header: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.mapMarkedAlt,
                            color: corPrimaria,
                          ),
                          sb,
                          hText('Zonas:', context),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: ZonasWidget(zonas, context,(dist / 1000))
                  ),

                  sb, sb,
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.user,
                          color: corPrimaria,
                        ),
                        sb,
                        hText(
                            'Total de visualizações: ${visualizacoes.toStringAsFixed(0)}',
                            context),
                      ],
                    ),
                  ),
                  sb, sb,
                  FutureBuilder(
                    builder: (context, snap) {
                      if (snap.data == null) {
                        return Container();
                      }
                      return snap.data;
                    },
                    future: ganhosWidget(corridas),
                  ),
                  sb, sb,
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.route,
                          color: corPrimaria,
                        ),
                        sb,
                        hText(
                            'Distancia percorrida: Km ${(dist / 1000).toStringAsFixed(2)}',
                            context),
                      ],
                    ),
                  ),
                  sb, sb,
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.clock,
                          color: corPrimaria,
                        ),
                        sb,
                        hText(
                            'Tempo na Rua: ${(tempoNaRua / 60).toStringAsFixed(0)} min',
                            context),
                      ],
                    ),
                  ),
                  sb, sb,
                  /* Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.truck,
                      color: corPrimaria,
                    ),
                    sb,
                    hText('Corridas: ${countCorridas}', context),
                  ],
                ),
              ),*/
                  sb,
                  widget.carro == null
                      ? Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.car,
                                color: corPrimaria,
                              ),
                              sb,
                              hText('Carros:${carros}', context),
                            ],
                          ),
                        )
                      : Container(),
                  sb, sb,
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        hText(
                            'Ultima Corrida:${corridas.last.hora_ini.day.toString().length == 1 ? '0' + corridas.last.hora_ini.day.toString() : corridas.last.hora_ini.day}/${corridas.last.hora_ini.month.toString().length == 1 ? '0' + corridas.last.hora_ini.month.toString() : corridas.last.hora_ini.month}/${corridas.last.hora_ini.year} ${corridas.last.hora_ini.hour.toString().length == 1 ? '0' + corridas.last.hora_ini.hour.toString() : corridas.last.hora_ini.hour.toString()}:${corridas.last.hora_ini.minute.toString().length == 1 ? '0' + corridas.last.hora_ini.minute.toString() : corridas.last.hora_ini.minute.toString()}  \nFeita por ${corridas.last.carro.placa}',
                            context),
                      ],
                    ),
                  ),
                  sb,
                  Divider(color: corPrimaria),
                  sb,
                  widget.carro == null
                      ? Center(
                          child: hText('Carros', context,
                              size: 70, weight: FontWeight.bold))
                      : Container(),
                  sb,
                  Divider(
                    color: corPrimaria,
                  ),
                  sb,
                  widget.carro == null
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            List<Corrida> corridasPorCarro = new List();
                            var vizualizacoesCarro = 0.0;
                            var distCarro = 0.0;
                            int countCorridastemp = 0;
                            for (Corrida c in corridas) {
                              bool contains = false;
                              if (carroIds[i].placa != c.carro.placa) {
                                contains = true;
                              }
                              for (Corrida s in corridasPorCarro) {
                                if (s.id == c.id) {
                                  contains = true;
                                }
                              }
                              if (!contains) {
                                vizualizacoesCarro += c.vizualizacoes == null
                                    ? 0
                                    : c.vizualizacoes;
                                distCarro += c.dist == null ? 0 : c.dist;
                                corridasPorCarro.add(c);
                              }
                            }
                            countCorridastemp = corridasPorCarro.length;
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExpandablePanel(
                                  header: hText(
                                      '${carroIds[i].modelo} - ${carroIds[i].cor} - ${carroIds[i].placa}',
                                      context),
                                  expanded: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.eye,
                                            color: corPrimaria,
                                          ),
                                          sb,
                                          hText(
                                              'Total de visualizações: ${vizualizacoesCarro.toStringAsFixed(0)}',
                                              context),
                                        ],
                                      ),
                                      sb,
                                      //hText('Corridas: ${countCorridastemp}', context),
                                      sb,
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.route,
                                            color: corPrimaria,
                                          ),
                                          sb,
                                          hText(
                                              'Distancia percorrida: Km ${(distCarro / 1000).toStringAsFixed(2)}',
                                              context),
                                        ],
                                      ),
                                      sb,
                                      sb,

                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => VisualizarCarroPage(carro: carroIds[i],)));
                                        } ,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              FontAwesomeIcons.car,
                                              color: corPrimaria,
                                            ),
                                            sb,
                                            hText(
                                                'Visualizar carro',
                                                context),
                                          ],
                                        ),
                                      ),sb,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: carroIds.length,
                        )
                      : Container() //TODO LISTAR CAMPANHASS,
                ],
              ),
            ),
          ),
        ));
  }

  getMediaWidget(List<Campanha> campanhas) {
    double totaldeCampanhas = 0;
    List<Campanha> campanha = new List();
    for (Campanha cc in campanhas) {}
  }
  /*EstatisticasGeraisWidget(List<Corrida> corridas) {
    double totalcorrida = 0;
    List corridas = new List();
    double maiorcorrida = 0;
    DateTime maiorCorridaData = DateTime.now();

    for (Corrida p in corridas) {
      bool contains = false;
      for (String s in carros) {
        if (s == p.carros) {
          contains = true;
        }
      }
      if (!contains) {
        carros.add(p.carros);
      }

        maiscarros = p.carros;
        maiorVendaData = p.data_venda;
        mvComprador = p.comprador;

      total += p.total;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Pedidos: ${pagamentos.length}'),
            Text('Total em Vendas: R\$${total.toStringAsFixed(2)}'),
            Text('Clientes Atendidos: ${clientes.length}'),
            Divider(),
            Text(
                'Maior Venda: R\$${maiorVenda.toStringAsFixed(2)} no Dia: ${maiorVendaData.day}/${maiorVendaData.month}'),
            FutureBuilder(
                builder: (context, snap) {
                  if (snap.data == null) {
                    return Container();
                  }
                  print(snap.data.toString());
                  DocumentSnapshot d = snap.data;
                  print(d.data);
                  if (d.data == null) {
                    return Container();
                  }
                  User c = User.fromJson(d.data);
                  return Text(
                    'Comprador: ${c.nome}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                },
                future: userRef.document(mvComprador).get())
          ],
        ),
      ),
    );
  }  */

  /* List<ColumnSeries<Corrida, DateTime>> getLineSeries(List<Corrida> corrida) {}
  GraficosWidget(List<Corrida> corrida, List<Campanha> campanha,
      DateTime dataini, DateTime datafim) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Container(
            height: 300,
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container()),
          ),
        ),
      ],
    );
  }*/

  getPolyLines(List<Corrida> corridas) {
    List<Polyline> polylines = new List();

    for (Corrida c in corridas) {
      RandomColor _randomColor = RandomColor();

      Color _color = _randomColor.randomColor();
      List<LatLng> points = new List();
      for (var p in c.points) {
        try {
          points.add(LatLng(p.latitude, p.longitude));
        } catch (e) {
          try {
            points.add(LatLng(p['latitude'], p['longitude']));
          } catch (e) {}
        }
      }
      //points.add(LatLng(position.latitude, position.longitude));
      polylines.add(Polyline(
        polylineId: PolylineId(Random().nextInt(99999999).toString()),
        consumeTapEvents: true,
        color: _color,
        width: 5,
        points: points,
      ));
    }
    return polylines;
  }

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

 Widget ZonasWidget(
      Map<String, List<Localizacao>> zonas, BuildContext context, double d) {
    var textos = <Widget>[];

    List<List> txts = new List();
    double total = 0;
    zonas.forEach((k, v) {
      Localizacao lastPoint;
      double dist = 0;
      List<Localizacao> localizacoes = v;
      localizacoes.sort((a,b)=> a.timestamp.compareTo(b.timestamp));
      print("AQUI POINTS ${v.length}");
      for (Localizacao p in v) {
        if (lastPoint != null) {
          var distTemp = calculateDistance(
            p.latitude,
            p.longitude,
            lastPoint.latitude,
            lastPoint.longitude,
          );
            dist += distTemp;
        }
        lastPoint = p;
      }
      total+= (dist/10);
      txts.add(['Zona: ${k[0].toUpperCase()}${k.substring(1).toLowerCase()}', (dist / 10)]);
    });
    double sobra = 0;
    if(total<d){
      sobra = (d-total)/txts.length;
    }
    for(List l in txts){
      textos.add(
        hText(l[0],
        context),
      );
      textos.add(
        hText('Distancia Percorrida: ${(l[1]+sobra).toStringAsFixed(2)}Km',
            context),
      );
      textos.add(
        Divider(),
      );
    }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: textos,
        ),
      );
  }
}
