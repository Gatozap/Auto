import 'dart:convert';

import 'package:autooh/Objetos/Campanha.dart';

import 'Carro.dart';

class Participar{
  String id;
    String id_campanha;
    DateTime data;
       Carro carro;
  Campanha campanha;
  bool isResolved;
  bool isAceito;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  @override
  String toString() {
    return 'Participar{id: $id, id_campanha: $id_campanha, data: $data, carro: $carro, campanha: $campanha, isResolved: $isResolved, isAceito: $isAceito, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Participar.fromJson(j)
      : id = j['id'],
        id_campanha = j['id_campanha']== null ? null : j["id_campanha"],
        data = j['data'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['data']),
        carro = j['carro'] == null ? null : getCarros(json.decode(j['carros'])),
        campanha = j['campanha']== null ? null :getCampanhas(json.decode(j['campanha'])),
        isResolved = j['isResolved']== null ? false : j["isResolved"],
        isAceito = j['isAceito']== null ? false : j["isAceito"],
        created_at = j['created_at']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']);

  Map<String, dynamic> toJson() =>
      {
        'id': this.id == null ? null : this.id,
        'id_campanha': this.id_campanha == null ? null : this.id_campanha,
        'data':  this.data == null ? null : data.millisecondsSinceEpoch,
        'carro':  this.carro == null ? null : json.encode(this.carro),
        'campanha':  this.campanha == null ? null : json.encode(this.campanha),
        'isResolved': this.isResolved == null ? false : this.isResolved,
        'isAceito': this.isAceito == null ? false : this.isAceito,
        'created_at':
        this.created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
        this.updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
        this.deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
      };

  Participar({this.id, this.id_campanha, this.data, this.carro, this.campanha,
      this.isResolved, this.isAceito, this.created_at, this.updated_at,
      this.deleted_at});


  static getCarros(decoded) {
    List<Carro> carros = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      carros.add(Carro.fromJson(i));
    }
    return carros;
  }
  static getCampanhas(decoded) {
    List<Campanha> campanhas = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      campanhas.add(Campanha.fromJson(i));
    }
    return campanhas;
  }
}