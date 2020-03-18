import 'dart:convert';

import 'package:autooh/Objetos/Campanha.dart';

class Carro {
  String id;
  String cor;
  String modelo;
  String marca;
  String placa;
  int ano;
  String kms;
  String dono;
  String dono_nome;
  bool isAprovado;
  List<Campanha> campanhas;
  String renavam;
  String foto;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  Campanha anuncio_bancos;
  Campanha anuncio_laterais;
  Campanha anuncio_vidro_traseiro;
  Campanha anuncio_traseira_completa;
  String confirmacao;
  DateTime ultima_confirmacao;

  Carro(
      {this.cor,
      this.modelo,
      this.marca,
      this.placa,
      this.ano,
      this.confirmacao,
      this.ultima_confirmacao,
      this.dono,
      this.campanhas,
      this.dono_nome,
        this.isAprovado,
      this.renavam,
      this.foto,
      this.created_at,
      this.id,
      this.updated_at,
      this.deleted_at,
      this.anuncio_traseira_completa,
      this.anuncio_vidro_traseiro,
      this.anuncio_laterais,
      this.anuncio_bancos});

  Carro.Empty();

  @override
  String toString() {
    return 'Carro{id: $id, cor: $cor, modelo: $modelo, marca: $marca, placa: $placa, ano: $ano, kms: $kms, dono: $dono, dono_nome: $dono_nome, campanhas: $campanhas, renavam: $renavam, foto: $foto, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, anuncio_bancos: $anuncio_bancos, anuncio_laterais: $anuncio_laterais, anuncio_vidro_traseiro: $anuncio_vidro_traseiro, anuncio_traseira_completa: $anuncio_traseira_completa}';
  }

  Carro.fromJson(j)
      : cor = j['cor'],
        id = j['id'],
        dono_nome = j['dono_nome'],
        modelo = j['modelo'],
        marca = j['marca'],
        placa = j['placa'],
        isAprovado = j['isAprovado']== null? false : j['isAprovado'],
        ano = j['ano'],
        dono = j['dono'],
        ultima_confirmacao = j['ultima_confirmacao'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['ultima_confirmacao']),
        confirmacao = j['confirmacao'],
        anuncio_bancos = j['anuncio_bancos'] = j['anuncio_bancos'] == null
            ? null
            : Campanha.fromJson(j['anuncio_bancos']),
        anuncio_traseira_completa = j['anuncio_traseira_completa'] =
            j['anuncio_traseira_completa'] == null
                ? null
                : Campanha.fromJson(j['anuncio_traseira_completa']),
        anuncio_vidro_traseiro = j['anuncio_vidro_traseiro'] =
            j['anuncio_vidro_traseiro'] == null
                ? null
                : Campanha.fromJson(j['anuncio_vidro_traseiro']),
        anuncio_laterais = j['anuncio_laterais'] = j['anuncio_laterais'] == null
            ? null
            : Campanha.fromJson(j['anuncio_laterais']),
        created_at = j['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
        campanhas = j['campanhas'] == null
            ? null
            : getCampanhas(json.decode(j['campanhas'])),
        renavam = j['renavam'],
        foto = j['foto'];

  Map<String, dynamic> toJson() => {
        'cor': cor,
        'id': id,
        'modelo': modelo,
        'marca': marca,
        'placa': placa,
        'dono_nome': dono_nome,
        'confirmacao': confirmacao,
        'isAprovado': isAprovado == null? false: isAprovado,
        'ultima_confirmacao': ultima_confirmacao == null
            ? null
            : ultima_confirmacao.millisecondsSinceEpoch,
        'anuncio_laterais':
            anuncio_laterais == null ? null : anuncio_laterais.toJson(),
        'anuncio_traseira_completa': anuncio_traseira_completa == null
            ? null
            : anuncio_traseira_completa.toJson(),
        'anuncio_vidro_traseiro': anuncio_vidro_traseiro == null
            ? null
            : anuncio_vidro_traseiro.toJson(),
        'anuncio_bancos':
            anuncio_bancos == null ? null : anuncio_bancos.toJson(),
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'ano': ano,
        'dono': dono,
        'campanhas':
            this.campanhas == null ? null : json.encode(this.campanhas),
        'renavam': renavam,
        'foto': foto,
      };
  Map<String, dynamic> toJsonSemCampanha() => {
        'cor': cor,
        'id': id,
        'modelo': modelo,
        'marca': marca,
        'placa': placa,
        'dono_nome': dono_nome,
        'confirmacao': confirmacao,
    'isAprovado': isAprovado == null? false: isAprovado,
        'ultima_confirmacao': ultima_confirmacao == null
            ? null
            : ultima_confirmacao.millisecondsSinceEpoch,
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'ano': ano,
        'dono': dono,
        'renavam': renavam,
        'foto': foto,
      };
  static getCampanhas(decoded) {
    List<Campanha> campanhas = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      campanhas.add(Campanha.fromJson(i));
    }
    return campanhas;
  }
}
