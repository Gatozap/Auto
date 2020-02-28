import 'dart:convert';

class Zona{
  List bairros;
  String nome;

  Zona({this.bairros,this.nome});

  @override
  String toString() {
    return 'Zona{bairro: $bairros}';
  }

  Zona.fromJson( j)
      : bairros = json.decode(j['bairro']), nome =j['nome'];

  Map<String, dynamic> toJson() =>
      {
        'bairro': json.encode(bairros),
        'nome':nome,
      };


}