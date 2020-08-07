import 'dart:async';
import 'dart:convert';

import 'package:autooh/Objetos/Ativo.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Bairro.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Localizacao.dart';
import 'package:autooh/Objetos/Zona.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoder/geocoder.dart';
//import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationBloc extends BlocBase {
  //final navigatorRepository = NavigatorRepository();
  String idcorrida;
  BehaviorSubject<Corrida> corridaController = BehaviorSubject<Corrida>();
  Stream<Corrida> get outCorrida => corridaController.stream;
  Sink<Corrida> get inCorrida => corridaController.sink;
  Corrida corrida;
  var geolocator = Geolocator();
  DatabaseReference corridaRef;
  DatabaseReference pointsRef;
  BehaviorSubject<List> pointsController = BehaviorSubject<List>();
  Stream<List> get outPoints => pointsController.stream;
  Sink<List> get inPoints => pointsController.sink;
  List<Localizacao> points;
  Placemark ultimoEndereco;
  BehaviorSubject<String> controllerUltimoEndereco = BehaviorSubject<String>();
  Stream<String> get outUltimoEndereco => controllerUltimoEndereco.stream;
  Sink<String> get inUltimoEndereco => controllerUltimoEndereco.sink;

  BehaviorSubject<bool> controllerHasIdentificado = BehaviorSubject<bool>();
  Stream<bool> get outHasIdentificado => controllerHasIdentificado.stream;
  Sink<bool> get inHasIdentificado => controllerHasIdentificado.sink;

  void foregroundServiceFunction() {}

  Function globalForegroundService() {}

  @override
  void dispose() {}

  Future<String> start(Carro carroSelecionado, {String id}) async {
    print('INICIANDO CORRIDA');
    if (id == null) {
      print('INICIANDO CORRIDA 2');
      corrida = Corrida(
          id: idcorrida,
          // distancia: 0,
          hora_ini: DateTime.now(),
          carro: carroSelecionado,
          user: Helper.localUser.id,
          hora_fim: null,
          isRunning: true,
          last_seen: DateTime.now());
      corridaRef = FirebaseDatabase.instance
          .reference()
          .child('Corridas')
          .reference()
          .push();
      print("AQUI CAPETA${corridaRef.key}");
      corridaRef.set(corrida.toJson());
      corrida.id = corridaRef.key;
      pointsRef = corridaRef.child('points');
    } else {
      print('INICIANDO CORRIDA 3');
      corridaRef = FirebaseDatabase.instance
          .reference()
          .child('Corridas')
          .reference()
          .child(idcorrida);
      pointsRef = corridaRef.child('points');
      corrida = Corrida.fromJson((await corridaRef.once()).value);
    }
    print('INICIANDO CORRIDA 4');
    corridaRef.onValue.listen((v) async {
      if (v.snapshot.value != null) {
        corrida = Corrida.fromJson(v.snapshot.value);
        inCorrida.add(corrida);
      }
    });
    pointsRef.onValue.listen((v) {
      points = new List();

      if (v.snapshot.value != 'null') {
        Map<dynamic, dynamic> pts = v.snapshot.value;
        if (pts != null) {
          pts.forEach((k, v) {
            if (v != null) {
              points.add(Localizacao.fromJson(v));
            }
          });
          points.sort((var a, var b) {
            return a.timestamp.compareTo(b.timestamp);
          });
        }
      }
    });

    corridaRef.update(corrida.toJson());
    // pointsRef.push().set(location.toJson());
    inCorrida.add(corrida);
    SharedPreferences.getInstance().then((v) {
      v.setString('corrida', corrida.id);
    });

    Campanha c = carroSelecionado.anuncio_bancos != null
        ? carroSelecionado.anuncio_bancos
        : carroSelecionado.anuncio_vidro_traseiro != null
            ? carroSelecionado.anuncio_vidro_traseiro
            : carroSelecionado.anuncio_laterais != null
                ? carroSelecionado.anuncio_laterais
                : carroSelecionado.anuncio_traseira_completa != null
                    ? carroSelecionado.anuncio_traseira_completa
                    : null;
    Ativo ativo = Ativo(
        id: corrida.id,
        id_corrida: corrida.id,
        campanha: c,
        id_campanha: c.id,
        carro: carroSelecionado,
        usuario: Helper.localUser,
        dataFim: null,
        dataIni: DateTime.now(),
        isActive: true,
        id_usuario: Helper.localUser.id);
    await ativosRef
        .document(corrida.id)
        .setData(ativo.toJson())
        .catchError((err) {
      print('Erro ao salvar Ativo');
    });
    return corrida.id;
  }

  void check() {
    print('CORRIDA LALALA ${corrida.toString()}');
  }

  Future<bool> startRacing(location) async {
    print('RODANDO START RACING');
    if (corrida != null) {
      if (corrida.isRunning) {
        bool hasMoved = false;
        print('RODANDO START RACING ${hasMoved}');
        print('Corrida ${corrida.id}');
        Localizacao loc = Localizacao(
            latitude: location.latitude,
            longitude: location.longitude,
            altitude: location.altitude,
            accuracy: location.accuracy,
            timestamp: DateTime.now());

        if (points == null) {
          points = new List();
        }
        corrida.last_seen = DateTime.now();
        double dist = 0;

        Localizacao lastPoint;
        points.sort((var a, var b) {
          return a.timestamp.compareTo(b.timestamp);
        });
        for (var p in points) {
          if (lastPoint != null) {
            dist += await Geolocator().distanceBetween(
              p.latitude,
              p.longitude,
              lastPoint.latitude,
              lastPoint.longitude,
            );
          }
          lastPoint = p;
        }
        if (points != null) {
          if (points.length != 0) {
            Localizacao p = points.last;
            if (p.latitude.toStringAsFixed(6) !=
                    loc.latitude.toStringAsFixed(6) ||
                p.longitude.toStringAsFixed(6) !=
                    loc.longitude.toStringAsFixed(6)) {
              hasMoved = true;
            }
          } else {
            hasMoved = true;
          }
        } else {
          hasMoved = true;
        }
        if (hasMoved) {
          var addresses = await Geocoder.local.findAddressesFromCoordinates(
              Coordinates(location.latitude, location.longitude));
          var first = addresses.first;
          inUltimoEndereco.add('${first.subLocality}');
          corrida.dist = dist;
          print('CORRIDA ${corrida.id}');
          if (corridaRef == null) {
            corridaRef = FirebaseDatabase.instance
                .reference()
                .child('Corridas')
                .reference()
                .child(corrida.id);
            pointsRef = corridaRef.child('points');
          }
          corridaRef.update(corrida.toJson());
          loc.bairro = '${first.subLocality}';
          points.add(loc);
          print('POINT LALALA ${loc.toJson()}');
          print('POINTS LALALA ${points.length}');
          await pointsRef
              .child('${loc.timestamp.millisecondsSinceEpoch}')
              .update(loc.toJson())
              .catchError((err) {
            print(
                'ERRO AO ADICIONAR POINT ${err.toString()} ${loc.toString()}');
          });
        }
        return true;
      }
    }
  }

  Future<void> stopFGS() async {
    Future.delayed(Duration(seconds: 5)).then((vo) async {
      corrida.hora_fim = DateTime.now();
      corrida.last_seen = DateTime.now();
      ativosRef.document(corrida.id).updateData({
        'dataFim': DateTime.now().millisecondsSinceEpoch,
        'isActive': false
      }).catchError((err) {
        print('Erro ao salvar Ativo');
      });
      print('CORRIDA ${corrida.carro.toString()}');
      if (corrida.carro.anuncio_vidro_traseiro != null) {
        Campanha c = Campanha.fromJson((await campanhasRef
                .document(corrida.carro.anuncio_vidro_traseiro.id)
                .get())
            .data);
        await gravarCorridaFirestore(c);
      }
      if (corrida.carro.anuncio_bancos != null) {
        Campanha c = Campanha.fromJson(
            (await campanhasRef.document(corrida.carro.anuncio_bancos.id).get())
                .data);

        await gravarCorridaFirestore(c);
      }
      if (corrida.carro.anuncio_laterais != null) {
        Campanha c = Campanha.fromJson((await campanhasRef
                .document(corrida.carro.anuncio_laterais.id)
                .get())
            .data);

        await gravarCorridaFirestore(c);
      }
      if (corrida.carro.anuncio_traseira_completa != null) {
        Campanha c = Campanha.fromJson((await campanhasRef
                .document(corrida.carro.anuncio_traseira_completa.id)
                .get())
            .data);
        await gravarCorridaFirestore(c);
      }

      Future.delayed(Duration(seconds: 10)).then((v) {
        // pointsRef.push().set(location.toJson());

        corridaRef.update(corrida.toJson());
        points = new List();
        corridaRef = null;
        pointsRef = null;
        corrida.isRunning = false;
        corrida = null;
        SharedPreferences.getInstance().then((v) {
          v.setString('corrida', '');
        });
        inCorrida.add(corrida);
      });
    }).catchError((err) {
      print('Error ${err.toString()}');
    });
  }

  Future<void> gravarCorridaFirestore(Campanha anuncio) async {
    print("GRAVANDO CORRIDA FIRESTORE");
    print('ANUNCIO ${anuncio}');
    Corrida c = corrida;
    List enderecos = new List();
    List<Localizacao> localizacoes = new List();
    for (Localizacao l in points) {
      enderecos.add(l.bairro);
    }
    print('ENDEREÇOS ${enderecos}');

    int duracao = 0;
    print("ZONAS ANUNCIO ${anuncio.zonas}");
    for (Zona z in anuncio.zonas) {
      print("AQUI ZONA ${z.toString()}");
      if (z != null) {
        for (int i = 0; i < points.length; i++) {
          print('AQUI POINTS ${points[i].toString()}');
          bool contains = false;
          contains = z.nome.toLowerCase().contains('CENTRAL'.toLowerCase()) ||
              (enderecos[i].toLowerCase().contains('CENTRAL'.toLowerCase())) ||
              enderecos[i].toLowerCase().contains(z.nome.toLowerCase());
          for (var s in z.bairros) {
            String s1 =
                s['bairro'].replaceAll('ST.', '').replaceAll('Setor', '');
            String e1 =
                enderecos[i].replaceAll('Setor', '').replaceAll('ST.', '');
            if (s1.toLowerCase().contains(e1.toLowerCase())) {
              contains = true;
            }
          }
          if (contains) {
            points[i].bairro = enderecos[i];
            points[i].zona = z.nome;
            localizacoes.add(points[i]);
            if (i != 0) {
              try {
                duracao += localizacoes[i]
                    .timestamp
                    .difference(localizacoes[i - 1].timestamp)
                    .inSeconds;
              } catch (err) {
                print('Erro: ${err.toString()}');
              }
            }
          }
        }
      }
    }
    print('LOCALIZAÇÔES ${localizacoes.length}');
    List<Localizacao> localizacoesTemp = new List();
    for (Localizacao l in localizacoes) {
      bool contains = false;
      for (Localizacao l2 in localizacoesTemp) {
        if (l2.timestamp == l.timestamp) {
          contains = true;
        }
      }
      if (!contains) {
        localizacoesTemp.add(l);
      }
    }
    localizacoes = localizacoesTemp;
    c.id_corrida = c.id;
    c.id_carro = c.carro.id;
    c.points = localizacoes;
    c.campanha = anuncio.id;
    c.anuncio = anuncio;
    var lastPoint;
    c.duracao = duracao;
    c.vizualizacoes = 0;

    c.dist = 0;
    for (var p in c.points) {
      if (lastPoint != null) {
        c.dist += await Geolocator().distanceBetween(
          p.latitude,
          p.longitude,
          lastPoint.latitude,
          lastPoint.longitude,
        );
      }
      lastPoint = p;
    }
    var distInKM = ((c.dist == null ? 0 : c.dist) / 1000);
    c.vizualizacoes =
        ((distInKM * 15) + ((c.duracao / 60) * (15 / 60))).floor();
    c.vizualizacoes_por_distancia = (distInKM * 15).floor();
    c.vizualizacoes_por_tempo = ((c.duracao / 60) * (15 / 60)).ceil();
    corridasRef.add(c.toJsonFirestore()).then((v) {
      c.id = v.documentID;
      corridasRef
          .document(v.documentID)
          .updateData(c.toJsonFirestore())
          .then((d) {
        dToast(
            'Corrida Finalizada com Sucesso! Suas Vizualizações na campanha ${anuncio.nome} foram ${c.vizualizacoes}');
      }).catchError((err) {
        print('ERRO AO SALVAR CORRIDA ${err.toString()}');
      });
    }).catchError((err) {
      print('ERRO AO SALVAR CORRIDA ${err.toString()}');
    });
  }

  void getLocation() {
    print("AQUI GET LOCATION");



  }
}

NavigationBloc nb = NavigationBloc();
