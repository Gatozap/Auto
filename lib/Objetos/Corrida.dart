import 'dart:convert';

import 'package:bocaboca/Objetos/Localizacao.dart';

import 'Campanha.dart';
import 'Carro.dart';
import 'Distancia.dart';

class Corrida {
  String id;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  DateTime hora_ini;
  DateTime hora_fim;
  bool isRunning;
  DateTime last_seen;
  int vizualizacoes;
  String user;
  String campanha;
  int duracao;

  String id_corrida;
  String id_carro;
  var dist;
  Carro carro;
  List points;

  @override
  String toString() {
    return 'Corrida{id: $id, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, hora_ini: $hora_ini, hora_fim: $hora_fim, isRunning: $isRunning, last_seen: $last_seen, user: $user,  carro: $carro, points: $points}';
  }

  Corrida(
      {this.id,
      this.hora_ini,
      this.hora_fim,
      this.isRunning,
      this.last_seen,
      this.user,
      this.dist,
      this.duracao,

      this.vizualizacoes,
      this.carro,
      this.points,
      this.id_carro,
      this.campanha,
      this.id_corrida,
      this.deleted_at,
      this.created_at,
      this.updated_at});

  Corrida.fromJsonFirestore(j)
      : id = j['id'],
        created_at = j['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
        dist = j['dist'] ,
        campanha = j['campanha'],
        id_corrida = j['id_corrida'],
        id_carro = j['id_carro'],
        vizualizacoes = j['vizualizacoes'],

        hora_ini = j['hora_ini'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['hora_ini']),
        duracao = j['duracao'],
        hora_fim = j['hora_fim'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['hora_fim']),
        last_seen = j['last_seen'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['last_seen']),
        isRunning = j['isRunning'],
        user = j['user'],
        carro = j['carro'] == null ? null : Carro.fromJson(j['carro']),
        points = j['points'] == null ? null : getLocalizacoes(json.decode(j['points']));

  Corrida.fromJson(j)
      : id = j['id'],
        created_at = j['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
        dist = j['dist'],

        hora_ini = j['hora_ini'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['hora_ini']),
        hora_fim = j['hora_fim'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['hora_fim']),
        last_seen = j['last_seen'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['last_seen']),
        isRunning = j['isRunning'],
        user = j['user'],
        carro = j['carro'] == null ? null : Carro.fromJson(j['carro'])
  /*oints = j['points'] == null ? null : getLocalizacoes(j['points'])*/;

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,

        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'hora_ini': hora_ini == null ? null : hora_ini.millisecondsSinceEpoch,
        'hora_fim': hora_fim == null ? null : hora_fim.millisecondsSinceEpoch,
        'isRunning': isRunning,
        'id_carro': id_carro,
        'dist': dist,

        'last_seen':
            last_seen == null ? null : last_seen.millisecondsSinceEpoch,
        'user': user,

        'carro': carro == null ? null : carro.toJson(),
        'points': json.encode(points),
      };

  Map<String, dynamic> toJsonFirestore() => {
        'id': id,
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'hora_ini': hora_ini == null ? null : hora_ini.millisecondsSinceEpoch,
        'hora_fim': hora_fim == null ? null : hora_fim.millisecondsSinceEpoch,
        'duracao': duracao,
        'isRunning': isRunning,
        'vizualizacoes': vizualizacoes,
        'campanha': campanha,
        'id_corrida': id_corrida,
        'dist': dist,
        'last_seen':
            last_seen == null ? null : last_seen.millisecondsSinceEpoch,
        'user': user,

        'carro': carro == null ? null : carro.toJsonSemCampanha(),
        'points': json.encode(points),
      };

  static getLocalizacoes(decoded) {
    List<Localizacao> localizacoes = new List();
    List points = decoded;
    if (decoded == null) {
      return null;
    }
    for(var v in points){
      localizacoes.add(Localizacao.fromJson(v));
    }
    return localizacoes;
  }

  static getCampanhas(decoded) {
    List<Campanha> localizacoes = new List();
    Map<dynamic, dynamic> points = decoded;
    if (decoded == null) {
      return null;
    }
    points.forEach((k, v) {
      localizacoes.add(Campanha.fromJson(v));
    });
    return localizacoes;
  }

  static getDistancia(decoded) {
    List<Distancia> distancias = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      distancias.add(Distancia.fromJson(i));
    }
    return distancias;
  }
}
