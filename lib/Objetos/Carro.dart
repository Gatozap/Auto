import 'dart:convert';

import 'package:bocaboca/Objetos/Campanha.dart';



class Carro{
  String id;
  String cor;
  String modelo;
  String marca;
  String placa;
  int ano;
  String kms;
  String dono;
  String dono_nome;
  List<Campanha> campanhas;
  String renavam;
  String foto;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;




  Carro({this.cor, this.modelo, this.marca, this.placa, this.ano, this.dono,
      this.campanhas,this.dono_nome, this.renavam, this.foto ,this.created_at,this.id,
    this.updated_at,
    this.deleted_at});

  Carro.Empty();
  @override
  String toString() {
    return 'Carro{id: $id,dono_nome: $dono_nome, cor: $cor, modelo: $modelo, marca: $marca, placa: $placa, ano: $ano, dono: $dono, campanhas: $campanhas, renavam: $renavam, foto: $foto, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Carro.fromJson(j)
      : cor = j['cor'],
        id = j['id'],
        dono_nome = j['dono_nome'],
        modelo = j['modelo'],
        marca = j['marca'],
        placa = j['placa'],
        ano = j['ano'],
        dono = j['dono'],
        created_at = j['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
        campanhas = j['campanhas'] == null
            ? null
            : getCampanhas(json.decode(j['campanhas'])),
        renavam = j['renavam'],
        foto = j['foto'];

  Map<String, dynamic> toJson() =>
      {
        'cor': cor,
        'id': id,
        'modelo': modelo,
        'marca': marca,
        'placa': placa,
        'dono_nome': dono_nome,
        'created_at':
        created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
        updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
        deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'ano': ano,
        'dono': dono,
        'campanhas': this.campanhas == null ?null: json.encode(this.campanhas),
        'renavam': renavam,
        'foto': foto,
      };
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