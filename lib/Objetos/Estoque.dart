class Estoque {
  String prestador;
  String id;
  int disponivel;
  int minimo;
  String produto;
  DateTime created_at;
  DateTime last_purchased_at;
  DateTime updated_at;
  DateTime deleted_at;
  bool isHerbaLife;

  @override
  String toString() {
    return 'Estoque{prestador: $prestador, id: $id, disponivel: $disponivel, minimo: $minimo, produto: $produto, created_at: $created_at, last_purchased_at: $last_purchased_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Estoque(
      {this.prestador,
      this.id,
      this.disponivel,
      this.minimo,
      this.produto,
      this.created_at,
      this.last_purchased_at,
      this.updated_at,
      this.isHerbaLife,
      this.deleted_at});

  Map<String, dynamic> toJson() {
    return {
      "prestador": this.prestador,
      "id": this.id,
      "disponivel": this.disponivel,
      "minimo": this.minimo,
      "produto": this.produto,
      'isHerbaLife': this.isHerbaLife,
      "created_at": this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      "last_purchased_at": this.last_purchased_at == null
          ? null
          : this.last_purchased_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at == null
          ? null
          : this.deleted_at.millisecondsSinceEpoch,
    };
  }

  factory Estoque.fromJson(json) {
    return Estoque(
      prestador: json["prestador"],
      id: json["id"],
      disponivel: json["disponivel"],
      minimo: json["minimo"],
      produto: json["produto"],
      isHerbaLife: json['isHerbaLife'],
      created_at: json["created_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      last_purchased_at: json["last_purchased_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["last_purchased_at"]),
      updated_at: json["updated_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json["deleted_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
    );
  }
}
