import 'dart:convert';



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
  String user;
  List<Distancia> distancia;
  String carro;
  String campanhas;
 String points;


  @override
  String toString() {
    return 'Corrida{id: $id, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, hora_ini: $hora_ini, hora_fim: $hora_fim, isRunning: $isRunning, last_seen: $last_seen, user: $user, distancia: $distancia, carro: $carro, campanhas: $campanhas, Points: $points}';
  }

  Corrida({this.id, this.hora_ini, this.hora_fim, this.isRunning, this.last_seen,
      this.user, this.distancia, this.carro, this.campanhas, this.points, this.deleted_at, this.created_at,this.updated_at});


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
        distancia = j['distancia'] == null
            ? null
            : getDistancia(json.decode(j['distancia'])),
        hora_ini = j['hora_ini']== null? null: DateTime.fromMillisecondsSinceEpoch(j['hora_ini']),
        hora_fim = j['hora_fim']== null? null: DateTime.fromMillisecondsSinceEpoch(j['hora_fim']),
        last_seen = j['last_seen']== null? null: DateTime.fromMillisecondsSinceEpoch(j['last_seen']),
        isRunning = j['isRunning'],

        user = j['user'],

        carro = j['carro'],
        campanhas = j['campanhas'],
        points = j['points'];

  Map<String, dynamic> toJson() =>
      {
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
        'last_seen': last_seen == null ? null : last_seen.millisecondsSinceEpoch,
        'user': user,
        'distancia': json.encode(distancia),
        'carro': carro,
        'campanhas': campanhas,
        'points': points,
      };

  static getDistancia(decoded) {
    print('AQUI DECODED ${decoded}');
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