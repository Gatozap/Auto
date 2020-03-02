import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Objetos/Corrida.dart';
import 'package:bocaboca/Objetos/Localizacao.dart';

import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class NavigationBloc extends BlocBase {
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
  List<Localizacao> points;

  void foregroundServiceFunction() {
    print("The current time is: ${DateTime.now()}");
  }

  Function globalForegroundService() {
    print("current datetime is ${DateTime.now()}");
  }

  @override
  void dispose() {}

  Future<void> start({String id}) async {
    if (id == null) {
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
          .push();
      corridaRef.set(corrida.toJson());
      corrida.id = corridaRef.key;
      pointsRef = corridaRef.child('points');
    } else {
      corridaRef = FirebaseDatabase.instance
          .reference()
          .child('Corridas')
          .reference()
          .child(idcorrida);
      pointsRef = corridaRef.child('points');
      corrida = Corrida.fromJson((await corridaRef.once()).value);
    }

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
        points.add(Localizacao.fromJson(v));
      });
      points.sort((var a, var b) {
        return a.timestamp.compareTo(b.timestamp);
      });
    });

    corridaRef.update(corrida.toJson());
    // pointsRef.push().set(location.toJson());
    inCorrida.add(corrida);
  }

  void check() {
    print('CORRIDA LALALA ${corrida.toString()}');
  }

  Future<bool> startRacing(location) async {
    if (corrida.isRunning) {
      bool hasMoved = false;
      Localizacao loc = Localizacao(
          latitude: location.latitude,
          longitude: location.longitude,
          altitude: location.altitude,
          accuracy: location.accuracy,
          timestamp: DateTime.now());
      if(points == null){
        points = new List();
      }
      corrida.last_seen = DateTime.now();
      double dist = 0;

      Localizacao lastPoint;
      for (var p in points) {
        if (lastPoint != null) {
          dist += await Geolocator().distanceBetween(
            p.latitude,
            p.longitude,
            loc.latitude,
            loc.longitude,
            );
        }
        lastPoint = p;
      }
      if(points != null) {
        if(points.length != 0) {
          Localizacao p = points.last;
          if (p.latitude != loc.latitude || p.longitude != loc.longitude) {
            print(' AQUI LALALA  ${p.latitude} ${ loc.latitude}  ${p.longitude}  ${loc.longitude}');
            hasMoved = true;
          }
        }else{
          hasMoved = true;
        }
      }else{
        //hasMoved= true;
      }
      print('HAS MOVED ${hasMoved}');
      if(hasMoved) {
        corrida.dist = dist;
        corridaRef.update(corrida.toJson());
        points.add(loc);
        pointsRef.push().set(loc.toJson());
      }
      return true;
    }
  }

/*
  Future<void> startForegroundService() async {
    StreamSubscription subscription;
    // await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 3);
    start();
    await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: () {
        //quando o serviço é inicializado, ele inicia o geolocator para para a posição atual do user

        final geolocator = Geolocator();

        subscription = geolocator
            .getPositionStream().listen((p){
          startRacing(p);
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
      content: "",
      iconName: "",
      );
  }
*/
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
