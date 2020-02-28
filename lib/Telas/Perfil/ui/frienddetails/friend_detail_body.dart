import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Documento.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Perfil/PerfilVistoPage.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FriendDetailBody extends StatelessWidget {
  User user;
  FriendDetailBody(this.user);

  Widget _buildLocationInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
         Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            '${user.endereco.cidade} - ${user.endereco.estado} ',
            style: textTheme.subhead.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color, text) {
    return GestureDetector(
      onTap: (){
        dToast(text);
      },
      child: new Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: new CircleAvatar(
          backgroundColor: color,

          child:

          user.antecedentes == true? Icon(
            iconData,
            color: Colors.red,

            size: 25.0,
          ): Icon(
    iconData,
    color: corPrimaria,

    size: 25.0),
          radius: 23.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    bool isValidado = false;
      for(Documento d in user.documentos){
        if(d.isValid){
            isValidado = true;
        }
      }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          user.nome,
          style: textTheme.headline.copyWith(color: Colors.white),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Column(
            children: <Widget>[
              Text(
                'Endereço: ${user.endereco.endereco} ',
                  style: textTheme.headline.copyWith(color: Colors.white, fontSize: 16)

              )

            ],
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              user.isPrestador == true?_createCircleBadge(Icons.store, Colors.white, '${user.nome} É Prestador de serviço'): Container(),
              user.antecedentes == null?  Container(): user.antecedentes == true? _createCircleBadge(MdiIcons.redhat, Colors.white, 'Possui antecedentes criminais'):_createCircleBadge(MdiIcons.redhat, Colors.white, '${user.nome} verificado pela equipe Autooh') ,
              isValidado?_createCircleBadge(Icons.backup, Colors.white, 'Documentos de ${user.nome} são válidos e autênticos'): Container(),
            ],
          ),
        )
      ],
    );
  }
}
