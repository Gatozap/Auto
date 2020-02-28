import 'dart:convert';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Objetos/Corrida.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';


class RacingScreenController extends BlocBase {
 // final navigatorRepository = NavigatorRepository();
  DatabaseReference corridaRef;
  DatabaseReference pointsRef;
  BitmapDescriptor sourceIcon;
  BehaviorSubject<Position> positionController = BehaviorSubject();

  Stream<Position> get outPosition => positionController.stream;

  Sink<Position> get inPosition => positionController.sink;
  Position position;
  int corrida;
  Corrida c;

  double zoom = 16;
  BehaviorSubject<double> zoomController = BehaviorSubject();

  Stream<double> get outZoom => zoomController.stream;

  Sink<double> get inZoom => zoomController.sink;

  BehaviorSubject<List<Marker>> markerController =
  BehaviorSubject<List<Marker>>();

  Stream<List<Marker>> get outMarker => markerController.stream;

  Sink<List<Marker>> get inMarker => markerController.sink;
  List<Marker> markers;

  BehaviorSubject<List<Polyline>> polylineController =
  BehaviorSubject<List<Polyline>>();

  Stream<List<Polyline>> get outPolyline => polylineController.stream;

  Sink<List<Polyline>> get inPolyline => polylineController.sink;

  List<Polyline> polylines;

  GoogleMapController mapController;
  String lastV = '';

  Geolocator geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 20,
    );


  double distanciaPercorridaEmMetros = 0;
  BehaviorSubject<
      double> controllerDistanciaPercorridaEmMetros = BehaviorSubject();

  Stream<double> get outDistanciaPercorridaEmMetros =>
      controllerDistanciaPercorridaEmMetros.stream;

  Sink<double> get inDistanciaPercorridaEmMetros =>
      controllerDistanciaPercorridaEmMetros.sink;

  bool isRacing = false;
  BehaviorSubject<bool> controllerIsRacing = BehaviorSubject();

  Stream<bool> get outIsRacing => controllerIsRacing.stream;

  Sink<bool> get inIsRacing => controllerIsRacing.sink;
  bool hasStarted = false;
  List positions;


  RacingScreenController() {
    startListening();

    inZoom.add(zoom);
    getFirstPosition();
    geolocator.getPositionStream(locationOptions).listen((Position p) async {
      //TODO SUBSTITUIR O 1 pela linha ao lado > navigatorRepository.updateGeolocation(corrida, position.latitude, position.longitude);
      position = p;
      inPosition.add(position);
      updateMarker();
    });
  }

  Future<void> updateMarker() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 4.5),
      "assets/marker.png",
      );
    markers = new List();

    markers.add(Marker(
      markerId: MarkerId('sourcePin'),
      position: LatLng(
        position.latitude,
        position.longitude,
        ),
      icon: sourceIcon,
      ));
    inMarker.add(markers);
  }

  void updatePolyline(positions) {
    if(positions != null) {
      polylines = new List();
      List<LatLng> points = new List();
      for (var p in positions) {
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
        polylineId: PolylineId('0'),
        consumeTapEvents: true,
        color: Colors.orange,
        width: 5,
        points: points,
        ));
      inPolyline.add(polylines);
    }else{
      inPolyline.add(null);
    }
  }

  @override
  void dispose() {
    positionController.close();
    markerController.close();
    polylineController.close();
    zoomController.close();
  }

  Future<void> getFirstPosition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    inPosition.add(position);
    updateMarker();
  }

  Future<void> startListening() async {
   // sp.getBool('isRacing',defaultValue: false).listen((v){
      //if(v!= isRacing) {
      //  isRacing = v;
     //   inIsRacing.add(isRacing);
   //   }
  //  });
    if (!hasStarted) {/*
      sp.getInt('corrida', defaultValue: 789789789788789).listen((idCorrida) {
        if(idCorrida != corrida) {
          if (idCorrida != corrida) {
            int cor = idCorrida;

            corrida = cor != 789789789788789 ? cor : null;
            if (corrida != null) {
              corridaRef =
                  FirebaseDatabase.instance.reference()
                      .child('Corridas')
                      .reference()
                      .child(corrida.toString());
              pointsRef =
                  corridaRef.child('points');
              print("AQUI CORRIDA CAPETA ${corrida}");
              corridaRef.onValue.listen((v) {
                print("AQUI VALUE CORRIDAREF");
                c = Corrida.fromJson(v.snapshot.value);
                print('ENTROU AQUI CORRIDA VOLTANDO ${c.toString()}');
                //distanciaPercorridaEmMetros = c.distancia;
                inDistanciaPercorridaEmMetros.add(distanciaPercorridaEmMetros);
                isRacing = true;
                inIsRacing.add(true);
              });

              pointsRef.onValue.listen((points) {
                print(' ${points.snapshot.value.runtimeType}');
                positions = new List();
                Map<dynamic, dynamic> pts = points.snapshot.value;
                pts.forEach((k, v) {
                  positions.add(v);
                });
                positions.sort((var a, var b) {
                  return a['timestamp'].compareTo(b['timestamp']);
                });
                updatePolyline(positions);
                //updatePolyline(positions);
              });
              hasStarted = true;
            } else {
              isRacing = false;
              inIsRacing.add(false);
            }
          }
        }
      });
    */}
  }
}
