import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool started = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Foreground Service Example'),
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
                    //OPCIONAL: inicializar foreground service com o seguinte bloco de código:
                    /*
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FlutterForegroundPlugin.stopForegroundService();
     await startForegroundService();
    });
    super.initState();
  }


                    */
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
  // await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 3);
  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      //quando o serviço é inicializado, ele inicia o geolocator para para a posição atual do user
      
      final geolocator = Geolocator();

      subscription = geolocator
          .getPositionStream()
          // em vez do Dio().post, coloque aqui a sua requisição pro seu serviço na API
          .asyncMap((location) => Dio().post(
                  "https://webhook.site/d756f865-f075-45a2-82fd-eb2e61676890",
                  data: {
                    "altitude": location.altitude,
                    "longitude": location.longitude,
                    "latitude": location.latitude
                  }))
          .listen((response) async {
        print("${DateTime.now()}");
        // print(response.statusCode);
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
