class Address {
  String street;
  String number;
  String complement;
  String zipCode;
  String district;
  String city;
  String state;
  String country;

  Address({
    this.street,
    this.number,
    this.complement,
    this.zipCode,
    this.district,
    this.city,
    this.state,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        street: json['Street'] == null ? null : json['Street'],
        number: json['Number'] == null ? null : json['Number'],
        complement: json['Complement'] == null ? null : json['Complement'],
        zipCode: json['ZipCode'] == null ? null : json['ZipCode'],
        district: json['District'] == null ? null : json['District'],
        city: json['City'] == null ? null : json['City'],
        state: json['State'] == null ? null : json['State'],
        country: json['Country'] == null ? null : json['Country']);
  }

  Map<String, dynamic> toJson() {
    return {
      "Street": this.street == null ? null : this.street,
      "Number": this.number == null ? null : this.number,
      "Complement": this.complement == null ? null : this.complement,
      "ZipCode": this.zipCode == null ? null : this.zipCode,
      "District": this.district == null ? null : this.district,
      "City": this.city == null ? null : this.city,
      "State": this.state == null ? null : this.state,
      "Country": this.country == null ? null : this.country,
    };
  }
}
