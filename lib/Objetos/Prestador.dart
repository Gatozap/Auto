import 'Endereco.dart';


//ESTABELECIMENTO
class Prestador {
  String numero;
  String usuario;
  String plano;
  String nome;
  String cpf;
  String logo;
  String email;
  String grupo;
  String telefone;
  Endereco endereco;
  bool isDemo;
  bool isHerbalife;
  bool isMerchant;
  DateTime last_payed_at;
  DateTime demo_expires_at;
  DateTime created_at, updated_at, deleted_at;
  String codigo;
  String cp;

  bool isEstoque;

  Prestador.Empty();

  @override
  String toString() {
    return 'prestador{isMerchant: $isMerchant, numero: $numero, usuario: $usuario, plano: $plano, nome_clinica: $nome, cpf: $cpf, logo: $logo, email: $email, telefone: $telefone, endereco: $endereco, isDemo: $isDemo, isHerbalife: $isHerbalife, last_payed_at: $last_payed_at, demo_expires_at: $demo_expires_at, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, codigo: $codigo}';
  }

  Prestador(
      {this.numero,
      this.usuario,
      this.plano,
      this.cp,
        this.grupo,
      this.last_payed_at,
      this.demo_expires_at,
      this.created_at,
      this.updated_at,
      this.nome,
      this.deleted_at,
      this.logo,
      this.isHerbalife,
      this.endereco,
      this.telefone,
      this.email,
      this.codigo,
      this.cpf,
      this.isMerchant,
      this.isEstoque,
      this.isDemo});

  factory Prestador.fromJson(json) {
    print("AQUI MONTANDO prestador ${json.toString()}");
    return Prestador(
      numero: json["numero"],
      usuario: json["usuario"],
      plano: json["plano"],
      grupo:json['grupo'] == null? 'nenhum': json['grupo'],
      cp: json['cp'] == null ? '' : json['cp'],
      nome: json['nome_clinica'] == null ? '' : json['nome_clinica'],
      cpf: json['cpf'] == null ? null : json['cpf'],
      codigo: json['codigo'] == null ? null : json['codigo'],
      isDemo: json['isDemo'] == null ? null : json['isDemo'],
      email: json['email'] == null ? null : json['email'],
      telefone: json['telefone'] == null ? null : json['telefone'],
      logo: json['logo'] == null ? null : json['logo'],
      isEstoque: json['isEstoque'] == null ? false : json['isEstoque'],
      isHerbalife: json['isHerbaLife'] == null ? false : json['isHerbaLife'],
      isMerchant: json['isMerchant'] == null ? false : json['isMerchant'],
      endereco:
          json['endereco'] == null ? null : Endereco.fromJson(json['endereco']),
      last_payed_at: json["last_payed_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["last_payed_at"]),
      demo_expires_at: json["demo_expires_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["demo_expires_at"]),
      created_at: json["created_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      updated_at: json["updated_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json["deleted_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "numero": this.numero == null ? null : this.numero,
      "usuario": this.usuario == null ? null : this.usuario,
      "plano": this.plano == null ? null : this.plano,
      'nome_clinica': this.nome == null ? null : this.nome,
      'cpf': this.cpf == null ? null : this.cpf,
      'isDemo': this.isDemo == null ? null : this.isDemo,
      'telefone': this.telefone == null ? null : this.telefone,
      'email': this.email == null ? null : this.email,
      'cp': this.cp == null ? '' : this.cp,
      'logo': this.logo == null ? null : this.logo,
      'grupo': this.grupo == null? 'nenhum': this.grupo,
      'codigo': this.codigo == null ? null : this.codigo,
      'endereco': this.endereco == null ? null : this.endereco.toJson(),
      'isMerchant': this.isMerchant == null ? false : this.isMerchant,
      'isEstoque': this.isEstoque == null ? false : this.isEstoque,
      "last_payed_at": this.last_payed_at == null
          ? null
          : this.last_payed_at.millisecondsSinceEpoch,
      'isHerbaLife': this.isHerbalife == null ? false : this.isHerbalife,
      "demo_expires_at": this.demo_expires_at == null
          ? null
          : this.demo_expires_at.millisecondsSinceEpoch,
      "created_at": this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at == null
          ? null
          : this.deleted_at.millisecondsSinceEpoch,
    };
  }


}
