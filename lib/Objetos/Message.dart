class Message {
  String msg;
  String imgUrl;
  String senderName;
  String senderFoto;
  String senderId;
  DateTime timestamp;

  Message(
      {this.msg,
      this.imgUrl,
      this.senderName,
      this.senderFoto,
      this.senderId,
      this.timestamp});

  @override
  String toString() {
    return 'Message{msg: $msg, imgUrl: $imgUrl, senderName: $senderName, senderFoto: $senderFoto, senderId: $senderId, timestamp: $timestamp}';
  }

  Map<String, dynamic> toJson() {
    return {
      "msg": this.msg,
      "imgUrl": this.imgUrl == null ? null : this.imgUrl,
      "senderName": this.senderName,
      "senderFoto": this.senderFoto,
      "senderId": this.senderId,
      "timestamp": this.timestamp.millisecondsSinceEpoch,
    };
  }

  factory Message.fromJson(json) {
    return Message(
      msg: json["msg"],
      imgUrl: json["imgUrl"] == null ? null : json["imgUrl"],
      senderName: json["senderName"],
      senderFoto: json["senderFoto"],
      senderId: json["senderId"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json["timestamp"]),
    );
  }
}
