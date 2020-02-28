import 'dart:convert';

import 'package:autooh/Objetos/Prestador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:autooh/Objetos/Cartao.dart';
import 'package:autooh/Objetos/Pacote.dart';
import 'package:autooh/Objetos/ProdutoPedido.dart';

import 'Cielo/flutter_cielo.dart';
import 'Cielo/src/Subordinate.dart';
import 'Helper.dart';
import 'References.dart';

Future<String> getIp() {
  return http.get('https://www.google.com').then((value) {
    return json.decode(value.body)['origin'].toString();
  }).catchError((error) => print(error));
}

class CieloController {
  final transacoesRef = Firestore.instance.collection('Transacoes').reference();
  String merchantId = "7b93c7a4-465a-40ef-b33b-b5fc5e4087e7";
  String merchantKey = "OFICWPDTEHGIZRADHLDQURMWRUJBOHCEGAPLYQFB";

  String ProductionClientId = 'f417edfc-f1cd-49b5-b326-09115844e034';
  String ProductionClientSecret =
      'USAFYl7mbacs5I/9dACAZlz9JXInrv3BjuXlHa9ZoQA=';

  String functionalMerchantId = '10d99647-54da-48cf-acce-f15c2d5ffa1e';
  String OtherMerchantKey = "IFEYGLEVXXBTNOYXIQJEPYNWAKJMQUMOQDHDIDEG";
  String clientSecret = 'yA2cEY6Zgs5Ux6B5qH7W5D+2cdn7bSEANswE2ct4YVo=';
  String OtherMerchantId = "2b0c5f21-f56f-4909-bf08-5ee68f3ae5c5";

  String ProductionMerchantId = " bd42d8ba-8462-4fe2-907b-286427c31fef";
  String ProductionMerchantKey = "haGf1RSXlfV39vlUecd29NC9ocmG0G7cRsmCalMU";
  String braspagTestClientId = '79db5023-a318-45dc-bc2f-010210ff8145';
  String braspagTestClienstSecret =
      'QNA6Mr7owxiY5k1Z14A84QrQISQOTDzmisBFxQI3UNU=';
  String braspagTesteSubordinado1 = 'c066ed76-3d95-428c-8bb8-454c6a638bfb';
  String braspagTesteSubordiando2 = 'cf7435e3-3f77-4268-bc1a-f2fbba44abe7';

  String testMerchantId = '3835fa75-1020-457c-a811-c883a75e7ec4';
  String testMerchantKey = 'XNDFRVDJDULOCSIHHPHBIVYYTORYVCIRCOGLAFYT';
/*
  Future<Payment> EfetuarPagamento(
      Assinatura plano, Cartao c, bool isBoleto, Prestador prestador) async {
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionMerchantKey,
            clientSecret: clientSecret));
    //TODO Alterar para ESSA QUANDO LANÇAR
    /*CieloEcommerce(
          environment: Environment.PRODUCTION, // ambiente de desenvolvimento
          merchant: Merchant(
            merchantId: "05a5f5dc-626c-4201-9ff3-a397cacd1ada",
            merchantKey: "EBFGSQDGLWITJECPLXXNYGXFVUZECFDQPMHPDTQY",
          ));*/

    //Objeto de venda

    DateTime dataFim = DateTime.utc(
        plano.referencia.contains('Mensal')
            ? DateTime.now().year + 1
            : DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day);
    String EndDate =
        '${dataFim.year}-${dataFim.month.toString().length == 1 ? '0' + dataFim.month.toString() : dataFim.month.toString()}-${dataFim.day.toString().length == 1 ? '0' + dataFim.day.toString() : dataFim.day.toString()}';

