import 'dart:async';

import 'package:bocaboca/BlocCentral/Racing/NavigationBloc2.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Objetos/Corrida.dart';
import 'package:bocaboca/Objetos/Localizacao.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MapController.dart';

bool started = false;
class Racing extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Racing> {

  GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    if (mapController == null) {
      mapController = MapController();
    }
    return Scaffold(
        appBar:  AppBar(
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
                                      print('Aqui !');
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
                    'Distancia percorrida ${((corrida.data.dist == null? 0: corrida.data.dist)/1000).toStringAsFixed(2)} Km', context);
              }),
        ]),
        floatingActionButton: FloatingActionButton(
          child: started ? Text("Parar") : Text("Iniciar"),
          onPressed: () async {
            if (started) {
              await FlutterForegroundPlugin.stopForegroundService();
              nb.stopFGS();
            } else {
              startForegroundService().then((v) {
                if (v != null) {
                  mapController.updateCorridaId(v);
                }
              });
            }
            setState(() {
              started = !started;
            });
          },
        ),
      );
  }
}

MapController mapController;

//função que inicializa o serviço em primeiro plano
Future<String> startForegroundService() async {
  StreamSubscription subscription;

  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      //quando o serviço é inicializado, ele inicia o geolocator para para a posição atual do user

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
      print("Foreground on Started");
    },
    onStopped: () {
      // quando o serviço de primeiro plano termina, as atualizações de local são canceladas
      subscription.cancel();
      print("Foreground on Stopped");
    },
    // título, conteúdo e nome do ícone da notificação do serviço
    title: "Location Service",
    content: "Você está Ganhando Dinheiro",
    iconName: "",
  );
  return nb.start();
}

//função em primeiro plano chamada quando o serviço é inicializado
// ESSA FUNÇÃO DEVE ESTAR AQUI
void globalForegroundService() async {
  debugPrint("service");
}

/*

// adicionar as seguintes dependências ao pubspec
  geolocator: ^5.3.0
  dio: any
  flutter_foreground_plugin: any

*/
