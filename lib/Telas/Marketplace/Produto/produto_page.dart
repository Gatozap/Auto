import 'package:bocaboca/Helpers/Helper.dart';
import 'package:bocaboca/Helpers/PhotoScroller.dart';
import 'package:bocaboca/Helpers/References.dart';
import 'package:bocaboca/Helpers/Styles.dart';
import 'package:bocaboca/Objetos/Comentario.dart';
import 'package:bocaboca/Objetos/Message.dart';
import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Objetos/ProdutoPedido.dart';
import 'package:bocaboca/Objetos/Rating.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Dialogs/RatingDialog.dart';
import 'package:bocaboca/Telas/Grupo/Chat/ChatScreen/ChatPage.dart';
import 'package:bocaboca/Telas/Perfil/PerfilVistoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'CadastrarProduto/CadastrarProdutoController.dart';
import 'ProdutoGeneralController.dart';
import 'ProdutoPageController.dart';

class ProdutoPage extends StatefulWidget {
  Produto produto;

  ProdutoPage({this.produto});

  @override
  _ProdutoPageTestState createState() => _ProdutoPageTestState();
}

class _ProdutoPageTestState extends State<ProdutoPage> {
  ProdutoPageController ppc;
  CadastrarProdutoController cpc;
  Produto produto;
  @override
  Widget build(BuildContext context) {
    if (ppc == null) {
      ppc = ProdutoPageController(widget.produto);
    }
    String tituloAbreviado = '';
    List char = widget.produto.titulo.split('');

    if (char.length > 24) {
      for (int i = 0; i < 24; i++) {
        tituloAbreviado= tituloAbreviado+ char[i];

      }
      tituloAbreviado += '...';
    }
    return StreamBuilder(
        stream: ppc.outProduto,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            widget.produto = snapshot.data;
          }
          return Scaffold(
            body: Stack(
              children: <Widget>[

                CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      actions: <Widget>[  widget.produto.criador == Helper.localUser.id ? Container(

                        child: IconButton(onPressed: (){

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
                                            widget.produto.deleted_at = DateTime.now();
                                              produtosRef.document(widget.produto.id).updateData(widget.produto.toJson()).then((v){
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

                        }, icon: Icon(Icons.block), color:
                        Colors.red, iconSize: 35,),
                      ): Container(),],
                      expandedHeight: 350.0,
                      backgroundColor: corPrimaria,
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                        title: hText(char.length<24?widget.produto.titulo: tituloAbreviado, context,
                            color: Colors.white, ),
                        background: SizedBox.expand(
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[


                              widget.produto.fotos == null
                                  ? Container()
                                  : Center(
                                      child: widget.produto.fotos != null
                                          ? widget.produto.fotos.length != 1
                                              ? Hero(
                                                  tag: widget.produto.fotos[0],
                                                  child: PhotoScroller(
                                                    widget.produto.fotos,
                                                    hide: true,
                                                    altura: 374.0,
                                                    fractionsize: 1,
                                                    largura:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                  ),
                                                )
                                              : Hero(
                                                  tag: widget.produto.fotos[0],
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget
                                                          .produto.fotos[0],
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 374.0,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                  ),
                                                )
                                          : Container(),

                                    ),
                              Container(color: Colors.black26),


                            ],

                          ),

                        ),

                      ),
                      elevation: 2.0,
                      forceElevated: true,
                      pinned: true,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: hText(
                                'Descrição: ${widget.produto.descricao}',
                                context,
                                size: 40)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  hText(
                                      'R\$ ${widget.produto.preco.toStringAsFixed(2)}',
                                      context,
                                      size: 40)
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: getLargura(context) * .9,
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              hText(
                                                  'Dias dispoíveis na semana:',
                                                  context,
                                                  size: 40),
                                              sb,
                                              Row(
                                                children: <Widget>[
                                                  widget.produto.segunda == true
                                                      ? Icon(
                                                          MdiIcons.checkBold,
                                                          color: Colors.green,
                                                        )
                                                      : Icon(
                                                          MdiIcons.close,
                                                          color: Colors.red,
                                                        ),
                                                  hText('Segunda', context,
                                                      size: 40),
                                                  sb,
                                                  Row(
                                                    children: <Widget>[
                                                      widget.produto.terca ==
                                                              true
                                                          ? Icon(
                                                              MdiIcons
                                                                  .checkBold,
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          : Icon(
                                                              MdiIcons.close,
                                                              color: Colors.red,
                                                            ),
                                                      hText('Terça', context,
                                                          size: 40),
                                                    ],
                                                  ),
                                                  sb,
                                                  Row(
                                                    children: <Widget>[
                                                      widget.produto.quarta ==
                                                              true
                                                          ? Icon(
                                                              MdiIcons
                                                                  .checkBold,
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          : Icon(
                                                              MdiIcons.close,
                                                              color: Colors.red,
                                                            ),
                                                      hText('Quarta', context,
                                                          size: 40),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4),
                                                child: Row(
                                                  children: <Widget>[
                                                    widget.produto.quinta ==
                                                            true
                                                        ? Icon(
                                                            MdiIcons.checkBold,
                                                            color: Colors.green,
                                                          )
                                                        : Icon(
                                                            MdiIcons.close,
                                                            color: Colors.red,
                                                          ),
                                                    hText('Quinta', context,
                                                        size: 40),
                                                    sb,
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2,
                                                              bottom: 0,
                                                              top: 0,
                                                              right: 2),
                                                      child: Row(
                                                        children: <Widget>[
                                                          widget.produto
                                                                      .sexta ==
                                                                  true
                                                              ? Icon(
                                                                  MdiIcons
                                                                      .checkBold,
                                                                  color: Colors
                                                                      .green,
                                                                )
                                                              : Icon(
                                                                  MdiIcons
                                                                      .close,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                          hText(
                                                              'Sexta', context,
                                                              size: 40),
                                                        ],
                                                      ),
                                                    ),
                                                    sb,
                                                    Row(
                                                      children: <Widget>[
                                                        widget.produto.sabado ==
                                                                true
                                                            ? Icon(
                                                                MdiIcons
                                                                    .checkBold,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : Icon(
                                                                MdiIcons.close,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                        hText('Sábado', context,
                                                            size: 40),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  widget.produto.domingo == true
                                                      ? Icon(
                                                          MdiIcons.checkBold,
                                                          color: Colors.green,
                                                        )
                                                      : Icon(
                                                          MdiIcons.close,
                                                          color: Colors.red,
                                                        ),
                                                  hText('Domingo', context,
                                                      size: 40),
                                                ],
                                              ),
                                            ],
                                          ),
                                          StreamBuilder<User>(
                                              stream: ppc.outUser,
                                              builder: (context, snapshot) {
                                                if (snapshot.data == null) {
                                                  return Container();
                                                }
                                                String initials = '';
                                                var words = snapshot.data.nome
                                                    .split(' ');
                                                for (String word in words) {
                                                  initials += word
                                                      .split('')[0]
                                                      .toUpperCase();
                                                }
                                                return Positioned(
                                                  right: 10,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    PerfilVistoPage(
                                                                        user: snapshot
                                                                            .data)));
                                                      },
                                                      child: Hero(
                                                        tag: snapshot.data.id,
                                                        child: snapshot
                                                                    .data.foto !=
                                                                null
                                                            ? CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .purple,
                                                                radius: 45,
                                                                backgroundImage:
                                                                    CachedNetworkImageProvider(
                                                                        snapshot
                                                                            .data
                                                                            .foto))
                                                            : CircleAvatar(
                                                                radius: 45,
                                                                backgroundColor:
                                                                    Colors
                                                                        .purple,
                                                                child: hText(
                                                                    initials,
                                                                    context,
                                                                    color: Colors
                                                                        .white)),
                                                      )),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            widget.produto.criador == Helper.localUser.id?Container():
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.bottomRight,
                                  child: StreamBuilder(
                                      stream: ppc.outUser,
                                      builder: (context,
                                          AsyncSnapshot<User> snapshot) {
                                        print(
                                            'AQUI RETORNANDO USUARIO ${widget.produto.criador}');
                                        if (snapshot.data == null) {
                                          return Container();
                                        }
                                        if (snapshot.data == null) {
                                          return Container();
                                        }
                                        u = snapshot.data;
                                        u.id = snapshot.data.id;
                                        print('AQUI USUARIO $u');
                                        return Container(
                                          width: getLargura(context) * .5,
                                          child: defaultActionButton(
                                              'Conversar', context, () {
                                            if (u.id != Helper.localUser.id) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(user: u)));
                                            } else {
                                              dToast('Esse produto é seu');
                                            }
                                          },
                                              icon: Icons.chat,
                                              color: Colors.white,
                                              textColor: corPrimaria),
                                        );
                                      }),
                                ),
                                Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: getLargura(context) * .5,
                                      child: defaultActionButton(

                                          'Contratar', context, () {
                                        User u = Helper.localUser;
                                        ProdutoPedido test = ProdutoPedido(
                                          user: u.id,
                                          created_at: DateTime.now(),
                                          updated_at: DateTime.now(),
                                          prestador: widget.produto.criador,
                                          preco_unitario: widget.produto.preco,
                                          produto: widget.produto.id,
                                          quantidade: 1,
                                          deleted_at: null,
                                        );
                                        AdicionarProdutoAoCarrinho(
                                                user: u.id, produto: test)
                                            .then((result) {
                                          if (result != null) {
                                            if (result == 'ok') {
                                              dToast(
                                                  'Produto Adicionado Com Sucesso!');
                                            } else {
                                              dToast(
                                                  'Ocorreu um erro: ${result}');
                                            }
                                          } else {
                                            dToast(
                                                'Ocorreu um erro: Desconhecido');
                                          }
                                        });
                                      },
                                          icon: FontAwesomeIcons.shoppingCart,
                                          color: Colors.white,
                                          textColor: corPrimaria),
                                    )),
                              ],
                            ),
                          ],
                        ),

                        /// Rating average
                        widget.produto.rating == null
                            ? Container()
                            : widget.produto.rating.avaliacoes.length == 0
                                ? Container()
                                : RatingWidget(widget.produto),
                        sb, sb, sb,

                        widget.produto.comentarios == null
                            ? Container()
                            : widget.produto.comentarios.length == 0
                                ? Container()
                                : Container(
                                    height: getAltura(context) * .5,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            widget.produto.comentarios.length,
                                        itemBuilder: (context, index) {
                                          print(
                                              'AQUI COMENTARIOS ${widget.produto.comentarios.length}');
                                          return widget
                                                      .produto
                                                      .comentarios[index]
                                                      .comentarios ==
                                                  null
                                              ? ComentarioListItem(
                                                  widget.produto
                                                      .comentarios[index],
                                                  widget.produto,
                                                  context)
                                              : widget
                                                          .produto
                                                          .comentarios[index]
                                                          .comentarios
                                                          .length ==
                                                      0
                                                  ? ComentarioListItem(
                                                      widget.produto
                                                          .comentarios[index],
                                                      widget.produto,
                                                      context)
                                                  : Container(
                                                      child: Column(
                                                      children: <Widget>[
                                                        ComentarioListItem(
                                                            widget.produto
                                                                    .comentarios[
                                                                index],
                                                            widget.produto,
                                                            context),
                                                        Container(
                                                            height: getAltura(
                                                                    context) *
                                                                .1,
                                                            child: ListView
                                                                .builder(
                                                                    itemCount: widget
                                                                        .produto
                                                                        .comentarios[
                                                                            index]
                                                                        .comentarios
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      return ComentarioListItem(
                                                                          widget
                                                                              .produto
                                                                              .comentarios[index]
                                                                              .comentarios[i],
                                                                          widget.produto,
                                                                          context);
                                                                    })),
                                                      ],
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                    ));
                                        }),
                                  ),

                        /// Review
                      ]),
                    ),
                  ],
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: widget.produto.criador == Helper.localUser.id
                      ? Container()
                      : FloatingActionButton(
                          child: Icon(Icons.star),
                          onPressed: () {
                            AvaliarDialog(widget.produto);
                          }),
                )
              ],
            ),
          );
        });
  }

  AvaliarDialog(Produto produto) {
    TextEditingController comentarioController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            icon: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(produto.fotos[0]),
                radius: (((getAltura(context) + getLargura(context)) / 2) *
                    .2)), // set your own image/icon widget
            title: "Avaliar ${produto.titulo}",
            description: 'Ajude as pessoas a terem serviços de qualidade!',
            comentario: Padding(
                padding: EdgeInsets.all(8),
                child: DefaultField(
                    hint: 'Ótimo serviço e preço, recomendo!',
                    controller: comentarioController,
                    context: context,
                    maxLines: 50,
                    borderColor: Colors.transparent,
                    hintColor: Colors.black,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    padding: EdgeInsets.all(0),
                    label: 'Como foi sua experiência?')),
            submitButton: "AVALIAR",
            alternativeButton: "Fale conosco", // optional
            positiveComment: "Que maravilha! :D", // optional
            negativeComment: "Que Pena :(", // optional
            accentColor: corPrimaria, // optional
            onSubmitPressed: (int rating) {
              print("onSubmitPressed: rating = $rating");

              if (produto.rating != null) {
                if (produto.rating.avaliacoes != null) {
                  for (Avaliacao a in produto.rating.avaliacoes) {
                    if (a.user == Helper.localUser.id) {
                      dToast('Você ja fez uma avaliação deste produto!');
                      return;
                    }
                  }
                }
              }
              Avaliacao a = Avaliacao(
                  user: Helper.localUser.id,
                  nota: rating.toDouble(),
                  data: DateTime.now());
              Comentario comentario = Comentario(
                senderId: Helper.localUser.id,
                msg: comentarioController.text,
                senderName: Helper.localUser.nome,
                senderFoto: Helper.localUser.foto,
                timestamp: DateTime.now(),
              );
              if (produto.comentarios == null) {
                produto.comentarios = new List();
              }
              produto.comentarios.add(comentario);
              if (produto.rating == null) {
                produto.rating = new Rating();
              }
              produto.rating = produto.rating.addAvaliacao(a);
              produtosRef
                  .document(produto.id)
                  .updateData(produto.toJson())
                  .then((v) {
                dToast('Obrigado pelo Feedback :D');

                Navigator.of(context).pop();
              });
            },
            onAlternativePressed: () {
              print("onAlternativePressed: do something");
              // TODO: maybe you want the user to contact you instead of rating a bad review
            },
          );
        });
  }

  RatingWidget(Produto produto) {
    double star1 = 0;
    double star2 = 0;
    double star3 = 0;
    double star4 = 0;
    double star5 = 0;

    ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);
    for (Avaliacao a in produto.rating.avaliacoes) {
      switch (a.nota.toInt()) {
        case 1:
          star1 += 1;
          break;
        case 2:
          star2 += 1;
          break;
        case 3:
          star3 += 1;
          break;

        case 4:
          star4 += 1;
          break;
        case 5:
          star5 += 1;
          break;
      }
    }
    star5 = star5 / produto.rating.avaliacoes.length;
    star4 = star4 / produto.rating.avaliacoes.length;
    star3 = star3 / produto.rating.avaliacoes.length;
    star2 = star2 / produto.rating.avaliacoes.length;
    star1 = star1 / produto.rating.avaliacoes.length;

    return Material(
      elevation: 12.0,
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.0),
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Text('${widget.produto.rating.mediaAvaliacoes}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 64.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: RatingBar(

              initialRating: produto.rating.mediaAvaliacoes,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(Icons.star,
                  color: corPrimaria, size: ScreenUtil.instance.setSp(70)),
            ),
          ),

          /// Rating chart lines
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /// 5 stars and progress bar
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(right: 24.0)),
                      Expanded(
                        child: Theme(
                          data: ThemeData(accentColor: Colors.green),
                          child: LinearProgressIndicator(
                            value: star5,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(right: 24.0)),
                      Expanded(
                        child: Theme(
                          data: ThemeData(accentColor: Colors.lightGreen),
                          child: LinearProgressIndicator(
                            value: star4,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(right: 24.0)),
                      Expanded(
                        child: Theme(
                          data: ThemeData(accentColor: Colors.yellow),
                          child: LinearProgressIndicator(
                            value: star3,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(right: 24.0)),
                      Expanded(
                        child: Theme(
                          data: ThemeData(accentColor: Colors.orange),
                          child: LinearProgressIndicator(
                            value: star2,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.black54, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                          Icon(Icons.star, color: Colors.black12, size: 16.0),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(right: 24.0)),
                      Expanded(
                        child: Theme(
                          data: ThemeData(accentColor: Colors.red),
                          child: LinearProgressIndicator(
                            value: star1,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

ComentarioListItem(Comentario comentario, Produto produto, context) {
  String stars = '';
  String initials = '';
  var words = comentario.senderName.split(' ');
  for (String word in words) {
    initials += word.split('')[0].toUpperCase();
  }
  for (Avaliacao a in produto.rating.avaliacoes) {
    if (a.user == comentario.senderId) {
      for (int i = 0; i < a.nota.toInt(); i++) {
        stars += '★';
        //print('AQUI STAR ${ stars}');
      }
    }
  }
  if (comentario.senderId == produto.criador) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Material(
                elevation: 12.0,
                color: Colors.tealAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          hText('${comentario.senderName} ', context, size: 40),
                          hText(comentario.msg, context,
                              size: 40, color: Colors.grey[600])
                        ])),
              ),
              sb,
              comentario.senderFoto != null
                  ? GestureDetector(
                      onTap: () async {
                        User u = User.fromJson((await userRef
                                .document(comentario.senderId)
                                .get())
                            .data);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PerfilVistoPage(user: u)));
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.purple,
                          backgroundImage: CachedNetworkImageProvider(
                              comentario.senderFoto)))
                  : GestureDetector(
                      onTap: () async {
                        User u = User.fromJson((await userRef
                                .document(comentario.senderId)
                                .get())
                            .data);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PerfilVistoPage(user: u)));
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child:
                              hText(initials, context, color: Colors.white))),
            ],
          ),
        ),
        Divider(),
      ],
    );
  } else {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Material(
            elevation: 12.0,
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      User u = User.fromJson(
                          (await userRef.document(comentario.senderId).get())
                              .data);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PerfilVistoPage(user: u)));
                    },
                    child: Container(
                      child: ListTile(
                        leading: Hero(
                          tag: comentario.senderId,
                          child: comentario.senderFoto != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  backgroundImage: CachedNetworkImageProvider(
                                      comentario.senderFoto))
                              : CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  child: hText(initials, context,
                                      color: Colors.white)),
                        ),
                        title:
                            hText('${comentario.senderName} ${stars}', context),
                        subtitle: hText(comentario.msg, context,
                            size: 35, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  Helper.localUser.id == produto.criador
                      ? Padding(
                          padding: EdgeInsets.only(top: 4.0, right: 10.0),
                          child: FlatButton.icon(
                            onPressed: () {
                              ResponderDialog(comentario, produto, context);
                            },
                            icon: Icon(Icons.reply, color: Colors.blueAccent),
                            label: hText('Responder', context,
                                color: Colors.blueAccent,
                                weight: FontWeight.w700,
                                size: 35),
                          ))
                      : Container(),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

ResponderDialog(Comentario comentario, Produto produto, context) {
  TextEditingController comentarioController = TextEditingController();
  showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) {
        return AlertDialog(
          // set your own image/icon widget
          title: hText("Responder ${comentario.senderName}", context,
              color: corPrimaria),
          contentPadding: EdgeInsets.all(6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Padding(
              padding: EdgeInsets.all(8),
              child: DefaultField(
                  hint: 'Obrigado por sua avaliação',
                  controller: comentarioController,
                  context: context,
                  maxLines: 50,
                  borderColor: Colors.transparent,
                  hintColor: Colors.black,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  padding: EdgeInsets.all(0),
                  label: 'Resposta a avaliação')),

          actions: <Widget>[
            defaultActionButton('Cancelar', context, () {
              //TODO EFETUAR AVALIACAO
              Navigator.of(context).pop();
            }, icon: null, color: Colors.white, textColor: corPrimaria),
            defaultActionButton('Responder', context, () {
              //TODO EFETUAR RESPONDER

              if (comentario.comentarios == null) {
                comentario.comentarios = new List();
              }

              Comentario come = Comentario(
                senderId: Helper.localUser.id,
                msg: comentarioController.text,
                senderName: Helper.localUser.nome,
                senderFoto: Helper.localUser.foto,
                timestamp: DateTime.now(),
              );
              comentario.comentarios.add(come);

              for (Comentario c in produto.comentarios) {
                if (c.timestamp == comentario.timestamp) {
                  c = comentario;
                }
              }
              comentarioController.text.isEmpty
                  ? dToast('Sua resposta está vazia')
                  : produtosRef
                      .document(produto.id)
                      .updateData(produto.toJson())
                      .then((v) {
                      dToast('Obrigado pelo Feedback :D');

                      Navigator.of(context).pop();
                    });
            }, icon: null, color: Colors.white, textColor: corPrimaria),
          ],
        );
      });
}
