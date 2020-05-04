import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/PhotoScroller.dart';
import 'package:autooh/Objetos/Documento.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PortfolioShowcase extends StatelessWidget {
    User user;
    Produto produto;

    PortfolioShowcase({this.user, this.produto});
  List<Widget> _buildItems() {
    var items = <Widget>[];

    for (var i = 1; i <= 6; i++) {
     // var image =  user.foto != null? Image(image: CachedNetworkImageProvider( user.foto)):Container();


       
         // items.add(image);

    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 1,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );

    return  GridView(
      shrinkWrap: true,

      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children:<Widget>[ user.isPrestador? documentosWidget(user.documentos): Container()]
    );
  }
    Widget documentosWidget (List<Documento> documentos){
      List fotos = new List();
      for(Documento d in documentos){
        if(d.frente != null){
          fotos.add(d.frente);
        }
        if (d.verso != null) {
          fotos.add(d.verso);

        }

      }
      return PhotoScroller(fotos, largura: 340.0, altura: 270.0, fractionsize: 1,);
    }

}
