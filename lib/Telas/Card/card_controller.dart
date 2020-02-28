import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/Validators.dart';
import 'package:bocaboca/Objetos/Cartao.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:rxdart/rxdart.dart';

import 'card_color.dart';
import 'card_color_model.dart';
import 'card_list_controller.dart';

class CardController with Validators implements BlocBase {
  BehaviorSubject<int> controller_id = BehaviorSubject<int>();
  //TODO ALTERAR PARA O USUARIO DO SERVIDOR
  BehaviorSubject<int> controller_user_id = BehaviorSubject<int>();
  BehaviorSubject<int> controller_expiration_month = BehaviorSubject<int>();
  BehaviorSubject<int> controller_expiration_year = BehaviorSubject<int>();
  BehaviorSubject<String> controller_number = BehaviorSubject<String>();
  BehaviorSubject<int> controller_cvc = BehaviorSubject<int>();
  BehaviorSubject<String> controller_hash = BehaviorSubject<String>();
  BehaviorSubject<String> controller_owner_name = BehaviorSubject<String>();
  BehaviorSubject<String> controller_card_type = BehaviorSubject<String>();
  BehaviorSubject<String> controller_card_brand = BehaviorSubject<String>();
  BehaviorSubject<int> controller_card_color_index = BehaviorSubject<int>();

  final _cardColors = BehaviorSubject<List<CardColorModel>>();

  CardController() {
    InCard_brand('Visa');
    SelectCardColor(0);
  }

  Stream<List<CardColorModel>> get OutCardColor => _cardColors.stream;
  Stream<int> get Outid => controller_id.stream;
  Stream<int> get Outuser_id => controller_user_id.stream;
  Stream<int> get Outexpiration_month =>
      controller_expiration_month.stream.transform(validateCardMonth);
  Stream<int> get Outexpiration_year =>
      controller_expiration_year.stream.transform(validateCardYear);
  Stream<String> get Outnumber =>
      controller_number.stream.transform(validateCardNumber);
  Stream<int> get Outcvc =>
      controller_cvc.stream.transform(validateCardVerificationValue);
  Stream<String> get Outhash => controller_hash.stream;
  Stream<String> get Outowner_name =>
      controller_owner_name.stream.transform(validateCardHolderName);
  Stream<String> get Outcard_type => controller_card_type.stream;
  Stream<int> get Outcard_color_index => controller_card_color_index.stream;
  Stream<String> get  outCard_brand =>controller_card_brand.stream;

  Stream<bool> get saveCardValid => Observable.combineLatest6(
      Outexpiration_month,
      Outexpiration_year,
      Outnumber,
      Outcvc,
      Outowner_name,
      Outcard_type,
      (em, ey, n, c, on, ct) => true);

  Future saveCard() {
    print('ENTROU SAVE CARD');
    Cartao c = new Cartao(
        id_user: Helper.localUser.id,
        expiration_month: controller_expiration_month.value,
        expiration_year: controller_expiration_year.value,
        number: controller_number.value,
        cvc: controller_cvc.value,
        hash: controller_hash.value,
        owner: controller_owner_name.value,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),marca: controller_card_brand.value,
        tipo: controller_card_type.value,
        //:controller_card_type.value,
        R: CardColor
            .baseColors[controller_card_color_index.value != null
                ? controller_card_color_index.value
                : 0]
            .red,
        G: CardColor
            .baseColors[controller_card_color_index.value != null
                ? controller_card_color_index.value
                : 0]
            .green,
        B: CardColor
            .baseColors[controller_card_color_index.value != null
                ? controller_card_color_index.value
                : 0]
            .blue);
    return getCartoes().then((v) {
      print('CHEGOU AQUI ${v}');
      User u = Helper.localUser;
      u.cartoes = v;
      u.cartoes.add(c);
      Helper.localUser = u;
      print('CHEGOU AQUI ${Helper.localUser.cartoes.toString()}');
      return Helper.storage
          .write(
              key: 'Cartoes' + Helper.localUser.id,
              value: json.encode(Helper.localUser.cartoes))
          .then((v) {
        clc.addCardToList();
        return true;
      }).catchError((err) {
        print('Erro ao Salvar Cartão');
      });
    }).catchError((err) {
      print('Erro ao Salvar Cartão:${err.toString()}');
    });
  }

  Function(List<CardColorModel>) get InCardColor => _cardColors.sink.add;
  Function(int) get Inid => controller_id.sink.add;
  Function(int) get Inuser_id => controller_user_id.sink.add;
  Function(int) get Inexpiration_month => controller_expiration_month.sink.add;
  Function(int) get Inexpiration_year => controller_expiration_year.sink.add;
  Function(String) get Innumber => controller_number.sink.add;
  Function(int) get Incvc => controller_cvc.sink.add;
  Function(String) get Inhash => controller_hash.sink.add;
  Function(String) get Inowner_name => controller_owner_name.sink.add;
  Function(String) get Incard_type => controller_card_type.sink.add;
  Function(int) get Incard_color_index => controller_card_color_index.sink.add;
  Function(String) get InCard_brand =>controller_card_brand.add;

  removerCartao(Cartao c){
    getCartoes().then((v) {
      print('CHEGOU AQUI ${v}');
      User u = Helper.localUser;
      List<Cartao> cartoes = new List();
      for (Cartao cartao in v) {
        if (cartao.number != c.number) {
          cartoes.add(cartao);
        }
      }
      u.cartoes = cartoes;
      Helper.localUser = u;
      print('CHEGOU AQUI ${Helper.localUser.cartoes.toString()}');
      return Helper.storage
          .write(
          key: 'Cartoes' + Helper.localUser.id,
          value: json.encode(Helper.localUser.cartoes))
          .then((v) {
        clc.addCardToList();
        return true;
      }).catchError((err) {
        print('Erro ao Salvar Cartão');
      });
    });
  }
  @override
  void dispose() {
    controller_id.close();
    controller_user_id.close();
    controller_expiration_month.close();
    controller_expiration_year.close();
    controller_number.close();
    controller_cvc.close();
    controller_hash.close();
    controller_card_color_index.close();
    controller_owner_name.close();
    _cardColors.close();
    controller_card_type.close();
  }

  void SelectCardColor(int i) {
    print('RODANDO COR SELECIONADA');
    CardColor.cardColors.forEach((color) => color.isSelected = false);
    CardColor.cardColors[i].isSelected = true;
    InCardColor(CardColor.cardColors);
    Incard_color_index(i);
  }
}
