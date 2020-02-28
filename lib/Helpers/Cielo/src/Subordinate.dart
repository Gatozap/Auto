import 'SubordinateMeta.dart';

class Subordinate {
  String CorporateName;
  String FancyName;
  String DocumentNumber;
  String DocumentType;
  String MerchantCategoryCode;
  String ContactName;
  String ContactPhone;
  String MailAddress;
  String Website;
  AddressBean Address;
  AgreementBean Agreement;
  BankAccountBean BankAccount;
  NotificationBean Notification;
  List<AttachmentsListBean> Attachments;
  SubordinateMeta subordinateMeta;

  @override
  String toString() {
    return 'Subordinate{CorporateName: $CorporateName, FancyName: $FancyName, DocumentNumber: $DocumentNumber, DocumentType: $DocumentType, MerchantCategoryCode: $MerchantCategoryCode, ContactName: $ContactName, ContactPhone: $ContactPhone, MailAddress: $MailAddress, Website: $Website, Address: $Address,  BankAccount: $BankAccount, Notification: $Notification, Attachments: $Attachments, Agreement: $Agreement,}';
  }

  Subordinate(
      {this.CorporateName,
      this.FancyName,
      this.DocumentNumber,
      this.DocumentType,
      this.MerchantCategoryCode,
      this.ContactName,
      this.ContactPhone,
      this.MailAddress,
      this.Website,
      this.Address,
      this.Agreement,
      this.BankAccount,
      this.Notification,
      this.subordinateMeta,
      this.Attachments});

  Subordinate.fromJson(json) {

    this.CorporateName = json['CorporateName'];
    this.FancyName = json['FancyName'];
    this.DocumentNumber = json['DocumentNumber'];
    this.DocumentType = json['DocumentType'];
    this.MerchantCategoryCode = json['MerchantCategoryCode'];
    this.ContactName = json['ContactName'];
    this.ContactPhone = json['ContactPhone'];
    this.MailAddress = json['MailAddress'];
    this.Website = json['Website'];
    this.Address =
        json['Address'] != null ? AddressBean.fromJson(json['Address']) : null;

    this.Agreement = json['Agreement'] != null
        ? AgreementBean.fromJson(json['Agreement'])
        : null;
    this.BankAccount = json['BankAccount'] != null
        ? BankAccountBean.fromJson(json['BankAccount'])
        : null;
    this.Notification = json['Notification'] != null
        ? NotificationBean.fromJson(json['Notification'])
        : null;
    this.Attachments = (json['Attachments'] as List) != null
        ? (json['Attachments'] as List)
            .map((i) => AttachmentsListBean.fromJson(i))
            .toList()
        : null;
    this.subordinateMeta = json['SubordinateMeta'] == null
        ? null
        : SubordinateMeta.fromJson(json['SubordinateMeta']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CorporateName'] = this.CorporateName;
    data['FancyName'] = this.FancyName;
    data['DocumentNumber'] = this.DocumentNumber;
    data['DocumentType'] = this.DocumentType;
    data['MerchantCategoryCode'] = this.MerchantCategoryCode;
    data['ContactName'] = this.ContactName;
    data['ContactPhone'] = this.ContactPhone;
    data['MailAddress'] = this.MailAddress;
    data['Website'] = this.Website;
    if (this.Address != null) {
      data['Address'] = this.Address.toJson();
    }
    if (this.Agreement != null) {
      data['Agreement'] = this.Agreement.toJson();
    }
    if (this.BankAccount != null) {
      data['BankAccount'] = this.BankAccount.toJson();
    }
    if (this.Notification != null) {
      data['Notification'] = this.Notification.toJson();
    }
    data['Attachments'] = this.Attachments != null
        ? this.Attachments.map((i) => i.toJson()).toList()
        : null;
    data['SubordinateMeta'] =
        this.subordinateMeta == null ? null : subordinateMeta.toJson();
    return data;
  }
}

class AddressBean {
  String Street;
  String Number;
  String Complement;
  String Neighborhood;
  String City;
  String State;
  String ZipCode;

  @override
  String toString() {
    return 'AddressBean{Street: $Street, Number: $Number, Complement: $Complement, Neighborhood: $Neighborhood, City: $City, State: $State, ZipCode: $ZipCode}';
  }

  AddressBean(
      {this.Street,
      this.Number,
      this.Complement,
      this.Neighborhood,
      this.City,
      this.State,
      this.ZipCode});

  AddressBean.fromJson(json) {
    this.Street = json['Street'];
    this.Number = json['Number'];
    this.Complement = json['Complement'];
    this.Neighborhood = json['Neighborhood'];
    this.City = json['City'];
    this.State = json['State'];
    this.ZipCode = json['ZipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Street'] = this.Street;
    data['Number'] = this.Number;
    data['Complement'] = this.Complement;
    data['Neighborhood'] = this.Neighborhood;
    data['City'] = this.City;
    data['State'] = this.State;
    data['ZipCode'] = this.ZipCode;
    return data;
  }
}

class AgreementBean {
  int Fee;
  List<MerchantDiscountRatesListBean> MerchantDiscountRates;

  @override
  String toString() {
    return 'AgreementBean{Fee: $Fee, MerchantDiscountRates: $MerchantDiscountRates}';
  }

  AgreementBean({this.Fee, this.MerchantDiscountRates});

