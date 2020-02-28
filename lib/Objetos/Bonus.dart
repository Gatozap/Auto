class Bonus {
  String atributo;
  bool isActive;
  bool isPericia;

  int bonus;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;

  Bonus(
      {this.atributo,
      this.isActive,
      this.isPericia,
      this.bonus,
      this.created_at,
      this.updated_at,
      this.deleted_at});


  @override
  String toString() {
    return 'Bonus{atributo: $atributo, isActive: $isActive, isPericia: $isPericia, bonus: $bonus, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Bonus.fromJson(Map<String, dynamic> json)
      : atributo = json['atributo'],
        isActive = json['isActive'],
        isPericia = json['isPericia'],
        bonus = json['bonus'],

        created_at = json['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['created_at']),
        updated_at = json['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
        deleted_at = json['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']);

  Map<String, dynamic> toJson() => {
        'atributo': atributo,
        'isActive': isActive,
        'isPericia': isPericia,
        'bonus': bonus,
   
        'created_at':
            created_at == null ? null : created_at.millisecondsSinceEpoch,
        'updated_at':
            updated_at == null ? null : updated_at.millisecondsSinceEpoch,
        'deleted_at':
            deleted_at == null ? null : deleted_at.millisecondsSinceEpoch,
      };
}
