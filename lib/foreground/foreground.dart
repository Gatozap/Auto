import 'dart:async';

import 'package:bocaboca/BlocCentral/Racing/NavigationBloc2.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/Corrida.dart';
import 'package:bocaboca/Objetos/Localizacao.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'MapController.dart';

bool started = false;

class Racing extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Racing> {
  GoogleMapController _controller;
  Carro carroSelecionado;
  @override
  Widget build(BuildContext context) {
    if (mapController == null) {
      mapController = MapController();
    }
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Percurso",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
              ),
              Container(
                color: Colors.red[500],
                height: 4.0,
              ),
            ],
          ),
          preferredSize: Size.fromHeight(80.0),
        ),
      ),
      body: Stack(children: <Widget>[
        StreamBuilder<List<Marker>>(
            stream: mapController.outMarker,
            builder: (context, markers) {
              return StreamBuilder<List<Polyline>>(
                  stream: mapController.outPolyline,
                  builder: (context, polyline) {
                    return StreamBuilder<Localizacao>(
                        stream: mapController.outPosition,
                        builder: (context, position) {
                          if (position.data == null) {
                            return Container();
                          }
                          return StreamBuilder<double>(
                              stream: mapController.outZoom,
                              builder: (context, zoom) {
                                double z = zoom.data == null ? 16 : zoom.data;
                                if (_controller != null) {
                                  _controller.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                          position.data.latitude,
                                          position.data.longitude,
                                        ),
                                        zoom: z,
                                      ),
                                    ),
                                  );
                                }
                                return GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      position.data.latitude,
                                      position.data.longitude,
                                    ),
                                    zoom: z,
                                  ),
                                  onCameraMove: (cp) {
                                    mapController.zoom = cp.zoom;
                                    mapController.inZoom
                                        .add(mapController.zoom);
                                  },
                                  zoomGesturesEnabled: true,
                                  markers: markers.data == null
                                      ? Set<Marker>()
                                      : markers.data.toSet(),
                                  polylines: polyline.data == null
                                      ? Set<Polyline>()
                                      : polyline.data.toSet(),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller = controller;
                                  },
                                );
                              });
                        });
                  });
            }),
        StreamBuilder<Corrida>(
            stream: mapController.outCorrida,
            builder: (context, corrida) {
              if (corrida.data == null) {
                return Container();
              }
              return hText(
                  'Distancia percorrida ${((corrida.data.dist == null ? 0 : corrida.data.dist) / 1000).toStringAsFixed(2)} Km',
                  context);
            }),
      ]),
      floatingActionButton: FloatingActionButton(
        child: started ? Text("Parar") : Text("Iniciar"),
        onPressed: () async {
          if (started) {
            await FlutterForegroundPlugin.stopForegroundService();
            nb.stopFGS();
            setState(() {
              started = !started;
            });
            dToast('Corrida Finalizada');
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: CarSelectorWidget(),
                    actions: <Widget>[
                      defaultActionButton('Cancelar', context, () async {
                        Navigator.of(context).pop();
                      }, icon: null),
                      defaultActionButton('Iniciar', context, () async {
                        if(carroSelecionado != null) {
                          startForegroundService(carroSelecionado).then((v) {
                            if (v != null) {
                              mapController.updateCorridaId(v);
                              setState(() {
                                started = !started;
                              });
                              Navigator.of(context).pop();
                              dToast('Corrida iniciado com sucesso!');
                            }
                          });
                        }else{
                          dToast('Selecione um Carro');
                        }
                      }, icon: null)
                    ],
                  );
                });
          }
        },
      ),
    );
  }

  CarSelectorWidget() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder(
            future: getDropdownCarros(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              }

              return DropdownButton(
                hint: Row(
                  children: <Widget>[
                    Icon(MdiIcons.car, color: corPrimaria),
                    sb,
                    hText(
                      'Selecione o Carro que deseja',
                      context,
                      size: 40,
                      color: corPrimaria,
                    ),
                  ],
                ),
                style: TextStyle(
                    color: corPrimaria,
                    fontSize: ScreenUtil.getInstance().setSp(40),
                    fontWeight: FontWeight.bold),
                icon: Icon(Icons.arrow_drop_down, color: corPrimaria),
                items: snapshot.data,
                onChanged: (value) {
                  carroSelecionado = value;
                },
              );
            }),
      ),
    );
  }

  Future<List<DropdownMenuItem<Carro>>> getDropdownCarros() {
    List<DropdownMenuItem<Carro>> items = List();
    return carrosRef
        .where('dono', isEqualTo: Helper.localUser.id)
        .getDocuments()
        .then((v) {
      List carros = new List();
      for (var d in v.documents) {
        carros.add(Carro.fromJson(d.data));
      }
      for (Carro z in carros) {
        items.add(DropdownMenuItem(value: z, child: Text('${z.modelo} ${z.placa}')));
      }
      return items;
    }).catchError((err) {
      print('aqui erro 1 ${err}');
      return null;
    });
  }
}

MapController mapController;

//função que inicializa o serviço em primeiro plano
Future<String> startForegroundService(Carro carroSelecionado) async {
  StreamSubscription subscription;

  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      final geolocator = Geolocator();
      subscription = geolocator.getPositionStream().listen((v) {
        Localizacao l = Localizacao(
            latitude: v.latitude,
            longitude: v.longitude,
            timestamp: v.timestamp,
            altitude: v.altitude);
        mapController.position = l;
        mapController.inPosition.add(l);
        mapController.updateMarker();
        nb.startRacing(v);
      });
// serviço de primeiro plano iniciado
    },
    onStopped: () {
      // quando o serviço de primeiro plano termina, as atualizações de local são canceladas
      subscription.cancel();
    },
    // título, conteúdo e nome do ícone da notificação do serviço
    title: "Location Service",
    content: "Você está Ganhando Dinheiro",
    iconName: "",
  );
  return nb.start(carroSelecionado);
}

void globalForegroundService() async {
}
