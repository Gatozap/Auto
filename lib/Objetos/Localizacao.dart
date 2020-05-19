class Localizacao {
  var latitude;
  var longitude;
  var altitude;
  var accuracy;
  var zona;
  var bairro;
  bool isInRange;
  DateTime timestamp;

  Localizacao({this.latitude, this.longitude, this.altitude, this.accuracy,
      this.timestamp});

  @override
  String toString() {
    return 'Localizacao{latitude: $latitude, longitude: $longitude, altitude: $altitude, accuracy: $accuracy, zona: $zona, bairro: $bairro, isInRange: $isInRange, timestamp: $timestamp}';
  }

  Localizacao.FromPoint(p ,{this.bairro, this.zona}) {
    this.latitude = p.latitude;
    this.longitude = p.longitude;
    this.altitude = p.altitude;
    this.accuracy = p.accuracy;
    this.timestamp = p.timestamp;
  }
  Localizacao.fromJson( json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        altitude = json['altitude'],
        accuracy = json['accuracy'],
  bairro = json['bairro'] == null? null: json['bairro'],
  zona = json['zona'] == null? null:json['zona'],
        timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() =>
      {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'accuracy': accuracy,
        'zona':zona,
        'bairro':bairro,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

}
