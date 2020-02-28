import 'dart:convert';

import 'CreditCard.dart';
import 'DebitCard.dart';
import 'Link.dart';
import 'RecurrentPayment.dart';
import 'SplitPayment.dart';

class Payment {
  String type;
  String amount;
  String installments;
  String serviceTaxAmount;
  String status;
  String provider;
  String address;
  String boletoNumber;
  String assignor;
  String demonstrative;
  String expirationDate;
  String identification;
  String instructions;
  String softDescriptor;
  var creditCard;
  DebitCard debitCard;
  RecurrentPayment recurrentPayment;
  String url;
  String number;
  String barCodeNumber;
  String digitableLine;
  String paymentId;
  String currency;
  String country;
  bool IsCryptoCurrencyNegotiation;
  List<dynamic> extraDataCollection;

  List<Link> links;

  String interest;
  bool capture;
  bool authenticate;
  String proofOfSale;
  String tid;
  String authorizationCode;
  String returnCode;
  String returnMessage;
  String ReturnUrl;
  List<SplitPayment> splitPayments;

  Map<String, Object> FraudAnalysis;

  Payment(
      {this.type,
      this.amount,
      this.provider,
      this.address,
      this.boletoNumber,
      this.assignor,
      this.demonstrative,
      this.expirationDate,
      this.identification,
      this.instructions,
      this.installments,
      this.softDescriptor,
      this.creditCard,
      this.debitCard,
      this.url,
      this.ReturnUrl,
      this.number,
      this.barCodeNumber,
      this.digitableLine,
      this.paymentId,
      this.currency,
      this.country,
      this.extraDataCollection,
      this.status,
      this.links,
      this.serviceTaxAmount,
      this.interest,
      this.capture,
      this.authenticate,
      this.proofOfSale,
      this.tid,
      this.authorizationCode,
      this.returnCode,
      this.returnMessage,
      this.recurrentPayment,
      this.IsCryptoCurrencyNegotiation,
        this.FraudAnalysis,
      this.splitPayments});

