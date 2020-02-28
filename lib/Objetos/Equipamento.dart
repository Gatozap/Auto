
import 'Bonus.dart';
class Equipamento{
  String id;
  String aventura;
  String nome;
  List<Bonus> bonus;
  DateTime created_at;
  DateTime updated_at;
  String dano;
  String foto;
  DateTime deleted_at;
  String descricao;
  String requerimentos;
  bool isEquipado;
  bool isEquipavel;
  String slot;
  int quantia;

  Equipamento({this.dano, this.foto,this.id, this.aventura, this.nome, this.bonus, this.created_at,
      this.updated_at, this.deleted_at, this.descricao, this.requerimentos,
      this.slot,this.isEquipavel,this.isEquipado, this.quantia});


  @override
  String toString() {
    return 'Equipamento{id: $id, aventura: $aventura, nome: $nome, bonus: $bonus, created_at: $created_at, updated_at: $updated_at, dano: $dano, foto: $foto, deleted_at: $deleted_at, descricao: $descricao, requerimentos: $requerimentos, isEquipado: $isEquipado, isEquipavel: $isEquipavel, slot: $slot, quantia: $quantia}';
  }

  Equipamento.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        aventura = json['aventura'],
        quantia = json['quantia'],
        nome = json['nome'],
        bonus = json['bonus'],
        dano = json['dano'],
        foto = json['foto'],
        isEquipavel = json['isEquipavel']== null? false:json['isEquipavel'],
        isEquipado = json['isEquipado'] == null? false:json['isEquipado'],
        created_at = json['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['created_at']),
        updated_at = json['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
        deleted_at = json['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']),
        descricao = json['descricao'],
        requerimentos = json['requerimentos'],
        slot = json['slot'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'aventura': aventura,
        'nome': nome,
        'quantia': quantia,
        'dano': dano,
        'foto': foto,
        'bonus': bonus,
        'isEquipavel': isEquipavel,
        'isEquipado': isEquipado,
        'created_at':
        created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
        updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
        deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'descricao': descricao,
        'requerimentos': requerimentos,
        'slot': slot,
      };


}