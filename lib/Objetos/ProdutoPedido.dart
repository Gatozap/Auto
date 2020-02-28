class ProdutoPedido {
  String id;
  String produto;
  String prestador;
  String user;
  int id_pedido;
  int quantidade;
  double preco_unitario;
  double preco_final;
  bool isPrestadorAdded;
  bool isHerbaLife;
  String estado;
  DateTime created_at, updated_at, deleted_at;

  @override
  String toString() {
    return 'ProdutoPedido{id: $id, produto: $produto, prestador: $prestador, user: $user, id_pedido: $id_pedido, quantidade: $quantidade, preco_unitario: $preco_unitario, preco_final: $preco_final, isHerbaLife: $isHerbaLife, estado: $estado, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  ProdutoPedido(
      {this.id,
      this.produto,
      this.prestador,
      this.user,
      this.id_pedido,
      this.quantidade,
      this.preco_unitario,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.isPrestadorAdded,
      String unidade = 'un',
      this.isHerbaLife,
      this.estado}) {
    if (unidade == 'un') {
      if (preco_unitario != null && quantidade != null) {
        preco_final = preco_unitario * quantidade;
      }
    } else {
      if (preco_unitario != null && quantidade != null) {
        preco_final = preco_unitario * (quantidade / 1000);
      }
    }
  }

  factory ProdutoPedido.fromJson(json) {
    return ProdutoPedido(
      id: json["produto"],
      produto: json["produto"],
      prestador: json["prestador"],
      user: json["user"],
      id_pedido:
          json["id_pedido"] == null ? null : int.parse(json["id_pedido"]),
      quantidade: json["quantidade"],
      preco_unitario: double.parse(json["preco_unitario"].toString()),
      isHerbaLife: json['isHerbaLife'] == null ? false : json['isHerbaLife'],
      estado: json['estado'] == null ? '' : json['estado'],
      isPrestadorAdded: json['isCoachAdded'] == null ? false : json['isCoachAdded'],
      created_at: json['created_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "produto": this.produto,
      "prestador": this.prestador,
      "user": this.user,
      "id_pedido": this.id_pedido,
      "quantidade": this.quantidade,
      "preco_unitario": this.preco_unitario,
      "preco_final": this.preco_final,
      'isCoachAdded': this.isPrestadorAdded == null ? false : this.isPrestadorAdded,
      'isHerbaLife': this.isHerbaLife == null ? false : this.isHerbaLife,
      'estado': this.estado == null ? '' : this.estado,
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
}
