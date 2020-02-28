class Bairro{
  String bairro;

  Bairro({this.bairro});

  @override
  String toString() {
    return 'Bairro{bairro: $bairro}';
  }

  Bairro.fromJson(Map<String, dynamic> json)
      : bairro = json['bairro'];

  Map<String, dynamic> toJson() =>
      {
        'bairro': bairro,
      };


}