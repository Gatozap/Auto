import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    try {
      var words = widget.user.nome.split(' ');
      for (String word in words) {
        initials += word.split('')[0].toUpperCase();
      }
    }catch(err){
      print("ERROR${err.toString()}");
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
                  widget.user.foto != null
                      ? CircleAvatar(
                          radius: ScreenUtil.getInstance().setSp(200),
                          backgroundColor: Colors.purple,
                          backgroundImage:
                              CachedNetworkImageProvider(widget.user.foto))
                      : Container(
                    height: 200,
                        width: 200,
                        child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                        'assets/editar_perfil.png',
                    ),),
                      )
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.user, color: corPrimaria),sb,
                    hText('Nome: ${widget.user.nome}', context),
                  ],
                ),
              ),
              sb,
              widget.user.celular == null
                  ? hText('Não informou número', context)
                  : Padding(
                padding:  EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.mobileAlt, color: corPrimaria),sb,
                        Column(
                          children: <Widget>[
                            hText(
                                'Telefone: ${widget.user.celular}', context),
                          ],
                        ),
                      ],
                    ),
                  ),
              sb,
              Divider(color: corPrimaria),sb,
              hText('   Endereço', context, size: 60),
              sb,
              Divider(color: corPrimaria),

              sb,

              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons
                        .assistant_photo, color: corPrimaria),sb,
                    Column(
                      children: <Widget>[
                        hText(
                            'CEP: ${widget.user.endereco.cep}', context),
                      ],
                    ),
                  ],
                ),
              ),sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.location_city, color: corPrimaria),sb,
                    Column(
                      children: <Widget>[
                        hText(
                            'Estado: ${widget.user.endereco.estado}', context),
                      ],
                    ),
                  ],
                ),
              ),
              sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons
                        .location_city, color: corPrimaria),sb,
                    Column(
                      children: <Widget>[
                        hText(
                            'Cidade: ${widget.user.endereco.cidade}', context),
                      ],
                    ),
                  ],
                ),
              ),
              sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
               
                    hText(
                        'Endereço: ${widget.user.endereco.endereco}', context),
                  ],
                ),
              ),
              sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.home, color: corPrimaria),sb,
                    Column(
                      children: <Widget>[
                        hText(
                            'Bairro: ${widget.user.endereco.bairro}', context),
                      ],
                    ),
                  ],
                ),
              ),
              sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.filter_1, color: corPrimaria),sb,
                    Column(
                      children: <Widget>[
                        hText(
                            'Número: ${widget.user.endereco.numero}', context),
                      ],
                    ),
                  ],
                ),
              ),
              sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.home, color: corPrimaria),sb,
                    Column(
                      children: <Widget>[
                        hText(
                            'Complemento: ${widget.user.endereco.complemento}', context),
                      ],
                    ),
                  ],
                ),
              ),
              sb,
              Divider(color: corPrimaria),sb,
              hText('   Dados Bancarios', context, size: 60),
              sb,
              Divider(color: corPrimaria),

              sb,
              widget.user.conta_bancaria == null
                  ? hText('Não informou Banco', context)
                  : Column(

                    children: <Widget>[

                      hText('Banco: ${widget.user.conta_bancaria}', context),
                    ],
                  ),sb,
              
              Row(
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(left: 60.0),
                    child: Column(
                      children: <Widget>[
                        hText('Agência', context, color: corPrimaria),sb,
                        hText('${widget.user.agencia}', context)
                      ],
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(left: 40.0),
                    child: Column(
                      children: <Widget>[
                        hText('Número da conta', context, color: corPrimaria),sb,
                        hText('${widget.user.numero_conta}', context)
                      ],
                    ),
                  ),
                ],
              ),
              sb,sb,
              Padding(
                padding:  EdgeInsets.only(left: 8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    hText('Nome', context, color: corPrimaria),sb,
                    hText('${widget.user.nome_conta == null? widget.user.nome: widget.user.nome_conta}', context),
                    sb,
                    hText('CPF da conta', context, color: corPrimaria),sb,
                    hText('${widget.user.cpf_conta == null? widget.user.cpf: widget.user.cpf_conta}', context)
                  ],
                ),
              ),
              sb,
              sb,
              sb,
              Divider(color: corPrimaria),sb,
              hText('   Quilometrogem Mensal', context, size: 60),
              sb,
              Divider(color: corPrimaria),

              sb,
              sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                     Container(height: 30,width: 30, child: Image.asset('assets/velocimetro_low.png')),sb,
                    hText('Quilômetros Mínimos: ${widget.user.kmmin}',
                        context),
                  ],
                ),
              ),
              sb,
              Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Container(height: 30,width: 30, child: Image.asset('assets/velocimetro_fast.png')),sb,
                    hText('Quilômetros Máximos: ${widget.user.kmmax}',
                        context),
                  ],
                ),
              ),
              sb,

              sb,
              Divider(color: corPrimaria),sb,
              hText('   Atendimentos e períodos', context, size: 60),
              sb,
              Divider(color: corPrimaria),

              sb,
              Padding(
                padding:  EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  hText('Atende em Festas? ', context,
             ),
                    widget.user.atende_festa == true
                        ? hText('Sim', context, color: Colors.green)
                        : hText('Não', context, color: Colors.red)


                  ],

                ),
              ),sb,
              Padding(
                padding:  EdgeInsets.only(left: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  hText('Atende em Finais de Semana? ', context,
                     ),
                  widget.user.atende_fds == true
                      ? hText('Sim', context, color: Colors.green)
                      : hText('Não', context, color: Colors.red),],),
              ),sb,
              Padding(
                padding:  EdgeInsets.only(left: 20.0),
                child: Row(

                  children: <Widget>[
                    hText('Circula pela parte da manhã? ', context,
                    ),
                    widget.user.manha == true
                        ? hText('Sim', context, color: Colors.green)
                        : hText('Não', context, color: Colors.red)

                  ],

                ),
              ),sb,
              Padding(
                padding:  EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    hText('Circula pela parte da tarde? ', context,
                    ),
                    widget.user.tarde == true
                        ? hText('Sim', context, color: Colors.green)
                        : hText('Não', context, color: Colors.red)


                  ],

                ),
              ),sb,
              Padding(
                padding:  EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    hText('Circula pela parte da noite? ', context,
                    ),
                    widget.user.noite == true
                        ? hText('Sim', context, color: Colors.green)
                        : hText('Não', context, color: Colors.red)


                  ],

                ),
              ),sb,
            ],
          ),
        )),
      ),
    );
  }
}
