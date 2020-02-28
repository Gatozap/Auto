class Pericia{
    String id;
    String nome;
    String atributo;
    int modificador;
    int graduacao;
    DateTime updated_at;
    DateTime deleted_at;
    DateTime created_at;
    bool isAventureUnique;
    String aventura;
    int bonus;
    int total;
    String descricao;


    Pericia({this.id, this.nome,this.descricao, this.atributo, this.modificador, this.graduacao,
            this.updated_at, this.deleted_at, this.created_at,
            this.isAventureUnique, this.aventura, this.bonus, this.total});

    @override
    String toString() {
      return 'Pericia{id: $id, nome: $nome, atributo: $atributo, modificador: $modificador, graduacao: $graduacao, update_at: $updated_at, delete_at: $deleted_at, created_at: $created_at, isAventureUnique: $isAventureUnique, Aventura: $aventura, bonus: $bonus, total: $total}';
    }

    Pericia.fromJson(Map<String, dynamic> json)
        : id = json['id'],
          nome = json['nome'],
          atributo = json['atributo'],
          modificador = json['modificador'],
          graduacao = json['graduacao'],
          created_at = json['created_at']== null? null: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
          updated_at = json['updated_at']== null? null: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
          deleted_at = json['deleted_at']== null? null: DateTime.fromMillisecondsSinceEpoch(json['deleted_at']),
          isAventureUnique = json['isAventureUnique'],
          aventura = json['aventura'],
          bonus = json['bonus'],
          descricao= json['descricao'],
          total = json['total'];

    Map<String, dynamic> toJson() =>
        {
          'id': id,
          'nome': nome,
          'atributo': atributo,
          'descricao': descricao,
          'modificador': modificador,
          'graduacao': graduacao,
          'created_at':created_at == null? null: created_at.millisecondsSinceEpoch,
          'updated_at':updated_at == null? null: updated_at.millisecondsSinceEpoch,
          'deleted_at':deleted_at == null? null: deleted_at.millisecondsSinceEpoch,
          'isAventureUnique': isAventureUnique,
          'aventura': aventura,
          'bonus': bonus,
          'total': total,
        };


}

