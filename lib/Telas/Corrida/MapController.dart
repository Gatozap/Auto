import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapController extends BlocBase{
  DatabaseReference corridaRef;
  DatabaseReference pointsRef;
  BitmapDescriptor sourceIcon;
  BehaviorSubject<Localizacao> positionController = BehaviorSubject();

  Stream<Localizacao> get outPosition => positionController.stream;

  Sink<Localizacao> get inPosition => positionController.sink;
  Localizacao position;
  int corrida;
  Corrida c;
  BehaviorSubject<Corrida> corridaController = new BehaviorSubject<Corrida>();
  Stream<Corrida> get outCorrida => corridaController.stream;
  Sink<Corrida> get inCorrida => corridaController.sink;

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

  String lastV = '';
  List positions;

  MapController(){
  }


  double distanciaPercorridaEmMetros = 0;
  BehaviorSubject<
      double> controllerDistanciaPercorridaEmMetros = BehaviorSubject();
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

  void updateCorridaId(String v) {
    corridaRef =
        FirebaseDatabase.instance.reference()
            .child('Corridas')
            .reference()
            .child(v);
    pointsRef =
        corridaRef.child('points');
    corridaRef.onValue.listen((v) {
      c = Corrida.fromJson(v.snapshot.value);
      inCorrida.add(c);
      //distanciaPercorridaEmMetros = c.distancia;
    });

    pointsRef.onValue.listen((points) {
      positions = new List();
      if(points.snapshot.value.toString() != 'null') {
        var pts = points.snapshot.value;
        pts.forEach((k, v) {
          positions.add(v);
        });
        positions.sort((var a, var b) {
          return a['timestamp'].compareTo(b['timestamp']);
        });
        updatePolyline(positions);
      }
      //updatePolyline(positions);
    });
  }
  LocationOptions locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 20,
    );
}