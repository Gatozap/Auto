import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
//import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart' as http;

import '../../Helper.dart';
import 'CieloError.dart';
import 'CieloException.dart';
import 'Environment.dart';
import 'Merchant.dart';
import 'Sale.dart';
import 'Subordinate.dart';
import 'SubordinateMeta.dart';

class CieloEcommerce {
  final Environment environment;
  final Merchant merchant;
  Dio dio;

  CieloEcommerce({this.environment, this.merchant}) {
    dio = Dio(BaseOptions(headers: {
      "MerchantId": this.merchant.merchantId,
      "MerchantKey": this.merchant.merchantKey
    }));
  }

  Future<Sale> createSale(Sale sale) async {
    print('SALE >>>>>>');
    print(sale.toJson().toString());
    //Share.text('', sale.toJson(), 'text/plain');
    print({
      "MerchantId": this.merchant.merchantId,
      "MerchantKey": this.merchant.merchantKey,
      //'Authorization': 'Bearer ${this.merchant.merchantId}'
    });
    print('${environment.apiUrl}/1/sales/');
    return http.post("${environment.apiUrl}/1/sales/",
        body: json.encode(sale),
        headers: {
          "MerchantId": this.merchant.merchantId,
          "MerchantKey": this.merchant.merchantKey,
          'content-type': 'application/json'
          //'Authorization': 'Bearer ${this.merchant.merchantId}'
        }).then((response) {
      print('${response.statusCode}');
      print('Resposta do servidor : ${response.body}');
      if (response.body != null && response.body != '') {
        return Sale.fromJson(response.body);
      }
    });
  }

  /* Future<CreditCard> tokenizeCard(CreditCard card) async {
    try {
      Response response =
          await dio.post("${environment.apiUrl}/1/card/", data: card.toJson());
      card.cardToken = response.data["CardToken"];
      card.cardNumber =
          "****" + card.cardNumber.substring(card.cardNumber.length - 4);
      return card;
    } on DioError catch (e) {
      _getErrorDio(e);
    } catch (e) {
      throw CieloException(
          List<CieloError>()
            ..add(CieloError(
              code: 0,
              message: e.message,
            )),
          "unknown");
    }
    return null;
  }*/

  _getErrorDio(DioError e) {
    try {
      if (e?.response != null) {
        List<CieloError> errors = (e.response.data as List)
            .map((i) => CieloError.fromJson(i))
            .toList();
        throw CieloException(errors, e.message);
      } else {
        throw CieloException(
            List<CieloError>()..add(CieloError(code: 0, message: "unknown")),
            e.message);
      }
    } catch (err) {
      print('error Cielo: ${err.toString()}');
    }
  }

  Future createSubordinate(Subordinate s) async {
    var token = await getToken();
    String t = json.decode(token)['access_token'];
    print('TOKEN $t');
    //Share.text('', json.encode(s), 'text/plain');
    return http
        .post("${environment.OnBoardingUrl}/api/subordinates",
            headers: {
              "Authorization": "Bearer $t",
              'content-type': 'application/json'
            },
            body: json.encode(s))
        .then((response) {
      print('Response ${response.body}');
      //Share.text('', response.body, 'text/plain');
      SubordinateMeta sb = SubordinateMeta.fromJson(json.decode(response.body));
      s.subordinateMeta = sb;
      return s; //response.body;
    }).catchError((err) {
      dToast('Erro ao cadastrar: ${err.toString()}');
      print('Error Create Subordinate: $err');
      return null;
    });
  }

  Future getToken() {
    String token = '${merchant.merchantKey}:${merchant.clientSecret}';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(token); // dXNlcm5hbWU6cGFzc3dvcmQ=
    print(encoded);
    return http.post('${environment.authUrl}/oauth2/token',
        body: 'grant_type=client_credentials',
        headers: {
          "Authorization": "Basic $encoded",
          //"MerchantKey": 'IFEYGLEVXXBTNOYXIQJEPYNWAKJMQUMOQDHDIDEG',
          'Content-Type': 'application/json',
          //'Authorization': 'Basic YnJhc3BhZ3Rlc3RlczoxcTJ3M2U0cg=='
        }).then((r) {
      return r.body;
    }).catchError((err) {
      print('Error Token: ${err.toString()}');
    });
  }

  Future createSubordinateSale(var s) async {
    var token = await getToken();
    String t = json.decode(token)['access_token'];
    //Share.text('', json.encode(s), 'text/plain');

    print('Token $t');
    print("${environment.apiUrl}/1/sales/");
    //Share.text('', json.encode(s), 'text/plain');
    return http
        .post("${environment.apiUrl}/1/sales/",
            headers: {
              "Authorization": "Bearer $t",
              'content-type': 'application/json'
            },
            body: json.encode(s))
        .then((response) {
      print('AQUI RESPONSE ${response.body}');
      //Share.text('', response.body, 'text/plain');
      checkSale(response.body);
      return response.body; //response.body;
    }).catchError((err) {
      dToast('Erro ao cadastrar: ${err.toString()}');
      print('Error Create Subordinate: $err');
      return null;
    });
  }

