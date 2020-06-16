import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Carro.dart';
import 'Cartao.dart';
import 'Documento.dart';
import 'Endereco.dart';

class User {
  String id;
  String nome;
  DateTime data_nascimento;
  String celular;
  String cpf;
  bool isGroupAdm;
  String email; 
  String responsavel;
  String senha;
  String user_responsavel;
  int strike;
  String saldo;
  String identidade;
  String identidade_expedidor;
  DateTime identidade_data_expedicao;
  int permissao;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  List<Cartao> cartoes;
  bool antecedentes;
  DateTime antecendete_verificados_em;
  String remember_token;
  String genero;
  bool isPrestador;
  bool isEmailVerified;
  bool isEmpresario;
  bool manha;
  bool tarde;
  bool noite;
  String prestador;
  String tipo;
  bool isAdm;
  String foto;
  bool isAlowed;
  Endereco endereco;
  bool isAniversario;
  String grupo;
  String tipo_conta;
  int kmmin;
  int kmmax;
  String conta_bancaria;
  List<Carro> carros;
  String telefone;
  String agencia;
  String numero_conta;
  String nome_conta;
  String cpf_conta;
  bool isBanido;
  bool atende_festa;
  bool atende_fds;

  List<Documento> documentos;

  var example = {
    "id": "124",
    "nome": "Renato Bosa",
    "data_nascimento": "1992-04-15 00:00:00",
    "celular": "(42) 9 9931-9375",
    "cpf": "083.668.949-67",
    "email": "vergil009@hotmail.com",
    "senha": "cf7fb946251d266391dece237e4e1155",
    "strike": "0",
    "identidade": "1123123123",
    "identidade_expedidor": "PR",
    "identidade_data_expedicao": "1992-04-15 00:00:00",
    "permissao": null,
    "created_at": null,
    "updated_at": null,
    "deleted_at": null,
    "remember_token": null,
    "enderecos": [
      {
        "id": "16",
        "id_user": "124",
        "cidade": "Castro",
        "cep": "84178-470",
        "bairro": "Cantagalo",
        "endereco": "Rua Pedro Canha Salgado",
        "numero": "87",
        "complemento": "",
        "lat": "-24.8153262",
        "lng": "-50.0001578",
        "created_at": "2019-01-28 14:53:50",
        "updated_at": "2019-01-28 14:53:50",
        "deleted_at": null
      }
    ],
    "cartoes": [
      {
        "id": "1",
        "id_user": "124",
        "expiration_month": "10",
        "expiration_year": "2022",
        "number": "5292 0500 1263 9481",
        "cvc": "827",
        "hash": "  ",
        "R": "198",
        "G": "40",
        "B": "40",
        "created_at": "2019-01-28 17:33:06",
        "updated_at": "2019-01-28 17:33:06",
        "deleted_at": null,
        "owner_name": "Renato Bosa"
      }
    ]
  };

  User.Empty() {
    strike = 0;
    permissao = 0;
  }

  User(
      {this.id,
      this.nome,
      this.data_nascimento,
      this.celular,
      this.cpf,
      this.email,
      this.saldo,
      this.kmmin,
      this.kmmax,
      this.senha,
      this.tipo_conta,
      this.strike,
      this.numero_conta,
      this.agencia,
      this.identidade,
      this.manha,
      this.tarde,
      this.noite,
      this.identidade_expedidor,
      this.identidade_data_expedicao,
      this.permissao,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.cartoes,
      this.responsavel,
      this.remember_token,
      this.tipo,
      this.isEmpresario,
      this.antecedentes,
      this.isPrestador,
      this.genero,
      this.prestador,
      this.isAlowed,
      this.isAdm,
      this.isGroupAdm,
      this.user_responsavel,
      this.grupo,
      this.endereco,
      this.documentos,
      this.carros,
      this.telefone,
      this.atende_fds,
      this.atende_festa,
      this.conta_bancaria,
        this.nome_conta,
        this.cpf_conta,
      this.isEmailVerified,
      this.foto}) {
    if (this.data_nascimento != null) {
      DateTime hoje = DateTime.now();
      isAniversario = hoje.day == this.data_nascimento.day &&
          hoje.month == this.data_nascimento.month;
    }
    if (this.atende_fds == null) {
      this.atende_fds = false;
    }
    if (this.atende_festa == null) {
      this.atende_festa = false;
    }
    if (this.manha == null) {
      this.manha = false;
    }
    if (this.tarde == null) {
      this.tarde = false;
    }
    if (this.noite == null) {
      this.noite = false;
    }
  }

