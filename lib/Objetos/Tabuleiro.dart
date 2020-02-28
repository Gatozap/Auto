import 'Atores.dart';
import 'Personagem.dart';

class Tabuleiro{
  String id;
  String aventura;
  List<Ator> personagens;
  int altura;
  int largura;
  String foto;

  Tabuleiro({this.id, this.aventura, this.personagens, this.altura, this.largura,
            this.foto});


  @override
  String toString() {
    return 'Tabuleiro{id: $id, aventura: $aventura, personagens: $personagens, altura: $altura, largura: $largura, foto: $foto}';
  }

  Tabuleiro.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        aventura = json['aventura'],
        personagens = json['personagens'],
        altura = json['altura'],
        largura = json['largura'],
        foto = json['foto'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'aventura': aventura,
        'personagens': personagens,
        'altura': altura,
        'largura': largura,
        'foto': foto,
      };


}