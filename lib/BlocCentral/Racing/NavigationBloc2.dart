import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Objetos/Bairro.dart';
import 'package:bocaboca/Objetos/Campanha.dart';
import 'package:bocaboca/Objetos/Carro.dart';
import 'package:bocaboca/Objetos/Corrida.dart';
import 'package:bocaboca/Objetos/Localizacao.dart';
import 'package:bocaboca/Objetos/Zona.dart';

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
    if (id == null) {
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
        if (v != null) {
          points.add(Localizacao.fromJson(v));
        }
      });
      points.sort((var a, var b) {
        return a.timestamp.compareTo(b.timestamp);
      });
    });

    corridaRef.update(corrida.toJson());
    // pointsRef.push().set(location.toJson());
    inCorrida.add(corrida);
    SharedPreferences.getInstance().then((v) {
      v.setString('corrida', corrida.id);
    });
    return corrida.id;
  }

  void check() {
    print('CORRIDA LALALA ${corrida.toString()}');
  }

  Future<bool> startRacing(location) async {
    print('RODANDO START RACING');
    try {
      if (corrida != null) {
        if (corrida.isRunning) {
          bool hasMoved = false;
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
              if (p.latitude.toStringAsFixed(5) !=
                      loc.latitude.toStringAsFixed(5) ||
                  p.longitude.toStringAsFixed(5) !=
                      loc.longitude.toStringAsFixed(5)) {
                print(
                    'AQUI SETANDO HASMOVED ${p.latitude} == ${loc.latitude} ?  ${p.latitude != loc.latitude}');
                print(
                    'AQUI SETANDO HASMOVED ${p.longitude} == ${loc.longitude} ?  ${p.longitude != loc.longitude}');
                hasMoved = true;
              }
            } else {
              hasMoved = true;
            }
          } else {
            //hasMoved= true;
          }
          if (hasMoved) {
            print('Em Movimento ${location}');
            var addresses = await Geocoder.local.findAddressesFromCoordinates(
                Coordinates(location.latitude, location.longitude));
            var first = addresses.first;
            inUltimoEndereco.add('${first.subLocality}');
            corrida.dist = dist;
            corridaRef.update(corrida.toJson());
            points.add(loc);
            pointsRef.push().set(loc.toJson());
          }
          return true;
        }
      }
    } catch (err) {
      print('Erro ao verificar status ${err.toString()}');
    }
  }

  Future<void> stopFGS() async {
    Future.delayed(Duration(seconds: 5)).then((vo) async {
      corrida.hora_fim = DateTime.now();
      corrida.last_seen = DateTime.now();
      if (corrida.carro.anuncio_vidro_traseiro != null) {
        await gravarCorridaFirestore(corrida.carro.anuncio_vidro_traseiro);
      }
      if (corrida.carro.anuncio_bancos != null) {
        await gravarCorridaFirestore(corrida.carro.anuncio_bancos);
      }
      if (corrida.carro.anuncio_laterais != null) {
        await gravarCorridaFirestore(corrida.carro.anuncio_laterais);
      }
      if (corrida.carro.anuncio_traseira_completa != null) {
        await gravarCorridaFirestore(corrida.carro.anuncio_traseira_completa);
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
    });
  }

  Future<void> gravarCorridaFirestore(Campanha anuncio) async {
    Corrida c = corrida;
    List enderecos = new List();
    List<Localizacao> localizacoes = new List();
    for (Localizacao l in points) {
      var addresses = await Geocoder.local
          .findAddressesFromCoordinates(Coordinates(l.latitude, l.longitude));
      enderecos.add(addresses.first);
    }

    int duracao = 0;
    for (Zona z in anuncio.zonas) {
      try {
        if (z != null) {
          for (int i = 0; i < points.length; i++) {
            if ((z.nome.toLowerCase().contains('CENTRAL'.toLowerCase()) ||
                    enderecos[i]
                        .subLocality
                        .toLowerCase()
                        .contains('CENTRAL'.toLowerCase())) ||
                enderecos[i]
                    .subLocality
                    .toLowerCase()
                    .contains(z.nome.toLowerCase())) {
              localizacoes.add(points[i]);
              if (i != 0) {
                duracao += localizacoes[i]
                    .timestamp
                    .difference(localizacoes[i - 1].timestamp)
                    .inSeconds;
              }
            }
          }
        }
      } catch (err) {
        print('Erro ${err.toString()}');
      }
    }
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
    print("AQUI DISTANCIA EM KM ${distInKM}");
    print('DURACAO ${((c.duracao / 60) * (15 / 60))}');
    c.vizualizacoes =
        ((distInKM * 15) + ((c.duracao / 60) * (15 / 60))).floor();
    corridasRef.add(c.toJsonFirestore()).then((v) {
      c.id = v.documentID;
      corridasRef
          .document(v.documentID)
          .updateData(c.toJsonFirestore())
          .then((d) {
        dToast(
            'Corrida Finalizada com Sucesso! Suas Vizualizações na campanha ${anuncio.nome} foram ${c.vizualizacoes}');
      });
    });
  }
}

NavigationBloc nb = NavigationBloc();
