import 'dart:convert';

import 'package:flutter/material.dart';

import 'Endereco.dart';

class Parceiro {

  bool segunda, terca, quarta, quinta, sexta, sabado, domingo;
  Endereco endereco;
  TimeOfDay hora_ini, hora_fim;
  DateTime created_at, updated_at, deleted_at;
  String nome, id, foto, telefone;

  Parceiro(
      {this.segunda,
      this.terca,
        this.telefone,
        this.foto,
        this.id,
      this.quarta,
      this.quinta,
      this.sexta,
      this.sabado,
      this.domingo,
      this.endereco,
      this.hora_ini,
      this.hora_fim,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.nome});

  @override
  String toString() {
    return 'Parceiros{segunda: $segunda,id: $id, telefone: $telefone, foto: $foto, terca: $terca, quarta: $quarta, quinta: $quinta, sexta: $sexta, sabado: $sabado, domingo: $domingo, endereco: $endereco, hora_ini: $hora_ini, hora_fim: $hora_fim, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, nome: $nome}';
  }

  Parceiro.fromJson( j)
      : segunda = j['segunda'],
        terca = j['terca'],
        quarta = j['quarta'],
        quinta = j['quinta'],
        sexta = j['sexta'],
        sabado = j['sabado'],
        domingo = j['domingo'],
        endereco = j['endereco']== null
            ? null
            : Endereco.fromJson(j['endereco']),
        hora_ini = j['hora_ini'] == null ? null :TimeOfDay(hour: j['hora_ini']['hour'], minute: j['hora_ini']['minute']),
        hora_fim = j['hora_fim']== null ? null :TimeOfDay(hour: j['hora_fim']['hour'], minute: j['hora_fim']['minute']),
        created_at = j['created_at']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
        nome = j['nome'],
        id = j['id'],
        foto = j['foto'],
        telefone = j['telefone'];



  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'telefone': this.telefone,
      'foto': this.foto,
      "segunda": this.segunda,
      "terca": this.terca,
      "quarta": this.quarta,
      "quinta": this.quinta,
      "sexta": this.sexta,
      "sabado": this.sabado,
      "domingo": this.domingo,

      "endereco": this.endereco== null ? null : this.endereco.toJson(),
      'hora_ini': {'hour': this.hora_ini.hour,'minute': this.hora_ini.minute} ,
      'hora_fim': {'hour': this.hora_fim.hour,'minute': this.hora_fim.minute},
      'created_at': this.created_at != null
          ? this.created_at.millisecondsSinceEpoch
          : null,
      'updated_at': this.updated_at != null
          ? this.updated_at.millisecondsSinceEpoch
          : null,
      'deleted_at': this.deleted_at != null
          ? this.deleted_at.millisecondsSinceEpoch
          : null,
      "nome": this.nome
    };
  }



  static getEndereco(decoded) {
    List<Endereco> enderecos = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      enderecos.add(Endereco.fromJson(i));
    }
    return enderecos;
  }
}
