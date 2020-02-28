import 'Address.dart';

class Customer {
  String name;
  String identity;
  Address address;

  Customer({
    this.name,
    this.identity,
    this.address,
  });

  @override
  String toString() {
    return 'Customer{name: $name, identity: $identity, address: $address}';
  }

  factory Customer.fromJson(json) {
    return Customer(
        name: json['Name'] as String,
        identity: json['Identity'],
        address:
            json['Address'] == null ? null : Address.fromJson(json['Address']));
  }

  Map<String, dynamic> toJson() {
    return {
      "Name": this.name == null ? null : this.name,
      "Identity": this.identity == null ? null : this.identity,
      "Address": this.address == null ? null : this.address.toJson(),
    };
  }
}
