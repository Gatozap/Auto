class Localizacao {
  var latitude;
  var longitude;
  var altitude;
  var accuracy;
  DateTime timestamp;

  Localizacao({this.latitude, this.longitude, this.altitude, this.accuracy,
      this.timestamp});

  Localizacao.FromPoint(p) {
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
        timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() =>
      {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'accuracy': accuracy,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };




}
