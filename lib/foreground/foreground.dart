import 'dart:async';

import 'package:bocaboca/BlocCentral/Racing/NavigationBloc2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:geolocator/geolocator.dart';


class Racing extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Racing> {
  bool started = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:  Text('Foreground Service Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: started ? Text("STOP") : Text("START"),
                onPressed: () async {
                  if (started) {
                    await FlutterForegroundPlugin.stopForegroundService();
                  } else {
                    startForegroundService();
                  }
                  setState(() {
                    started = !started;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//função que inicializa o serviço em primeiro plano
Future<void> startForegroundService() async {
  StreamSubscription subscription;
  nb.start();
  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      //quando o serviço é inicializado, ele inicia o geolocator para para a posição atual do user

      final geolocator = Geolocator();

      subscription = geolocator
          .getPositionStream().listen((v){
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
    content: "",
    iconName: "",
  );
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
