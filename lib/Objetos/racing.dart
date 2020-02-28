class Racing {
  String idcorrida;
  String motoristaId;
  String inicio;
  String fim;
  String publicidadeId;
  String latitudeStart;
  String latitudeEnd;
  String longitudeStart;
  String longitudeEnd;
  String metrosRodados;

  Racing(
      {this.idcorrida,
      this.motoristaId,
      this.inicio,
      this.fim,
      this.publicidadeId,
      this.latitudeStart,
      this.latitudeEnd,
      this.longitudeStart,
      this.longitudeEnd,
      this.metrosRodados});

  Racing.fromJson(Map<String, dynamic> json) {
    idcorrida = json['idcorrida'];

    motoristaId = json['motorista_id'];
    inicio = json['inicio'];
    fim = json['fim'];
    publicidadeId = json['publicidade_id'];
    latitudeStart = json['latitude_start'];
    latitudeEnd = json['latitude_end'];
    longitudeStart = json['longitude_start'];
    longitudeEnd = json['longitude_end'];

    metrosRodados = json['metros_rodados'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcorrida'] = this.idcorrida;
    data['motorista_id'] = this.motoristaId;
    data['inicio'] = this.inicio;
    data['fim'] = this.fim;
    data['publicidade_id'] = this.publicidadeId;
    data['latitude_start'] = this.latitudeStart;
    data['latitude_end'] = this.latitudeEnd;
    data['longitude_start'] = this.longitudeStart;
    data['longitude_end'] = this.longitudeEnd;
    data['metros_rodados'] = this.metrosRodados;
    return data;
  }
}
