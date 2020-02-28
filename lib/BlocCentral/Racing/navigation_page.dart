
import 'package:bocaboca/Objetos/Corrida.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';
import 'navigation_screen_controller.dart';
import 'NavigationBloc2.dart';
class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() {
    return _NavigationPageState();
  }
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  RacingScreenController rsc;
  GoogleMapController mapController;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(rsc == null){
      rsc = RacingScreenController();
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
        body: Stack(
          children: <Widget>[
            StreamBuilder<List<Marker>>(
                stream: rsc.outMarker,
                builder: (context, markers) {
                  return StreamBuilder<List<Polyline>>(
                      stream: rsc.outPolyline,
                      builder: (context, polyline) {
                        return StreamBuilder<Position>(
                            stream: rsc.outPosition,
                            builder: (context, position) {
                              if (position.data == null) {
                                return Container();
                              }
                              return StreamBuilder<double>(
                                  stream: rsc.outZoom,
                                  builder: (context, zoom) {
                                    double z =
                                        zoom.data == null ? 16 : zoom.data;
                                    if(mapController!= null){
                                        mapController.moveCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                              target: LatLng(
                                                position.data.latitude,
                                                position.data.longitude,
                                                ),
                                              zoom: zoom.data,
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
                                        rsc.zoom = cp.zoom;
                                        rsc.inZoom.add(rsc.zoom);
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
                                        mapController = controller;
                                        print('Aqui !');
                                      },
                                    );
                                  });
                            });
                      });
                }),
            /*StreamBuilder<Corrida>(
                stream: nb.outCorrida,
                builder: (context, corrida) {
                  return Container(
                      child: Text(corrida.data == null
                          ? ''
                          : corrida.data.distancia  == 0 ? '' : '${(corrida.data.distancia /1000).toStringAsFixed(2)}Km'));
                }), */
          ],
        ),
        floatingActionButton: StreamBuilder<Corrida>(
            stream: nb.outCorrida,
            builder: (context, isRacing) {
              print("ATUALIZOU ISRACING ${isRacing.data}");
              return FloatingActionButton.extended(
                onPressed: () {
                  print("AQ UI CLICK BOTÂO");
                  if (isRacing.data == null) {
                   // nb.startFGS();
                  } else {
                    if (isRacing.data.isRunning) {
                      nb.stopFGS();
                    } else {
                      //nb.startFGS();
                    }
                  }
                },
                label: Text(
                  isRacing.data == null
                      ? 'INICIAR'
                      : isRacing.data.isRunning ? "FINALIZAR PERCURSO" : "INICIAR",
                ),
              );
            }));
  }
}
