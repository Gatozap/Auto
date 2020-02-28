import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

import 'Helpers/Cielo/src/Environment.dart';
import 'Helpers/Cielo/src/Merchant.dart';
import 'Helpers/Cielo/src/cielo_ecommerce.dart';
import 'Helpers/Helper.dart';
import 'Helpers/NotificacoesHelper.dart';
import 'Helpers/References.dart';
import 'Objetos/Notificacao.dart';
import 'Telas/Cadastro/CadastroPage.dart';
import 'Telas/Compartilhados/WaitScreen.dart';
import 'Telas/Intro/IntroPage.dart';

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
    name: 'autooh',
    options: new FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:623468197680:ios:09eca9f9d4cca36b'
          : '1:623468197680:android:09eca9f9d4cca36b',
      gcmSenderID: '623468197680',
      apiKey: 'AIzaSyDnts2EFi9ERUTeGjjYK0fvKwJ62aDcVTY',
      projectID: 'novo-boca-a-boca',
      storageBucket: 'novo-boca-a-boca.appspot.com',
      clientID: Platform.isIOS
          ? '623468197680-1r719v3451iimn9r8tj09uvhpvjhe060.apps.googleusercontent.com'
          : '623468197680-nnrtliq5fogfucn663942n5a3c6a73l5.apps.googleusercontent.com',
      bundleID: 'com.view.autooh',
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
    /*switch (j['tipo']) {
      case 'Estacionado':
        Estacionado e = Estacionado.fromJson(
            json.decode(json.decode(j['assunto'])['Estacionado']));
        Rua rua = Rua.fromJson(json.decode(json.decode(j['assunto'])['Rua']));

        print(
            'AQUI DIFERENCA     ${e.data_saida.difference(DateTime.now()).inSeconds}');
        Dialogs().ShowEstenderDialog(context, e, rua, false);
        break;
    }*/
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4)).then((V) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
      SharedPreferences.getInstance().then((sp) {
        bool intro = sp.getBool('intro');
        /*if (intro == null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => IntroPage()));
          } else {
            if (intro == false) {*/

        /*}
          }*/
        isIntroOpen = true;
      });
    });
    //TODO COMENTAR ESSAS 2 LINHAS
    /*for (Assinatura a in assinaturas) {
      assinaturasRef.document(a.id).setData(a.toJson());
    }*/
    //  Inserir planos
    /*final planosRef = Firestore.instance.collection('Planos').reference();
    for (Plano p in planos) {
      planosRef.add(p.toJson()).then((docref) {
        p.id = docref.documentID;
        planosRef.document(p.id).updateData(p.toJson());
      });
    }*/
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

        /*pushData = msg;
        hasPush = true;*/
      },
    );
    //NotificacoesHelper().showDailyAtTime();

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
        title: 'autooh',
        /*localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt_br'),
        ],*/
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Helvetica',
            textSelectionColor: corSecundaria,
            textSelectionHandleColor: corPrimaria,
            highlightColor: Colors.white,
            cursorColor: corPrimaria),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
    // display a dialog with the notification details, tap ok to go to another page

    dToast('Aqui push ${payload.toString()}');
    NotificacoesHelper().showNotification(json.decode(payload), context);
    SharedPreferences.getInstance().then((sp) {
      sp.setString('lastpush', json.encode(payload));
    });
    print('Notificação AQUI Launch');
  }
}
