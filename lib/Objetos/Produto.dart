import 'dart:convert';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Comentario.dart';

import 'Endereco.dart';

import 'Rating.dart';

class Produto {
  String titulo;
  String descricao;
  double preco;
  double preco_original;
  String unidade;
  List fotos;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String id;
  String secao;
  bool visivel;
  String criador;
  bool isHerbaLife;
  String estado;
  bool segunda;
  bool terca;
  bool quarta;
  bool quinta;
  bool sexta;
  bool sabado;
  bool domingo;
  Endereco endereco;
  Rating rating;

  List<Comentario> comentarios;
  Produto.Empty();


  @override
  String toString() {
    return 'Produto{titulo: $titulo, descricao: $descricao, preco: $preco, preco_original: $preco_original, unidade: $unidade, fotos: $fotos, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, id: $id, secao: $secao, visivel: $visivel, criador: $criador, isHerbaLife: $isHerbaLife, estado: $estado, segunda: $segunda, terca: $terca, quarta: $quarta, quinta: $quinta, sexta: $sexta, sabado: $sabado, domingo: $domingo, endereco: $endereco, rating: $rating, comentarios: $comentarios}';
  }

  Produto(
      {this.titulo,
        this.endereco,
      this.descricao,
      this.preco,
        this.preco_original,
      this.unidade,
      this.fotos,
      this.created_at,
      this.updated_at,
      this.deleted_at,
        this.comentarios,
        this.segunda,
        this.terca,
        this.quarta,
        this.quinta,
        this.rating,
        this.sexta,
        this.sabado,
        this.domingo,
      this.id,
      this.criador,
      this.secao,

      this.visivel,
      this.isHerbaLife = false,
      this.estado = ''}) {}

  factory Produto.fromJson(j) {
    Produto p = Produto(
      titulo: j['titulo'] == null ? null : j["titulo"],
      descricao: j['descricao'] == null ? null : j["descricao"],
      segunda: j['segunda'] == null ? null : j["segunda"],
      terca: j['terca'] == null ? null : j["terca"],
      quarta: j['quarta'] == null ? null : j["quarta"],
      quinta: j['quinta'] == null ? null : j["quinta"],
      sexta: j['sexta'] == null ? null : j["sexta"],
      sabado: j['sabado'] == null ? null : j["sabado"],
      comentarios : j['comentarios'] == null ? null : getComentarios(json.decode(j["comentarios"])),
      domingo: j['domingo'] == null ? null : j["domingo"],
        endereco: j['endereco'] == null ? null : Endereco.fromJson(j['endereco']),

      rating:j['rating']  == null?null:  Rating.fromJson(j['rating']),
      preco: j['preco'] == null ? null : j["preco"].toDouble(),
      preco_original: j['preco_original'] == null ? null : j["preco_original"].toDouble(),
      unidade: j['unidade'] == null ? null : j["unidade"],
      fotos: j['fotos'] == null ? null : Helper().jsonToList(j["fotos"]),
      criador: j['criador'] == null ? null : j['criador'],
      isHerbaLife: j['isHerbaLife'] == null ? false : j['isHerbaLife'],
      estado: j['estado'] == null ? '' : j['estado'],

      created_at: j['created_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j["created_at"]),
      updated_at: j['updated_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j["updated_at"]),
      deleted_at: j['deleted_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j["deleted_at"]),
      id: j['id'] == null ? null : j["id"],
      visivel: j['visivel'] == null ? null : j["visivel"],
    );
    return p;
  }


  static getComentarios(decoded) {
    List<Comentario> avaliacoes = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      avaliacoes.add(Comentario.fromJson(i));
    }
    return avaliacoes;
  }
  Map<String, dynamic> toJson() {
    return {
      'titulo': this.titulo == null ? null : this.titulo,
      "descricao": this.descricao == null ? null : this.descricao,
      "preco": this.preco == null ? null : this.preco,
      "unidade": this.unidade == null ? null : this.unidade,
      "fotos": this.fotos == null ? null : this.fotos,
      'criador': this.criador == null ? null : this.criador,
      "preco_original": this.preco_original == null ? null : this.preco_original,
      'comentarios': this.comentarios == null ?null: json.encode(this.comentarios),
      'segunda': this.segunda == null ? null : this.segunda,
      "terca": this.terca == null ? null : this.terca,
      "quarta": this.quarta == null ? null : this.quarta,
      "quinta": this.quinta == null ? null : this.quinta,
      "sexta": this.sexta == null ? null : this.sexta,
      'sabado': this.sabado == null ? null : this.sabado,
      'domingo': this.domingo == null ? null : this.domingo,
      'rating': this.rating == null ? null :this.rating.toJson(),
      'endereco': this.endereco == null ? null : this.endereco.toJson(),
      'isHerbaLife': this.isHerbaLife == null ? false : this.isHerbaLife,
      'estado': this.estado == null ? '' : this.estado,
      "created_at": this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at == null
          ? null
          : this.deleted_at.millisecondsSinceEpoch,
      "id": this.id == null ? null : this.id,
      "secao": this.secao == null ? null : this.secao,
      "visivel": this.visivel == null ? null : this.visivel,
    };
  }
}
