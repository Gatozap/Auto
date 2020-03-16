import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Carteira.dart';

Future AdicionarSaldo(String cliente, int valor) {
  carteirasRef.document(cliente).get().then((v) {
    if (v.data != null) {
      Carteira c = Carteira.fromJson(v.data);
      c.saldo += valor;
      c.updated_at = DateTime.now();
      carteirasRef.document(cliente).updateData(c.toJson()).then((v) {
        return c;
      });
    } else {
      Carteira c = Carteira(
          deleted_at: null,
          updated_at: DateTime.now(),
          created_at: DateTime.now(),
          id: cliente,
          owner: cliente,
          saldo: valor);
      carteirasRef.document(cliente).setData(c.toJson()).then((v) {
        return c;
      });
    }
  });
}

Future RemoverSaldo(String cliente, int valor) {
  carteirasRef.document(cliente).get().then((v) {
    if (v.data != null) {
      Carteira c = Carteira.fromJson(v.data);
      c.saldo -= valor;
      c.updated_at = DateTime.now();
      carteirasRef.document(cliente).updateData(c.toJson()).then((v) {
        return c;
      });
    } else {
      dToast('Carteira não existe');
      return null;
    }
  });
}
