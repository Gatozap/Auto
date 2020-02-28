



import 'package:bocaboca/Objetos/racing.dart';

class ResultRacing {
  List<Racing> data;

  ResultRacing({this.data});

  ResultRacing.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Racing>();
      json['data'].forEach((v) {
        data.add(new Racing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
