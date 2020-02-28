import 'Message.dart';

class Sala {
  String id;
  String sala;
  DateTime created_at, updated_at, deleted_at;
  Message lastMessage;
  List membros;
  bool isPrivate;
  String name;
  String foto;
  var meta;
  List pedidos;

  Sala(
      {this.id,
      this.sala,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.lastMessage,
      this.membros,
      this.foto,
      this.name,
        this.pedidos,
      this.meta,
      this.isPrivate});

  @override
  String toString() {
    return 'Sala{id: $id, sala: $sala, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, lastMessage: $lastMessage, membros: $membros, isPrivate: $isPrivate, meta: $meta}';
  }

  factory Sala.fromJson(json) {
    return Sala(
      id: json["id"],
      sala: json["sala"],
      foto: json['foto'],
      name: json['name'] == null ? null : json['name'],
      created_at: json["created_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      updated_at: json["updated_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json["deleted_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
      lastMessage: json["lastMessage"] == null
          ? null
          : Message.fromJson(json["lastMessage"]),
      isPrivate: json['isPrivate'] == null ? null : json['isPrivate'],
      meta: json['meta'] == null ? null : json['meta'],
      membros: json["membros"],
      pedidos: json['pedidos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "sala": this.sala,
      'foto': this.foto,
      'name': this.name == null ? null : this.name,
      "created_at": this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at == null
          ? null
          : this.deleted_at.millisecondsSinceEpoch,
      "lastMessage":
          this.lastMessage == null ? null : this.lastMessage.toJson(),
      "membros": this.membros,
      "meta": this.meta,
      'pedidos': this.pedidos,
      "isPrivate": this.isPrivate,
    };
  }
}