  Future cancelSubordinateSale(var s) async {
    var token = await getToken();
    String t = json.decode(token)['access_token'];
    //Share.text('', json.encode(s), 'text/plain');

    print('Token $t');
    print("${environment.apiUrl}/1/sales/$s/void");
    //Share.text('', json.encode(s), 'text/plain');
    return http.put(
      "${environment.apiUrl}/1/sales/$s/void",
      headers: {
        "Authorization": "Bearer $t",
        'content-type': 'application/json'
      },
    ).then((response) {
      print('AQUI RESPONSE ${response.body}');
      //Share.text('', response.body, 'text/plain');
      checkSale(response.body);
      return response; //response.body;
    }).catchError((err) {
      dToast('Erro ao cadastrar: ${err.toString()}');
      print('Error Create Subordinate: $err');
      return null;
    });
  }

  Future checkSaleFromJson(var r) async {
    var token = await getToken();
    String t = json.decode(token)['access_token'];
    //Share.text('', json.encode(s), 'text/plain');

    print('Token $t');
    var j = r;
    var links = json.decode(j["Payment"]['Links']);
    for (var i in links) {
      if (!i['Href'].toString().contains('void') ||
          !i['Href'].toString().contains('capture')) {
        return http.get("${i['Href']}", headers: {
          "MerchantId": this.merchant.merchantId,
          "MerchantKey": this.merchant.merchantKey,
          'content-type': 'application/json'
          //'Authorization': 'Bearer ${this.merchant.merchantId}'
        }).then((response) {
          print('AQUI  "${i['Href']}" ');
          print('RESPONSE ${response.body.toString()}');
          //Share.text('', response.body.toString(), 'text/plain');
          //checkSale(response);
          return response.body; //response.body;
        }).catchError((err) {
          dToast('Erro ao cadastrar: ${err.toString()}');
          print('Error Create Subordinate: $err');
          return null;
        });
      }
    }
  }

  Future checkSale(var r) async {
    var token = await getToken();
    String t = json.decode(token)['access_token'];
    //Share.text('', json.encode(s), 'text/plain');

    print('Token $t');
    var j = jsonDecode(r);
    var links = j["Payment"]['Links'];
    for (var i in links) {
      http.get(
        "${i['Href']}",
        headers: {
          "Authorization": "Bearer $t",
          'content-type': 'application/json'
        },
      ).then((response) {
        print('AQUI  "${i['Href']}" ');
        print('RESPONSE ${response.body.toString()}');
        //Share.text('', response.body.toString(), 'text/plain');
        //checkSale(response);
        return response; //response.body;
      }).catchError((err) {
        dToast('Erro ao cadastrar: ${err.toString()}');
        print('Error Create Subordinate: $err');
        return null;
      });
    }
  }

  reactivate(pagamento) {
    print(
        '${environment.apiUrl}/1/RecurrentPayment/${pagamento["Payment"]['MerchantOrderId']}/Reactivate');
    return http
        .put(
            "${environment.apiUrl}/1/RecurrentPayment/${pagamento["Payment"]['MerchantOrderId']}/Reactivate",
            headers: {
              "MerchantId": this.merchant.merchantId,
              "MerchantKey": this.merchant.merchantKey,
              'content-type': 'application/json'
              //'Authorization': 'Bearer ${this.merchant.merchantId}'
            },
            body: '')
        .then((response) {
      print('${response.statusCode}');
      print('Resposta do servidor : ${response.body}');
      if (response.body != null && response.body != '') {
        return response.body;
      }
    });
  }

  Future<Subordinate> verificarSubordinate(Subordinate subordinate) async {
    var token = await getToken();
    String t = json.decode(token)['access_token'];
    //Share.text('', json.encode(s), 'text/plain');
    return http.get(
      "${environment.OnBoardingUrl}/api/subordinates/${subordinate.subordinateMeta.MerchantId}",
      headers: {
        "Authorization": "Bearer $t",
        'content-type': 'application/json'
      },
    ).then((response) {
      //Share.text('', response.body, 'text/plain');
      AnalysisBean sb =
          AnalysisBean.fromJson(json.decode(response.body)['Analysis']);
      subordinate.subordinateMeta.Analysis = sb;
      return subordinate; //response.body;
    }).catchError((err) {
      dToast('Erro ao cadastrar: ${err.toString()}');
      print('Error Create Subordinate: ${err}');
      return null;
    });
  }
}
