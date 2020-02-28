class Pacote {
  int preco;
  int valor;
  String titulo;
  String prestador;
  DateTime created_at, updated_at, deleted_at;
  String foto;
  String id;

  Pacote(
      {this.preco,
      this.valor,
      this.titulo,
      this.prestador,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.foto,
      this.id});

  Pacote.Empty();

  @override
  String toString() {
    return 'Pacote{preco: $preco, valor: $valor, titulo: $titulo, prestador: $prestador, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, foto: $foto}';
  }

  factory Pacote.fromJson(json) {
    return Pacote(
      preco: json["preco"],
      valor: json["valor"],
      id: json['id'],
      titulo: json["titulo"],
      prestador: json["prestador"],
      created_at: json["created_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      updated_at: json["updated_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json["deleted_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
      foto: json["foto"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "preco": this.preco,
      "valor": this.valor,
      "titulo": this.titulo,
      'id': this.id,
      "prestador": this.prestador,
      "created_at": this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at == null
          ? null
          : this.deleted_at.millisecondsSinceEpoch,
      "foto": this.foto,
    };
  }
}
