import 'dart:async';

class Validators {
  final validateCardHolderName = StreamTransformer<String, String>.fromHandlers(
      handleData: (cardHolderName, sink) {
    RegExp('[a-zA-Z]').hasMatch(cardHolderName)
        ? sink.add(cardHolderName.toUpperCase())
        : sink.addError('Nome Invalido');
  });

  final validateCardNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (cardNumber, sink) {
    //1st Regular Expression to Validate Credit Card Number
    RegExp(
                r'^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$')
            //2nd Regular Expression to remove white spaces
            .hasMatch(cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), ''))
        ? sink.add(cardNumber)
        : cardNumber.length == 19
            ? sink.addError('Numero do cartão invalido')
            : sink.add(cardNumber);
  });

  final validateCardMonth =
      StreamTransformer<int, int>.fromHandlers(handleData: (cardMonth, sink) {
    if (cardMonth != null && cardMonth > 0 && cardMonth < 13) {
      sink.add(cardMonth);
    } else {
      sink.addError('Mês Invalido');
    }
  });

  final validateCardYear =
      StreamTransformer<int, int>.fromHandlers(handleData: (cardYear, sink) {
    if (cardYear != null &&
        cardYear > DateTime.now().year &&
        cardYear < DateTime.now().year + 10) {
      sink.add(cardYear);
    } else {
      sink.addError('Ano Invalido');
    }
  });

  final validateCardVerificationValue =
      StreamTransformer<int, int>.fromHandlers(handleData: (cardCvv, sink) {
    if (cardCvv.toString().length > 1) {
      sink.add(cardCvv);
    } else {
      sink.addError('CVV Invalido');
    }
  });
}