  @override
  String toString() {
    return 'Payment{type: $type, installments: $installments, provider: $provider, '
        'assignor: $assignor, demonstrative: $demonstrative, '
        'expirationDate: $expirationDate, identification: '
        '$identification, instructions: $instructions, '
        'creditCard: ${creditCard.toString()},'
        ' barCodeNumber: $barCodeNumber, '
        'recurrentPayment: $recurrentPayment'
        'paymentId: $paymentId, currency: '
        '$currency, country: '
        '$country, extraDataCollection: '
        '$extraDataCollection, status: '
        'debitCard: $debitCard'
        'ReturnUrl: $ReturnUrl'
        '$status, interest: $interest, '
        'IsCryptoCurrencyNegotiation: $IsCryptoCurrencyNegotiation'
        'capture: $capture, authenticate:'
        ' $authenticate, proofOfSale: '
        '$proofOfSale, tid: $tid, returnCode: $returnCode, returnMessage: $returnMessage}';
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      type: json['Type'] == null ? null : json["Type"],
      amount: json['Amount'] == null ? null : json["Amount"].toString(),
      installments:
          json['Installments'] == null ? null : json["Installments"].toString(),
      provider: json['Provider'] == null ? null : json["Provider"],
      address: json['Address'] == null ? null : json["Address"],
      boletoNumber: json['BoletoNumber'] == null ? null : json["BoletoNumber"],
      assignor: json['Assignor'] == null ? null : json["Assignor"],
      demonstrative:
          json['Demonstrative'] == null ? null : json["Demonstrative"],
      expirationDate:
          json['ExpirationDate'] == null ? null : json["ExpirationDate"],
      identification:
          json['Identification'] == null ? null : json["Identification"],
      instructions: json['Instructions'] == null ? null : json["Instructions"],
      softDescriptor:
          json['SoftDescriptor'] == null ? null : json["SoftDescriptor"],
      creditCard: json['CreditCard'] == null
          ? null
          : json["CreditCard"],
      debitCard: json['DebitCard'] == null
          ? null
          : DebitCard.fromJson(json["DebitCard"]),
      recurrentPayment: json['RecurrentPayment'] == null
          ? null
          : RecurrentPayment.fromJson(json["RecurrentPayment"]),
      url: json['Url'] == null ? null : json["Url"],
      number: json['Number'] == null ? null : json["Number"],
      barCodeNumber:
          json['BarCodeNumber'] == null ? null : json["BarCodeNumber"],
      digitableLine:
          json['DigitableLine'] == null ? null : json["DigitableLine"],
      paymentId: json['PaymentId'] == null ? null : json["PaymentId"],
      currency: json['Currency'] == null ? null : json["Currency"],
      country: json['Country'] == null ? null : json["Country"],
      IsCryptoCurrencyNegotiation: json['IsCryptoCurrencyNegotiation'] == null
          ? null
          : json["IsCryptoCurrencyNegotiation"],
      extraDataCollection: json['ExtraDataCollection'] == null
          ? null
          : List.of(json["ExtraDataCollection"])
              .map((i) => i /* can't generate it properly yet */)
              .toList(),
      status: json['Status'] == null ? null : json["Status"].toString(),
      links: json['Links'] == null
          ? null
          : List.of(json["Links"])
              .map((i) => Link.fromJson(i) /* can't generate it properly yet */)
              .toList(),
      serviceTaxAmount: json['ServiceTaxAmount'] == null
          ? null
          : json["ServiceTaxAmount"].toString(),
      interest: json['Interest'] == null ? null : json["Interest"].toString(),
      capture: json['Capture'] == null ? null : json["Capture"],
      authenticate: json['Authenticate'] == null ? null : json["Authenticate"],
      proofOfSale: json['ProofOfSale'] == null ? null : json["ProofOfSale"],
      tid: json['Tid'] == null ? null : json["Tid"],
      authorizationCode:
          json['AuthorizationCode'] == null ? null : json["AuthorizationCode"],
      returnCode: json['ReturnCode'] == null ? null : json["ReturnCode"],
      returnMessage:
          json['ReturnMessage'] == null ? null : json["ReturnMessage"],
      ReturnUrl: json['ReturnUrl'] == null ? null : json["ReturnUrl"],
        FraudAnalysis: json['FraudAnalysis'] == null ? null : json['FraudAnalysis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Amount": this.amount == null ? null : this.amount.toString(),
      "Installments":
          this.installments == null ? null : this.installments.toString(),
      "Type": this.type == null ? null : this.type,
      "Provider": this.provider == null ? null : this.provider,
      "Address": this.address == null ? null : this.address,
      "BoletoNumber": this.boletoNumber == null ? null : this.boletoNumber,
      "Assignor": this.assignor == null ? null : this.assignor,
      "Demonstrative": this.demonstrative == null ? null : this.demonstrative,
      "ExpirationDate":
          this.expirationDate == null ? null : this.expirationDate,
      "Identification":
          this.identification == null ? null : this.identification,
      "Instructions": this.instructions == null ? null : this.instructions,
      "SoftDescriptor":
          this.softDescriptor == null ? null : this.softDescriptor,
      "CreditCard": this.creditCard == null ? null : this.creditCard,
      "DebitCard": this.debitCard == null ? null : this.debitCard.toJson(),
      "RecurrentPayment":
          this.recurrentPayment == null ? null : this.recurrentPayment.toJson(),
      "Url": this.url == null ? null : this.url,
      "Number": this.number == null ? null : this.number,
      "BarCodeNumber": this.barCodeNumber == null ? null : this.barCodeNumber,
      "DigitableLine": this.digitableLine == null ? null : this.digitableLine,
      "PaymentId": this.paymentId == null ? null : this.paymentId,
      "Currency": this.currency == null ? null : this.currency,
      "Country": this.country == null ? null : this.country,
      "IsCryptoCurrencyNegotiation": this.IsCryptoCurrencyNegotiation == null
          ? null
          : this.IsCryptoCurrencyNegotiation,
      "ExtraDataCollection": this.extraDataCollection == null
          ? null
          : jsonEncode(this.extraDataCollection),
      "Status": this.status == null ? null : this.status.toString(),
      "Links": this.links == null ? null : jsonEncode(this.links),
      "ServiceTaxAmount": this.serviceTaxAmount == null
          ? null
          : this.serviceTaxAmount.toString(),
      "Interest": this.interest == null ? null : this.interest,
      "Capture": this.capture == null ? null : this.capture,
      "Authenticate": this.authenticate == null ? null : this.authenticate,
      "ProofOfSale": this.proofOfSale == null ? null : this.proofOfSale,
      "Tid": this.tid == null ? null : this.tid,
      "AuthorizationCode":
          this.authorizationCode == null ? null : this.authorizationCode,
      "ReturnCode": this.returnCode == null ? null : this.returnCode,
      "ReturnMessage": this.returnMessage == null ? null : this.returnMessage,
      "ReturnUrl": this.ReturnUrl == null ? null : this.ReturnUrl,
      "splitPayments": this.splitPayments == null ? null : this.splitPayments,
      'FraudAnalysis': this.FraudAnalysis == null ? null : this.FraudAnalysis,
    };
  }
}

class TypePayment {
  static String get creditCard => 'CreditCard';
  static String get debitCard => 'DebitCard';
  static String get boleto => 'Boleto';
}
