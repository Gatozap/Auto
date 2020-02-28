import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Objetos/Endereco.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Perfil/ui/frienddetails/footer/friend_detail_footer.dart';
import 'package:autooh/Telas/Perfil/ui/frienddetails/friend_detail_body.dart';
import 'package:autooh/Telas/Perfil/ui/frienddetails/header/friend_detail_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'PerfilController.dart';
import 'addEnderecoController.dart';

class PerfilVistoPage extends StatefulWidget {
  User user;
  Produto produto;
  PerfilVistoPage({Key key, this.user, this.produto}) : super(key: key);

  @override
  _PerfilVistoPageState createState() => _PerfilVistoPageState();
}

PerfilController perfilController;
AddEnderecoController aec;
User u;
Produto p;
class _PerfilVistoPageState extends State<PerfilVistoPage> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF1E88E5),
          const Color(0xFF1E88E5),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(

          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               FriendDetailHeader(
                user: widget.user,

              ),
               Padding(
                padding: const EdgeInsets.all(24.0),
                child:  FriendDetailBody(widget.user),
              ),
               FriendShowcase(user: widget.user, produto: widget.produto,),
            ],
          ),
        ),
      ),
    );
  }
}
