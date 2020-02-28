class Despesa {
  String id;
  String descricao;
  String prestador;
  String criador;
  double valor;
  int tipo;
  /*
      case 0:
        tipo = 'Diario';
        break;
      case 1:
        tipo = 'Mensal';
        break;
      case 2:
        tipo = 'Anual';
        break;
      case 3:
        tipo = 'Unico';
        break;
   */
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  DateTime data_pagamento;
  bool repetivel;

  Despesa(
      {this.id,
      this.descricao,
      this.prestador,
      this.criador,
      this.valor,
      this.tipo,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.data_pagamento,
      this.repetivel});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "descricao": this.descricao,
      "prestador": this.prestador,
      "criador": this.criador,
      "valor": this.valor,
      "tipo": this.tipo,
      "created_at": this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at == null ? null : this.deleted_at,
      "data_pagamento": this.data_pagamento.millisecondsSinceEpoch == null
          ? null
          : this.data_pagamento.millisecondsSinceEpoch,
      "repetivel": this.repetivel,
    };
  }

  factory Despesa.fromJson(Map<String, dynamic> json) {
    return Despesa(
        id: json["id"],
        descricao: json["descricao"],
        prestador: json["prestador"],
        criador: json["criador"],
        valor: json["valor"],
        tipo: json["tipo"],
        created_at: json["created_at"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
        updated_at: json["updated_at"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
        deleted_at: json["deleted_at"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
        data_pagamento: json["data_pagamento"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["data_pagamento"]),
        repetivel: json["repetivel"]);
  }
}
