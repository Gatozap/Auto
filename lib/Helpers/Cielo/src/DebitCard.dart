class DebitCard {
  String CardNumber;
  String Holder;
  String ExpirationDate;
  String Brand;
  bool SaveCard;
  String SecurityCode;

  DebitCard(
      {this.CardNumber,
      this.Holder,
      this.ExpirationDate,
      this.Brand,
      this.SecurityCode,
      this.SaveCard});

  DebitCard.fromJson(json) {
    this.CardNumber = json['CardNumber'] == null ? null : json['CardNumber'];
    this.Holder = json['Holder'] == null ? null : json['Holder'];
    this.ExpirationDate =
        json['ExpirationDate'] == null ? null : json['ExpirationDate'];
    this.Brand = json['Brand'] == null ? null : json['Brand'];
    this.SecurityCode =
        json['SecurityCode'] == null ? null : json['SecurityCode'];
    this.SaveCard = json['SaveCard'] == null ? null : json['SaveCard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CardNumber'] = this.CardNumber == null ? null : this.CardNumber;
    data['Holder'] = this.Holder == null ? null : this.Holder;
    data['ExpirationDate'] =
        this.ExpirationDate == null ? null : this.ExpirationDate;
    data['Brand'] = this.Brand == null ? null : this.Brand;
    data['SaveCard'] = this.SecurityCode == null ? null : this.SaveCard;
    data['SecurityCode'] = this.SaveCard == null ? null : this.SecurityCode;
    return data;
  }
}
