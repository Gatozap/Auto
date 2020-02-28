import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:autooh/Helpers/Cielo/flutter_cielo.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/ShortStreamBuilder.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Cartao.dart';
import 'package:autooh/Objetos/Prestador.dart';
import 'package:autooh/Telas/Card/card_front.dart';
import 'package:autooh/Telas/Card/flip_card.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'card_back.dart';
import 'card_back_display.dart';
import 'card_chip.dart';
import 'card_color.dart';
import 'card_controller.dart';
import 'card_create.dart';
import 'card_front_display.dart';
import 'card_list_controller.dart';

class CardListWidget extends StatelessWidget {
  CardListWidget();
  bool BuscouDados = false;
  Cartao selecionado;

  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
  Widget _buildRaisedButton(
      {Color buttonColor,
      String buttonText,
      Color textColor,
      BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: RaisedButton(
        elevation: 1.0,
        onPressed: () {
          var blocProviderCardCreate = BlocProvider(
            bloc: CardController(),
            child: CardCreate(),
          );
          blocProviderCardCreate.bloc.Incard_type(buttonText);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => blocProviderCardCreate));
        },
        color: buttonColor,
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }

  final _buildTextInfo = Padding(
    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
    child: Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: '',
            style: TextStyle(
                color: Colors.lightBlue, fontWeight: FontWeight.bold)),
      ], text: ''),
      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
      softWrap: true,
      textAlign: TextAlign.center,
    ),
  );
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return new Scaffold(
        drawer: CustomDrawerWidget(),
        appBar: myAppBar('Meus Cartões', context,
            showBack: true,),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              StreamBuilder<List<Cartao>>(
                  stream: clc.outCardList,
                  builder: (context, AsyncSnapshot<List<Cartao>> snapshot) {
                    if (snapshot.data == null) {
                      return Container();
                    }
                    if (snapshot.data.length == 0) {
                      return Container();
                    }
                    return Center(
                      child: Text(
                        'Arraste para os lados para selecionar outro cartão',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: myBlack,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }),
              Center(
                child: Text(
                  '...ou adicione um novo clicando no botão abaixo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: myBlack,
                    fontSize: 14,
                  ),
                ),
              ),
              SSB(
                  stream: clc.outCardList,
                  emptylist: Container(
                      child: Center(
                          child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        /*_buildRaisedButton(
                                  buttonColor: Colors.blue,
                                  buttonText: 'Adicionar Cartão de Credito',
                                  textColor: Colors.white,
                                  context: context),*/
                        /* _buildRaisedButton(
                                  buttonColor: Colors.grey[100],
                                  buttonText: 'Cartão de Debito',
                                  textColor: Colors.grey[600],
                                  context: context),
                              _buildRaisedButton(
                                  buttonColor: Colors.red[800],
                                  buttonText: 'Gift Card',
                                  textColor: Colors.white,
                                  context: context),*/
                        _buildTextInfo
                      ],
                    ),
                  ))),
                  isList: true,
                  error: LoadingScreen('Carregando Cartões'),
                  buildfunction: (context, snapshot) {
                    selecionado = snapshot.data[0];
                    GlobalKey<FlipCardState> animatedStateKey =
                        GlobalKey<FlipCardState>();
                    return Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onLongPress: () =>
                                    DeletarCartao(snapshot.data[0], context),
                                child: snapshot.data.length == 1
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Card(
                                          color: Colors.grey[100],
                                          elevation: 0.0,
                                          margin: EdgeInsets.fromLTRB(
                                              15.0, 2.0, 15.0, 0.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            child: FlipCard(
                                              key: animatedStateKey,
                                              front: CardFrontDisplay(
                                                rotatedTurnsValue: 0,
                                                c: snapshot.data[0],
                                              ),
                                              back: CardBackDisplay(
                                                  snapshot.data[0]),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Swiper(
                                        itemCount: snapshot.data.length,
                                        itemWidth: size.width * .9,
                                        onIndexChanged: (i) {
                                          selecionado = snapshot.data[i];
                                        },
                                        itemHeight: size.height * .3,
                                        layout: SwiperLayout.STACK,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext contex, int i) {
                                          GlobalKey<FlipCardState> a =
                                              GlobalKey<FlipCardState>();
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: GestureDetector(
                                              onLongPress: () => DeletarCartao(
                                                  snapshot.data[i], context),
                                              child: Card(
                                                color: Colors.grey[100],
                                                elevation: 0.0,
                                                margin: EdgeInsets.fromLTRB(
                                                    15.0, 2.0, 15.0, 0.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .9,
                                                  child: FlipCard(
                                                    key: a,
                                                    front: CardFrontDisplay(
                                                      rotatedTurnsValue: 0,
                                                      c: snapshot.data[i],
                                                    ),
                                                    back: CardBackDisplay(
                                                        snapshot.data[i]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                          /*GestureDetector(
                                                      onTap: () {

                                                      child: CardFrontListVertical(
                                                          cardModel:
                                                              snapshot.data[i],
                                                          size: size));*/
                                        },
                                      ),
                              ),
                              //PublicidadeWidget()
                            ]));
                  }),
              sb,
              sb,
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  child: MaterialButton(
                    child: Text(
                      'Adicionar Cartão',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: corPrimaria,
                    onPressed: () {
                      var blocProviderCardCreate = BlocProvider(
                        bloc: CardController(),
                        child: CardCreate(),
                      );
                      blocProviderCardCreate.bloc.Incard_type('Credito');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => blocProviderCardCreate));
                    },
                  ),
                ),
              ),
              Center(
                child:Container(),
              ),
              /*plano != null
                  ? Text('Clique em um cartão para efetuar o Pagamento!')
                  : Container(),*/
            ],
          ),
        ));
  }

  DeletarCartao(Cartao cartao, context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Apagar Cartão ${cartao.marca}:${cartao.number} ?'),
            actions: <Widget>[
              MaterialButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: corPrimaria),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
                elevation: 0,
              ),
              MaterialButton(
                child: Text(
                  'Apagar',
                  style: TextStyle(color: myOrange),
                ),
                onPressed: () {
                  CardController().removerCartao(cartao);
                  Navigator.of(context).pop();
                },
                color: Colors.white,
                elevation: 0,
              )
            ],
          );
        });
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class PublicidadeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 14.0),
        child: Center(
            child: CachedNetworkImage(
          imageUrl:
              'https://scontent.fcfc1-1.fna.fbcdn.net/v/t1.0-9/24852511_1685671331493750_9009202741090212301_n.jpg?_nc_cat=100&_nc_ht=scontent.fcfc1-1.fna&oh=3a83f226c4df644505130ace828fe4e3&oe=5C8E44C7',
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .33,
        )));
  }
}

