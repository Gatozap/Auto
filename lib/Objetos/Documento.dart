class Documento {
  String user;
  String frente;
  String verso;
  var data;
  bool isValid;
  String tipo;
  DateTime created_at, updated_at, deleted_at;

  Documento(
      {this.user,
      this.frente,
      this.data,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Documento.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        frente = json['frente'],
        data = json['data'],
        isValid = json['isValid'],
        tipo = json['tipo'],
        created_at = json['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['created_at']),
        updated_at = json['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
        deleted_at = json['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']);

  Map<String, dynamic> toJson() => {
        'user': user,
        'frente': frente,
        'verso': verso,
        'data': data,
        'isValid': isValid,
        'tipo': tipo,
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
      };
}
