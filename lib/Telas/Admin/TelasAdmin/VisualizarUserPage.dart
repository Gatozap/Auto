import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VisualizarUserPage extends StatefulWidget {
  User user;
  VisualizarUserPage({Key key, this.user}) : super(key: key);

  @override
  _VisualizarUserPageState createState() {
    return _VisualizarUserPageState();
  }
}

class _VisualizarUserPageState extends State<VisualizarUserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String initials = '';
    var words = widget.user.nome.split(' ');
    for (String word in words) {
      initials += word.split('')[0].toUpperCase();
    }
    // TODO: implement build
    return Scaffold(
      appBar: myAppBar('Perfil de ${widget.user.nome}', context),
      body: Container(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: widget.user.id,
                    child: widget.user.foto != null
                        ? CircleAvatar(
                            radius: ScreenUtil.getInstance().setSp(200),
                            backgroundColor: Colors.purple,
                            backgroundImage:
                                CachedNetworkImageProvider(widget.user.foto))
                        : CircleAvatar(
                            radius: ScreenUtil.getInstance().setSp(200),
                            backgroundColor: Colors.purple,
                            child: hText(initials, context,
                                size: 150, color: Colors.white)),
                  )
                ],
              ),
              hText('Nome: ${widget.user.nome}', context),
              sb,
              widget.user.celular == null
                  ? hText('Não informou número', context)
                  : hText(
                      'Telefone para contato: ${widget.user.celular}', context),
              sb,
              widget.user.conta_bancaria == null
                  ? hText('Não informou Banco', context)
                  : hText('Banco: ${widget.user.conta_bancaria}', context),
              sb,
              hText('Agência: ${widget.user.agencia}', context),
              sb,
              hText('Número da conta: ${widget.user.numero_conta}', context),
              sb,
              hText('Quilômetros Mínimos que roda: ${widget.user.kmmin}',
                  context),
              sb,
              hText('Quilômetros Máximos que roda: ${widget.user.kmmax}',
                  context),
              sb,
              Row(
                children: <Widget>[
                hText('Atende em Festas', context,
             ),
                  widget.user.atende_festa == true
                      ? Icon(
                          MdiIcons.checkBold,
                          color: Colors.green,
                        )
                      : Icon(
                          MdiIcons.close,
                          color: Colors.red,
                        ),


                ],

              ),sb,
              Row(children: <Widget>[
                hText('Atende em Finais de Semana', context,
                   ),
                widget.user.atende_fds == true
                    ? Icon(
                  MdiIcons.checkBold,
                  color: Colors.green,
                )
                    : Icon(
                  MdiIcons.close,
                  color: Colors.red,
                ),],)
            ],
          ),
        )),
      ),
    );
  }
}
