import 'dart:convert';

import 'Bonus.dart';

class Talento {
  String id;
  String aventura;
  String nome;
  List<Bonus> bonus;

  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String requerimentos;
  String descricao;

  Talento(
      {this.id,
      this.aventura,
      this.nome,
      this.bonus,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.requerimentos,
      this.descricao});

  @override
  String toString() {
    return 'Talento{id: $id, aventura: $aventura, nome: $nome, bonus: $bonus, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, requirimentos: $requerimentos, descricao: $descricao}';
  }

  Talento.fromJson(j)
      : id = j['id'],
        aventura = j['aventura'],
        nome = j['nome'],
        bonus = j['bonus'] == null ? null : getBonus(json.decode(j['bonus'])),
        created_at = j['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
        requerimentos = j['requirimentos'],
        descricao = j['descricao'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'aventura': aventura,
        'nome': nome,
        'bonus': json.encode(bonus),
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'requirimentos': requerimentos,
        'descricao': descricao,
      };
  static getBonus(decoded) {
    List<Bonus> bonus = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      bonus.add(Bonus.fromJson(i));
    }
    return bonus;
  }
}
