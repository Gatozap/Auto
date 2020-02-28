import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Comentario.dart';
import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Objetos/Rating.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Marketplace/Produto/CadastrarProduto/CadastrarProdutoPage.dart';
import 'package:autooh/Telas/Marketplace/Produto/EditarProduto/EditarProdutoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../produto_page.dart';

class ProdutoItem extends StatelessWidget {
  Produto produto;
   User user;
  ProdutoItem({this.produto, this.user});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);

    if (produto.rating != null) {
      print('AQUI MEDIA ${produto.rating.mediaAvaliacoes.toStringAsFixed(2)}');
    }
    String descricaoAbreviada = '';
    String tituloAbreviado = '';
    List char = produto.titulo.split('');
    List chars = produto.descricao.split('');
    if (char.length > 22) {
      for (int i = 0; i < 22; i++) {
        tituloAbreviado= tituloAbreviado+ char[i];

      }
      tituloAbreviado += '...';
    }
    if (chars.length > 70) {
      for (int i = 0; i < 70; i++) {
        descricaoAbreviada= descricaoAbreviada+ chars[i];
        print('${descricaoAbreviada}');
      }
      descricaoAbreviada += '...';
    }

    Comentario topComentario;
    Avaliacao topAvaliacao;
    String stars = '';
    if (produto.comentarios != null) {
      if (produto.comentarios.length != 0) {
        if (produto.rating != null) {
          for (Avaliacao a in produto.rating.avaliacoes) {
            if (topAvaliacao == null) {
              topAvaliacao = a;
            }
            if (a.nota > topAvaliacao.nota) {
              topAvaliacao = a;
            }
          }
          if (topAvaliacao != null) {
            for (Comentario c in produto.comentarios) {
              if (c.senderId == topAvaliacao.user) {
                topComentario = c;
              }
            }
          }
        }
      }
    }
    if (topAvaliacao != null) {
      for (int i = 0; i < topAvaliacao.nota.toInt(); i++) {
        stars += '★';
        //print('AQUI STAR ${ stars}');
      }
    }
    String initials = '';
    if (topComentario != null) {
      var words = topComentario.senderName.split(' ');
      for (String word in words) {
        initials += word.split('')[0].toUpperCase();
      }
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Stack(
        children: <Widget>[
          /// Item card
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 180,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    /// Item description inside a material
                    Container(
                      margin: EdgeInsets.only(top: 24.0),
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(12.0),
                        shadowColor: Color(0x802196F3),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProdutoPage(produto: produto))),
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// Title and rating
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    hText(char.length<25? produto.titulo: tituloAbreviado, context,
                                        color: Colors.blueAccent, size: 55),
                                    produto.rating == null
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: hText(
                                                'Sem avaliações', context,
                                                size: 35))
                                        : RatingBar(
                                            initialRating:
                                                produto.rating.mediaAvaliacoes,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            unratedColor: Colors.grey[100],
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: corPrimaria,
                                                size: ScreenUtil.instance
                                                    .setSp(5)),
                                          ),
                                  ],
                                ),

                                /// Infos
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.green,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: hText(
                                              '\$${produto.preco.toStringAsFixed(2)}',
                                              context,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: hText(
                                                chars.length < 70
                                                    ? '${produto.descricao}'
                                                    : descricaoAbreviada,
                                                context,
                                                size: 35))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Item image
                   produto.fotos == null? Container():produto.fotos.length == 0? Container(): Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(54.0),
                          child: Material(
                            elevation: 20.0,
                            shadowColor: Color(0x802196F3),
                            shape: CircleBorder(),
                            child: Hero(
                              tag: new Text('hero1'),
                              child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      produto.fotos[0]),
                                  radius: (((getAltura(context) +
                                              getLargura(context)) /
                                          2) *
                                      .2)),
                            ),

                          ),

                        ),

                      ),

                    ),
                    produto.criador == Helper.localUser.id? Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: produto.deleted_at == null? IconButton(onPressed: (){
                          showDialog(

                              context: context,
                              builder: (context) {
                                return AlertDialog(

                                  title: hText(
                                      "Deseja deletar este Serviço?",
                                      context),
                                  content:
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <
                                        Widget>[
                                      defaultActionButton(
                                        'Não',
                                        context,
                                            () {

                                          Navigator.of(context)
                                              .pop();
                                        },
                                      ),

                                      defaultActionButton(
                                        'Sim',
                                        context,
                                            () {
                                          produto.deleted_at = DateTime.now();

                                          produtosRef.document(produto.id).updateData(produto.toJson()).then((v){
                                            dToast('Serviço deletado com sucesso!');

                                            Navigator.of(context)
                                                .pop();
                                          });
                                          Navigator.of(context)
                                              .pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        }, icon: Icon(Icons.block),color: Colors.red, ):IconButton(onPressed: (){
                          showDialog(

                              context: context,
                              builder: (context) {
                                return AlertDialog(

                                  title: hText(
                                      "Deseja reativar este Serviço?",
                                      context),
                                  content:
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <
                                        Widget>[
                                      defaultActionButton(
                                        'Não',
                                        context,
                                            () {

                                          Navigator.of(context)
                                              .pop();
                                        },
                                      ),

                                      defaultActionButton(
                                        'Sim',
                                        context,
                                            () {
                                          produto.deleted_at = null;

                                          produtosRef.document(produto.id).updateData(produto.toJson()).then((v){
                                            dToast('Serviço reativado com sucesso!');

                                            Navigator.of(context)
                                                .pop();
                                          });
                                          Navigator.of(context)
                                              .pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        }, icon: Icon(Icons.autorenew),color: Colors.green, ),

                      ),

                    ): Container(),
                    produto.criador == Helper.localUser.id? Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Align(alignment: Alignment.topLeft,child: IconButton(icon: Icon(Icons.sort),color: Colors.black, onPressed: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    CadastrarProdutoPage( produto: produto,)));
                      },)),
                    ):Container(),
                  ],
                )),
          ),

          ///
          /// Review
          produto.comentarios == null
              ? Container()
              : produto.comentarios.length == 0
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(top: 160.0, left: 32.0),
                      child: Material(
                        elevation: 12.0,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Color(0xFF84fab0),
                                Color(0xFF8fd3f4)
                              ],
                                  end: Alignment.topLeft,
                                  begin: Alignment.bottomRight)),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: hText(
                                  '${topComentario.senderName} ${stars}',
                                  context,
                                  size: 35),
                              leading: topComentario.senderFoto != null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.purple,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              topComentario.senderFoto))
                                  : CircleAvatar(
                                      backgroundColor: Colors.purple,
                                      child: hText(initials, context,
                                          color: Colors.white)),

                              // title: hText(comentario.senderName, context),
                              subtitle: hText(topComentario.msg, context,
                                  color: Colors.grey[600], size: 35),
                            ),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

