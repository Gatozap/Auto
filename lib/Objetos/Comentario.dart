import 'dart:convert';

class Comentario {
  String msg;
  String imgUrl;
  String senderName;
  String senderFoto;
  String senderId;
  DateTime timestamp;
  List<Comentario> comentarios;

  Comentario(
      {this.msg,
      this.imgUrl,
      this.senderName,
      this.senderFoto,
      this.senderId,
      this.timestamp,this.comentarios});

  @override
  String toString() {
    return 'Comentario{msg: $msg, imgUrl: $imgUrl, senderName: $senderName,  comentarios: $comentarios,senderFoto: $senderFoto, senderId: $senderId, timestamp: $timestamp}';
  }
  static getComentarios(decoded) {
    List<Comentario> avaliacoes = new List();
    if (decoded == null) {
      return null;
    }
    for (var i in decoded) {
      avaliacoes.add(Comentario.fromJson(i));
    }
    return avaliacoes;
  }
  Map<String, dynamic> toJson() {
    return {
      "msg": this.msg,
      "imgUrl": this.imgUrl == null ? null : this.imgUrl,
      "senderName": this.senderName,
      "senderFoto": this.senderFoto,
      "senderId": this.senderId,
      "timestamp": this.timestamp.millisecondsSinceEpoch,
      'comentarios': this.comentarios == null ?null: json.encode(this.comentarios),
    };
  }

  factory Comentario.fromJson(j) {
    return Comentario(
      msg: j["msg"],
      imgUrl: j["imgUrl"] == null ? null : j["imgUrl"],
      senderName: j["senderName"],
      senderFoto: j["senderFoto"],
      senderId: j["senderId"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(j["timestamp"]),
      comentarios : j['comentarios'] == null ? null : getComentarios(json.decode(j["comentarios"])),
    );
  }
}
