import 'Carro.dart';

class Solicitacao {
  bool isAprovado;
  String usuario;
  String campanha;
  Carro carro;
  String nome_campanha, nome_usuario;
  String id;
  DateTime created_at, updated_at, deleted_at;

  Solicitacao({
    this.id,
    this.isAprovado,
    this.usuario,
    this.campanha,
    this.carro,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.nome_campanha,
    this.nome_usuario,
  });


  @override
  String toString() {
    return 'Solicitacao{isAprovado: $isAprovado, usuario: $usuario, campanha: $campanha, carro: $carro, nome_campanha: $nome_campanha, nome_usuario: $nome_usuario, id: $id, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      "isAprovado": this.isAprovado,
      "usuario": this.usuario,
      "campanha": this.campanha,
      "carro": this.carro.toJson(),
      'nome_campanha': this.nome_campanha,
      'nome_usuario': this.nome_usuario,
      "created_at": this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at == null
          ? null
          : this.deleted_at.millisecondsSinceEpoch,
    };
  }

  factory Solicitacao.fromJson(json) {
    return Solicitacao(
      isAprovado: json["isAprovado"],
      usuario: json["usuario"],
      id: json['id'],
      campanha: json["campanha"],
      carro: json["carro"] == null? null: Carro.fromJson(json["carro"]),
      nome_campanha: json['nome_campanha'],
      nome_usuario: json['nome_usuario'],
      created_at: json["created_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      updated_at: json["updated_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json["deleted_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
    );
  }
}
