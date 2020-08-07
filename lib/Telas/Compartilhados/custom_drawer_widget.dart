import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Corrida.dart';
import 'package:autooh/Objetos/Distancia.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/AdminPage.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/EstatisticaPage.dart';
import 'package:autooh/Telas/Carro/CadastrarNovoCarroPage.dart';
import 'package:autooh/Telas/Carro/EditarCarroPage.dart';
import 'package:autooh/Telas/Perfil/EditarPerfilPage.dart';
import 'package:autooh/Telas/Carro/ListaCarroPage.dart';
import 'package:autooh/Telas/Perfil/PerfilController.dart';
import 'package:autooh/Telas/Perfil/PerfilVistoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Telas/Login/Login.dart';
import 'package:autooh/Telas/Versao/VersaoPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomDrawerWidget extends StatefulWidget {
  @override
  CustomDrawerWidgetState createState() {
    return new CustomDrawerWidgetState();
  }

  User user;
  Carro carro;
  Campanha campanha;
  Distancia distancia;
  Corrida corrida;
  CustomDrawerWidget(
      {this.user, this.carro, this.campanha, this.corrida, this.distancia});
}

PerfilController pfcontroller;
User u;

class CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    if (pfcontroller == null) {
      pfcontroller = PerfilController(widget.user);
    }
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.topLeft,
        end: FractionalOffset.bottomRight,
        colors: <Color>[
          Color.fromRGBO(0, 168, 180, 100),
          Colors.indigo,
        ],
      ),
    );
    return Drawer(
        child: Stack(children: <Widget>[
      Scrollbar(
        child: Container(
          decoration: linearGradient,
          height: getAltura(context),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .1, left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 100,
                          height: 100,
                          child: Helper.localUser.foto != null
                              ? Image(
                                  image: CachedNetworkImageProvider(
                                      Helper.localUser.foto))
                              : Image.asset('assets/foto_perfil.png')),
                      /*CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(Helper
                                    .localUser !=
                                null
                            ? Helper.localUser.foto != null
                                ? Helper.localUser.foto
                                : 'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'
                            : 'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'),
                      ),*/
                      SizedBox(
                        width: 5,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Helper.localUser != null
                                  ? Helper.localUser.nome != null
                                      ? Helper.localUser.nome.length > 15
                                          ? Helper.localUser.nome
                                                  .substring(0, 15) +
                                              '...'
                                          : Helper.localUser.nome
                                      : 'Carregando usuário'
                                  : 'Carregando usuário',
                              style: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontSize: 24,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            /*Text(
                              Helper.localUser != null
                                  ? Helper.localUser.nome != null
                                      ? '@' +
                                          Helper.localUser.nome
                                              .replaceAll(' ', '.')
                                      : ''
                                  : '',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontStyle: FontStyle.italic),
                            ),*/
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                sb,
                sb,
                menuButton(
                    context, 'Editar Perfil', FontAwesomeIcons.user, true, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditarPerfilPage(
                            user: Helper.localUser,
                          )));
                }),
                menuButton(
                    context, 'Editar Meu Carro', FontAwesomeIcons.carSide, true,
                    () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ListaCarroPage(carro: widget.carro)));
                }),
                Helper.localUser.permissao == 10
                    ? menuButton(
                        context, 'Meus Percursos', FontAwesomeIcons.route, true,
                        () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EstatisticaPage(user: Helper.localUser)));
                      })
                    : Container(),
                /*menuButton(context, 'Cadastrar Novos Carros', Icons.directions_car, true, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CadastrarNovoCarroPage(
                          carro: widget.carro, campanha: widget.campanha,
                      )));
                }),*/

                Helper.localUser.permissao >= 5
                    ? menuButton(context, 'Painel do Administrador',
                        FontAwesomeIcons.wrench, true, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AdminPage(
                                  user: widget.user,
                                  campanha: widget.campanha,
                                  carro: widget.carro,
                                  corrida: widget.corrida,
                                  distancia: widget.distancia,
                                )));
                      })
                    : Container(),
                menuButton(context, 'Sair', Icons.exit_to_app, true, () {
                  doLogout(context);
                }),
                CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VersaoPage()));
                  },
                  child: Text(
                    'Versão',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }

  separator(context) {
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 2,
        color: Colors.grey[200]);
  }

  Widget menuButton(context, text, icon, isLogout, onPress, {color}) {
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        child: MaterialButton(
          onPressed: onPress,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Icon(
                icon,
                color: Colors.yellowAccent,
                size: 24,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                  child: Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
              ))
              //Icon(Icons.arrow_forward_ios)
            ],
          ),
        ));
  }

  doLogout(context) async {
    Helper.fbmsg.unsubscribeFromTopic(Helper.localUser.id);
    await FirebaseAuth.instance.signOut();
    Helper.localUser = null;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
}
