class SubordinateMeta {
  String MasterMerchantId;
  String MerchantId;
  bool Blocked;
  int MerchantType;
  int Holder;
  AnalysisBean Analysis;

  SubordinateMeta({
    this.MasterMerchantId,
    this.MerchantId,
    this.Blocked,
    this.MerchantType,
    this.Holder,
    this.Analysis,
  });

  @override
  String toString() {
    return 'SubordinateMeta{MasterMerchantId: $MasterMerchantId, MerchantId: $MerchantId, Blocked: $Blocked, MerchantType: $MerchantType, Holder: $Holder, Analysis: $Analysis}';
  }

  SubordinateMeta.fromJson(json) {
    print('CHEGOU AQUI ${json.toString()}');
    this.MasterMerchantId = json['MasterMerchantId'];
    this.MerchantId = json['MerchantId'];
    this.Blocked = json['Blocked'];
    this.MerchantType = json['MerchantType'] != null
        ? int.parse(json['MerchantType'].toString())
        : null;
    this.Holder =
        json['Holder'] != null ? int.parse(json['Holder'].toString()) : null;
    this.Analysis = json['Analysis'] != null
        ? AnalysisBean.fromJson(json['Analysis'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MasterMerchantId'] = this.MasterMerchantId;
    data['MerchantId'] = this.MerchantId;
    data['Blocked'] = this.Blocked;
    data['MerchantType'] = this.MerchantType;
    data['Holder'] = this.Holder;
    data['Analisys'] = Analysis == null ? null : Analysis.toJson();
    return data;
  }
}

class AnalysisBean {
  String Status;

  AnalysisBean({this.Status});

  AnalysisBean.fromJson(Map<String, dynamic> json) {
    this.Status = json['Status'];
  }

  @override
  String toString() {
    return 'AnalysisBean{Status: $Status}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.Status;
    return data;
  }
}
