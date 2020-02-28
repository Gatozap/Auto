import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Objetos/Cartao.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:rxdart/rxdart.dart';

class CardListController implements BlocBase {
  final cartoesRef = Firestore.instance.collection('Cartoes').reference();
  CardListController() {
    getCartoes().then((v) {
      User u = Helper.localUser;
      u.cartoes = v;
      Helper.localUser = u;
      _cardsCollection.add(v);
    });

    //print(Helper.localUser.cartoes.toString());
  }

  BehaviorSubject<List<Cartao>> _cardsCollection =
      BehaviorSubject<List<Cartao>>();

  Stream<List<Cartao>> get outCardList => _cardsCollection.stream;

  void addCardToList() {
    _cardsCollection.sink.add(Helper.localUser.cartoes);
  }

  void dispose() {
    _cardsCollection.close();
  }
}

CardListController clc = CardListController();
Future<List<Cartao>> getCartoes() {
  List<Cartao> cartoes = new List();
  return Helper.storage.read(key: 'Cartoes' + Helper.localUser.id).then((s) {
    print("buscando cartao ${s}");
    cartoes = new List();
    if (s != null) {
      var j = json.decode(s);

      for (var d in j) {
        Cartao c = Cartao.fromJson(d);
        //print('Cartão : ' + c.toString());
        bool contains = false;
        for (Cartao cc in cartoes) {
          // print('NUMBERS ${cc.number}  ${c.number}');
          if (cc.number == c.number) {
            contains = true;
          }
        }
        if (!contains) {
          cartoes.add(c);
        }
        // print('Contains $contains');
      }
      Map<String, Cartao> mp = {};
      for (var item in cartoes) {
        mp[item.number] = item;
      }
      //print('MP AQUI ${mp.toString()}');
      cartoes = mp.values.toList();
    }
    print('Cartoes ' + cartoes.toString());
    return cartoes;
  }).catchError((err) {
    return new List<Cartao>();
  });
}
