import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Card/cartoes_page.dart';
import 'package:autooh/Telas/Marketplace/Pedidos/PedidosPage.dart';
import 'package:autooh/Telas/Perfil/EditarPerfilPage.dart';
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
  CustomDrawerWidget({this.user});

}
PerfilController pfcontroller;
  User u;
class CustomDrawerWidgetState extends State<CustomDrawerWidget> {

  @override
  Widget build(BuildContext context) {
    if (pfcontroller == null) {
      pfcontroller = PerfilController(widget.user);
    }
    return Drawer(
      child: Scrollbar(
        child: Container(
          color: corPrimaria,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .1, left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PerfilVistoPage(user: Helper.localUser)));
                  },
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(Helper
                                    .localUser !=
                                null
                            ? Helper.localUser.foto != null
                                ? Helper.localUser.foto
                                : 'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'
                            : 'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'),
                      ),
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
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontStyle: FontStyle.normal),
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
                SizedBox(height: 10),
                separator(context),
                SizedBox(
                  height: 8,
                ),
                Helper.localUser.isPrestador == true
                    ? hText(
                    'Você é Prestador de serviços', context,color: Colors.white, size: 45 )
                    : menuButton(context, 'Desejo me Tornar Prestador',
                    Icons.assignment_ind, true, () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {

                            return AlertDialog(
                              content: Container(
                                color: Colors.white,
                                width: getLargura(context),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    hText(
                                      'Deseja tornar Prestador do Autooh? Caso sim não poderá voltar a ser cliente com este perfil',
                                      context,
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          defaultActionButton('Não', context,
                                                  () {
                                                Navigator.of(context).pop();
                                              },  icon: null),
                                          defaultActionButton('Sim', context,
                                                  () {
                                                widget.user.isPrestador = true;
                                                pfcontroller
                                                    .updateUser(widget.user)
                                                    .then((v) {
                                                  if (v ==
                                                      'Atualizado com sucesso!') {
                                                    dToast(
                                                        'É necessário você anexar os documentos para a verificação da veracidade.\n Toque no botão Anexar Documentos', timeInSecForIoss: 10);
                                                  } else {
                                                    dToast(
                                                        'Dado atualizados com sucesso!');
                                                  }
                                                });
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditarPerfilPage(
                                                              user: Helper
                                                                  .localUser,
                                                            )));


                                              }, icon: null)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
                menuButton(context, 'Editar Perfil', Icons.person, true, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditarPerfilPage(
                            user: Helper.localUser,
                          )));
                }),
                menuButton(context, 'Meus Cartões', MdiIcons.creditCard, true,
                    () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CartoesPage()));
                }),

                menuButton(context, 'Meus Pedidos', Icons.shopping_cart, true,
                    () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PedidosPage()));
                }),
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
    );
  }

  separator(context) {
    return Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 2,
        color: Colors.grey[200]);
  }

  Widget menuButton(context, text, icon, isLogout, onPress) {
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
                color: !isLogout ? Colors.white : Colors.white,
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
