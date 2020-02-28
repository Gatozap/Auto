import 'dart:convert';

class Rating {
  int totalAvaliacoes;
  double somaAvaliacoes;
  double mediaAvaliacoes;
  List<Avaliacao> avaliacoes;


  Rating({this.totalAvaliacoes, this.somaAvaliacoes, this.mediaAvaliacoes,
         this.avaliacoes});

  Rating.fromJson(j){
    print('AQUI RATING ${j}');
    totalAvaliacoes = j['totalAvaliacoes'];
        somaAvaliacoes = j['somaAvaliacoes'];
        mediaAvaliacoes = j['mediaAvaliacoes'];
        avaliacoes = getAvaliacoes(json.decode(j['avaliacoes']));
  }

  Map<String, dynamic> toJson() =>
      {
        'totalAvaliacoes': totalAvaliacoes,
        'somaAvaliacoes': somaAvaliacoes,
        'mediaAvaliacoes': mediaAvaliacoes,
        'avaliacoes': json.encode(avaliacoes),
      };

  static getAvaliacoes(decoded) {
    List<Avaliacao> avaliacoes = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      avaliacoes.add(Avaliacao.fromJson(i));
    }
    return avaliacoes;
  }

  Rating addAvaliacao(Avaliacao a) {
    if(avaliacoes == null){
      avaliacoes = new List();
    }
    avaliacoes.add(a);
    this.somaAvaliacoes = 0;
    this.totalAvaliacoes = avaliacoes.length;
    for(Avaliacao a in avaliacoes){
      this.somaAvaliacoes += a.nota;
    }
    this.mediaAvaliacoes =  this.somaAvaliacoes/ this.totalAvaliacoes;
    return this;
  }

}

class Avaliacao {
  String user;
  double nota;
  DateTime data;

  Avaliacao({this.user, this.nota, this.data});

  Avaliacao.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        nota = json['nota'],
        data = json['data'] == null? null: DateTime.fromMillisecondsSinceEpoch(json['data']);

  Map<String, dynamic> toJson() =>
      {
        'user': user,
        'nota': nota,
        'data': data == null? null : data.millisecondsSinceEpoch,
      };


}