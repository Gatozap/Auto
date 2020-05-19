import 'dart:convert';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Zona.dart';

import 'Carro.dart';

class Campanha {
  String id;
  String empresa;
  String cnpj;
  DateTime dataini;
  DateTime datafim;
  List zonas;
  String nome;
  bool anuncio_bancos;
  bool anuncio_laterais;
  bool anuncio_vidro_traseiro;
  bool anuncio_traseira_completa;
  bool manha;
  bool tarde;
  bool noite;
  bool final_de_semana;
  bool atende_festas;
  String sobre;
  double kmMinima, duracaoMinima, precomes;
  DateTime horaini;
  DateTime horafim;
  DateTime dias;
  int limite;
  List fotos;
  List<Carro> carros;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  Campanha.Empty();

  Campanha(
      {this.empresa,
      this.cnpj,
      this.dataini,
      this.datafim,
      this.zonas,
      this.horaini,
      this.nome,
      this.horafim,
      this.dias,
      this.limite,
      this.fotos,
      this.created_at,
      this.updated_at,
      this.anuncio_bancos,
      this.anuncio_laterais,
      this.anuncio_traseira_completa,
      this.anuncio_vidro_traseiro,
      this.deleted_at,
      this.kmMinima,
      this.duracaoMinima,
      this.precomes,
      this.carros,
      this.id,
      this.atende_festas,
      this.final_de_semana,
      this.manha,
      this.noite,
      this.sobre,
      this.tarde});

  factory Campanha.fromJson(j) {
    if(j.runtimeType.toString() == "Campanha"){
      return j;
    }
    Campanha c = new Campanha(
      atende_festas: j['atende_festas'] == null ? false : j["atende_festas"],
      final_de_semana:
          j['final_de_semana'] == null ? false : j["final_de_semana"],
      anuncio_laterais:
          j['anuncio_laterais'] == null ? false : j["anuncio_laterais"],
      anuncio_bancos: j['anuncio_bancos'] == null ? false : j["anuncio_bancos"],
      anuncio_traseira_completa: j['anuncio_traseira_completa'] == null
          ? false
          : j["anuncio_traseira_completa"],
      anuncio_vidro_traseiro: j['anuncio_vidro_traseiro'] == null
          ? false
          : j["anuncio_vidro_traseiro"],
      duracaoMinima: j['duracaoMinima'] == null
          ? 0.0
          : double.parse(j["duracaoMinima"].toString()),
      precomes:
          j['precomes'] == null ? 0.0 : double.parse(j["precomes"].toString()),
      kmMinima:
          j['kmMinima'] == null ? 0.0 : double.parse(j["kmMinima"].toString()),
      manha: j['manha'] == null ? false : j["manha"],
      noite: j['noite'] == null ? false : j["noite"],
      tarde: j['noite'] == null ? false : j["noite"],
      sobre: j['sobre'] == null ? null : j["sobre"],
      empresa: j['empresa'] == null ? null : j["empresa"],
      nome: j['nome'] == null ? null : j["nome"],
      id: j['id'] == null ? null : j["id"],
      cnpj: j['cnpj'] == null ? null : j["cnpj"],
      dataini: j['dataini'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j['dataini']),
      datafim: j['datafim'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j['datafim']),
      zonas: j['zonas'] == null ? null : getZonas(json.decode(j['zonas'])),
      horaini: j['horaini'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j['horaini']),
      horafim: j['horafim'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j['horafim']),
      dias: j['dias'] == null ? null : j["dias"],
      limite: j['limite'] == null ? 5000000 : j["limite"],
      fotos: j['fotos'] == null ? null : Helper().jsonToList(j["fotos"]),
      carros: j['carros'] == null ? null : getCarros(json.decode(j['carros'])),
      created_at: j['created_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
      updated_at: j['updated_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
      deleted_at: j['deleted_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
    );
    return c;
  }

  @override
  String toString() {
    return 'Campanha{id: $id, empresa: $empresa, cnpj: $cnpj, dataini: $dataini, datafim: $datafim, zonas: $zonas, nome: $nome, anuncio_bancos: $anuncio_bancos, anuncio_laterais: $anuncio_laterais, anuncio_vidro_traseiro: $anuncio_vidro_traseiro, anuncio_traseira_completa: $anuncio_traseira_completa, manha: $manha, tarde: $tarde, noite: $noite, final_de_semana: $final_de_semana, atende_festas: $atende_festas, sobre: $sobre, kmMinima: $kmMinima, duracaoMinima: $duracaoMinima, precomes: $precomes, horaini: $horaini, horafim: $horafim, dias: $dias, limite: $limite, fotos: $fotos, carros: $carros, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id == null ? null : this.id,
      'nome': this.nome == null ? null : this.nome,
      'empresa': this.empresa == null ? null : this.empresa,
      'cnpj': this.cnpj == null ? null : this.cnpj,
      'kmMinima': this.kmMinima == null ? 0.0 : this.kmMinima,
      'precomes': this.precomes == null ? 0.0 : this.precomes,
      'duracaoMinima': this.duracaoMinima == null ? 0.0 : this.duracaoMinima,
      'tarde': this.tarde == null ? false : this.tarde,
      'noite': this.noite == null ? false : this.noite,
      'manha': this.manha == null ? false : this.manha,
      'anuncio_bancos':
          this.anuncio_bancos == null ? false : this.anuncio_bancos,
      'anuncio_vidro_traseiro': this.anuncio_vidro_traseiro == null
          ? false
          : this.anuncio_vidro_traseiro,
      'anuncio_traseira_completa': this.anuncio_traseira_completa == null
          ? false
          : this.anuncio_traseira_completa,
      'anuncio_laterais':
          this.anuncio_laterais == null ? false : this.anuncio_laterais,
      'atende_festas': this.atende_festas == null ? false : this.atende_festas,
      'final_de_semana':
          this.final_de_semana == null ? false : this.final_de_semana,
      'sobre': this.sobre == null ? null : this.sobre,
      'dataini': this.dataini == null ? null : dataini.millisecondsSinceEpoch,
      'datafim': this.datafim == null ? null : datafim.millisecondsSinceEpoch,
      'zonas': this.zonas == null ? null : json.encode(this.zonas),
      'horaini': this.horaini == null ? null : horaini.millisecondsSinceEpoch,
      'horafim': this.horafim == null ? null : horafim.millisecondsSinceEpoch,
      'dias': this.dias == null ? null : dias.millisecondsSinceEpoch,
      'created_at':
          this.created_at == null ? null : created_at.millisecondsSinceEpoch,
      'updated_at':
          this.updated_at == null ? null : updated_at.millisecondsSinceEpoch,
      'deleted_at':
          this.deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
      'limite': this.limite == null ? 5000000 : this.limite,
      "fotos": this.fotos == null ? null : this.fotos,
      'carros':
          this.carros == null ? null : json.encode(EncodeCarros(this.carros)),
    };
  }

  static getCarros(decoded) {
    List<Carro> carros = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      carros.add(Carro.fromJson(i));
    }
    return carros;
  }

  static getZonas(decoded) {
    List<Zona> zonas = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      zonas.add(Zona.fromJson(i));
    }
    return zonas;
  }

  EncodeCarros(List<Carro> carros) {
    List encoded = new List();
    for (Carro c in carros) {
      encoded.add(c.toJsonSemCampanha());
    }
    return encoded;
  }
}
