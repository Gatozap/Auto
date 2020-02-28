class Distancia{
String id_campanha;
double distancia;
String carro;
String corrida;

Distancia({this.id_campanha, this.distancia, this.carro, this.corrida});

@override
String toString() {
  return 'Distancia{id_campanha: $id_campanha, distancia: $distancia, carro: $carro, corrida: $corrida}';
}

Distancia.fromJson(Map<String, dynamic> json)
    : id_campanha = json['id_campanha'],
      distancia = json['distancia'],
      carro = json['carro'],
      corrida = json['corrida'];

Map<String, dynamic> toJson() =>
    {
      'id_campanha': id_campanha,
      'distancia': distancia,
      'carro': carro,
      'corrida': corrida,
    };


}