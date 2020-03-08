class Bairro{
  String bairro;
  int pessoa_km_rodado;
  int pessoa_hora_parado;
  Bairro({this.bairro, this.pessoa_hora_parado, this.pessoa_km_rodado});

  @override
  String toString() {
    return 'Bairro{bairro: $bairro,pessoa_hora_parado: $pessoa_hora_parado,pessoa_km_rodado: $pessoa_km_rodado, }';
  }

  Bairro.fromJson(Map<String, dynamic> json)
      : bairro = json['bairro'],
        pessoa_km_rodado = json['pessoa_km_rodado'],
        pessoa_hora_parado = json['pessoa_hora_parado'];

  Map<String, dynamic> toJson() =>
      {
        'bairro': bairro,
        'pessoa_km_rodado': pessoa_km_rodado,
        'pessoa_hora_parado': pessoa_hora_parado,
      };


}