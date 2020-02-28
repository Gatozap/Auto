import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Sala.dart';
import 'package:bocaboca/Telas/Grupo/Chat/CriarGrupo/CriarGrupoPage.dart';
import 'list_grupo_controller.dart';

class ListGrupoPage extends StatefulWidget {
  ListGrupoPage({Key key}) : super(key: key);

  @override
  _ListGrupoPageState createState() => _ListGrupoPageState();
}

class _ListGrupoPageState extends State<ListGrupoPage> {
  ListGrupoController lgc;
  @override
  Widget build(BuildContext context) {
    if (lgc == null) {
      lgc = new ListGrupoController();
    }
    return Scaffold(
      appBar: myAppBar(
        'Procurar Grupos',
        context,
        showBack: true,
      ),
      body: StreamBuilder<List<Sala>>(
        stream: lgc.outGrupos,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          if (snapshot.data.length == 0) {
            return Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Text('Nenhum grupo disponivel, que tal criar o seu?'),),sb,sb,
                MaterialButton(onPressed: (){           Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CriarGrupoPage()));},child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height * .2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width:
                          MediaQuery.of(context).size.width * .9,
                          height: MediaQuery.of(context).size.height *
                              .08,
                          decoration: BoxDecoration(
                              color: corPrimaria,
                              borderRadius:
                              BorderRadiusDirectional.all(
                                  Radius.circular(60))),
                          child: Center(
                              child: Text(
                                'Criar Grupo',
                                style: estiloTextoBotao,
                                )),
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                      ],
                      )),)
              ],
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return GrupoListItem(snapshot.data[index]);
            },
            itemCount: snapshot.data.length,
          );
        },
      ),
    );
  }

  Widget GrupoListItem(Sala s) {
    int NonReads = 0;
    String avatarPic;
    var partnerName = '';
    // print('AQUI META  >>>> ${i[Helper.localUser.id]}');
    partnerName = s.name;
    print('AQUI FOTO ${s.foto}');
    if(s.foto != null) {
      avatarPic = s.foto;
    }
    double radius = ((MediaQuery.of(context).size.width * .03) +
            (MediaQuery.of(context).size.height * .03)) /
        2;
    String otherUserId;
    for (var i in s.membros) {
      if (i != Helper.localUser.id) {
        otherUserId = i;
      }
    }
    return MaterialButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(title:Text('Deseja fazer parte do Grupo: ${s.name}?',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      ),
                    ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: myOrange,
                  ),
                MaterialButton(
                  child: Text(
                    'Pedir para Entrar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                   if(s.pedidos == null){
                     s.pedidos = new List();
                   }
                   s.pedidos.add(Helper.localUser.id);
                   lgc.askToJoin(s);
                   Navigator.of(context).pop();
                   },
                  color: corPrimaria,
                )
              ],
            );
          },
        );
      },
      child: Card(
        elevation: 2,
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: avatarPic == null?                AssetImage('https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'): CachedNetworkImageProvider(avatarPic),
                        radius: radius,backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        s.lastMessage != null
                            ? Text(
                                s.name,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        SizedBox(
                          height: 3,
                        ),
                        /*LimitedBox(
                          maxHeight: MediaQuery.of(context).size.height * .3,
                          maxWidth: MediaQuery.of(context).size.width * .5,
                          child: s.lastMessage != null
                                 ? NonReads != 0
                                   ? Text(
                            s.lastMessage.msg == null
                            ? 'Enviou uma Foto'
                            : s.lastMessage.msg,
                            softWrap: true,
                            )
                                   : Text(
                              s.lastMessage.msg == null
                              ? 'Enviou uma Foto'
                              : s.lastMessage.msg,
                              softWrap: true)
                                 : Container(),
                          ),*/
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            s.lastMessage != null
                                ? Text(
                                    s.updated_at.day != DateTime.now().day
                                        ? '${s.updated_at.day}/${s.updated_at.month} - ${s.updated_at.hour}:${s.updated_at.minute}'
                                        : '${s.updated_at.hour}:${s.updated_at.minute}',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