  User.fromJson(j) {
    this.id = j['id'] == null ? null : j['id'];
    this.saldo = j['saldo'] == null ? null : j['id'];
    this.tipo_conta = j['tipo_conta'] == null ? null : j['tipo_conta'];
    this.kmmin = j['kmmin'] == null ? null : j['kmmin'];
    this.kmmax = j['kmmax'] == null ? null : j['kmmax'];
    this.telefone = j['telefone'] == null ? null : j['telefone'];
    this.conta_bancaria =
        j['conta_bancaria'] == null ? null : j['conta_bancaria'];
    this.atende_fds = j['atende_fds'] == null ? false : j['atende_fds'];
    this.atende_festa = j['atende_festa'] == null ? false : j['atende_festa'];
    carros = j['carros'] == null ? null : getCarros(json.decode(j['carros']));
    this.nome = j['nome'] == null ? null : j['nome'];
    this.agencia = j['agencia'] == null ? null : j['agencia'];
    this.numero_conta = j['numero_conta'] == null ? null : j['numero_conta'];
    this.isEmpresario = j['isEmpresario'] == null ? false : j['isEmpresario'];
    this.manha = j['manha'] == null ? false : j['manha'];
    this.tarde = j['tarde'] == null ? false : j['tarde'];
    this.noite = j['noite'] == null ? false : j['noite'];
    this.data_nascimento = j['data_nascimento'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['data_nascimento']);
    this.user_responsavel =
        j['user_responsavel'] == null ? null : j['user_responsavel'];
    this.celular = j['celular'] == null ? null : j['celular'];
    this.cpf = j['cpf'] == null ? null : j['cpf'];
    this.email = j['email'] == null ? null : j['email'];
    this.senha = j['senha'] == null ? null : j['senha'];
    this.strike = j['strike'] == null ? null : j['strike'];
    this.antecendete_verificados_em = j['antecendete_verificados_em'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['antecendete_verificados_em']);
    this.identidade = j['identidade'] == null ? null : j['identidade'];
    this.responsavel = j['responsavel'] == null ? null : j['responsavel'];
    this.antecedentes = j['antecedentes'] == null ? null : j['antecedentes'];
    this.nome_conta = j['nome_conta'] == null? this.nome:j['nome_conta'];
    this.cpf_conta = j['cpf_conta'] == null? this.cpf:j['cpf_conta'];
    this.documentos = j['documentos'] == null
        ? null
        : getDocumentos(json.decode(j['documentos']));
    this.cartoes =
        /*(j['cartoes'] as List) != null
        ? (j['cartoes'] as List).map((i) => Cartao.fromJson(i)).toList()
        : */
        null;
    this.identidade_expedidor =
        j['identidade_expedidor'] == null ? null : j['identidade_expedidor'];
    this.identidade_data_expedicao = j['identidade_data_expedicao'] == null
        ? null
        : DateTime.parse(j['identidade_data_expedicao']);
    this.permissao = j['permissao'] == null ? null : j['permissao'];
    this.created_at = j['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['created_at']);
    this.updated_at = j['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['updated_at']);
    this.deleted_at = j['deleted_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']);
    this.remember_token =
        j['remember_token'] == null ? null : j['remember_token'];
    this.isAdm = j['isAdm'] == null ? false : j['isAdm'];
    this.isEmailVerified =
        j['isEmailVerified'] == null ? null : j['isEmailVerified'];
    this.tipo = j['tipo'] == null ? null : j['tipo'];
    this.genero = j['genero'] == null ? null : j['genero'];
    this.isPrestador = j['isPrestador'] == null ? null : j['isPrestador'];
    this.prestador = j['prestador'] == null ? null : j['prestador'];
    this.isAlowed = j['isAlowed'] == null ? null : j['isAlowed'];
    this.endereco =
        j['endereco'] == null ? null : Endereco.fromJson(j['endereco']);
    this.foto = j['foto'] == null ? null : j['foto'];
    this.grupo = j['grupo'] == null ? '' : j['grupo'];

    if (data_nascimento != null) {
      DateTime hoje = DateTime.now();
      isAniversario = hoje.day == this.data_nascimento.day &&
          hoje.month == this.data_nascimento.month;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carros'] = this.carros == null ? null : json.encode(this.carros);
    data['id'] = this.id;
    data['telefone'] = this.telefone;
    data['tipo_conta'] = this.tipo_conta;
    data['kmmin'] = this.kmmin;
    data['kmmax'] = this.kmmax;
    data['saldo'] = this.saldo;
    data['nome'] = this.nome;
    data['numero_conta'] = this.numero_conta;
    data['agencia'] = this.agencia;
    data['atende_festa'] =
        this.atende_festa == null ? false : this.atende_festa;
    data['atende_fds'] = this.atende_fds == null ? false : this.atende_fds;
    data['manha'] = this.manha == null ? false : this.manha;
    data['tarde'] = this.tarde == null ? false : this.tarde;
    data['noite'] = this.noite == null ? false : this.noite;

    data['conta_bancaria'] = this.conta_bancaria;
    data['isEmailVerified'] = this.isEmailVerified;
    data['data_nascimento'] = this.data_nascimento != null
        ? this.data_nascimento.millisecondsSinceEpoch
        : null;
    data['celular'] = this.celular;
    data['user_responsavel'] =
        this.user_responsavel == null ? null : this.user_responsavel;
    data['cpf'] = this.cpf;
    data['isEmpresario'] =
        this.isEmpresario == null ? false : this.isEmpresario;
    data['email'] = this.email;
    data['antecedentes'] = this.antecedentes;
    data['senha'] = this.senha;
    data['permissao'] = this.permissao;
    data['grupo'] = this.grupo == null ? '' : this.grupo;
    data['antecendete_verificados_em'] = this.antecendete_verificados_em != null
        ? this.antecendete_verificados_em.millisecondsSinceEpoch
        : null;
    data['created_at'] =
        this.created_at != null ? this.created_at.millisecondsSinceEpoch : null;
    data['updated_at'] =
        this.updated_at != null ? this.updated_at.millisecondsSinceEpoch : null;
    data['deleted_at'] =
        this.deleted_at != null ? this.deleted_at.millisecondsSinceEpoch : null;
    data['remember_token'] = this.remember_token;
    data['isEmailVerified'] = this.isEmailVerified;
    data['responsavel'] = this.responsavel;
    data['tipo'] = this.tipo;
    data['genero'] = this.genero;
    data['documentos'] =
        this.documentos == null ? null : json.encode(this.documentos);
    data['isPrestador'] = this.isPrestador;
    data['prestador'] = this.prestador;

    data['nome_conta'] = this.nome_conta;
    data['cpf_conta'] = this.cpf_conta;
    data['foto'] = this.foto;
    data['cartoes'] = this.cartoes != null
        ? this.cartoes.map((i) => i.toJson()).toList()
        : null;
    data['isAlowed'] = this.isAlowed;
    data['isAdm'] = this.isAdm == null ? false : this.isAdm;
    data['endereco'] = this.endereco == null ? null : this.endereco.toJson();

    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, nome: $nome, data_nascimento: $data_nascimento, celular: $celular, cpf: $cpf, isGroupAdm: $isGroupAdm, email: $email, responsavel: $responsavel, senha: $senha, user_responsavel: $user_responsavel, strike: $strike, saldo: $saldo, identidade: $identidade, identidade_expedidor: $identidade_expedidor, identidade_data_expedicao: $identidade_data_expedicao, permissao: $permissao, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, cartoes: $cartoes, antecedentes: $antecedentes, antecendete_verificados_em: $antecendete_verificados_em, remember_token: $remember_token, genero: $genero, isPrestador: $isPrestador, isEmailVerified: $isEmailVerified, isEmpresario: $isEmpresario, manha: $manha, tarde: $tarde, noite: $noite, prestador: $prestador, tipo: $tipo, isAdm: $isAdm, foto: $foto, isAlowed: $isAlowed, endereco: $endereco, isAniversario: $isAniversario, grupo: $grupo, tipo_conta: $tipo_conta, kmmin: $kmmin, kmmax: $kmmax, conta_bancaria: $conta_bancaria, carros: $carros, telefone: $telefone, agencia: $agencia, numero_conta: $numero_conta, isBanido: $isBanido, atende_festa: $atende_festa, atende_fds: $atende_fds, documentos: $documentos, example: $example}';
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

  void Contatar(context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: Text('Conversar por'),
          actions: <Widget>[
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  Icon(
                    MdiIcons.whatsapp,
                    color: corPrimaria,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('WhatsApp'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              onPressed: () {
                whatsAppOpen(this
                    .celular
                    .replaceAll('(', '')
                    .replaceAll(')', '')
                    .replaceAll('-', '')
                    .replaceAll(' ', ''));
                Navigator.of(dialogContext).pop(); // Dismiss alert
              },
            ),
            CupertinoButton(
              child: Row(children: <Widget>[
                Icon(
                  MdiIcons.cellphone,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Telefone',
                  style: TextStyle(color: Colors.blue),
                ),
              ], mainAxisAlignment: MainAxisAlignment.center),
              onPressed: () {
                launch(
                    "tel://${this.celular.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '')}");
                Navigator.of(dialogContext).pop(); // Dismiss alert
              },
            ),
            CupertinoButton(
              child: Row(children: <Widget>[
                Icon(
                  MdiIcons.cancel,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ], mainAxisAlignment: MainAxisAlignment.center),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert
              },
            ),
          ],
        );
      },
    );
  }

