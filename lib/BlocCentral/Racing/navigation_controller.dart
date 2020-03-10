import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Objetos/Corrida.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../../main.dart';

bool isRacing = false;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class RacingController extends BlocBase {

  DatabaseReference corridaRef;
  DatabaseReference pointsRef;
  Position position;
  int corrida;
  Corrida c;
  bool hasStarted = false;
  List points;

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (flutterLocalNotificationsPlugin == null) {
      var initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings(
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
      });
      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String payload) async {});
    }
    if (points == null) {
      points = new List();
    }
    /*BackgroundLocation.getLocationUpdates((location) async {

    });*/
  }

  updateLocation() async {
    var location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    bool canFetch = position != null;
    if (canFetch) {
      canFetch = position.latitude != location.latitude &&
          position.longitude != location.longitude;
    } else {
      canFetch = true;
    }

    if (isRacing) {
      position = Position(
          latitude: location.latitude,
          longitude: location.longitude,
          altitude: location.altitude,
          timestamp: DateTime.now());
      try {
       /* c.distancia += await geolocator.distanceBetween(
          points.last.latitude,
          points.last.longitude,
          position.latitude,
          position.longitude,
          ); */
      } catch (e) {
        try {
         /* c.distancia += await geolocator.distanceBetween(
            points.last['latitude'],
            points.last['longitude'],
            position.latitude,
            position.longitude,
            );*/
        } catch (err) {}
      }
      if (position != null) {
        if (points == null) {
          points = new List();
        }
        points.add(position);
      }
    }
    if (canFetch) {
      if (!hasStarted) {/*
        int cor =
            await sp.getInt('corrida', defaultValue: 789789789788789).first;
        corrida = cor != 789789789788789 ? cor : null;

        isRacing = await sp.getBool('isRacing', defaultValue: false).first;
        if (isRacing) {
          c = Corrida.fromJson((await corridaRef.once()).value);
        }
        hasStarted = true;
      */}
        corridaRef.update(c.toJson());
        //pointsRef.push().set(position.toJson());

    }
  }


  Geolocator geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 20,
  );

  RacingController() {
    initPlatformState();
    if (c != null) {
      if (points == null) {
        points = new List();
      }
    }
  }

  @override
  void dispose() {}

  Future<void> stopRacing() async {
    try {
      if (corrida != null) {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        corridaRef =
            FirebaseDatabase.instance.reference().child('Corridas').reference().child(corrida.toString());
        c = Corrida.fromJson((await corridaRef.once()).value);
        double dist = 0;
        var lastPoint;
        for (var p in points) {
          if (lastPoint != null) {
            dist += await geolocator.distanceBetween(
              p.latitude,
              p.longitude,
              lastPoint.latitude,
              lastPoint.longitude,
            );
          }
          lastPoint = p;
        }
       // c.distancia = dist;
        c.hora_fim = DateTime.now();
        corridaRef.update(c.toJson());

        try{

      }catch(err){
    }
        corrida = null;
        corridaRef = null;
        pointsRef = null;

        isRacing = false;

        c = null;
        _cancelNotification();
      } else {
        /*int cor =
            await sp.getInt('corrida', defaultValue: 789789789788789).first;*/
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        corridaRef =
            FirebaseDatabase.instance.reference().child('Corridas').reference()/*.child(cor.toString())*/;
        c = Corrida.fromJson((await corridaRef.once()).value);

        double dist = 0;
        var lastPoint;
        for (var p in points) {
          if (lastPoint != null) {
            dist += await geolocator.distanceBetween(
              p.latitude,
              p.longitude,
              lastPoint.latitude,
              lastPoint.longitude,
              );
          }
          lastPoint = p;
        }
        //c.distancia = dist;
        c.hora_fim = DateTime.now();
        corridaRef.update(c.toJson());

        try {

        }catch(err){
          print('Erro na merda do servidor ${err.toString()}');
        }
        corrida = null;
        corridaRef = null;
        pointsRef = null;

        isRacing = false;

        c = null;
        _cancelNotification();
      }
    } catch (err) {
      print('Error:${err.toString()}');
      stopRacing();
      return;
    }
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> _showOngoingNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'CorridaAvantiCar',
        'CorridaAvantiCar',
        'Notificação da corrida AvantiCar',
        importance: Importance.Max,
        priority: Priority.High,
        icon: 'ic_launcher',
        ongoing: true,
        autoCancel: false,
        channelAction: AndroidNotificationChannelAction.Update);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'DivulgaCars',
        'Você está ganhando dinheiro', platformChannelSpecifics);
    while (isRacing) {
      await Future.delayed(Duration(seconds: 5));
      updateLocation();
    }
  }

  Future<void> startRacing() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


    print('CORRIDA ${corrida}');
    if (corrida == null) {
      startRacing();
      print('REINICIANDO START RACIN SEM RESPOSTA DA API');
      return;
    }


    corridaRef =
        FirebaseDatabase.instance.reference().child('Corridas').reference().child(corrida.toString());
    pointsRef = corridaRef.child('points');
    c = Corrida(
       // distancia: 0,
        hora_ini: DateTime.now(),
        id: corrida.toString(),
       // user: user
    )
    ;
    corridaRef.set(c.toJson());
    isRacing = true;
    //sp.setBool('isRacing', isRacing);
    await _showOngoingNotification();
    //changePositionRandomly();
  }
}
