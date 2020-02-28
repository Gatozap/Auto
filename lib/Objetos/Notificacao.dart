class Notificacao {
  String image;
  String title;
  String message;
  String topic;
  String sender;
  int behaivior;
  var data;
  DateTime sended_at;

  Notificacao(
      {this.image,
      this.title,
      this.message,
      this.topic,
      this.sender,
      this.behaivior,
      this.data,
      this.sended_at});

  @override
  String toString() {
    return 'Notificacao{image: $image, title: $title, message: $message, topic: $topic, sender: $sender, behaivior: $behaivior, data: $data, sended_at: $sended_at}';
  }

  factory Notificacao.fromJson(json) {
    print('AQUI JSON ${json}');
    return Notificacao(
      image: json["image"] == null ? null : json['image'],
      title: json["title"],
      message: json["message"],
      topic: json["topic"],
      sender: json["sender"],
      behaivior: int.parse(json["behaivior"].toString()),
      data: json["data"],
      sended_at: json['sended_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              int.parse(json["sended_at"].toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": this.image == null ? '' : this.image,
      "title": this.title,
      "message": this.message,
      "topic": this.topic,
      "sender": this.sender,
      "behaivior": this.behaivior.toString(),
      "data": this.data,
      "sended_at": this.sended_at.millisecondsSinceEpoch.toString(),
    };
  }
}
