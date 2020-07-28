class Relatorio{
  String id;
  String sender;
  String campanha;
  String url;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String nome;

  Relatorio({this.nome, this.id, this.sender, this.campanha, this.url, this.created_at,
      this.updated_at, this.deleted_at});

  @override
  String toString() {
    return 'Relatorio{id: $id, sender: $sender, campanha: $campanha, url: $url, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      'nome': this.nome,
      "sender": this.sender,
      "campanha": this.campanha,
      "url": this.url,
      "created_at": this.created_at== null? null: this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at== null? null: this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at== null? null: this.deleted_at.millisecondsSinceEpoch,
    };
  }

  factory Relatorio.fromJson(Map<String, dynamic> json) {
    return Relatorio(id: json["id"],
      sender: json["sender"],
      campanha: json["campanha"],
      url: json["url"],
      nome: json['nome'],
      created_at: json["created_at"] == null? null: DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      updated_at: json["updated_at"] == null? null: DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json["deleted_at"] == null? null: DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),);
  }





}