import 'Personagem.dart';

class Ator {
  Personagem personagem;
  int y;
  int x;

  Ator(this.personagem, this.y, this.x);

  @override
  String toString() {
    return 'Ator{personagem: $personagem, y: $y, x: $x}';
  }

  Ator.fromJson(Map<String, dynamic> json)
      : personagem = Personagem.fromJson(json['personagem']),
        y = json['y'],
        x = json['x'];

  Map<String, dynamic> toJson() =>
      {
        'personagem': personagem.toJson(),
        'y': y,
        'x': x,
      };


}