  AgreementBean.fromJson(json) {
    this.Fee = json['Fee'];
    this.MerchantDiscountRates = (json['MerchantDiscountRates'] as List) != null
        ? (json['MerchantDiscountRates'] as List)
            .map((i) => MerchantDiscountRatesListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fee'] = this.Fee;
    data['MerchantDiscountRates'] = this.MerchantDiscountRates != null
        ? this.MerchantDiscountRates.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class BankAccountBean {
  String Bank;
  String BankAccountType;
  String Number;
  String Operation;
  String VerifierDigit;
  String AgencyNumber;
  String AgencyDigit;
  String DocumentNumber;
  String DocumentType;

  @override
  String toString() {
    return 'BankAccountBean{Bank: $Bank, BankAccountType: $BankAccountType, Number: $Number, Operation: $Operation, VerifierDigit: $VerifierDigit, AgencyNumber: $AgencyNumber, AgencyDigit: $AgencyDigit, DocumentNumber: $DocumentNumber, DocumentType: $DocumentType}';
  }

  BankAccountBean(
      {this.Bank,
      this.BankAccountType,
      this.Number,
      this.Operation,
      this.VerifierDigit,
      this.AgencyNumber,
      this.AgencyDigit,
      this.DocumentNumber,
      this.DocumentType});

  BankAccountBean.fromJson(json) {
    this.Bank = json['Bank'];
    this.BankAccountType = json['BankAccountType'];
    this.Number = json['Number'];
    this.Operation = json['Operation'];
    this.VerifierDigit = json['VerifierDigit'];
    this.AgencyNumber = json['AgencyNumber'];
    this.AgencyDigit = json['AgencyDigit'];
    this.DocumentNumber = json['DocumentNumber'];
    this.DocumentType = json['DocumentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bank'] = this.Bank;
    data['BankAccountType'] = this.BankAccountType;
    data['Number'] = this.Number;
    data['Operation'] = this.Operation;
    data['VerifierDigit'] = this.VerifierDigit;
    data['AgencyNumber'] = this.AgencyNumber;
    data['AgencyDigit'] = this.AgencyDigit;
    data['DocumentNumber'] = this.DocumentNumber;
    data['DocumentType'] = this.DocumentType;
    return data;
  }
}

class NotificationBean {
  String Url;
  List<HeadersListBean> Headers;

  @override
  String toString() {
    return 'NotificationBean{Url: $Url, Headers: $Headers}';
  }

  NotificationBean({this.Url, this.Headers});

  NotificationBean.fromJson(json) {
    this.Url = json['Url'];
    this.Headers = (json['Headers'] as List) != null
        ? (json['Headers'] as List)
            .map((i) => HeadersListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Url'] = this.Url;
    data['Headers'] = this.Headers != null
        ? this.Headers.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class AttachmentsListBean {
  String AttachmentType;
  FileBean File;

  @override
  String toString() {
    return 'AttachmentsListBean{AttachmentType: $AttachmentType, File: $File}';
  }

  AttachmentsListBean({this.AttachmentType, this.File});

  AttachmentsListBean.fromJson(json) {
    this.AttachmentType = json['AttachmentType'];
    this.File = json['File'] != null ? FileBean.fromJson(json['File']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AttachmentType'] = this.AttachmentType;
    if (this.File != null) {
      data['File'] = this.File.toJson();
    }
    return data;
  }
}

class MerchantDiscountRatesListBean {
  double Percent;
  int InitialInstallmentNumber;
  int FinalInstallmentNumber;
  PaymentArrangementBean PaymentArrangement;

  @override
  String toString() {
    return 'MerchantDiscountRatesListBean{Percent: $Percent, InitialInstallmentNumber: $InitialInstallmentNumber, FinalInstallmentNumber: $FinalInstallmentNumber, PaymentArrangement: $PaymentArrangement}';
  }

  MerchantDiscountRatesListBean(
      {this.Percent,
      this.InitialInstallmentNumber,
      this.FinalInstallmentNumber,
      this.PaymentArrangement});

  MerchantDiscountRatesListBean.fromJson( json) {
    this.Percent = json['Percent'];
    this.InitialInstallmentNumber = json['InitialInstallmentNumber'];
    this.FinalInstallmentNumber = json['FinalInstallmentNumber'];
    this.PaymentArrangement = json['PaymentArrangement'] != null
        ? PaymentArrangementBean.fromJson(json['PaymentArrangement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Percent'] = this.Percent;
    data['InitialInstallmentNumber'] = this.InitialInstallmentNumber;
    data['FinalInstallmentNumber'] = this.FinalInstallmentNumber;
    if (this.PaymentArrangement != null) {
      data['PaymentArrangement'] = this.PaymentArrangement.toJson();
    }
    return data;
  }
}

class PaymentArrangementBean {
  String Product;
  String Brand;

  @override
  String toString() {
    return 'PaymentArrangementBean{Product: $Product, Brand: $Brand}';
  }

  PaymentArrangementBean({this.Product, this.Brand});

  PaymentArrangementBean.fromJson(json) {
    this.Product = json['Product'];
    this.Brand = json['Brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Product'] = this.Product;
    data['Brand'] = this.Brand;
    return data;
  }
}

class HeadersListBean {
  String Key;
  String Value;

  @override
  String toString() {
    return 'HeadersListBean{Key: $Key, Value: $Value}';
  }

  HeadersListBean({this.Key, this.Value});

  HeadersListBean.fromJson(json) {
    this.Key = json['Key'];
    this.Value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.Key;
    data['Value'] = this.Value;
    return data;
  }
}

class FileBean {
  String Name;
  String FileType;
  String Data;

  @override
  String toString() {
    return 'FileBean{Name: $Name, FileType: $FileType, Data: $Data}';
  }

  FileBean({this.Name, this.FileType, this.Data});

  FileBean.fromJson(json) {
    this.Name = json['Name'];
    this.FileType = json['FileType'];
    this.Data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.Name;
    data['FileType'] = this.FileType;
    data['Data'] = this.Data;
    return data;
  }
}
