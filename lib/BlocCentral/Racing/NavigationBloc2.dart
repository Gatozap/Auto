import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Objetos/Corrida.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class NavigationBloc extends BlocBase   {
  //final navigatorRepository = NavigatorRepository();
  String idcorrida;
  BehaviorSubject<Corrida> corridaController = BehaviorSubject<Corrida>();
  Stream<Corrida> get outCorrida => corridaController.stream;
  Sink<Corrida> get inCorrida => corridaController.sink;
  Corrida corrida;


  DatabaseReference corridaRef;
  DatabaseReference pointsRef;
  BehaviorSubject<List> pointsController = BehaviorSubject<List>();
  Stream<List> get outPoints => pointsController.stream;
  Sink<List> get inPoints => pointsController.sink;
  List points;/*
  void startFGS() async {
    start();
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
    await FlutterForegroundPlugin.setServiceMethod(startRacing);
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: () {
        print("Foreground on Started");
      },
      onStopped: () {
        print("Foreground on Stopped");
      },
      title: "DivulgaCars",
      content: "Você está ganhando dinheiro!",
      iconName: "ic_launcher",
      );
  }

  void foregroundServiceFunction() {
    print("The current time is: ${DateTime.now()}");
  }*/

  void foregroundServiceFunction() {
    print("The current time is: ${DateTime.now()}");
  }

  Function globalForegroundService() {
    print("current datetime is ${DateTime.now()}");
  }

  @override
  void dispose() {}



  Future<void> start({String id}) async {

    var location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    idcorrida = id==null?
   id: id;
    if(id == null){
      corrida = Corrida(
          id: idcorrida,
         // distancia: 0,
          hora_ini: DateTime.now(),
          //user: user,
          hora_fim: null,
          isRunning: true,
          last_seen: DateTime.now());
      corridaRef = FirebaseDatabase.instance
          .reference()
          .child('Corridas')
          .reference()
          .child(idcorrida);
      pointsRef = corridaRef.child('points');

    }else {
      corridaRef = FirebaseDatabase.instance
          .reference()
          .child('Corridas')
          .reference()
          .child(idcorrida);
      pointsRef = corridaRef.child('points');
      corrida = Corrida.fromJson((await corridaRef.once()).value);

    }

    startRacing();

    corridaRef.onValue.listen((v) async {
      if (v.snapshot.value != null) {
        corrida = Corrida.fromJson(v.snapshot.value);
        inCorrida.add(corrida);
      }
    });
    pointsRef.onValue.listen((v) {
      points = new List();
      Map<dynamic, dynamic> pts = v.snapshot.value;
      pts.forEach((k, v) {
        points.add(v);
      });
      points.sort((var a, var b) {

        return a['timestamp'].compareTo(b['timestamp']);


      });


    });

    corridaRef.update(corrida.toJson());
   // pointsRef.push().set(location.toJson());
    inCorrida.add(corrida);
  }
  void check() {
    print('CORRIDA LALALA ${corrida.toString()}');
  }

  Future<bool> startRacing() async {

      if (corrida.isRunning) {
        var location = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Position p = Position(
            latitude: location.latitude,
            longitude: location.longitude,
            altitude: location.altitude,
            timestamp: DateTime.now());
        corrida.last_seen = DateTime.now();
        double dist = 0;
        var lastPoint;
        for (var p in points) {
          if (lastPoint != null) {
            dist += await Geolocator().distanceBetween(
              p['latitude'],
              p['longitude'],
              lastPoint['latitude'],
              lastPoint['longitude'],
            );
          }
          lastPoint = p;
        }
        //corrida.distancia = dist;
        corridaRef.update(corrida.toJson());
        points.add(p);
       // pointsRef.push().set(p.toJson());
        return true;
      }

  }

  Future<void> stopFGS() async {
    corrida.hora_fim = DateTime.now();
    corrida.last_seen = DateTime.now();
    var location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   // pointsRef.push().set(location.toJson());
    corridaRef.update(corrida.toJson());
    corridaRef = null;
    pointsRef = null;
    corrida.isRunning = false;
    inCorrida.add(corrida);
    print('AQUI FIM STOP ${corrida}');
  }

}

NavigationBloc nb = NavigationBloc();
