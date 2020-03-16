import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:rxdart/subjects.dart';

class CadastroEmailController implements BlocBase {
  BehaviorSubject<User> userController = new BehaviorSubject<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance.collection('Users').reference();

  Stream<User> get outUser => userController.stream;

  Sink<User> get inUser => userController.sink;

  CadastroEmailController() {
    inUser.add(User.Empty());
    /*http
        .get(
           '')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
      }
    });*/
  }

  @override
  void dispose() {
    userController.close();
  }

  registerUser(User data) {
    return _auth
        .createUserWithEmailAndPassword(
            email: data.email.toLowerCase().replaceAll(' ', ''),
            password: data.senha)
        .then((result) {
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      data.created_at = DateTime.now();
      data.id = user.uid;
      data.senha = null;
      data.foto = user.photoUrl;
      data.updated_at = DateTime.now();
      data.isEmailVerified = user.isEmailVerified;
      data.tipo = 'Email';

      databaseReference.document(user.uid).setData(data.toJson()).then((v) {
        _auth.signOut();
      }).catchError((err) {});
      return 0;
    }).catchError((err) {
      print('Err: ${err.toString()}');
      erros(err.toString());
    });
  }

  erros(data) {
    switch (data) {
      case 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)':
        dToastTop('E-mail já existe, tente outro e-mail');
        break;

      case 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)':
        dToastTop(
            'Insira um e-mail válido contendo @hotmail.com ou @gmail.com e entre outros');
        break;

      default: dToastTop(data);
        break;
    }
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }
}