    print('${EndDate}');
    RecurrentPayment rc = RecurrentPayment(
        AuthorizeNow: true,
        Interval: plano.referencia.contains('Mensal')
            ? RecurrentPayment.Monthly
            : RecurrentPayment.Anual,
        EndDate: EndDate);
    print(rc.toString());
    Sale sale;
    if (!isBoleto) {
      print(
          'DATA >>>>>>>>> ${c.expiration_month.toString().length == 1 ? '0' + c.expiration_month.toString() : c.expiration_month.toString()}/${c.expiration_year}');

      String CardNumber = c.number.replaceAll(' ', '');
      if (c.tipo == 'Credito') {
        sale = Sale(
            MerchantOrderId: DateTime.now()
                .millisecondsSinceEpoch
                .toString(), // id único de sua venda
            customer: Customer(
                address: Address(
                    city: prestador.endereco.cidade,
                    number: prestador.endereco.numero,
                    complement: prestador.endereco.complemento == null
                        ? ""
                        : prestador.endereco.complemento,
                    country: 'BR',
                    district: prestador.endereco.bairro,
                    state: prestador.endereco.estado,
                    street: prestador.endereco.endereco,
                    zipCode: prestador.endereco.cep),
                //objeto de dados do usuário
                name: c.owner),
            payment: Payment(
                currency: "BRL",
                country: "BRA",

                // objeto para de pagamento
                type: TypePayment.creditCard, //tipo de pagamento
                softDescriptor: plano.referencia
                    .replaceAll('Assinatura', 'A')
                    .replaceAll('Mensal', 'M')
                    .replaceAll('Anual', 'A')
                    .replaceAll('Especial', 'E')
                    .replaceAll('Presidente', 'P'),
                amount: plano.preco.toString(), // valor da compra em centavos
                installments: '1', // número de parcelas
                recurrentPayment:
                    rc, //descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
                creditCard: {
                  "CardNumber": c.number.replaceAll(' ', ''),
                  "Holder": c.owner,
                  "ExpirationDate":
                      '${c.expiration_month.toString().length == 1 ? '0' + c.expiration_month.toString() : c.expiration_month.toString()}/${c.expiration_year}', // data de expiração,
                  "SaveCard": false,
                  "Brand": c.marca,
                  //"SecurityCode":c.cvc,
                  "CardOnFile": {"Usage": "Used", "Reason": "Unscheduled"}
                }));
      } else if (c.tipo == 'Debito') {
        print(
            'DATA DE VENCIMENTO ${'${c.expiration_month.toString().length == 1 ? '0' + c.expiration_month.toString() : c.expiration_month.toString()}/${c.expiration_year}'}');
        sale = Sale(
            MerchantOrderId: "1242132343", // id único de sua venda
            customer: Customer(
                identity: '1234567',
                address: Address(
                    city: prestador.endereco.cidade,
                    number: prestador.endereco.numero,
                    complement: prestador.endereco.complemento == null
                        ? ""
                        : prestador.endereco.complemento,
                    country: 'BR',
                    district: prestador.endereco.bairro,
                    state: prestador.endereco.estado,
                    street: prestador.endereco.endereco,
                    zipCode: prestador.endereco.cep),
                //objeto de dados do usuário
                name: c.owner),
            payment: Payment(
                authenticate: false,
                // objeto para de pagamento
                type: TypePayment.debitCard, //tipo de pagamento
                amount: plano.preco
                    .toString(), // valor da compra em centavos//descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
                returnCode: '1',
                installments: '1', // número de parcelas
                recurrentPayment: rc,
                ReturnUrl: 'http://www.google.com',
                IsCryptoCurrencyNegotiation: false,
                debitCard: DebitCard(
                    //objeto de Cartão de crédito
                    CardNumber: c.number.replaceAll(' ', ''), //número do cartão
                    Holder: c.owner, //nome do usuário impresso no cartão
                    ExpirationDate:
                        '${c.expiration_month.toString().length == 1 ? '0' + c.expiration_month.toString() : c.expiration_month.toString()}/${c.expiration_year}', // data de expiração// código de segurança
                    Brand: c.marca, // bandeira
                    SaveCard: false,
                    SecurityCode: c.cvc.toString().length == 2
                        ? '0' + c.cvc.toString()
                        : c.cvc.toString())));
      }
    } else {
      sale = Sale(
          MerchantOrderId: "1242132343", // id único de sua venda
          customer: Customer(
              identity: '1234567',
              address: Address(
                  city: prestador.endereco.cidade,
                  number: prestador.endereco.numero,
                  complement: prestador.endereco.complemento == null
                      ? ""
                      : prestador.endereco.complemento,
                  country: 'BR',
                  district: prestador.endereco.bairro,
                  state: prestador.endereco.estado,
                  street: prestador.endereco.endereco,
                  zipCode: prestador.endereco.cep),
              //objeto de dados do usuário
              name: Helper.localUser.nome),
          payment: Payment(
            authenticate: false,
            // objeto para de pagamento
            type: TypePayment.boleto, //tipo de pagamento
            amount: plano.preco
                .toString(), // valor da compra em centavos//descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
            returnCode: '1',
            provider:
                "SIMULADO", //TODO ALTERAR PARA Banco do Brasil ou Bradesco
            boletoNumber: '1234',
            assignor: 'autooh',
            demonstrative: 'Demonstrativo',
            instructions:
                "Aceitar somente até a data de vencimento, após essa data juros de 1% dia.",
            expirationDate:
                '${DateTime.now().add(Duration(days: 10)).year}-${DateTime.now().add(Duration(days: 10)).month}-${DateTime.now().add(Duration(days: 10)).day}',
          ));
    }
    CreditCard card = CreditCard(
      //objeto de Cartão de crédito
      cardNumber: c.number.replaceAll(' ', ''), //número do cartão
      holder: c.owner, //nome do usuário impresso no cartão
      customerName: c.owner,
      expirationDate:
          '${c.expiration_month.toString().length == 1 ? '0' + c.expiration_month.toString() : c.expiration_month.toString()}/${c.expiration_year}', // data de expiração
      securityCode: c.cvc.toString().length == 2
          ? '0' + c.cvc.toString()
          : c.cvc.toString(), // código de segurança
      brand: c.marca, // bandeira
    );

