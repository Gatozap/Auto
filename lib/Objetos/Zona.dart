class Zona{
  String bairro;

  Zona({this.bairro});

  @override
  String toString() {
    return 'Zona{bairro: $bairro}';
  }

  Zona.fromJson(Map<String, dynamic> json)
      : bairro = json['bairro'];

  Map<String, dynamic> toJson() =>
      {
        'bairro': bairro,
      };


}