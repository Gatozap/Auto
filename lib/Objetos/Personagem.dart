import 'dart:convert';

import 'package:bocaboca/Objetos/Talento.dart';

import 'Equipamento.dart';
import 'Pericia.dart';

class Personagem {
  String id;
  String user;
  String aventura;
  String foto;
  String nome;
  String raca;
  int idade;
  double altura;
  double peso;
  int forca;
  int dex;
  int con;
  int car;
  int inte;
  int sab;
  int ca;
  String ba;
  String cac;
  String ad;
  int pv;
  int pv_total;
  int refl;
  int fort;
  String bg;
  int vont;
  int nivel;
  int exp;
  String classe;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  List<Pericia> pericias;
  List<Talento> talentos;
  List<Equipamento> equipamentos;

  Personagem(
      {this.id,
             this.equipamentos,
      this.talentos,
      this.bg,
      this.classe,
      this.nivel,
      this.exp,
      this.user,
      this.aventura,
      this.foto,
      this.nome,
      this.idade,
      this.altura,
      this.peso,
      this.forca,
      this.dex,
      this.con,
      this.car,
      this.inte,
      this.sab = 10,
      this.ca = 10,
      this.raca,
      this.ba,
      this.cac,
      this.ad,
      this.pv,
      this.refl,
      this.fort,
      this.pericias,
      this.pv_total,
      this.vont,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  @override
  String toString() {
    return 'Personagem{id: $id,equipamentos: $equipamentos, user: $user, aventura: $aventura, foto: $foto, nome: $nome, raca: $raca, idade: $idade, altura: $altura, peso: $peso, forca: $forca, dex: $dex, con: $con, car: $car, inte: $inte, sab: $sab, ca: $ca, ba: $ba, cac: $cac, ad: $ad, pv: $pv, pv_total: $pv_total, refl: $refl, fort: $fort, bg: $bg, vont: $vont, nivel: $nivel, exp: $exp, classe: $classe, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, pericias: $pericias, talentos: $talentos}';
  }


  Personagem.fromJson(j)
      : id = j['id'],
        user = j['user'],
        aventura = j['aventura'],
        foto = j['foto'],
        nome = j['nome'],
        raca = j['raca'],
        idade = j['idade'],
        altura = j['altura'],
        peso = j['peso'],
        forca = j['forca'],
        dex = j['dex'],
        con = j['con'],
        car = j['car'],
        inte = j['inte'],
        sab = j['sab'],
        ca = j['ca'],
        ba = j['ba'].toString(),
        cac = j['cac'].toString(),
        ad = j['ad'].toString(),
        pv = j['pv'],
        pv_total = j['pv_total'],
        refl = j['refl'],
        fort = j['fort'],
        bg = j['bg'],
        vont = j['vont'],
        nivel = j['nivel'],
        exp = j['exp'],
        classe = j['classe'],
        created_at = j['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['created_at']),
        updated_at = j['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['updated_at']),
        deleted_at = j['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']),
        pericias = j['pericias'] == null
            ? null
            : getPericias(json.decode(j['pericias'])),

        talentos = j['talentos'] == null
            ? null
            :getTalentos(json.decode(j['talentos'])),
        equipamentos = j['equipamentos'] == null
            ? null
            :getEquipamentos(json.decode(j['equipamentos']));





        // getTalentos(json.decode(j['talentos']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'aventura': aventura,

        'foto': foto,
        'nome': nome,
        'idade': idade,
        'altura': altura,
        'peso': peso,
        'forca': forca,
        'dex': dex,
        'con': con,
        'car': car,
        'inte': inte,
        'sab': sab,
        'ca': ca,
        'ba': ba,
        'cac': cac,
        'ad': ad,
        'pv': pv,
        'pv_total': pv_total,
        'refl': refl,
        'fort': fort,
        'bg': bg,
        'vont': vont,
        'nivel': nivel,
        'raca': raca,
        'exp': exp,
        'classe': classe,
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
        'pericias': json.encode(pericias),
        'talentos': json.encode(talentos),
    'equipamentos': json.encode(equipamentos),
      };

  static getPericias(decoded) {
    List<Pericia> pericias = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      pericias.add(Pericia.fromJson(i));
    }
    return pericias;
  }

  static getTalentos(decoded) {
    print('AQUI DECODED ${decoded}');
    List<Talento> talentos = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      talentos.add(Talento.fromJson(i));
    }
    return talentos;
  }
  static getEquipamentos(decoded) {
    print('AQUI DECODED ${decoded}');
    List<Equipamento> equipamentos = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      equipamentos.add(Equipamento.fromJson(i));
    }
    return equipamentos;
  }
}