    //Share.text('', card.toString(), 'text/plain');
    print('AQUI CARTAO DE CREDITO ${card.toString()}');
    return cielo.createSale(sale).then((response) {
      print('Reponse AQUI ${response.toString()}');
      if (response != null) {
        return transacoesRef.add({
          'User': Helper.localUser.id,
          'Cartao':c.number.replaceAll(' ', ''),
          'Venda': response.toJson(),
          'Plano': plano.toJson(),
          'Data': DateTime.now().millisecondsSinceEpoch,
          'prestador': Helper.localAdm.estabelecimentos[Helper.selectedCoach],
        }).then((transacao) {
          print(
              "TRANSACAO --------------------------------------------------------------------------");
          print(transacao.documentID);
          return response.payment;
        }).catchError((err) {
          print('ERRO AO SALVAR TRANSACAO: ${err.toString()}');
        });
      } else {
        print('ERRO NA TRANSAÇÂO');
      }
    });
  }*/

  Future CadastrarSubordinado(Subordinate s, Prestador prestador) {
    print('Aqui prestador' + prestador.toString());
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionClientId,
            clientSecret: ProductionClientSecret));
    return cielo.createSubordinate(s).then((v) {
      if (v != null) {
        return vendedoresRef
            .document(prestador.numero)
            .setData(v.toJson())
            .then((d) {
          return prestadorRef.document(prestador.numero).get().then((r) {
            Prestador c = Prestador.fromJson(r.data);
            c.isMerchant = true;
            print('prestador ${c.toString()}');
            return prestadorRef.document(c.numero).setData(c.toJson()).then((x) {
              print('Vendedor cadastrado com sucesso!');
              return v;
            }).catchError((err) {
              Err(err, 'Cadastrar Subordinado');
              dToast(
                  'Verifique os campos preenchidos e tente novamente mais tarde.: ${err.toString()}');
              return null;
            });
          }).catchError((err) {
            Err(err, 'Cadastrar Subordinado');
            dToast(
                'Verifique os campos preenchidos e tente novamente mais tarde. ${err.toString()}');
            return null;
          });
        }).catchError((err) {
          Err(err, 'Cadastrar Subordinado');
          dToast(
              'Verifique os campos preenchidos e tente novamente mais tarde. ${err.toString()}');
          return null;
        });
      } else {
        return v;
      }
    }).catchError((err) {
      Err(err, 'Cadastrar Subordinado');
      dToast('Erro ao cadastrar: ${err.toString()}');
      return null;
    });
  }

  Future ComprarProdutos(Subordinate s, List<ProdutoPedido> ppl, Cartao c,
      String merchantOrderId) async {
    String ipAddress = await getIp();
    print('IP ${ipAddress}');
    int total = 0;
    List itens = new List();
    for (ProdutoPedido pp in ppl) {
      total += (pp.preco_final * 100).toInt();
      itens.add({
        "GiftCategory": "Undefined",
        "HostHedge": "Off",
        "NonSensicalHedge": "Off",
        "ObscenitiesHedge": "Off",
        "PhoneHedge": "Off",
        "Name": pp.produto,
        "Quantity": pp.quantidade,
        "Sku": pp.id,
        "UnitPrice": pp.preco_unitario,
        "Risk": "High",
        "TimeHedge": "Normal",
        "Type": "Default ",
        "VelocityHedge": "High",
      });
    }
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionClientId,
            clientSecret: ProductionClientSecret));
    Customer customer = new Customer(
        name: Helper.localUser.nome,
        address: Address(
            country: 'BR',
            zipCode: Helper.localUser.endereco.cep,
            street: Helper.localUser.endereco.endereco,
            state: Helper.localUser.endereco.estado,
            district: Helper.localUser.endereco.bairro,
            complement: Helper.localUser.endereco.complemento,
            number: Helper.localUser.endereco.numero,
            city: Helper.localUser.endereco.cidade),
        identity: Helper.localUser.cpf);
    var jsale = {
      "MerchantOrderId": merchantOrderId,
      "Customer": {
        "Name": Helper.localUser.nome,
        "Identity": "08366894967",
        "IdentityType": "CPF",
        "Email": Helper.localUser.email,
        //"Birthdate":
        // "${Helper.localUser.data_nascimento.year}-${Helper.localUser.data_nascimento.month}-${Helper.localUser.data_nascimento.day}",
        "Mobile": Helper.localUser.celular
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '')
            .replaceAll('-', ''),
        "Phone": Helper.localUser.celular
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '')
            .replaceAll('-', ''),
        "Address": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
        "DeliveryAddress": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
        "BillingAddress": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
      },
      "Payment": {
        "Type": c.tipo == 'Debito' ? 'DebitCard' : 'CreditCard',
        "Amount": total,
        "Currency": "BRL",
        "Country": "BRA",
        "ServiceTaxAmount": 0,
        "Installments": 1,
        "Interest": "ByMerchant",
        "Capture": true,
        "Authenticate": false,
        "SoftDescriptor": DateTime.now().millisecondsSinceEpoch,
        "CreditCard": {
          "CardNumber": c.number.replaceAll(' ', ''),
          "Holder": c.owner,
          "ExpirationDate":
              '${c.expiration_month.toString().length == 1 ? '0' + c.expiration_month.toString() : c.expiration_month.toString()}/${c.expiration_year}',
          "SecurityCode": c.cvc.toString().length == 2
              ? '0' + c.cvc.toString()
              : c.cvc.toString(),
          "Brand": c.marca,
          "SaveCard": "false"
        },
        "FraudAnalysis": {
          "Provider": "cybersource",
          "Sequence": "AuthorizeFirst",
          "SequenceCriteria": "OnSuccess",
          "CaptureOnLowRisk": true,
          "VoidOnHighRisk": false,
          "TotalOrderAmount": total,
          "Browser": {
            "CookiesAccepted": false,
            "Email": Helper.localUser.email,
            "HostName": "autooh",
            "IpAddress": ipAddress,
            "Type": "Chrome"
          },
          "Cart": {"IsGift": false, "ReturnsAccepted": true, "Items": itens},
          "MerchantDefinedFields": [
            {"Id": 89, "Value": "ID DO VENDEDOR"}
          ],
          "Shipping": {
            "Addressee": Helper.localUser.nome,
            "Method": "LowCost",
            "Phone": Helper.localUser.celular
          },
        },
        "SplitPayments": [
          {
            "SubordinateMerchantId": functionalMerchantId,
            "Amount": (total * .008).toInt().toString(),
            "Fares": {"Mdr": 5, "Fee": 0}
          },
          {
            "SubordinateMerchantId": s.subordinateMeta.MerchantId,
            "Amount": (total * .992).toInt().toString(),
            "Fares": {"Mdr": 5, "Fee": 0}
          }
        ]
      }
    };
    return cielo.createSubordinateSale(jsale).then((v) {
      print('CHEGOU AQUI ${v}');
      return v;
    });
  }

  checkPlano(Map<String, dynamic> data) {
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionMerchantKey,
            clientSecret: clientSecret));

    return cielo.checkSaleFromJson(data['Venda']).then((v) {
      print('VALUE ${v}');
      print('PAYMENT ${json.decode(v)['Payment']}');
      print('DATA RECEBIDA ${json.decode(v)['Payment']['ReceivedDate']}');
      DateTime dataCielo =
          DateTime.parse(json.decode(v)['Payment']['ReceivedDate']);
      DateTime dataServidor = DateTime.fromMillisecondsSinceEpoch(data['Data']);
      if (dataCielo.day == dataServidor.day &&
          dataCielo.month == dataServidor.month &&
          dataCielo.year == dataServidor.year) {
        print('PAGAMENTO Atrasado');
        dToast(
            'Seu pagamento não foi detectado, por favor verifique assim que possivel');
        return null;
      } else {
        return transacoesRef.add({
          'User': Helper.localUser.id,
          'Venda': json.decode(v),
          'Plano': data['Plano'],
          'Data': DateTime.now().millisecondsSinceEpoch,
          'Prestador': Helper.localUser.prestador,
        }).then((transacao) {
          print(
              "TRANSACAO --------------------------------------------------------------------------");
          print(transacao.documentID);
          return transacao.documentID;
        }).catchError((err) {
          print('ERRO AO SALVAR TRANSACAO: ${err.toString()}');
        });
      }
    }).catchError((err) {
      print('ERRO: ${err.toString()}');
    });
  }

  Future reactivate(pagamento) {
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionMerchantKey,
            clientSecret: clientSecret));

    print('Efetuar Pagamento ${pagamento['Venda']['Payment'].toString()}');
    return cielo.reactivate(pagamento['Venda']).then((v) {
      return checkPlano(pagamento);
    });
  }

  Future ComprarProdutosBraspagTeste(Subordinate s, List<ProdutoPedido> ppl,
      Cartao c, String merchantOrderId) async {
    String ipAddress = await getIp();
    int total = 0;
    print('AQUI CARTÃO ${c.number}');
    List itens = new List();
    for (ProdutoPedido pp in ppl) {
      total += (pp.preco_final * 100).toInt();
      itens.add({
        "GiftCategory": "Undefined",
        "HostHedge": "Off",
        "NonSensicalHedge": "Off",
        "ObscenitiesHedge": "Off",
        "PhoneHedge": "Off",
        "Name": pp.produto,
        "Quantity": pp.quantidade,
        "Sku": pp.id,
        "UnitPrice": pp.preco_unitario,
        "Risk": "High",
        "TimeHedge": "Normal",
        "Type": "Default ",
        "VelocityHedge": "High",
      });
    }
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.SANDBOX, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: braspagTestClientId,
            merchantKey: OtherMerchantKey,
            clientSecret: braspagTestClienstSecret));

    var jsale = {
      "MerchantOrderId": merchantOrderId,
      "Customer": {
        "Name": Helper.localUser.nome + ' Accept',
        "Identity": "08366894967",
        "IdentityType": "CPF",
        "Email": Helper.localUser.email,
        //"Birthdate":
        // "${Helper.localUser.data_nascimento.year}-${Helper.localUser.data_nascimento.month}-${Helper.localUser.data_nascimento.day}",
        "Mobile": Helper.localUser.celular
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '')
            .replaceAll('-', ''),
        "Phone": Helper.localUser.celular
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '')
            .replaceAll('-', ''),
        "Address": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
        "DeliveryAddress": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
        "BillingAddress": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
      },
      "Payment": {
        "Type": c.tipo == 'Debito' ? 'SplittedDebitCard' : 'splittedcreditcard',
        "Amount": total,
        "Currency": "BRL",
        "Country": "BRA",
        "ServiceTaxAmount": 0,
        "Installments": 1,
        "Interest": "ByMerchant",
        "Capture": true,
        "Authenticate": false,
        "SoftDescriptor": 'autooh',
        "CreditCard": {
          "CardNumber": c.number.replaceAll(' ', ''),
          "Holder": c.owner,
          "ExpirationDate": "${c.expiration_month}/${c.expiration_year}",
          "SecurityCode": c.cvc.toString().length == 2
              ? '0' + c.cvc.toString()
              : c.cvc.toString(),
          "Brand": c.marca, //TODO usar a  Marca
          "SaveCard": "false"
        },
        "FraudAnalysis": {
          "Provider": "cybersource",
          "Sequence": "AuthorizeFirst",
          "SequenceCriteria": "OnSuccess",
          "CaptureOnLowRisk": true,
          "VoidOnHighRisk": false,
          "TotalOrderAmount": total,
          "Browser": {
            "CookiesAccepted": false,
            "Email": Helper.localUser.email,
            "HostName": "autooh",
            "IpAddress": ipAddress,
            "Type": "Chrome"
          },
          "Cart": {"IsGift": false, "ReturnsAccepted": true, "Items": itens},
          "MerchantDefinedFields": [
            {"Id": 89, "Value": "ID DO VENDEDOR"}
          ],
          "Shipping": {
            "Addressee": Helper.localUser.nome,
            "Method": "LowCost",
            "Phone": Helper.localUser.celular
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll(' ', '')
                .replaceAll('-', ''),
          },
        },
        "SplitPayments": [
          {
            "SubordinateMerchantId": braspagTesteSubordinado1,
            "Amount": (total * .008).toInt().toString(),
            "Fares": {"Mdr": 5, "Fee": 0}
          },
          {
            "SubordinateMerchantId": braspagTesteSubordiando2,
            "Amount": (total * .992).toInt().toString(),
            "Fares": {"Mdr": 5, "Fee": 0}
          }
        ]
      }
    };

    /*Share.text(
        '',
        {
          "CreditCard": {
            "CardNumber": c.number,
            "Holder": c.owner,
            "ExpirationDate": "${c.expiration_month}/${c.expiration_year}",
            "SecurityCode": c.cvc.toString(),
            "Brand": c.marca,
            "SaveCard": "false"
          },
        }.toString(),
        'text/plain');*/
    return cielo.createSubordinateSale(jsale).then((v) {
      print('CHEGOU AQUI ${v}');
    });
  }

  void CancelarPedido(String paymentId) {
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionClientId,
            clientSecret: ProductionClientSecret));

    cielo.cancelSubordinateSale(paymentId);
  }

  void CancelarPedidoBraspagTeste(String paymentId) {
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.SANDBOX, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: braspagTestClientId,
            merchantKey: OtherMerchantKey,
            clientSecret: braspagTestClienstSecret));

    cielo.cancelSubordinateSale(paymentId);
  }

  Future ComprarPacote(
      Subordinate s, Pacote pacote, Cartao c, String merchantOrderId) async {
    String ipAddress = await getIp();
    print('IP ${ipAddress}');
    int total = 0;
    List itens = new List();
    total += pacote.valor;
    itens.add({
      "GiftCategory": "Undefined",
      "HostHedge": "Off",
      "NonSensicalHedge": "Off",
      "ObscenitiesHedge": "Off",
      "PhoneHedge": "Off",
      "Name": pacote.titulo,
      "Quantity": 1,
      "Sku": pacote.id,
      "UnitPrice": pacote.valor,
      "Risk": "High",
      "TimeHedge": "Normal",
      "Type": "Default ",
      "VelocityHedge": "High",
    });
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionClientId,
            clientSecret: ProductionClientSecret));
    Customer customer = new Customer(
        name: Helper.localUser.nome,
        address: Address(
            country: 'BR',
            zipCode: Helper.localUser.endereco.cep,
            street: Helper.localUser.endereco.endereco,
            state: Helper.localUser.endereco.estado,
            district: Helper.localUser.endereco.bairro,
            complement: Helper.localUser.endereco.complemento,
            number: Helper.localUser.endereco.numero,
            city: Helper.localUser.endereco.cidade),
        identity: Helper.localUser.cpf);
    var jsale = {
      "MerchantOrderId": merchantOrderId,
      "Customer": {
        "Name": Helper.localUser.nome,
        "Identity": "08366894967",
        "IdentityType": "CPF",
        "Email": Helper.localUser.email,
        //"Birthdate":
        // "${Helper.localUser.data_nascimento.year}-${Helper.localUser.data_nascimento.month}-${Helper.localUser.data_nascimento.day}",
        "Mobile": Helper.localUser.celular
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '')
            .replaceAll('-', ''),
        "Phone": Helper.localUser.celular
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '')
            .replaceAll('-', ''),
        "Address": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
        "DeliveryAddress": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
        "BillingAddress": {
          "Street": Helper.localUser.endereco.endereco,
          "Number": Helper.localUser.endereco.numero,
          "Complement": Helper.localUser.endereco.complemento,
          "ZipCode": Helper.localUser.endereco.cep,
          "City": Helper.localUser.endereco.cidade,
          "State": Helper.localUser.endereco.estado,
          "Country": "BR",
          "District": Helper.localUser.endereco.bairro
        },
      },
      "Payment": {
        "Type": c.tipo == 'Debito' ? 'DebitCard' : 'CreditCard',
        "Amount": total,
        "Currency": "BRL",
        "Country": "BRA",
        "ServiceTaxAmount": 0,
        "Installments": 1,
        "Interest": "ByMerchant",
        "Capture": true,
        "Authenticate": false,
        "SoftDescriptor": DateTime.now().millisecondsSinceEpoch,
        "CreditCard": {
          "CardNumber": c.number.replaceAll(' ', ''),
          "Holder": c.owner,
          "ExpirationDate": "${c.expiration_month}/${c.expiration_year}",
          "SecurityCode": c.cvc.toString().length == 2
              ? '0' + c.cvc.toString()
              : c.cvc.toString(),
          "Brand": c.marca,
          "SaveCard": "false"
        },
        "FraudAnalysis": {
          "Provider": "cybersource",
          "Sequence": "AuthorizeFirst",
          "SequenceCriteria": "OnSuccess",
          "CaptureOnLowRisk": true,
          "VoidOnHighRisk": false,
          "TotalOrderAmount": total,
          "Browser": {
            "CookiesAccepted": false,
            "Email": Helper.localUser.email,
            "HostName": "autooh",
            "IpAddress": ipAddress,
            "Type": "Chrome"
          },
          "Cart": {"IsGift": false, "ReturnsAccepted": true, "Items": itens},
          "MerchantDefinedFields": [
            {"Id": 89, "Value": "ID DO VENDEDOR"}
          ],
          "Shipping": {
            "Addressee": Helper.localUser.nome,
            "Method": "LowCost",
            "Phone": Helper.localUser.celular
          },
        },
        "SplitPayments": [
          {
            "SubordinateMerchantId": functionalMerchantId,
            "Amount": (total * .008).toInt().toString(),
            "Fares": {"Mdr": 5, "Fee": 0}
          },
          {
            "SubordinateMerchantId": s.subordinateMeta.MerchantId,
            "Amount": (total * .992).toInt().toString(),
            "Fares": {"Mdr": 5, "Fee": 0}
          }
        ]
      }
    };
    return cielo.createSubordinateSale(jsale).then((v) {
      print('CHEGOU AQUI ${v}');
      return v;
    });
  }

  Future<Subordinate> verificarSubordinado(Subordinate subordinate) {
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
            merchantId: ProductionMerchantId,
            merchantKey: ProductionClientId,
            clientSecret: ProductionClientSecret));
    return cielo.verificarSubordinate(subordinate).then((v) {
      return v;
    });
  }
}
