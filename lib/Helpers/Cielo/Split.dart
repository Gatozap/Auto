class Split {
  String merchantId;
  String Amount;

  @override
  String toString() {
    return 'Split{merchantId: $merchantId, Amount: $Amount}';
  }

  factory Split.fromJson(Map<String, dynamic> json) {
    return Split(
      merchantId: json["merchantId"],
      Amount: json["Amount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "merchantId": this.merchantId,
      "Amount": this.Amount,
    };
  }

  Split({this.merchantId, this.Amount});
}
