import '../Split.dart';

class SplitPayment {
  String SubordinateMerchantId;
  int Amount;
  Fares fares;

  List<Split> Splits;
  SplitPayment(
      {this.SubordinateMerchantId, this.Amount, this.fares, this.Splits});

  SplitPayment.fromJson(Map<String, dynamic> json) {
    this.SubordinateMerchantId = json['SubordinateMerchantId'];
    this.Amount = json['Amount'];
    this.fares = json['Fares'] != null ? Fares.fromJson(json['Fares']) : null;
    this.Splits = json['Splits'] != null ? json['Splits'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SubordinateMerchantId'] = this.SubordinateMerchantId;
    data['Amount'] = this.Amount;
    if (this.fares != null) {
      data['Fares'] = this.fares.toJson();
    }
    data['Splits'] = Splits != null ? Splits : null;
    return data;
  }
}

class Fares {
  int Mdr;
  int Fee;

  Fares({this.Mdr, this.Fee});

  Fares.fromJson(json) {
    this.Mdr = json['Mdr'];
    this.Fee = json['Fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Mdr'] = this.Mdr;
    data['Fee'] = this.Fee;
    return data;
  }
}
