class Grupo{
  String id;
  String nome;
  String foto;
  String descricao;
  List membros;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  List aventuras;
  List adms;


  @override
  String toString() {
    return 'Grupo{id: $id, nome: $nome, foto: $foto, descricao: $descricao, membros: $membros, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, aventuras: $aventuras, adms: $adms}';
  }

  Grupo({this.id, this.nome, this.foto, this.descricao, this.membros,
        this.created_at, this.updated_at, this.deleted_at,this.adms, this.aventuras});

  Grupo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        foto = json['foto'],
        descricao = json['descricao'],
        membros = json['membros'],
        created_at = json['created_at']== null? null: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
        updated_at = json['updated_at']== null? null: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
        deleted_at = json['deleted_at']== null? null: DateTime.fromMillisecondsSinceEpoch(json['deleted_at']),
        adms = json['adms'],
        aventuras = json['aventuras'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'nome': nome,
        'foto': foto,
        'descricao': descricao,
        'membros': membros,
        'adms': adms,
        'created_at': created_at == null? null: created_at.millisecondsSinceEpoch,
        'updated_at': updated_at == null? null: updated_at.millisecondsSinceEpoch,
        'deleted_at': deleted_at == null? null: deleted_at.millisecondsSinceEpoch,
        'aventuras': aventuras,
      };


}