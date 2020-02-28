import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Instagram.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:rxdart/rxdart.dart';

class LoginController implements BlocBase {
  BehaviorSubject<User> _UserController = new BehaviorSubject<User>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Stream<User> get outUser => _UserController.stream;

  Sink<User> get inUser => _UserController.sink;

  LoginController() {
    /* http.get('').then((response) {
      var j = json.decode(response.body);
      for (var v in j) {}
    });*/
  }

  onError(err) {
    print('Error: ${err.toString()}');
  }

  Future logInApple() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    print('RESULT STATUS ${result.status}');
    switch (result.status) {
      case AuthorizationStatus.authorized:
        print('LOGOU');
        print(result.credential);
        return _auth
            .createUserWithEmailAndPassword(
                email: result.credential.email, password: 'NutrannoIOS')
            .then((user) async {
          User data = new User.Empty();
          data.created_at = DateTime.now();
          data.nome = result.credential.fullName.nickname;
          data.email = user.user.email;
          data.foto = user.user.photoUrl;
          data.data_nascimento = null;
          data.id = user.user.uid;
          data.updated_at = DateTime.now();
          data.isEmailVerified = user.user.isEmailVerified;
          data.tipo = 'Apple';
          data.isAlowed = true;
          data.permissao = 0;
          Helper().setUserType('Apple');
          Helper.localUser = await CadastrarUsuario(data);
          Helper.user = user.user;
          Helper().LogUserData(Helper.localUser);
          return 0;
        }).catchError((err) {
          print('Error: ${err.toString()}');
          return _auth
              .signInWithEmailAndPassword(
                  email: result.credential.email, password: 'NutrannoIOS')
              .then((user) {
            FirebaseUser u = user.user;
            if (user != null) {
              return userRef.document(u.uid).get().then((d) {
                Helper.localUser = User.fromJson(d.data);
                Helper.user = u;
                Helper().LogUserData(Helper.localUser);
                Helper().setUserType('Apple');
                return 0;
              }).catchError((err) {
                print('Login Error: ${err.toString()}');
                return 1;
              });
            } else {
              return 1;
            }
          }).catchError((err) {
            print('Login Error: ${err.toString()}');
            return 1;
          });
        });
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        return 1;
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        return 1;
        break;
    }
  }

  Future LoginGoogle() async {
    return _googleSignIn.signIn().then((googleUser) async {
      print(googleUser.toString());
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      User data = new User.Empty();
      data.created_at = DateTime.now();
      data.nome = user.displayName;
      data.email = user.email;
      data.foto = user.photoUrl;
      data.data_nascimento = null;
      data.id = user.uid;
      data.updated_at = DateTime.now();
      data.isEmailVerified = user.isEmailVerified;
      data.tipo = 'Google';
      data.isAlowed = true;
      data.permissao = 0;

      Helper().setUserType('Google');
      Helper.localUser = await CadastrarUsuario(data);
      Helper.user = user;
      Helper().LogUserData(Helper.localUser);
      return 0;
    }).catchError((err) {
      print('Erro no Login com Google ${err.toString()}');
    });
  }

  Future LoginInstagram() async {
    Token t = await getToken();
    Helper().setUserType('Instagram');
    return _auth
        .signInWithEmailAndPassword(
            email: t.id + '@instagram.com', password: '123456')
        .then((result) async {
      FirebaseUser user = result.user;
      if (user != null) {
        User data = new User.Empty();
        data.created_at = DateTime.now();
        data.nome = user.displayName;
        data.email = t.id + '@instagram.com';
        data.foto = user.photoUrl;
        data.data_nascimento = null;
        data.id = user.uid;
        data.updated_at = DateTime.now();
        data.isEmailVerified = user.isEmailVerified;
        data.tipo = 'Instagram';
        data.isAlowed = true;
        print('Logou');
        Helper.localUser = data;
        Helper.user = user;
        return 0;
      } else {
        AuthResult authResult = await _auth.createUserWithEmailAndPassword(
            email: t.id + '@instagram.com', password: '123456');
        FirebaseUser user = authResult.user;
        UserUpdateInfo upi = new UserUpdateInfo();
        upi.photoUrl = t.profile_picture;
        upi.displayName = t.username;
        user.updateProfile(upi).then((t) {}).catchError((err) {
          print('ERRO AQUI FDP ${err.toString()}');
        });
        User data = new User.Empty();
        data.created_at = DateTime.now();
        data.nome = user.displayName;
        data.email = t.id + '@instagram.com';
        data.foto = user.photoUrl;
        data.data_nascimento = null;
        data.id = user.uid;
        data.updated_at = DateTime.now();
        data.isEmailVerified = user.isEmailVerified;
        data.tipo = 'Instagram';
        data.isAlowed = true;
        data.permissao = 0;

        Helper().setUserType('Instagram');
        Helper.localUser = await CadastrarUsuario(data);
        Helper.user = user;
        Helper().LogUserData(Helper.localUser);
        Helper.user = user;
        return 0;

        print('AQUI USUARIO ${user.toString()}');
      }
    }).catchError((err) async {
      onError(err);
      AuthResult auth = await _auth.createUserWithEmailAndPassword(
          email: t.id + '@instagram.com', password: '123456');
      FirebaseUser user = auth.user;
      UserUpdateInfo upi = new UserUpdateInfo();
      upi.photoUrl = t.profile_picture;
      upi.displayName = t.username;
      user.updateProfile(upi).then((t) {}).catchError((err) {
        print('ERRO AQUI FDP ${err.toString()}');
      });
      ;
      User data = new User.Empty();
      data.created_at = DateTime.now();
      data.nome = user.displayName;
      data.email = t.id + '@instagram.com';
      data.foto = user.photoUrl;
      data.data_nascimento = null;
      data.id = user.uid;
      data.updated_at = DateTime.now();
      data.isEmailVerified = user.isEmailVerified;
      data.tipo = 'Instagram';

      userRef.document(user.uid).setData(data.toJson()).then((v) {
        print('Salvou a porra do Usuario');
      }).catchError((err) {
        print('Erro salvado Usuario: ${err.toString()}');
      });
      Helper.localUser = data;
      Helper.user = user;
      Helper().LogUserData(Helper.localUser);
      return 0;

      print('AQUI USUARIO ${user.toString()}');
    });
  }

  Future<User> getUserfacebookProfile(result) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    print(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final user = json.decode(graphResponse.body);
    print(user);

    User data = new User.Empty();
    data.created_at = DateTime.now();
    data.nome = user['name'];
    data.email = user['email'];
    data.foto =
        'https://graph.facebook.com/${user['id']}/picture?fields=picture.width(720).height(720)';
    data.data_nascimento = null;
    data.id = user['id'];
    data.updated_at = DateTime.now();
    data.isEmailVerified = true;
    data.tipo = 'Facebook';
    data.permissao = 0;
    data.isAlowed = true;

    return data;
  }

  /*Future LoginTwitter() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: 'PFaXsKzjtBFewWjbFvPlUmW6R   ',
      consumerSecret: 'Vsgqiautu8KWjApPrpkOMtZDcF6mhr9JCg8cyPAw6SOVgnrRII ',
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        //return'Logged in! username: ${result.session.username}';
        final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: result.session.token,
            authTokenSecret: result.session.secret);
        final FirebaseUser user = await _auth.signInWithCredential(credential);

        print('AQUI USUARIO ${user.toString()}');
        final FirebaseUser currentUser = await _auth.currentUser();
        Helper().setUserType('Twitter');
        if (user != null) {
          User data = new User.Empty();
          data.created_at = DateTime.now();
          data.nome = user.displayName;
          data.email = user.email;
          data.foto = user.photoUrl;
          data.data_nascimento = null;
          data.id = user.uid;
          data.updated_at = DateTime.now();
          data.isEmailVerified = user.isEmailVerified;
          data.tipo = 'Twitter';

          databaseReference
              .document(user.uid)
              .setData(data.toJson())
              .catchError((err) {
            print('Erro salvado Usuario: ${err.toString()}');
          });

          databaseReference.document(user.uid).get().then((d) {
            Helper.localUser = User.fromJson(d.data);
            Helper.user = currentUser;
            Helper().LogUserData(Helper.localUser);
            return 0;
          });
        } else {
          return 'Failed to sign in with Twitter. ';
        }
        break;
      case TwitterLoginStatus.cancelledByUser:
        return 'Login cancelled by user.';
        break;
      case TwitterLoginStatus.error:
        return 'Login error: ${result.errorMessage}';
        break;
    }
  }
*/
  Future<User> CadastrarUsuario(User data) {
    return userRef.document(data.id).get().then((snap) {
      if (snap.data != null) {
        return User.fromJson(snap.data);
      } else {
        return userRef.document(data.id).setData(data.toJson()).then((v) {
          return data;
        }).catchError((err) {
          print('Erro salvando Usuario: ${err.toString()}');
        });
      }
    });
  }

  Future LoginFacebook() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        User data = await getUserfacebookProfile(result);

        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: accessToken.token,
        );
        AuthResult authResult = await _auth.signInWithCredential(credential);
        FirebaseUser user = authResult.user;
        data.id = user.uid;

        Helper().setUserType('Facebook');
        Helper.localUser = await CadastrarUsuario(data);
        Helper.user = user;
        Helper().LogUserData(Helper.localUser);

        Helper().setUserType('Facebook');
        return 0;
        break;
      case FacebookLoginStatus.cancelledByUser:
        facebookSignIn.logOut();
        return 'Login cancelled by the user.';
        break;
      case FacebookLoginStatus.error:
        facebookSignIn.logOut();
        return 'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}';
        break;
    }
  }

  @override
  void dispose() {
    _UserController.close();
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

  Future LoginEmail({String email, String password}) {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      FirebaseUser user = result.user;
      if (user != null) {
        return userRef.document(user.uid).get().then((d) {
          Helper.localUser = User.fromJson(d.data);
          Helper.user = user;
          Helper().LogUserData(Helper.localUser);
          Helper().setUserType('Email');
          return true;
        }).catchError((err) {
          print('Login Error: ${err.toString()}');
          return false;
        });
      } else {
        return false;
      }
    }).catchError((err) {
      print('Login Error: ${err.toString()}');
      return false;
    });
  }
}