class CardFrontListVertical extends StatelessWidget {
  final Cartao cardModel;
  Size size;
  CardFrontListVertical({this.cardModel, this.size});

  @override
  Widget build(BuildContext context) {
    //print('AQUI CARTÂO ${cardModel.toString()}');
    final _cardLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: CardColor.TopPadding, right: 52.0),
          child: Image(
            image: AssetImage(getBandeira(cardModel.marca)),
            width: 65.0,
            height: 32.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 52.0),
          child: Text(
            cardModel.tipo,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );

    final _cardNumber = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPadding, left: CardColor.LeftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildDots(),
        ],
      ),
    );

    final _cardValidThru = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPadding, right: 15.0, left: size.width * .5),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'valid',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              ),
              Text(
                'thru',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              )
            ],
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            '${cardModel.expiration_month}/${cardModel.expiration_year.toString().substring(2)}',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );

    final _cardOwner = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPadding, left: CardColor.LeftPadding),
      child: Text(
        cardModel.owner.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 22.0),
      ),
    );
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color.fromARGB(255, cardModel.R, cardModel.G, cardModel.B)),
      child: RotatedBox(
        quarterTurns: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _cardLogo,
            CardChip(),
            _cardNumber,
            _cardValidThru,
            _cardOwner
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    List<Widget> dotList = new List<Widget>();
    var counter = 0;
    for (var i = 0; i < 12; i++) {
      counter++;
      dotList.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Container(
          width: 6.0,
          height: 6.0,
          decoration:
              new BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ));
      if (counter == 4) {
        counter = 0;
        dotList.add(SizedBox(
          width: 20.0,
        ));
      }
    }
    dotList.add(_buildNumbers());
    return Row(
      children: dotList,
    );
  }

  Widget _buildNumbers() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: new Text(
        cardModel.number.substring(14),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class CardFrontListHorizontal extends StatelessWidget {
  final Cartao cardModel;
  Size size;
  CardFrontListHorizontal({this.cardModel, this.size});

  @override
  Widget build(BuildContext context) {
    final _cardLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: CardColor.TopPaddingHorizontal, right: 52.0),
          child: Image(
            image: AssetImage('assets/visa_logo.png'),
            width: 65.0,
            height: 32.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 52.0),
          child: Text(
            'Crédito',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );

    final _cardNumber = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPaddingHorizontal, left: CardColor.LeftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildDots(),
        ],
      ),
    );

    final _cardValidThru = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPaddingHorizontal,
          right: 15.0,
          left: size.width * .5),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'valid',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              ),
              Text(
                'thru',
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              )
            ],
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            '${cardModel.expiration_month}/${cardModel.expiration_year.toString().substring(2)}',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );

    final _cardOwner = Padding(
      padding: EdgeInsets.only(
          top: CardColor.TopPaddingHorizontal, left: CardColor.LeftPadding),
      child: Text(
        cardModel.owner,
        style: TextStyle(color: Colors.white, fontSize: 26.0),
      ),
    );
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color.fromARGB(255, cardModel.R, cardModel.G, cardModel.B)),
      child: RotatedBox(
        quarterTurns: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _cardLogo,
            CardChip(),
            _cardNumber,
            _cardValidThru,
            _cardOwner
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    List<Widget> dotList = new List<Widget>();
    var counter = 0;
    for (var i = 0; i < 12; i++) {
      counter++;
      dotList.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Container(
          width: 6.0,
          height: 6.0,
          decoration:
              new BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ));
      if (counter == 4) {
        counter = 0;
        dotList.add(SizedBox(
          width: 30.0,
        ));
      }
    }
    dotList.add(_buildNumbers());
    return Row(
      children: dotList,
    );
  }

  Widget _buildNumbers() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: new Text(
        cardModel.number.substring(12),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
