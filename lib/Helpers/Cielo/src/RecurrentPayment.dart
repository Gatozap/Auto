class RecurrentPayment {
  static String Monthly = 'Monthly';
  static String Bimestral = 'Bimonthly';
  static String Trimestral = 'Quarterly';
  static String Semestral = 'SemiAnnual';
  static String Anual = 'Annual';
  bool
      AuthorizeNow; //Define que qual o momento que uma recorrencia será criada. Se for enviado como True, ela é criada no momento da autorização, se False, a recorrencia ficará suspensaaté a data escolhida para ser iniciada.
  String
      StartDate; //Define a data que transação da Recorrência Programada será autorizada
  String
      EndDate; //Define a data que a Recorrência Programada será encerrada. Se não for enviada, a Recorrência será executada até ser cancelada pelo lojista
  String
      Interval; //Monthly - Mensal Bimonthly - Bimestral Quarterly - Trimestral SemiAnnual - Semestral Annual - Anual
  var example = {
    "RecurrentPayment": {
      "AuthorizeNow": "False",
      "StartDate": "2019-06-01",
      "EndDate": "2019-12-01",
      "Interval": "SemiAnnual"
    }
  };

  @override
  String toString() {
    return 'RecurrentPayment{AuthorizeNow: $AuthorizeNow, StartDate: $StartDate, EndDate: $EndDate, Interval: $Interval}';
  }

  RecurrentPayment(
      {this.AuthorizeNow, this.StartDate, this.EndDate, this.Interval});

  Map<String, dynamic> toJson() {
    return AuthorizeNow
        ? {
            "AuthorizeNow":
                this.AuthorizeNow == null ? null : this.AuthorizeNow,
            //"StartDate": 'this.StartDate == null? null: ${StartDate.year}-${StartDate.month}-${StartDate.day}',
            "EndDate": this.EndDate == null ? null : this.EndDate,
            "Interval": this.Interval == null ? null : this.Interval,
          }
        : {
            //"AuthorizeNow": this.AuthorizeNow,
            "StartDate": this.StartDate == null ? null : this.StartDate,
            "EndDate": this.EndDate == null ? null : this.EndDate,
            "Interval": this.Interval == null ? null : this.Interval,
          };
  }

  factory RecurrentPayment.fromJson(json) {
    return RecurrentPayment(
      AuthorizeNow: json['AuthorizeNow'] == null ? null : json["AuthorizeNow"],
      StartDate: json['StartDate'] == null ? null : json["StartDate"],
      EndDate: json['EndDate'] == null ? null : json["EndDate"],
      Interval: json['Interval'] == null ? null : json["Interval"].toString(),
    );
  }
}
