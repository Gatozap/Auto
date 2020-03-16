import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/VisualizarUserPage.dart';
import 'package:autooh/Telas/Carro/EditarCarroPage.dart';
import 'package:autooh/Telas/Perfil/PerfilController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';





class ListaUsuarioPage extends StatefulWidget {
  Carro carro;
  User user;
  ListaUsuarioPage({
    Key key,this.carro,this.user
  }) : super(key: key);

  @override
  ListaUsuarioPageState createState() {
    return ListaUsuarioPageState();
  }
}

class ListaUsuarioPageState extends State<ListaUsuarioPage> {
    PerfilController pc;
  @override
  void initState() {
    super.initState();
    if (pc == null) {
      pc = new PerfilController(widget.user);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: myAppBar('Lista de Carros', context),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<User>>(
              builder: (context, AsyncSnapshot<List<User>> snapshot) {

                if (snapshot.data == null) {
                  return Loading(completed: Text('Erro ao Buscar Usuarios'));
                }
                if (snapshot.data.length == 0) {
                  return Loading(
                      completed: Text('Nenhum Usuario encontrado'));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      User p = snapshot.data[index];

                      return CarroListItem( p);
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              },
              stream: pc.outUsers,
            )
          ],
        ),
      ),
    );
  }

  Widget CarroListItem(User p) {
    String initials = '';
    var words = p.nome.split(' ');
    for (String word in words) {
      initials += word.split('')[0].toUpperCase();
    }
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VisualizarUserPage(
                user: p
            )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Hero(
                tag: p.id,
                child: p.foto != null
                    ? CircleAvatar(
                    radius: ScreenUtil.getInstance().setSp(120),
                    backgroundColor: Colors.purple,
                    backgroundImage:
                    CachedNetworkImageProvider(p.foto))
                    : CircleAvatar(
                    radius: ScreenUtil.getInstance().setSp(120),
                    backgroundColor: Colors.purple,
                    child: hText(initials, context,
                        size: 150, color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Container(
                  width: getLargura(context)*.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(

                        child: p.nome == null? hText('Nome não informado', context, size: 44):hText('Nome: ${p.nome}', context,
                            size: 44, weight: FontWeight.bold),

                      ),sb,
                       Container(
                         width: getLargura(context),
                         child: p.celular == null? hText('Não possui telefone', context, size: 44):hText('${p.celular}', context, size: 44),),sb,


                     Container(child: p.conta_bancaria ==null? hText('Não informou seu Banco', context, size: 44) :  hText(
                       'Banco: ${p.conta_bancaria}',
                       context,
                       size: 44,

                     ), )



                    ],
                  ),
                ),
              ),

            ],
          ),

        ),
      ),
    );
  }
}
