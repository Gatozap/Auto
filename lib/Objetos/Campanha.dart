import 'dart:convert';

import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Zona.dart';

import 'Carro.dart';

class Campanha{
  String id;
 String empresa;
  String cnpj;
  DateTime dataini;
  DateTime datafim;
  List zonas;
  String nome;

  bool manha;
  bool tarde;
  bool noite;
  bool final_de_semana;
  bool atende_festas;
   String sobre;

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

 Campanha({this.empresa, this.cnpj, this.dataini, this.datafim, this.zonas,
     this.horaini,this.nome, this.horafim, this.dias, this.limite, this.fotos,this.created_at,
   this.updated_at,
   this.deleted_at,
     this.carros, this.id, this.atende_festas, this.final_de_semana, this.manha, this.noite, this.sobre,this.tarde});


  @override
  String toString() {
    return 'Campanha{id: $id, empresa: $empresa, cnpj: $cnpj, dataini: $dataini, datafim: $datafim, zonas: $zonas, nome: $nome, manha: $manha, tarde: $tarde, noite: $noite, final_de_semana: $final_de_semana, atende_festas: $atende_festas, sobre: $sobre, horaini: $horaini, horafim: $horafim, dias: $dias, limite: $limite, fotos: $fotos, carros: $carros, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  factory Campanha.fromJson(j){
   Campanha c = new Campanha(
     atende_festas: j['atende_festas'] == null ? false : j["atende_festas"],
    final_de_semana: j['final_de_semana'] == null ? false : j["final_de_semana"],
    manha: j['manha'] == null ? false : j["manha"],
     noite: j['noite'] == null ? false : j["noite"],
     tarde: j['noite'] == null ? false : j["noite"],
    sobre: j['sobre'] == null ? null : j["sobre"],
    empresa: j['empresa'] == null ? null : j["empresa"],
     nome: j['nome'] == null ? null : j["nome"],
     id: j['id'] == null ? null : j["id"],
   cnpj: j['cnpj'] == null ? null : j["cnpj"],
   dataini: j['dataini']== null
   ? null
       : DateTime.fromMillisecondsSinceEpoch(j['dataini']),
   datafim: j['datafim']== null
   ? null
       : DateTime.fromMillisecondsSinceEpoch(j['datafim']),
     zonas: j['zonas'] == null
         ? null
         : getZonas(json.decode(j['zonas'])),
   horaini:  j['horaini'] == null
   ? null
       : DateTime.fromMillisecondsSinceEpoch(j['horaini']),
   horafim:  j['horafim'] == null
   ? null
       : DateTime.fromMillisecondsSinceEpoch(j['horafim']),
   dias: j['dias'] == null ? null : j["dias"],
   limite:j['limite'] == null ? 5000000 : j["limite"],
   fotos :j['fotos'] == null ? null : Helper().jsonToList(j["fotos"]),
   carros: j['carros'] == null
       ? null
       : getCarros(json.decode(j['carros'])),
   created_at : j['created_at'] == null
   ? null
       : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
   updated_at : j['updated_at'] == null
   ? null
       : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
   deleted_at : j['deleted_at'] == null
   ? null
       : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
     
   );
   return c;
 }
 Map<String, dynamic> toJson() {
   return {
     'id': this.id == null ? null : this.id,
     'nome': this.nome == null ? null : this.nome,
     'empresa': this.empresa == null ? null : this.empresa,
     'cnpj': this.cnpj == null ? null : this.cnpj,
       'tarde':  this.tarde == null ? false : this.tarde,
     'noite':  this.noite == null ? false : this.noite,
     'manha':  this.manha == null ? false : this.manha,
     'atende_festas':  this.atende_festas == null ? false : this.atende_festas,
     'final_de_semana':  this.final_de_semana == null ? false : this.final_de_semana,
     'sobre': this.sobre == null ? null : this.sobre,
     'dataini': this.dataini == null ? null : dataini.millisecondsSinceEpoch,
     'datafim': this.datafim == null ? null : datafim.millisecondsSinceEpoch,
     'zonas': this.zonas == null ?null: json.encode(this.zonas),
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
     'carros': this.carros == null ?null: json.encode(EncodeCarros(this.carros)),
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
   for(Carro c in carros){
     encoded.add(c.toJsonSemCampanha());
   }
   return encoded;
  }

}