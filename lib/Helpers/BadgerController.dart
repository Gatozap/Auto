import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgerController extends BlocBase {
  BehaviorSubject<int> _controllerBadge = new BehaviorSubject<int>();

  Stream<int> get outBadge => _controllerBadge.stream;

  Sink<int> get inBadge => _controllerBadge.sink;

  BehaviorSubject<int> _controllerBadgeChat = new BehaviorSubject<int>();

  Stream<int> get outBadgeChat => _controllerBadgeChat.stream;

  Sink<int> get inBadgeChat => _controllerBadgeChat.sink;

  BehaviorSubject<int> _controllerBadgeAniversriante =
      new BehaviorSubject<int>();

  Stream<int> get outBadgeAniversariante =>
      _controllerBadgeAniversriante.stream;

  Sink<int> get inBadgeAniversariante => _controllerBadgeAniversriante.sink;

  BehaviorSubject<int> _controllerBadgeProduto = new BehaviorSubject<int>();

  Stream<int> get outBadgeProduto => _controllerBadgeProduto.stream;

  Sink<int> get inBadgeProduto => _controllerBadgeProduto.sink;

  BehaviorSubject<int> _controllerBadgeAvaliacao = new BehaviorSubject<int>();

  Stream<int> get outBadgeAvaliacao => _controllerBadgeAvaliacao.stream;

  Sink<int> get inBadgeAvaliacao => _controllerBadgeAvaliacao.sink;

  BehaviorSubject<int> _controllerBadgeEvento = new BehaviorSubject<int>();

  Stream<int> get outBadgeEvento => _controllerBadgeEvento.stream;

  Sink<int> get inBadgeEvento => _controllerBadgeEvento.sink;

  BadgerController() {
    initPlatformState();
    SharedPreferences.getInstance().then((prefs) {
      int badges = prefs.getInt('badges') == null ? 0 : prefs.getInt('badges');
      int chat = prefs.getInt('chat') == null ? 0 : prefs.getInt('chat');
      int aniversariante = prefs.getInt('aniversariante') == null
          ? 0
          : prefs.getInt('aniversariante');
      int evento = prefs.getInt('evento') == null ? 0 : prefs.getInt('evento');
      int produto =
          prefs.getInt('produto') == null ? 0 : prefs.getInt('produto');
      int avaliacao =
          prefs.getInt('avaliacao') == null ? 0 : prefs.getInt('avaliacao');

      inBadgeEvento.add(evento);
      inBadgeProduto.add(produto);
      inBadgeAvaliacao.add(avaliacao);
      inBadgeAniversariante.add(aniversariante);
      inBadgeChat.add(chat);
      inBadge.add(badges);
    });
  }

  initPlatformState() async {
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        print('Supported');
      } else {
        print('Not supported');
      }
    } on PlatformException {
      print('Failed to get badge support.');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    //setState(() {

    //});
  }

  Future addBadge(int type) async {
    if (type != 5) {
      initPlatformState();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int badges = prefs.getInt('badges');
      int tipebadges = 0;
      switch (type) {
        case 0:
          tipebadges = prefs.getInt('chat');
          break;
        case 1:
          tipebadges = prefs.getInt('aniversariante');
          break;
        case 2:
          tipebadges = prefs.getInt('produto');
          break;
        case 3:
          tipebadges = prefs.getInt('evento');
          break;
        case 4:
          tipebadges = prefs.getInt('avaliacao');
          break;
      }
      if (tipebadges == null) {
        tipebadges = 0;
      }
      if (badges == null) {
        badges = 0;
      }
      tipebadges++;

      switch (type) {
        case 0:
          prefs.setInt('chat', tipebadges);
          inBadgeChat.add(tipebadges);
          break;
        case 1:
          prefs.setInt('aniversariante', tipebadges);
          inBadgeAniversariante.add(tipebadges);
          break;
        case 2:
          prefs.setInt('produto', tipebadges);
          inBadgeProduto.add(tipebadges);
          break;
        case 3:
          prefs.setInt('evento', tipebadges);
          inBadgeEvento.add(tipebadges);
          break;
        case 4:
          prefs.setInt('avaliacao', tipebadges);
          inBadgeAvaliacao.add(tipebadges);
          break;
      }

      //AppBadger.updateBadgeCount(badges);
      int chat = prefs.getInt('chat') == null ? 0 : prefs.getInt('chat');
      int aniversariante = prefs.getInt('aniversariante') == null
          ? 0
          : prefs.getInt('aniversariante');
      int evento = prefs.getInt('evento') == null ? 0 : prefs.getInt('evento');
      int produto =
          prefs.getInt('produto') == null ? 0 : prefs.getInt('produto');
      int avaliacao =
          prefs.getInt('avaliacao') == null ? 0 : prefs.getInt('avaliacao');
      badges = chat + aniversariante + evento + produto + avaliacao;
      inBadge.add(badges);
      FlutterAppBadger.updateBadgeCount(badges);
      print('ADICIONOU BADGE ${badges}');
    }
  }

  Future removeBadges(int type, {value}) async {
    value = value == null ? 0 : value;
    initPlatformState();
    print('Iniciando ADD BADGE');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (type) {
      case 0:
        prefs.setInt('chat', value);
        break;
      case 1:
        prefs.setInt('aniversariante', value);
        break;
      case 2:
        prefs.setInt('produto', value);
        break;
      case 3:
        prefs.setInt('evento', value);
        break;
      case 4:
        prefs.setInt('avaliacao', value);
        break;
    }
    int chat = prefs.getInt('chat') == null ? 0 : prefs.getInt('chat');
    int aniversariante = prefs.getInt('aniversariante') == null
        ? 0
        : prefs.getInt('aniversariante');
    int evento = prefs.getInt('evento') == null ? 0 : prefs.getInt('evento');
    int produto = prefs.getInt('produto') == null ? 0 : prefs.getInt('produto');
    int avaliacao =
        prefs.getInt('avaliacao') == null ? 0 : prefs.getInt('avaliacao');
    int badges = chat + aniversariante + evento + produto + avaliacao;
    //AppBadger.updateBadgeCount(badges);
    prefs.setInt('badges', badges);
    FlutterAppBadger.updateBadgeCount(badges);
    inBadgeEvento.add(evento);
    inBadgeProduto.add(produto);
    inBadgeAvaliacao.add(avaliacao);
    inBadgeAniversariante.add(aniversariante);
    inBadgeChat.add(chat);
    inBadge.add(badges);
    print('ADICIONOU BADGE ${badges}');
  }

  @override
  void dispose() {
    _controllerBadge.close();
    _controllerBadgeAniversriante.close();
    _controllerBadgeChat.close();
    _controllerBadgeEvento.close();
    _controllerBadgeProduto.close();
    _controllerBadgeAvaliacao.close();
  }
}

BadgerController bc = new BadgerController();
