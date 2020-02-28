class Cartao {
  String id;
  String id_user;
  int expiration_month;
  int expiration_year;
  String number;
  int cvc;
  String hash;
  int R;
  int G;
  int B;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String owner;
  String tipo;
  String marca;

  bool isSelected;

  @override
  String toString() {
    return 'Cartao{id: $id,marca: $marca id_user: $id_user, expiration_month: $expiration_month, expiration_year: $expiration_year, number: $number, cvc: $cvc, hash: $hash, R: $R, G: $G, B: $B, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, owner: $owner}';
  }

  Cartao({
    this.id,
    this.id_user,
    this.expiration_month,
    this.expiration_year,
    this.number,
    this.cvc,
    this.hash,
    this.R,
    this.G,
    this.B,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.owner,
    this.tipo,
    this.marca,
  });

  Cartao.Empty();

  Cartao.fromJson(json) {
    this.id = json['id'];
    this.id_user = json['id_user'] == null
        ? json['user_id'] != null ? json['user_id'] : null
        : json['id_user'];
    this.expiration_month = int.parse(json['expiration_month'].toString());
    this.expiration_year = int.parse(json['expiration_year'].toString());
    this.number = json['number'];
    this.cvc = json['cvc'];
    this.hash = json['hash'];
    this.R = json['R'];
    this.G = json['G'];
    this.B = json['B'];
    this.marca = json['marca'] == null ? 'visa' : json['marca'];
    this.created_at = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['created_at']);
    this.updated_at = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['updated_at']);
    this.deleted_at = json['deleted_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']);
    this.owner = json['owner'] == null
        ? json['owner'] != null ? json['owner'] : null
        : json['owner'];
    this.tipo = json['tipo'] == null ? null : json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id == null ? null : this.id;
    data['id_user'] = this.id_user == null ? null : this.id_user;
    data['expiration_month'] =
        this.expiration_month == null ? null : this.expiration_month;
    data['expiration_year'] =
        this.expiration_year == null ? null : this.expiration_year;
    data['number'] = this.number == null ? null : this.number;
    data['cvc'] = this.cvc == null ? null : this.cvc;
    data['hash'] = this.hash == null ? null : this.hash;
    data['R'] = this.R == null ? null : this.R;
    data['G'] = this.G == null ? null : this.G;
    data['B'] = this.B == null ? null : this.B;
    data['marca'] = this.marca == null ? 'Visa' : this.marca;
    data['created_at'] =
        this.created_at == null ? null : this.created_at.millisecondsSinceEpoch;
    data['updated_at'] =
        this.updated_at == null ? null : this.updated_at.millisecondsSinceEpoch;
    data['deleted_at'] =
        this.deleted_at == null ? null : this.deleted_at.millisecondsSinceEpoch;
    data['owner'] = this.owner == null ? null : this.owner;
    data['tipo'] = this.tipo == null ? null : this.tipo;
    return data;
  }
}
