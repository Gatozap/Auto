class Endereco {
  String cidade;
  String cep;
  String bairro;
  String endereco;
  String numero;
  String complemento;
  double lat;
  double lng;
  String estado;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  bool isValid;

  bool isSelected;

  Endereco.Empty();

  Endereco({
    this.cidade,
    this.cep,
    this.bairro,
    this.endereco,
    this.numero,
    this.complemento,
    this.lat,
    this.lng,
    this.estado,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  Endereco.fromJson(json) {
    this.cidade = json['cidade'];
    this.cep = json['cep'];
    this.bairro = json['bairro'];
    this.endereco = json['endereco'];
    this.numero = json['numero'];
    this.complemento = json['complemento'];
    this.estado = json['estado'] == null ? 'SP' : json['estado'];
    this.lat =json['lat']== null? null:  double.parse(json['lat'].toString());
    this.lng =json['lng']== null? null:  double.parse(json['lng'].toString());
    this.created_at = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['created_at']);
    this.updated_at = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['updated_at']);
    this.deleted_at = json['deleted_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']);
  }

  get getEndereco =>
      '${endereco} ${numero} $complemento - ${bairro} - $cep, $cidade - $estado';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cidade'] = this.cidade == null ? null : this.cidade;
    data['cep'] = this.cep == null ? null : this.cep;
    data['bairro'] = this.bairro == null ? null : this.bairro;
    data['endereco'] = this.endereco == null ? null : this.endereco;
    data['numero'] = this.numero == null ? null : this.numero;
    data['complemento'] = this.complemento == null ? null : this.complemento;
    data['estado'] = this.estado == null ? 'SP' : this.estado;
    data['lat'] = this.lat == null ? null : this.lat;
    data['lng'] = this.lng == null ? null : this.lng;
    data['created_at'] =
        this.created_at == null ? null : this.created_at.millisecondsSinceEpoch;
    data['updated_at'] =
        this.updated_at == null ? null : this.updated_at.millisecondsSinceEpoch;
    data['deleted_at'] =
        this.deleted_at == null ? null : this.deleted_at.millisecondsSinceEpoch;
    return data;
  }

  @override
  String toString() {
    return 'Endereco{cidade: $cidade, cep: $cep, bairro: $bairro, endereco: $endereco, numero: $numero, complemento: $complemento, lat: $lat, lng: $lng, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, isValid: $isValid}';
  }
}
