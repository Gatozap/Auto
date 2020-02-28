import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_checkbox/flare_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:autooh/Helpers/Formatter.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/ShortStreamBuilder.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';

import 'card_back.dart';
import 'card_color.dart';
import 'card_controller.dart';
import 'card_front.dart';
import 'flip_card.dart';

class CardCreate extends StatefulWidget {
  @override
  _CardCreate createState() => _CardCreate();
}

class _CardCreate extends State<CardCreate> {
  final GlobalKey<FlipCardState> animatedStateKey = GlobalKey<FlipCardState>();
  FocusNode _focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  Future<Null> _focusNodeListener() async {
    animatedStateKey.currentState.toggleCard();
  }

  MaskedTextController numeroController = MaskedTextController(mask:'0000 0000 0000 0000');
  @override
  Widget build(BuildContext context) {
    final CardController bloc = BlocProvider.of<CardController>(context);

    final _creditCard = Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Card(
        color: Colors.grey[100],
        elevation: 0.0,
        margin: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 0.0),
        child: FlipCard(
          key: animatedStateKey,
          front: CardFront(rotatedTurnsValue: 0),
          back: CardBack(),
        ),
      ),
    );

    List<PopupMenuItem<String>> itens = new List<PopupMenuItem<String>>();
    for (String s in bandeiras) {
      itens.add(PopupMenuItem(
       enabled: true,
        value: s,
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage(getBandeira(s)),
              width: 40,
              height: 20,
            ),
            sb,
            Text(s),
          ],
        ),
      ));
    }
    var selectorBandeira = PopupMenuButton<String>(captureInheritedThemes: false,
      initialValue: 'Visa',
      child: StreamBuilder(
          stream: bloc.outCard_brand,
          builder: (context, snapshot) {
            return Container(
              color:Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text('Bandeira do Cartão   '),
                      Image(
                        image: AssetImage(getBandeira(
                            snapshot.data == null ? 'Visa' : snapshot.data)),
                        width: 40,
                        height: 20,
                      ),
                      sb,
                      Text(snapshot.data == null ? 'Visa' : snapshot.data),
                    ],
                  )),
            );
          }),
      itemBuilder: (BuildContext context) => itens,
      onSelected: (String c) {
        bloc.InCard_brand(c);
      },
    );
    final _cardHolderName = SSB(
        stream: bloc.Outowner_name,
        selfValidateError: true,
        errFunction: (err) {
          if (err == null) {
            return DefaultField(
                capitalization: TextCapitalization.characters,
                onChange: bloc.Inowner_name,
                keyboardType: TextInputType.text,
                context:
                  context,
                  icon: FontAwesomeIcons.idBadge,
                  hint: 'João da Silva',
                  label: 'Nome do Proprietário',);
          }
          return DefaultField(
              capitalization: TextCapitalization.characters,
              onChange: bloc.Inowner_name,
              keyboardType: TextInputType.text,
             context:context,
                  icon: FontAwesomeIcons.idBadge,
                  hint: 'João da Silva',
                  label: 'Nome do Proprietário',
                  error: err.toString());
        },
        buildfunction: (context, snapshot) {
          return DefaultField(
            capitalization: TextCapitalization.characters,
            onChange: bloc.Inowner_name,
            keyboardType: TextInputType.text,
         context:
              context,
              icon: FontAwesomeIcons.idBadge,
              label: 'Nome do Proprietário',
              hint: 'Nome do Proprietário',
              error: snapshot.error,
          );
        });

    final _cardNumber = Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SSB(
          selfValidateError: true,
          errFunction: (err) {
            if (err == null) {
              return DefaultField(
                onChange: bloc.Innumber,
                controller: numeroController,
                keyboardType: TextInputType.number,
                maxLength: 19,
                context: context,
                icon: FontAwesomeIcons.creditCard,
                label: 'Numero do Cartão',
                hint: 'xxxx xxxx xxxx xxxx',
              );
            }
            return DefaultField(
              onChange: bloc.Innumber,
              keyboardType: TextInputType.number,
              maxLength: 19,
              context: context,
              controller: numeroController,
              icon: FontAwesomeIcons.creditCard,
              label: 'Numero do Cartão',
              hint: 'xxxx xxxx xxxx xxxx',
              error: err,
            );
          },
          stream: bloc.Outnumber,
          buildfunction: (context, snapshot) {
            return DefaultField(
              onChange: bloc.Innumber,
              controller: numeroController,
              keyboardType: TextInputType.number,
              maxLength: 19,
              context: context,
              error: snapshot.error,
              icon: FontAwesomeIcons.creditCard,
              label: 'Numero do Cartão',
              hint: 'xxxx xxxx xxxx xxxx',
            );
          }),
    );

    final _cardMonth = SSB(
      stream: bloc.Outexpiration_month,
      selfValidateError: true,
      errFunction: (err) {
        if (err == null) {
          return Container(
            width: MediaQuery.of(context).size.width * .2,
            child: DefaultField(
              onChange: (v) {
                bloc.Inexpiration_month(int.parse(v));
              },
              keyboardType: TextInputType.number,
              maxLength: 2,
              context: context,
              hint: 'MM',
              label: 'Mês',
            ),
          );
        }
        return Container(
          width: MediaQuery.of(context).size.width * .2,
          child: DefaultField(
            onChange: (v) {
              bloc.Inexpiration_month(int.parse(v));
            },
            keyboardType: TextInputType.number,
            maxLength: 2,
            context: context,
            hint: 'MM',
            label: 'Mês',
            error: err,
          ),
        );
      },
      buildfunction: (context, snapshot) {
        return Container(
          width: 85.0,
          child: DefaultField(
            onChange: (v) {
              bloc.Inexpiration_month(int.parse(v));
            },
            keyboardType: TextInputType.number,
            maxLength: 2,
            context: context,
            hint: 'MM',
            label: 'Mês',
            error: snapshot.error,
          ),
        );
      },
    );

    final _cardYear = SSB(
        stream: bloc.Outexpiration_year,
        selfValidateError: true,
        errFunction: (err) {
          if (err == null) {
            return Container(
              width: MediaQuery.of(context).size.width * .3,
              child: DefaultField(
                onChange: (v) {
                  bloc.Inexpiration_year(int.parse(v));
                },
                context:context,
                keyboardType: TextInputType.number,
                maxLength: 4,
                label: 'Ano',
                hint: 'YYYY',
                error: err,
              ),
            );
          }
          return Container(
            width: MediaQuery.of(context).size.width * .3,
            child: DefaultField(
              onChange: (v) {
                bloc.Inexpiration_year(int.parse(v));
              },
              keyboardType: TextInputType.number,
              maxLength: 4,
              context: context,
              label: 'Ano',
              hint: 'YYYY',
              error: err,
            ),
          );
        },
        buildfunction: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width * .3,
            child: DefaultField(
              onChange: (v) {
                bloc.Inexpiration_year(int.parse(v));
              },
              keyboardType: TextInputType.number,
              maxLength: 4,
              context: context,
              hint: 'YYYY',
              label: 'Ano',
              error: snapshot.error,
            ),
          );
        });

    final _cardVerificationValue = SSB(
        isList: false,
        selfValidateError: true,
        errFunction: (err) {
          if (err == null) {
            return Container(
                width: MediaQuery.of(context).size.width * .2,
                child: DefaultField(
                  onChange: (v) {
                    bloc.Incvc(int.parse(v));
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  context: context,
                  hint: '000',
                  label: 'CVV',
                  error: err,
                ));
          }
          return Container(
            width: MediaQuery.of(context).size.width * .2,
            child: DefaultField(
              onChange: (v) {
                bloc.Incvc(int.parse(v));
              },
              keyboardType: TextInputType.number,
              maxLength: 3,
              context: context,
              hint: '000',
              label: 'CVV',
              error: err,
            ),
          );
        },
        stream: bloc.Outcvc,
        buildfunction: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width * .2,
            child: DefaultField(
              onChange: (v) {
                bloc.Incvc(int.parse(v));
              },
              keyboardType: TextInputType.number,
              maxLength: 3,
              context: context,
              hint: '000',
              label: 'CVV',
              error: snapshot.error,
            ),
          );
        });

    final _saveCard = SSB(
      stream: bloc.saveCardValid,
      error: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: RaisedButton(
          child: Text(
            'Salvar Cartão',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.lightBlue,
          onPressed: null,
        ),
      ),
      buildfunction: (context, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width - 40,
          child: RaisedButton(
            child: Text(
              'Salvar Cartão',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            onPressed: snapshot.hasData
                ? () {
                    bloc.saveCard().then((b) {
                      if (b) {
                        Navigator.pop(context);
                      }
                    });
                  }
                : null,
          ),
        );
      },
    );

    return new Scaffold(
        drawer: CustomDrawerWidget(),
        appBar: myAppBar('Adicionar Cartão', context, showBack: true),
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.5,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .3,
                  child: _creditCard,
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        selectorBandeira,
                        SizedBox(height: 8.0),
                        _cardHolderName,
                        _cardNumber,
                        SizedBox(height: 8.0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _cardMonth,
                              SizedBox(width: 8.0),
                              _cardYear,
                              SizedBox(width: 8.0),
                              _cardVerificationValue,
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        cardColors(bloc),
                        SizedBox(height: 20.0),
                        cardType(bloc),
                        SizedBox(height: 20.0),
                        _saveCard,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  nutrannoLogo(context, m1, m2) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * m1,
      height: MediaQuery.of(context).size.height * m2,
      child: Container(
        padding: EdgeInsets.all(1),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * m1,
        height: MediaQuery.of(context).size.height * m2,
        color: Colors.transparent,
        child: Image(
          image: AssetImage('assets/images/nutrannoLogo.png'),
          width: MediaQuery.of(context).size.width * m1,
          height: MediaQuery.of(context).size.height * m2,
        ),
      ),
    );
  }

  String selected = 'Visa';

  Widget widgetTopMenu(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .1,
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * .01,
          ),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: MediaQuery.of(context).size.height * .01,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: corPrimaria,
                    )),
                nutrannoLogo(context, .2, .05),
                Icon(Icons.settings, color: Colors.white),
              ],
            ),
          )),
    );
  }

  Widget cardColors(CardController bloc) {
    final dotSize =
        (MediaQuery.of(context).size.width - 220) / CardColor.baseColors.length;

    List<Widget> dotList = new List<Widget>();

    for (var i = 0; i < CardColor.baseColors.length; i++) {
      dotList.add(
        SSB(
          stream: bloc.OutCardColor,
          error: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () => bloc.SelectCardColor(i),
              child: Container(
                child: i == 0
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12.0,
                      )
                    : Container(),
                width: dotSize,
                height: dotSize,
                decoration: new BoxDecoration(
                  color: CardColor.baseColors[i],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          buildfunction: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () => bloc.SelectCardColor(i),
                child: Container(
                  child: snapshot.hasData
                      ? snapshot.data[i].isSelected
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.0,
                            )
                          : Container()
                      : Container(),
                  width: dotSize,
                  height: dotSize,
                  decoration: new BoxDecoration(
                    color: CardColor.baseColors[i],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: dotList,
    );
  }

  cardType(CardController bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SSB(
            stream: bloc.Outcard_type,
            error: Row(
              children: <Widget>[
                defaultCheckBox(true,'Credito',context,(){
                  bloc.controller_card_type.sink.add('Credito');
                },),
                SizedBox(width: 20),
                defaultCheckBox(false,'Debito',context,(){
                  bloc.controller_card_type.sink.add('Debito');
                },),
              ],
            ),
            buildfunction: (context, snapshot) {
              return Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    defaultCheckBox(snapshot.data =='Credito','Credito',context,(){
                      bloc.controller_card_type.sink.add('Credito');
                    },),
                    SizedBox(width: 20),
                    defaultCheckBox(snapshot.data =='Debito','Debito',context,(){
                      bloc.controller_card_type.sink.add('Debito');
                    },),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
