import 'package:autooh/Objetos/Solicitacao.dart';

import 'Campanha.dart';
import 'Carro.dart';
import 'Parceiro.dart';
import 'User.dart';

class Instalacao{
    String id;
  Solicitacao isAprovado;
  Parceiro id_parceiro;
  Solicitacao id_campanha;

  User id_usuario;
  Carro id_carro;
 DateTime  hora_agendada;
 DateTime created_at;
 DateTime updated_at;
 DateTime deleted_at;

  Instalacao({this.isAprovado, this.id_parceiro, this.id_campanha,
      this.id_usuario, this.id_carro, this.hora_agendada, this.created_at,
      this.updated_at, this.deleted_at, this.id});

  @override
  String toString() {
    return 'Instalacao{isAprovado: $isAprovado, id_parceiro: $id_parceiro, id: $id, id_campanha: $id_campanha, id_usuario: $id_usuario, id_carro: $id_carro, hora_agendada: $hora_agendada, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Instalacao.fromJson(j)
      : isAprovado = j['isAprovado'] == null? null:Solicitacao.fromJson(j['isAprovado']),
        id_parceiro = j['id_parceiro'] == null? null:Parceiro.fromJson(j['id_parceiro']),
        id_campanha = j['id_campanha'] == null? null:Solicitacao.fromJson(j['id_campanha']),
        id_usuario = j['id_usuario'] == null? null:User.fromJson(j['id_usuario']),
        id = j['id'],
        id_carro =  j['id_carro'] == null? null: Carro.fromJson(j['id_carro']),
        hora_agendada = j['hora_agendada']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['hora_agendada']),
        created_at = j['created_at']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at']== null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']);

  Map<String, dynamic> toJson() =>
      {
        'isAprovado': isAprovado,
        'id_parceiro': id_parceiro == null ? null : this.id_parceiro.toJson(),
        'id_campanha': id_campanha== null ? null : this.id_campanha.toJson(),
        'id_usuario': id_usuario== null ? null : this.id_usuario.toJson(),
        'id_carro': id_carro== null ? null : this.id_carro.toJson(),
        'parceiro_query' :this.id_parceiro.id,
        'id' : id,
        'hora_agendada': hora_agendada!= null
            ? this.hora_agendada.millisecondsSinceEpoch
            : null,
        'created_at': created_at!= null
            ? this.created_at.millisecondsSinceEpoch
            : null,
        'updated_at': updated_at!= null
            ? this.updated_at.millisecondsSinceEpoch
            : null,
        'deleted_at': deleted_at!= null
            ? this.deleted_at.millisecondsSinceEpoch
            : null,
      };


}