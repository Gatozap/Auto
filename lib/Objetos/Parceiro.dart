import 'package:flutter/material.dart';

import 'Endereco.dart';

class Parceiro {
  bool segunda, terca, quarta, quinta, sexta, sabado, domingo;
  Endereco endereco;
  TimeOfDay hora_ini, hora_fim;
  DateTime created_at, updated_at, deleted_at;
  String nome;

  Parceiro(
      {this.segunda,
      this.terca,
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
    return 'Parceiros{segunda: $segunda, terca: $terca, quarta: $quarta, quinta: $quinta, sexta: $sexta, sabado: $sabado, domingo: $domingo, endereco: $endereco, hora_ini: $hora_ini, hora_fim: $hora_fim, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, nome: $nome}';
  }

  Map<String, dynamic> toJson() {
    return {
      "segunda": this.segunda,
      "terca": this.terca,
      "quarta": this.quarta,
      "quinta": this.quinta,
      "sexta": this.sexta,
      "sabado": this.sabado,
      "domingo": this.domingo,
      "endereco": this.endereco,
      "hora_ini": this.hora_ini,
      "hora_fim": this.hora_fim,
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

  factory Parceiro.fromMap(Map<String, dynamic> map) {
    return new Parceiro(
      segunda: map['segunda'],
      terca: map['terca'],
      quarta: map['quarta'],
      quinta: map['quinta'],
      sexta: map['sexta'],
      sabado: map['sabado'],
      domingo: map['domingo'],
      endereco: map['endereco'],
      hora_ini: map['hora_ini'],
      hora_fim: map['hora_fim'],
      created_at: map['created_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updated_at: map['updated_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
      deleted_at: map['deleted_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['deleted_at']),
      nome: map['nome'],
    );
  }
}