ComentarioRating(Comentario comentario, Produto produto) {}

class BadShopItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Stack(
        children: <Widget>[
          /// Item card
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox.fromSize(
                size: Size.fromHeight(172.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    /// Item description inside a material
                    Container(
                      margin: EdgeInsets.only(top: 24.0),
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(12.0),
                        shadowColor: Color(0x802196F3),
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Color(0xFFDA4453),
                            Color(0xFF89216B)
                          ])),
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// Title and rating
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nike Jordan III',
                                        style: TextStyle(color: Colors.white)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('1.3',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 34.0)),
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 24.0),
                                      ],
                                    ),
                                  ],
                                ),

                                /// Infos
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Bought',
                                        style: TextStyle(color: Colors.white)),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text('3',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Text('times for a profit of',
                                        style: TextStyle(color: Colors.white)),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.green,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('\$ 363',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Item image
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(54.0),
                          child: Material(
                            elevation: 20.0,
                            shadowColor: Color(0x802196F3),
                            shape: CircleBorder(),
                            child: Image.asset('res/shoes1.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          /// Review
          Padding(
            padding: EdgeInsets.only(
              top: 160.0,
              right: 32.0,
            ),
            child: Material(
              elevation: 12.0,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text('AI'),
                  ),
                  title: Text('Ivascu Adrian ★☆☆☆☆'),
                  subtitle: Text(
                      'The shoes that arrived weren\'t the same as the ones in the image...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewShopItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox.fromSize(
            size: Size.fromHeight(172.0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                /// Item description inside a material
                Container(
                  margin: EdgeInsets.only(top: 24.0),
                  child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Title and rating
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('[New] Nike Jordan III',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('No reviews',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0)),
                                ],
                              ),
                            ],
                          ),

                          /// Infos
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Bought', style: TextStyle()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text('0',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              Text('times for a profit of', style: TextStyle()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.green,
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('\$ 0',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Item image
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(54.0),
                      child: Material(
                        elevation: 20.0,
                        shadowColor: Color(0x802196F3),
                        shape: CircleBorder(),
                        child: Image.asset('res/shoes1.png'),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
