import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:rxdart/subjects.dart';

class LoginEmailController implements BlocBase {
  BehaviorSubject<User> userController = new BehaviorSubject<User>();

  Stream<User> get outuser => userController.stream;

  Sink<User> get inuser => userController.sink;

  LoginEmailController() {}

  @override
  void dispose() {
    userController.close();
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
