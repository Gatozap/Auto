import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:autooh/Helpers/DiceKeyboard.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Objetos/Sala.dart';
import 'package:autooh/Objetos/User.dart';

class DicesWidget {

  BuildContext context;
  final FocusNode node = FocusNode();
  //This is only for custom keyboards
  final custom1Notifier = ValueNotifier<int>(0);
  final custom2Notifier = ValueNotifier<Color>(Colors.blue);
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(displayActionBar: true,
                         focusNode: node,closeWidget: hText('Deixa pra la',context,size: 34),
                         footerBuilder: (_) => DiceKeyboard(
                           notifier: custom1Notifier,
                           sala:sala,
                             user:user,
                           ),
                       ),
      ],
      );
  }
  Sala sala;
  User user;
  DicesWidget(this.context, {this.sala, this.user});

  getDiceWidget({double bottom,double right= 0}){
    custom1Notifier.addListener((){
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if(bottom == null){
      bottom= -getAltura(context)*.05;
    }
    return Positioned(bottom: bottom,right: right,child:  Container(
      width:getLargura(context)*.2,
      height: getAltura(context)*.2,
      child: KeyboardActions(isDialog: true,tapOutsideToDismiss: true,enable: true,
                                 config: _buildConfig(context),
                                 child:  KeyboardCustomInput<int>(
                                   focusNode: node,
                                   height: getAltura(context)*.2,
                                   notifier: custom1Notifier,
                                   builder: (context, val, hasFocus) {
                                     return Image(image:AssetImage('assets/d20_button.png'),fit: BoxFit.fill,);
                                   },
                                   )),
      ),);
  }
}