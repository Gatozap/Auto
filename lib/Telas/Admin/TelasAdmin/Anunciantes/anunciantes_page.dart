import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/Anunciantes/anunciantes_controller.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ListaUsuarioPage.dart';
import 'package:autooh/Telas/Admin/usuario_item.dart';
import 'package:flutter/material.dart';

class AnunciantesPage extends StatefulWidget {
  Campanha c;
  AnunciantesPage(this.c);

  @override
  _AnunciantesPageState createState() => _AnunciantesPageState();
}

class _AnunciantesPageState extends State<AnunciantesPage> {
  AnunciantesController ac;
  @override
  Widget build(BuildContext context) {
    if (ac == null) {
      ac = AnunciantesController(widget.c.anunciantes);
    }
    return Scaffold(
      appBar: myAppBar('Anunciantes ${widget.c.nome}', context, actions: [
        Helper.localUser.permissao == 5? Container():IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListaUsuarioPage(anunciantes:widget.c)));
          },
        ),
      ]),
      body: Container(
        child: StreamBuilder<List<User>>(
            stream: ac.outAnunciantes,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              if (snapshot.data.length == 0) {
                return Container();
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return UsuarioItem(snapshot.data[index]);
                },
                itemCount: snapshot.data.length,
              );
            }),
      ),
    );
  }
}
