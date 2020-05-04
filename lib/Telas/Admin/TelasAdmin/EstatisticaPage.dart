import 'dart:math';

import 'package:autooh/Helpers/ExpandableContainer.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Distancia.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Estatisticas/EstatisticasController.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

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

  @override
  void dispose() {
    super.dispose();
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

  bool isMapOpen = false;
  ExpandableController expController = ExpandableController();
  getEstatisticasWidget(List<Corrida> corridas) {
    if (corridas.length == 0) {
      return Center(child: Container(child: hText('Sem Corridas', context)));
    }
    double visualizacoes = 0;
    double dist = 0;
    List<Carro> carroIds = new List();

    String id_corrida = '';
    int countCorridas = 0;
    countCorridas = corridas.length;
    var tempoNaRua = 0.0;
    for (Corrida c in corridas) {
      visualizacoes += c.vizualizacoes == null ? 0 : c.vizualizacoes;
      dist += c.dist == null ? 0 : c.dist;
      tempoNaRua += c.duracao;
      bool containsCarro = false;
      for (Carro s in carroIds) {
        if (s.placa == c.carro.placa) {
          containsCarro = true;
        }
      }
      if (!containsCarro) {
        carroIds.add(c.carro);
      }
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
    return Container(
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
                      child: Container(
                        height: getAltura(context) * .5,
                        child: GoogleMap(
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
                        ),
                      ),
                    ))),
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
              Padding(
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
              ),
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
                            vizualizacoesCarro +=
                                c.vizualizacoes == null ? 0 : c.vizualizacoes;
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
    );
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

  List<ColumnSeries<Corrida, DateTime>> getLineSeries(List<Corrida> corrida) {}
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
  }

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
}
