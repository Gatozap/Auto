import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Home/Home.dart';
import 'package:autooh/Telas/Login/Login.dart';
import 'package:autooh/Telas/Login/LoginEmail/CadastroEmail/cadastroemail.dart';
import 'package:autooh/Telas/Login/LoginEmail/EsqueceuSenha/EsqueceuSenha.dart';
import 'package:autooh/Telas/Login/LoginEmail/LoginEmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helpers/Bairros.dart';
import 'Helpers/Cielo/src/Environment.dart';
import 'Helpers/Cielo/src/Merchant.dart';
import 'Helpers/Cielo/src/cielo_ecommerce.dart';
import 'Helpers/Helper.dart';
import 'Helpers/NotificacoesHelper.dart';
import 'Helpers/References.dart';
import 'Objetos/Notificacao.dart';
import 'Objetos/Zona.dart';
import 'Telas/Cadastro/CadastroPage.dart';  
import 'Telas/Compartilhados/WaitScreen.dart';
import 'Telas/Intro/IntroPage.dart';

FirebaseDatabase database;
String notificationUrl =
    'https://us-central1-autooh.cloudfunctions.net/sendNotification';
//TODO FAzer CLOUD FUNCTIONS

Future main() async {
  runApp(MyApp());
  CieloEcommerce cielo = CieloEcommerce(
      environment: Environment.SANDBOX, // ambiente de desenvolvimento
      merchant: Merchant(
        merchantId: "bd42d8ba-8462-4fe2-907b-286427c31fef",
        merchantKey: "haGf1RSXlfV39vlUecd29NC9ocmG0G7cRsmCalMU",
      ));

  //1. Integração
  //Faça integração conforme manual do desenvolvedor incluindo suas credenciais de acesso
  //Merchant ID: bd42d8ba-8462-4fe2-907b-286427c31fef
  //Merchant Key: haGf1RSXlfV39vlUecd29NC9ocmG0G7cRsmCalMU
  //As instruções para integração estão no Manual do Desenvolvedor no link abaixo:
  //https://developercielo.github.io/Webservice-3.0/#integração-webservice-3.0
  Helper.cielo = cielo;
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: new FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:833154723346:android:ec4788d0894308c7b9f2cb'
          : '1:833154723346:android:ec4788d0894308c7b9f2cb',
      gcmSenderID: '833154723346',
      apiKey: 'AIzaSyC1TP3_Egip9wBhskTz2_tNT8sS6enrDNw',
      projectID: 'avanticar-34239',
      databaseURL: 'https://avanticar-34239.firebaseio.com/',
      storageBucket: 'avanticar-34239.appspot.com',
      clientID: Platform.isIOS
          ? '833154723346-oap1dblgdcb7qdf7iu21dg2docfu7m08.apps.googleusercontent.com'
          : '833154723346-oap1dblgdcb7qdf7iu21dg2docfu7m08.apps.googleusercontent.com',
      bundleID: 'com.rbsoftware.autooh',
    ),
  );
  var firestore = new Firestore(app: app);
  firestore.settings(
    persistenceEnabled: true,
    timestampsInSnapshotsEnabled: true,
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: Helper.analytics);
  static final navKey = new GlobalKey<NavigatorState>();
  const MyApp({Key navKey}) : super(key: navKey);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isIntroOpen = false;
  Future onSelectNotification() async {
    final context = MyApp.navKey.currentState.overlay.context;
    SharedPreferences.getInstance().then((sp) {
      var p = sp.getString('lastpush');
      var j = json.decode(p);
      Notificacao n = new Notificacao.fromJson(Platform.isIOS ? j : j['data']);
      n.data = json.decode(n.data);
      print('ABRINDO NOTIFICACAO ${n.toString()}');
      switch (n.behaivior) {
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4)).then((V) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
      SharedPreferences.getInstance().then((sp) {
        bool intro = sp.getBool('intro');
        isIntroOpen = true;
      });
    });
  }

  final userRef = Firestore.instance.collection('Users').reference();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseMessaging fbmsg = new FirebaseMessaging();

  var flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        <DeviceOrientation>[DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: corPrimaria));
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('autooh');
    var initializationSettingsIOS = new IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (n) {
      onSelectNotification();
    });
    NotificacoesHelper.flutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin;

    //TODO DEFINIR BEHAVIOURS DAS PUSHS
    fbmsg.configure(
      onLaunch: (Map<String, dynamic> msg) {
        //App Terminated
        dToast('Aqui push ${msg.toString()}');
        NotificacoesHelper().showNotification(msg, context);
        SharedPreferences.getInstance().then((sp) {
          sp.setString('lastpush', json.encode(msg));
        });
        print('Notificação AQUI Launch');
      },
      onResume: (Map<String, dynamic> msg) {
        print('Notificação AQUI RESUME');
        //App in Background
        dToast('Aqui push ${msg.toString()}');
        SharedPreferences.getInstance().then((sp) {
          sp.setString('lastpush', json.encode(msg));
        });
        NotificacoesHelper().showNotification(msg, context);
      },
      onMessage: (Map<String, dynamic> msg) {
        print('Notificação Message');
        //App in Foreground
        dToast('Aqui push ${msg.toString()}');
        SharedPreferences.getInstance().then((sp) {
          sp.setString('lastpush', json.encode(msg));
        });
        NotificacoesHelper().showNotification(msg, context);
      },
    );

    fbmsg.requestNotificationPermissions(
        const IosNotificationSettings(alert: true, badge: true, sound: true));
    fbmsg.onIosSettingsRegistered.listen((IosNotificationSettings ins) {
      print("dispositivo registrado");
    });
    fbmsg.getToken().then((token) {
      print("TOKEN REGISTRADO" + token);
      Helper.token = token;
    });

    fbmsg.subscribeToTopic('global');
    fbmsg.subscribeToTopic('teste');
    Helper.fbmsg = fbmsg;
    print('Buscando user');
    Helper.analytics.logAppOpen();
    return MaterialApp(
        navigatorKey: MyApp.navKey,
        title: 'Autooh',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Helvetica',
            textSelectionColor: corSecundaria,
            textSelectionHandleColor: corPrimaria,
            highlightColor: Colors.white,
            cursorColor: corPrimaria),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: Helper.analytics),
        ],
        home: FutureBuilder(
          future: _auth.currentUser(),
          builder: (context, future) {
            if (future.hasData) {
              if (future.data != null) {
                try {
                  return FutureBuilder(
                      future: userRef.document(future.data.uid).get(),
                      builder: (context, v) {
                        if (v.hasData) {
                          if (v.data != null) {
                            if (v.data['id'] != null) {
                              Helper.localUser = User.fromJson(v.data);
                              if (Helper.localUser.isPrestador == null) {
                                return Cadastro();
                              } else {
                                return HomePage();
                              }
                            } else {
                              return Login();
                            }
                          } else {
                            return Login();
                          }
                        }
                        if (v.hasError) {
                          print('Error 1:${v.error.toString()}');
                          print('ENTROU AQUI');
                          return Login();
                        }
                        return Login();
                      });
                } catch (err) {
                  print('Error 1:${err.toString()}');
                  print('ENTROU AQUI');
                  return Login();
                }
              } else {
                return Login();
              }
            }
            if (future.hasError) {
              print('Error 1:${future.error.toString()}');
              print('ENTROU AQUI');
              return WaitScreen();
            }
            return Login();
          },
        ));
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    dToast('Aqui push ${payload.toString()}');
    NotificacoesHelper().showNotification(json.decode(payload), context);
    SharedPreferences.getInstance().then((sp) {
      sp.setString('lastpush', json.encode(payload));
    });
    print('Notificação AQUI Launch');
  }
}