  void whatsAppOpen(telefone) async {
    //print('ENTROU AQUI');
    var whatsappUrl = "whatsapp://send?phone=55${telefone}&text=Ola";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  MailTo() async {
    var url = 'mailto:${this.email}?subject=&body=';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static getDocumentos(decoded) {
    print('AQUI DECODED ${decoded}');
    List<Documento> talentos = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      talentos.add(Documento.fromJson(i));
    }
    return talentos;
  }
}

UserWidget(User user, context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: user.foto != null
              ? CachedNetworkImageProvider(user.foto)
              : AssetImage('assets/images/customer.jpg'),
          minRadius: 25,
          maxRadius: 50,
        ),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              user.nome.length > 15
                  ? user.nome.substring(0, 15) + '...'
                  : user.nome,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Icon(
                  user.genero == 'Masculino'
                      ? MdiIcons.genderMale
                      : MdiIcons.genderFemale,
                  color: user.genero == 'Masculino'
                      ? Colors.blueAccent
                      : Colors.pink,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(user.genero),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${(((DateTime.now().difference(user.data_nascimento).inDays) / 365) - 1).toStringAsFixed(0)} Anos',
                  style: TextStyle(),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                user.Contatar(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: corPrimaria,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${user.celular}',
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                user.MailTo();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    user.email,
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
