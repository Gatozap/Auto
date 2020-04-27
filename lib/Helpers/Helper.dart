import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Objetos/Personagem.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import 'Cielo/flutter_cielo.dart';
import 'NotificacoesHelper.dart';
import 'Styles.dart';

Err(err, String lugar) {
  print('Error ${lugar}: ${err.toString()}');
  return 'Error';
}

Future<String> uploadPicture(String filepath,
    {String filename, String ref}) async {
  File imageFile = File(filepath);
  String extension = filepath.split('.')[1];
  int random = new Random().nextInt(100000);
  if (filename == null) {
    filename = 'image_$random.${extension}';
  }
  StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  StorageUploadTask uploadTask = ref.put(imageFile);
  return uploadTask.onComplete.then((d) {
    return d.ref.getDownloadURL().then((url) {
      var downloadUrl = url;
      return downloadUrl.toString();
    }).catchError((err) {
      print('Error: ${err}');
      return null;
    });
  }).catchError((err) {
    print('Error: ${err}');
    return null;
  });
}

int getModificador(int status) {
  if (status <= 11) {
    switch (status) {
      case 1:
        return -5;
      case 2:
        return -4;
      case 3:
        return -4;
      case 4:
        return -3;
      case 5:
        return -3;
      case 6:
        return -2;
      case 7:
        return -2;
      case 8:
        return -1;
      case 9:
        return -1;
      case 10:
        return 0;
      case 11:
        return 0;
    }
  } else {
    int value = ((status - 11) / 2).ceil().toInt();
    return value;
  }
}

hText(text, context,
    {int size = 55,
    Color color = Colors.black,
    FontStyle style = FontStyle.normal,
    TextAlign textaling = TextAlign.start,
    FontWeight weight = FontWeight.normal}) {
  ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);

  return Text(
    text,
    textAlign: textaling,
    style: TextStyle(
      fontSize: ScreenUtil.getInstance().setSp(size),
      color: color,
      fontWeight: weight,
      fontStyle: style,
    ),
  );
}

void developing(context) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
                color: Colors.white,
                width: getLargura(context) * .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    hText('Em desenvolvimento', context, size: 42),
                    Container(
                      width: getLargura(context) * .6,
                      height: getAltura(context) * .3,
                      child: new FlareActor("assets/coding.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: "coding"),
                    ),
                    hText('Gostaria de Ajudar?', context, size: 44),
                    defaultActionButton('Entrar em contato', context, () {
                      whatsAppOpen();
                    }),
                  ],
                )));
      });
}

void whatsAppOpen() async {
  //print('ENTROU AQUI');
  var whatsappUrl = "whatsapp://send?phone=5542999319375&text=Ola";
  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl, forceSafariVC: false, forceWebView: false);
  } else {
    throw 'Could not launch $whatsappUrl';
  }
}

Widget defaultCheckBox(bool isChecked, text, context, onTap, {color: corPrimaria,size }) {

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
         

          Container(
            decoration: BoxDecoration(
                color: isChecked ? color : Colors.white,
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: color, width: 2)),
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 35,
            ),
            height: 40,
            width: 40,
          ),sb,
          hText(text, context, size: 45, color: corPrimaria),
        ],
      ),
    );

}

Widget defaultActionButton(String text, context, Function onPressed,
    {var icon = Icons.add,color = Colors.yellowAccent, textColor = Colors.blue,size= 50}) {
  return Padding(
    padding:  EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
    child: MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon == null
              ? Container()
              : Icon(
                  icon,size:ScreenUtil.instance.setSp(size),
                  color: textColor,
                ),
          icon == null ? Container() : sb,
          Padding(
            padding:  EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
            child: hText(
              text,
              context,
              size: size,
              color: textColor,
            ),
          )
        ],
      ),
      onPressed: onPressed,
    ),
  );
}

double getAltura(context) {
  return MediaQuery.of(context).size.height;
}

double getLargura(context) {
  return MediaQuery.of(context).size.width;
}

List<String> runMacro(String s, Personagem p) {
  List<String> resultado = ['', ''];
  Random r = new Random();
  List<String> etapas = s.split('#');
  for (String comando in etapas) {
    List<int> dado = isDice(comando);
    bool isDado = dado != null;
    if (isDado) {
      List<String> secundarios = comando.split('+');
      String comando2 = comando.split('+')[1].replaceAll(' ', '');
      if (comando2 == null) {
        for (int i = 0; i < dado[0]; i++) {
          int rolagem = r.nextInt(dado[1] - 1) + 1;
          resultado[0] += 'Rolou 1d${dado[1]} com Resultado: ${rolagem}\n';
          resultado[1] += '${rolagem},';
        }
      } else {
        try {
          int bonus = int.parse(comando2);
          List<int> resultados = new List();
          int rolagem = 0;
          for (int i = 0; i < dado[0]; i++) {
            int parcial = r.nextInt(dado[1] - 1) + 1;
            resultados.add(parcial);
            rolagem += parcial;
          }
          if (resultados.length > 1) {
            String etapa = '';
            for (int r in resultados) {
              etapa += r.toString() + ',';
            }
            resultado[0] +=
                'Rolou com os resultados $etapa por um total de ${rolagem} + (${bonus}) = ${rolagem + bonus}\n';
            resultado[1] += '${rolagem + bonus},';
          } else {
            resultado[0] +=
                'Rolou 1d${dado[1]} com Resultado ${rolagem} + Bonus (${bonus}) = ${rolagem + bonus}\n';
            resultado[1] += '${rolagem + bonus},';
          }
        } catch (err) {
          if (comando2 != 'cac') {
            if (comando2 != 'ad') {
              List valoresMacro = [0, ''];

              List<String> tempSecundarios = new List();
              for (int i = 1; i < secundarios.length; i++) {
                tempSecundarios.add(secundarios[i]);
              }
              secundarios = tempSecundarios;
              for (String s in secundarios) {
                List<int> dado2 = isDice(s);
                bool isDado2 = dado2 != null;
                if (!isDado2) {
                  List valoresParciaisMacro =
                      getValorMacro(s.replaceAll(' ', ''), p);
                  valoresMacro[0] += valoresParciaisMacro[0];
                  valoresMacro[1] += ' ${valoresParciaisMacro[1]}';
                }
              }
              List<String> parcial = rollValues(dado, valoresMacro[0],
                  valoresMacro[1], secundarios.length > 1);
              resultado[0] += parcial[0];
              resultado[1] += parcial[1];
            }
          }
          switch (comando2) {
            case 'cac':
              List<String> cacs = p.cac.split(',');
              for (String cac in cacs) {
                List<int> resultados = new List();
                for (int i = 0; i < dado[0]; i++) {
                  int parcial = r.nextInt(dado[1] - 1) + 1;
                  resultados.add(parcial);
                }
                if (resultados.length > 1) {
                  List<String> parcial = rollValues(
                      dado,
                      int.parse(cac),
                      'Corpo A Corpo(${int.parse(cac)})',
                      secundarios.length > 1);
                  resultado[0] += parcial[0];
                  resultado[1] += parcial[1];
                } else {
                  List<String> parcial = rollValues(
                      dado,
                      int.parse(cac),
                      'Corpo A Corpo(${int.parse(cac)})',
                      secundarios.length > 2);
                  resultado[0] += parcial[0];
                  resultado[1] += parcial[1];
                }
              }
              break;
            case 'ad':
              List<String> ads = p.cac.split(',');
              for (String ad in ads) {
                List<int> resultados = new List();
                for (int i = 0; i < dado[0]; i++) {
                  int parcial = r.nextInt(dado[1] - 1) + 1;
                  resultados.add(parcial);
                }
                if (resultados.length > 1) {
                  List<String> parcial = rollValues(dado, int.parse(ad),
                      'A Distancia(${int.parse(ad)})', secundarios.length > 1);
                  resultado[0] += parcial[0];
                  resultado[1] += parcial[1];
                } else {
                  List<String> parcial = rollValues(dado, int.parse(ad),
                      'A Distancia(${int.parse(ad)})', secundarios.length > 2);
                  resultado[0] += parcial[0];
                  resultado[1] += parcial[1];
                }
              }
              break;
          }
        }
      }
    }
  }
  return resultado;
}

List getValorMacro(String s, Personagem p) {
  List valores = [0, ''];
  switch (s) {
    case 'for':
      valores[0] = getModificador(p.forca);
      valores[1] = 'Força(${getModificador(p.forca)})';
      break;
    case 'dex':
      valores[0] = getModificador(p.dex);
      valores[1] = 'Destreza(${getModificador(p.dex)})';
      break;
    case 'con':
      valores[0] = getModificador(p.con);
      valores[1] = 'Constituição(${getModificador(p.con)})';
      break;
    case 'sab':
      valores[0] = getModificador(p.sab);
      valores[1] = 'Sabedoria(${getModificador(p.sab)})';
      break;
    case 'int':
      valores[0] = getModificador(p.inte);
      valores[1] = 'Inteligencia(${getModificador(p.inte)})';
      break;
    case 'car':
      valores[0] = getModificador(p.car);
      valores[1] = 'Carisma(${getModificador(p.car)})';
      break;
  }
  return valores;
}

rollValues(dado, valor, descricao, bool isMultiple) {
  List<String> resultado = ['', ''];
  Random r = new Random();
  List<int> resultados = new List();
  int rolagem = 0;
  for (int i = 0; i < dado[0]; i++) {
    int parcial = r.nextInt(dado[1] - 1) + 1;
    resultados.add(parcial);
    rolagem += parcial;
  }
  if (resultados.length > 1) {
    String etapa = '';
    for (int r in resultados) {
      etapa += r.toString() + ',';
    }
    resultado[0] +=
        'Rolou com os resultados $etapa por um total de ${rolagem} + $descricao ${isMultiple ? 'Total(${valor})' : ''} = ${rolagem + valor}\n';
    resultado[1] += '${rolagem + valor},';
  } else {
    resultado[0] +=
        'Rolou 1d${dado[1]} com Resultado ${rolagem} +  $descricao ${isMultiple ? 'Total(${valor})' : ''} = ${rolagem + valor}\n';
    resultado[1] += '${rolagem + valor},';
  }
  return resultado;
}

List<int> isDice(String comando) {
  comando.replaceAll('#', '');
  List<String> Comandos = comando.split('+');
  List<int> dado;
  for (String c in Comandos) {
    try {
      int quantidade = int.parse(c.split('d')[0].replaceAll('d', ''));
      int de = int.parse(c.split('d')[1].replaceAll('d', ''));
      dado = new List();
      dado.add(quantidade);
      dado.add(de);
      return dado;
    } catch (err) {
      print(err);
    }
  }
  return dado;
}

List<String> bandeiras = [
  /*'Alelo',
  'American Express',
  'Aura',
  'Banes Card',
  'Cabal',
  'Calcard',
  'Credz',
  'Dinners Club',
  'Discover',*/
  'Elo',
  /*'Good',
  'Green',
  'Hiper',
  'Hiper',*/
  /*'JCB',
  'Mais!',*/
  'Master',
  /*'Max Van',
  'Poly Card',
  'Rede Compras',
  'Sodexo',
  'Soro Cred',
  'Ticket Restaurante',
  'Vero Cheque',*/
  'Visa',
  //'VR'
];
SizedBox sb = SizedBox(
  height: 10,
  width: 10,
);
//String logoNutrannoOnline ='https://scontent.fgpb4-1.fna.fbcdn.net/v/t39.2081-0/64919246_399068487366637_7025924647753351168_n.png?_nc_cat=111&_nc_oc=AQmcoTwIZ6gxOn9Sl-qS-c0Otzqa0kvIzFgtt4z8RH9mjI91gqhHRWFjeNhFH89dIzU&_nc_ht=scontent.fgpb4-1.fna&oh=8145711c13578afd5afe3fda7cde1595&oe=5E540CD7';
CheckDocumentSnapShot(DocumentSnapshot v) {
  try {
    return v.exists && v.data != null;
  } catch (err) {
    err(err, 'CheckSnapshotList');
    return false;
  }
}

String getBandeira(String s) {
  String foto;
  switch (s) {
    case 'Alelo':
      foto = 'assets/Bandeiras/Alelo.png';
      break;
    case 'American Express':
      foto = 'assets/Bandeiras/Americam.png';
      break;
    case 'Aura':
      foto = 'assets/Bandeiras/Aura.png';
      break;
    case 'Banes Card':
      foto = 'assets/Bandeiras/Banes.png';
      break;
    case 'Cabal':
      foto = 'assets/Bandeiras/Cabal.png';
      break;
    case 'Calcard':
      foto = 'assets/Bandeiras/Calcard.png';
      break;
    case 'Credz':
      foto = 'assets/Bandeiras/Credz.png';
      break;
    case 'Dinners Club':
      foto = 'assets/Bandeiras/Dinners.png';
      break;
    case 'Discover':
      foto = 'assets/Bandeiras/Discover.png';
      break;
    case 'Elo':
      foto = 'assets/Bandeiras/Elo.png';
      break;
    case 'Good':
      foto = 'assets/Bandeiras/Good.png';
      break;
    case 'Green':
      foto = 'assets/Bandeiras/Green.png';
      break;
    case 'Hiper':
      foto = 'assets/Bandeiras/Hiper.png';
      break;
    case 'Hipercard':
      foto = 'assets/Bandeiras/Hipercard.png';
      break;
    case 'JCB':
      foto = 'assets/Bandeiras/JCB.png';
      break;
    case 'Mais!':
      foto = 'assets/Bandeiras/Mais.png';
      break;
    case 'Master':
      foto = 'assets/Bandeiras/Mastercard.png';
      break;
    case 'Max Van':
      foto = 'assets/Bandeiras/Max.png';
      break;
    case 'Poly Card':
      foto = 'assets/Bandeiras/Poly.png';
      break;
    case 'Rede Compras':
      foto = 'assets/Bandeiras/Rede.png';
      break;
    case 'Sodexo':
      foto = 'assets/Bandeiras/Sodexo.png';
      break;
    case 'Soro Cred':
      foto = 'assets/Bandeiras/Soro.png';
      break;
    case 'Ticket Restaurante':
      foto = 'assets/Bandeiras/Ticket.png';
      break;
    case 'Vero Cheque':
      foto = 'assets/Bandeiras/Verocheque.png';
      break;
    case 'Visa':
      foto = 'assets/Bandeiras/Visa.png';
      break;
    case 'VR':
      foto = 'assets/Bandeiras/VR.png';
      break;
  }
  return foto;
}

void DefaultValidator(v) {}

CheckSnapShot(AsyncSnapshot v) {
  ;
  try {
    return v.hasData && v.data != null && !v.hasError;
  } catch (err) {
    err(err, 'CheckSnapshotList');
    return false;
  }
}

CheckSnapShotList(AsyncSnapshot v) {
  try {
    return v.hasData && v.data != null && !v.hasError && v.data.length != 0;
  } catch (err) {
    err(err, 'CheckSnapshotList');
    return false;
  }
}

bool isIOS = Platform.isIOS;
Widget roundButton(context,
    {text, width, onPressed, double ratio = 2.5, IconData icon}) {
  if (width == null) {
    width = MediaQuery.of(context).size.width * .6;
  }
  double avaliblespace = (width - MediaQuery.of(context).size.width * .03);
  double tamanhoFonte = (avaliblespace / text.length - 3) * ratio; //RATIO;
  return MaterialButton(
    elevation: 5,
    onPressed: onPressed,
    shape: CircleBorder(),
    color: Colors.transparent,
    child: Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: corPrimaria,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * .03, //MAX .6
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: tamanhoFonte),
            SizedBox(
              width: tamanhoFonte * .5,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: tamanhoFonte),
            )
          ],
        ),
      ),
    ),
  );
}

Widget Badge(int i, {double size = 20, double fontsize = 14}) {
  return i == 0
      ? Container()
      : Container(
          width: size,
          height: size,
          child: Center(
            child: Text(
              i.toString(),
              style: TextStyle(
                fontSize: fontsize,
                color: Colors.white,
              ),
            ),
          ),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        );
}

EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
int StringToInt(String s) {
  return int.parse(s
      .replaceAll(',', '')
      .replaceAll('.', '')
      .replaceAll(' ', '')
      .replaceAll('-', '')
      .replaceAll('Anos', ''));
}

double StringToDouble(String s) {
  return double.parse(s
      .replaceAll(',', '.')
      .replaceAll(' ', '')
      .replaceAll('-', '')
      .replaceAll('kg', '')
      .replaceAll('cm', ''));
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  try {
    return double.parse(s) != null;
  } catch (err) {
    return false;
  }
}

InputDecoration DefaultInputDecoration(
  context, {
  var icon,
  var hintText= corPrimaria,
      hintColor= corPrimaria,
  error,
  var labelText, borderColor = corPrimaria,
}) {
  double fontsize = 14;
  FontStyle fontStyle = FontStyle.italic;
  ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
  );
  OutlineInputBorder focusedborder = OutlineInputBorder(
    borderSide: BorderSide(color: borderColor, width: 2.0),
  );
  TextStyle labelStyle = TextStyle(
    fontSize: ScreenUtil.getInstance().setSp(36),
    color: corPrimaria,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );
  if (icon == null) {
    if (error == null) {
      return InputDecoration(
          hintText: hintText,
          focusedBorder: focusedborder,
          hoverColor: borderColor,
          enabledBorder: border,
          labelText: labelText,
          focusColor: borderColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          labelStyle: labelStyle,
          hintStyle: TextStyle(
              color: hintColor, fontSize: fontsize, fontStyle: fontStyle));
    }
    return InputDecoration(
        hintText: hintText,
        labelText: labelText,
        focusedBorder: focusedborder,
        hoverColor: borderColor,
        enabledBorder: border,
        errorText: error,
        focusColor: borderColor,
        labelStyle: labelStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        hintStyle: TextStyle(
            color: hintColor, fontSize: fontsize, fontStyle: fontStyle));
  }
  if (error == null) {
    return InputDecoration(
        hintText: hintText,
        focusedBorder: focusedborder,
        hoverColor: borderColor,
        enabledBorder: border,
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        icon: Icon(
          icon,
          color: corPrimaria,
        ),
        labelText: labelText,
        focusColor: borderColor,
        labelStyle: labelStyle,
        hintStyle: TextStyle(
            color: hintColor, fontSize: fontsize, fontStyle: fontStyle));
  }
  return InputDecoration(
      icon: Icon(
        icon,
        color: corPrimaria,
      ),
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      focusedBorder: focusedborder,
      hoverColor: borderColor,
      enabledBorder: border,
      labelText: labelText,
      focusColor: borderColor,
      errorText: error,
      labelStyle: TextStyle(
        color: corPrimaria,
      ),
      hintStyle: TextStyle(
          color: hintColor, fontSize: fontsize, fontStyle: fontStyle));
}

DefaultField(
    {String hint = '',
    String label = '',
    Function validator,
    var keyboardType,

    var controller,
    Function onSubmited,
    TextCapitalization capitalization,
    bool expands = false,
    int minLines = 1,
    onChange,
    int maxLines = 1,
    TextStyle style,
      borderColor = corPrimaria,
    context,
    bool enabled = true,
     icon,
      var color,
    padding = const EdgeInsets.all(8),
    int maxLength, Color hintColor = Colors.grey, error = null}) {
  if (style == null) {
    ScreenUtil.instance = ScreenUtil(allowFontScaling: true)..init(context);
    style = TextStyle(
      fontSize: ScreenUtil.getInstance().setSp(36),
      color: color,

      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    );
  }
  return new Padding(
    padding: padding,
    child: TextFormField(
      expands: expands,
      minLines: minLines,
      maxLines: maxLines,
      enabled: enabled,
      cursorColor: corPrimaria,
      cursorWidth: 2,
      enableInteractiveSelection: true,
      style: style,
      textCapitalization:
          capitalization == null ? TextCapitalization.none : capitalization,
      onFieldSubmitted: onSubmited,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChange,
      validator: validator,
      maxLength: maxLength,
      textAlign: TextAlign.start,
      autocorrect: true,
      decoration: DefaultInputDecoration(context,
          icon: icon, hintText: hint, labelText: label,borderColor: borderColor,hintColor:hintColor,error: error),
      autovalidate: true,
    ),
  );
}

Widget TextFieldChange(String label, String content, function, context,
    {width}) {
  if (width == null) {
    width = MediaQuery.of(context).size.width * .6;
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: Helper.labelStyle,
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              width: width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      content == null ? '' : content,
                      style: Helper.textStyle,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        CupertinoButton(
          child: Text(
            function == null ? '' : 'Editar',
            style:
                TextStyle(color: function == null ? Colors.grey : corPrimaria),
          ),
          onPressed: function,
        )
      ],
    ),
  );
}

String capitalize(String s) {
  String result = '';
  var a = s.split(' ');
  for(var i in a){
    result+=i[0].toUpperCase() + i.substring(1).toLowerCase()+' ';
  }
  print('Resultado = ${result}');
  return result;
}


Widget Loading({
  int duration = 3,
  Widget completed,
  double altura = 50,
  double largura = 50,
}) {
  return Center(
    child: FutureBuilder(
      builder: (context, future) {
        if (future.data != null) {
          return completed;
        }
       return Container();
      },
      future: Future.delayed(Duration(seconds: duration)).then((v) {
        return true;
      }),
    ),
  );
}

getAtributeIcon(String atributo) {
  switch (atributo) {
    case 'for':
      return MdiIcons.armFlex;
    case 'dex':
      return MdiIcons.runFast;
    case 'cons':
      return MdiIcons.shieldOutline;
    case 'int':
      return MdiIcons.brain;
    case 'sab':
      return MdiIcons.eye;
    case 'car':
      return MdiIcons.glasses;
    case 'NA':
      return MdiIcons.nullIcon;
  }
  return MdiIcons.armFlex;
}

getSlotItem(String slot) {
  switch (slot) {
    case 'Cabeça':
      return AssetImage('assets/Elmo');
    case 'dex':
      return MdiIcons.runFast;
    case 'cons':
      return MdiIcons.shieldOutline;
    case 'int':
      return MdiIcons.brain;
    case 'sab':
      return MdiIcons.eye;
    case 'car':
      return MdiIcons.glasses;
    case 'NA':
      return MdiIcons.nullIcon;
  }
  return MdiIcons.armFlex;
}

getPericiaModificador(String atributo, Personagem p) {
  switch (atributo) {
    case 'for':
      return getModificador(p.forca);
    case 'dex':
      return getModificador(p.dex);
    case 'cons':
      return getModificador(p.con);
    case 'int':
      return getModificador(p.inte);
    case 'sab':
      return getModificador(p.sab);
    case 'car':
      return getModificador(p.car);
    case 'NA':
      return 0;
  }
}

Widget LoadingScreen(String loadingText) {
  return Container(
      child: Center(
    child: Column(
      children: <Widget>[
        Text(loadingText),
        SpinKitFadingCircle(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        ),
      ],
    ),
  ));
}

dToastTop(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

dToast(String msg, {int timeInSecForIoss, String cor}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIos: timeInSecForIoss,
      backgroundColor: corPrimaria,
      textColor: Colors.white,
      fontSize: 16.0);
}
var linearGradient = const BoxDecoration(
  gradient: const LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.bottomRight,
    colors: <Color>[
      Color.fromRGBO(0, 168, 180, 100),
      Colors.indigo,
    ],
  ),
);
myAppBar(String titulo, context,
    {actions, bool showBack = false, bool close = false}) {
  if (showBack) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (close) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      shape: Border.all(),
                      title: new Text('Deseja Sair?'),
                      content: Text('Tem Certeza?'),
                      actions: <Widget>[
                        MaterialButton(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        MaterialButton(
                          child: Text(
                            'Sair',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                        )
                      ],
                    );
                  });
            } else {
              Navigator.of(context).pop();
            }
          }),
      backgroundColor: corPrimaria,
      iconTheme: new IconThemeData(color: Colors.white),
      centerTitle: true,
      actionsIconTheme: new IconThemeData(color: Colors.white),
      actions: actions,
      title: Text(
        titulo,
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontFamily: 'HelveticaNeueBd',
        ),
      ),
    );
  }
  return AppBar(
    backgroundColor: corPrimaria,
    iconTheme: new IconThemeData(color: Colors.white),
    centerTitle: true,
    actionsIconTheme: new IconThemeData(color: Colors.white),
    actions: actions,
    title: Text(
      titulo,
      style: TextStyle(
        fontSize: 22,
        color: Colors.yellowAccent,
        fontWeight: FontWeight.bold,
        fontFamily: 'HelveticaNeueBd',
      ),
    ),
  );
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

class Helper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final storage = new FlutterSecureStorage();
  static FirebaseUser user;
  static Color blue_default = Colors.blue;
  static User localUser;
  static FirebaseMessaging fbmsg;
  static String UserType;
  static String INSTAGRAM_APP_ID = "237a05e3e39541788fd96532e02f5459";
  static String INSTAGRAM_APP_SECRET = "e6bc2c55e3354f92ae4fdcce36107f1a";
  static NotificacoesHelper nh = new NotificacoesHelper();
  static String token;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static CieloEcommerce cielo;

  static TextStyle labelStyle = TextStyle(
    color: Colors.grey[400],
    fontSize: 18,
  );
  static TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  static int selectedCoach = 0;
  String readTimestamp(DateTime date) {
    //TODO Tirar o -50000000
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    return timeago.format(date, locale: 'pt_BR');
  }

  setUserType(String type) {
    UserType = type;
    SharedPreferences.getInstance().then((sp) {
      sp.setString('UserType', type);
    }).catchError((err) {
      print('Erro ao gravar UserType: ${err.toString()}');
    });
  }

  Helpers() {
    if (user == null) {
      getUser();
    }
  }

  getUser() async {
    user = await _auth.currentUser();
  }

  /*(List<LatLng> points) {
    List<maps.LatLng> lpoints = new List<maps.LatLng>();
    for (LatLng p in points) {
      lpoints.add(maps.LatLng(p.latitude, p.longitude));
    }
    return lpoints;
  }

  toPoints(List<maps.LatLng> points) {
    List<LatLng> lpoints = new List<LatLng>();
    for (maps.LatLng p in points) {
      lpoints.add(LatLng(p.latitude, p.longitude));
    }
    return lpoints;
  }*/

  void LogUserData(User user) {
    analytics.setUserId(user.id);
    analytics.setUserProperty(name: 'nome', value: user.nome).then((v) {
      print('Registrou Dados');
    });
    analytics.setUserProperty(name: 'email', value: user.email).then((v) {
      print('Registrou Dados');
    });
    ;
  }

  Future<LatLng> fromAddres(String query) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    Coordinates c = first.coordinates;
    return LatLng(c.latitude, c.longitude);
  }

  uniqifyList(list) {
    for (int i = 0; i < list.length; i++) {
      var o = list[i];
      int index;
      // Remove duplicates
      do {
        index = list.indexOf(o, i + 1);
        if (index != -1) {
          list.removeRange(index, 1);
        }
      } while (index != -1);
    }
    return list;
  }

  Future<String> uploadPicture(String filepath,
      {String filename, String ref}) async {
    File imageFile = File(filepath);
    String extension = filepath.split('.')[1];
    int random = new Random().nextInt(100000);

    if (filename == null) {
      filename = 'image_$random.${extension}';
    }
    StorageReference ref = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = ref.put(imageFile);
    return uploadTask.onComplete.then((d) {
      return d.ref.getDownloadURL().then((url) {
        var downloadUrl = url;
        return downloadUrl.toString();
      }).catchError((err) {
        print('Error: ${err}');
        return null;
      });
    }).catchError((err) {
      print('Error: ${err}');
      return null;
    });
  }

  jsonToList(j) {
    List l = new List();
    for (int i = 0; i < j.length; i++) {
      l.add(j[i]);
    }
    return l;
  }
}

openMap(String titulo, double latitude, double longitude, context) async {
  final url =
      'https://www.google.com/maps/search/?api=1&query=$latitude},${longitude}';
  bool waze = await canLaunch("waze://");
  bool google = await canLaunch(url);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          titulo,
        ),
        actions: <Widget>[
          google
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.google),
                  onPressed: () async {
                    await launch(url);
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
          waze
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.waze),
                  onPressed: () {
                    launch("waze://?ll=${latitude},${longitude}&navigate=yes");
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
          MaterialButton(
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            color: myOrange,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
    barrierDismissible: true,
  );
}

String getMonthString(int month) {
  switch (month) {
    case 1:
      return 'Janeiro';
    case 2:
      return 'Fevereiro';
    case 3:
      return 'Março';
    case 4:
      return 'Abril';
    case 5:
      return 'Maio';
    case 6:
      return 'Junho';
    case 7:
      return 'Julho';
    case 8:
      return 'Agosto';
    case 9:
      return 'Setembro';
    case 10:
      return 'Outubro';
    case 11:
      return 'Novembro';
    case 12:
      return 'Dezembro';
  }
}

String pickAvagar(double d, bool male) {
  print('AQUI MALE ${male} IMC = ${d}');
  if (male) {
    if (d < 18.6) {
      return 'assets/avatares/male1.jpeg';
    } else if (d > 18.6 && d < 24.99) {
      return 'assets/avatares/male2.jpeg';
    } else if (d > 25 && d < 29.99) {
      return 'assets/avatares/male3.jpeg';
    } else if (d > 30 && d < 34.99) {
      return 'assets/avatares/male4.jpeg';
    } else if (d > 35 && d < 39.99) {
      return 'assets/avatares/male5.jpeg';
    } else if (d > 40) {
      return 'assets/avatares/male6.jpeg';
    }
  } else {
    if (d < 18.6) {
      return 'assets/avatares/female1.jpeg';
    } else if (d > 18.6 && d < 24.99) {
      return 'assets/avatares/female2.jpeg';
    } else if (d > 25 && d < 29.99) {
      return 'assets/avatares/female3.jpeg';
    } else if (d > 30 && d < 34.99) {
      return 'assets/avatares/female4.jpeg';
    } else if (d > 35 && d < 39.99) {
      return 'assets/avatares/female5.jpeg';
    } else if (d > 40) {
      return 'assets/avatares/female7.jpeg';
    }
  }
}

enum documentos {
  RG,
  CPF,
  CNH,
  PASSAPORTE,
}
final defaultDiacriticsRemovalap = [
  {
    'base': 'A',
    'letters':
        '\u0041\u24B6\uFF21\u00C0\u00C1\u00C2\u1EA6\u1EA4\u1EAA\u1EA8\u00C3\u0100\u0102\u1EB0\u1EAE\u1EB4\u1EB2\u0226\u01E0\u00C4\u01DE\u1EA2\u00C5\u01FA\u01CD\u0200\u0202\u1EA0\u1EAC\u1EB6\u1E00\u0104\u023A\u2C6F'
  },
  {'base': 'AA', 'letters': '\uA732'},
  {'base': 'AE', 'letters': '\u00C6\u01FC\u01E2'},
  {'base': 'AO', 'letters': '\uA734'},
  {'base': 'AU', 'letters': '\uA736'},
  {'base': 'AV', 'letters': '\uA738\uA73A'},
  {'base': 'AY', 'letters': '\uA73C'},
  {
    'base': 'B',
    'letters': '\u0042\u24B7\uFF22\u1E02\u1E04\u1E06\u0243\u0182\u0181'
  },
  {
    'base': 'C',
    'letters':
        '\u0043\u24B8\uFF23\u0106\u0108\u010A\u010C\u00C7\u1E08\u0187\u023B\uA73E'
  },
  {
    'base': 'D',
    'letters':
        '\u0044\u24B9\uFF24\u1E0A\u010E\u1E0C\u1E10\u1E12\u1E0E\u0110\u018B\u018A\u0189\uA779'
  },
  {'base': 'DZ', 'letters': '\u01F1\u01C4'},
  {'base': 'Dz', 'letters': '\u01F2\u01C5'},
  {
    'base': 'E',
    'letters':
        '\u0045\u24BA\uFF25\u00C8\u00C9\u00CA\u1EC0\u1EBE\u1EC4\u1EC2\u1EBC\u0112\u1E14\u1E16\u0114\u0116\u00CB\u1EBA\u011A\u0204\u0206\u1EB8\u1EC6\u0228\u1E1C\u0118\u1E18\u1E1A\u0190\u018E'
  },
  {'base': 'F', 'letters': '\u0046\u24BB\uFF26\u1E1E\u0191\uA77B'},
  {
    'base': 'G',
    'letters':
        '\u0047\u24BC\uFF27\u01F4\u011C\u1E20\u011E\u0120\u01E6\u0122\u01E4\u0193\uA7A0\uA77D\uA77E'
  },
  {
    'base': 'H',
    'letters':
        '\u0048\u24BD\uFF28\u0124\u1E22\u1E26\u021E\u1E24\u1E28\u1E2A\u0126\u2C67\u2C75\uA78D'
  },
  {
    'base': 'I',
    'letters':
        '\u0049\u24BE\uFF29\u00CC\u00CD\u00CE\u0128\u012A\u012C\u0130\u00CF\u1E2E\u1EC8\u01CF\u0208\u020A\u1ECA\u012E\u1E2C\u0197'
  },
  {'base': 'J', 'letters': '\u004A\u24BF\uFF2A\u0134\u0248'},
  {
    'base': 'K',
    'letters':
        '\u004B\u24C0\uFF2B\u1E30\u01E8\u1E32\u0136\u1E34\u0198\u2C69\uA740\uA742\uA744\uA7A2'
  },
  {
    'base': 'L',
    'letters':
        '\u004C\u24C1\uFF2C\u013F\u0139\u013D\u1E36\u1E38\u013B\u1E3C\u1E3A\u0141\u023D\u2C62\u2C60\uA748\uA746\uA780'
  },
  {'base': 'LJ', 'letters': '\u01C7'},
  {'base': 'Lj', 'letters': '\u01C8'},
  {'base': 'M', 'letters': '\u004D\u24C2\uFF2D\u1E3E\u1E40\u1E42\u2C6E\u019C'},
  {
    'base': 'N',
    'letters':
        '\u004E\u24C3\uFF2E\u01F8\u0143\u00D1\u1E44\u0147\u1E46\u0145\u1E4A\u1E48\u0220\u019D\uA790\uA7A4'
  },
  {'base': 'NJ', 'letters': '\u01CA'},
  {'base': 'Nj', 'letters': '\u01CB'},
  {
    'base': 'O',
    'letters':
        '\u004F\u24C4\uFF2F\u00D2\u00D3\u00D4\u1ED2\u1ED0\u1ED6\u1ED4\u00D5\u1E4C\u022C\u1E4E\u014C\u1E50\u1E52\u014E\u022E\u0230\u00D6\u022A\u1ECE\u0150\u01D1\u020C\u020E\u01A0\u1EDC\u1EDA\u1EE0\u1EDE\u1EE2\u1ECC\u1ED8\u01EA\u01EC\u00D8\u01FE\u0186\u019F\uA74A\uA74C'
  },
  {'base': 'OI', 'letters': '\u01A2'},
  {'base': 'OO', 'letters': '\uA74E'},
  {'base': 'OU', 'letters': '\u0222'},
  {'base': 'OE', 'letters': '\u008C\u0152'},
  {'base': 'oe', 'letters': '\u009C\u0153'},
  {
    'base': 'P',
    'letters': '\u0050\u24C5\uFF30\u1E54\u1E56\u01A4\u2C63\uA750\uA752\uA754'
  },
  {'base': 'Q', 'letters': '\u0051\u24C6\uFF31\uA756\uA758\u024A'},
  {
    'base': 'R',
    'letters':
        '\u0052\u24C7\uFF32\u0154\u1E58\u0158\u0210\u0212\u1E5A\u1E5C\u0156\u1E5E\u024C\u2C64\uA75A\uA7A6\uA782'
  },
  {
    'base': 'S',
    'letters':
        '\u0053\u24C8\uFF33\u1E9E\u015A\u1E64\u015C\u1E60\u0160\u1E66\u1E62\u1E68\u0218\u015E\u2C7E\uA7A8\uA784'
  },
  {
    'base': 'T',
    'letters':
        '\u0054\u24C9\uFF34\u1E6A\u0164\u1E6C\u021A\u0162\u1E70\u1E6E\u0166\u01AC\u01AE\u023E\uA786'
  },
  {'base': 'TZ', 'letters': '\uA728'},
  {
    'base': 'U',
    'letters':
        '\u0055\u24CA\uFF35\u00D9\u00DA\u00DB\u0168\u1E78\u016A\u1E7A\u016C\u00DC\u01DB\u01D7\u01D5\u01D9\u1EE6\u016E\u0170\u01D3\u0214\u0216\u01AF\u1EEA\u1EE8\u1EEE\u1EEC\u1EF0\u1EE4\u1E72\u0172\u1E76\u1E74\u0244'
  },
  {'base': 'V', 'letters': '\u0056\u24CB\uFF36\u1E7C\u1E7E\u01B2\uA75E\u0245'},
  {'base': 'VY', 'letters': '\uA760'},
  {
    'base': 'W',
    'letters': '\u0057\u24CC\uFF37\u1E80\u1E82\u0174\u1E86\u1E84\u1E88\u2C72'
  },
  {'base': 'X', 'letters': '\u0058\u24CD\uFF38\u1E8A\u1E8C'},
  {
    'base': 'Y',
    'letters':
        '\u0059\u24CE\uFF39\u1EF2\u00DD\u0176\u1EF8\u0232\u1E8E\u0178\u1EF6\u1EF4\u01B3\u024E\u1EFE'
  },
  {
    'base': 'Z',
    'letters':
        '\u005A\u24CF\uFF3A\u0179\u1E90\u017B\u017D\u1E92\u1E94\u01B5\u0224\u2C7F\u2C6B\uA762'
  },
  {
    'base': 'a',
    'letters':
        '\u0061\u24D0\uFF41\u1E9A\u00E0\u00E1\u00E2\u1EA7\u1EA5\u1EAB\u1EA9\u00E3\u0101\u0103\u1EB1\u1EAF\u1EB5\u1EB3\u0227\u01E1\u00E4\u01DF\u1EA3\u00E5\u01FB\u01CE\u0201\u0203\u1EA1\u1EAD\u1EB7\u1E01\u0105\u2C65\u0250'
  },
  {'base': 'aa', 'letters': '\uA733'},
  {'base': 'ae', 'letters': '\u00E6\u01FD\u01E3'},
  {'base': 'ao', 'letters': '\uA735'},
  {'base': 'au', 'letters': '\uA737'},
  {'base': 'av', 'letters': '\uA739\uA73B'},
  {'base': 'ay', 'letters': '\uA73D'},
  {
    'base': 'b',
    'letters': '\u0062\u24D1\uFF42\u1E03\u1E05\u1E07\u0180\u0183\u0253'
  },
  {
    'base': 'c',
    'letters':
        '\u0063\u24D2\uFF43\u0107\u0109\u010B\u010D\u00E7\u1E09\u0188\u023C\uA73F\u2184'
  },
  {
    'base': 'd',
    'letters':
        '\u0064\u24D3\uFF44\u1E0B\u010F\u1E0D\u1E11\u1E13\u1E0F\u0111\u018C\u0256\u0257\uA77A'
  },
  {'base': 'dz', 'letters': '\u01F3\u01C6'},
  {
    'base': 'e',
    'letters':
        '\u0065\u24D4\uFF45\u00E8\u00E9\u00EA\u1EC1\u1EBF\u1EC5\u1EC3\u1EBD\u0113\u1E15\u1E17\u0115\u0117\u00EB\u1EBB\u011B\u0205\u0207\u1EB9\u1EC7\u0229\u1E1D\u0119\u1E19\u1E1B\u0247\u025B\u01DD'
  },
  {'base': 'f', 'letters': '\u0066\u24D5\uFF46\u1E1F\u0192\uA77C'},
  {
    'base': 'g',
    'letters':
        '\u0067\u24D6\uFF47\u01F5\u011D\u1E21\u011F\u0121\u01E7\u0123\u01E5\u0260\uA7A1\u1D79\uA77F'
  },
  {
    'base': 'h',
    'letters':
        '\u0068\u24D7\uFF48\u0125\u1E23\u1E27\u021F\u1E25\u1E29\u1E2B\u1E96\u0127\u2C68\u2C76\u0265'
  },
  {'base': 'hv', 'letters': '\u0195'},
  {
    'base': 'i',
    'letters':
        '\u0069\u24D8\uFF49\u00EC\u00ED\u00EE\u0129\u012B\u012D\u00EF\u1E2F\u1EC9\u01D0\u0209\u020B\u1ECB\u012F\u1E2D\u0268\u0131'
  },
  {'base': 'j', 'letters': '\u006A\u24D9\uFF4A\u0135\u01F0\u0249'},
  {
    'base': 'k',
    'letters':
        '\u006B\u24DA\uFF4B\u1E31\u01E9\u1E33\u0137\u1E35\u0199\u2C6A\uA741\uA743\uA745\uA7A3'
  },
  {
    'base': 'l',
    'letters':
        '\u006C\u24DB\uFF4C\u0140\u013A\u013E\u1E37\u1E39\u013C\u1E3D\u1E3B\u017F\u0142\u019A\u026B\u2C61\uA749\uA781\uA747'
  },
  {'base': 'lj', 'letters': '\u01C9'},
  {'base': 'm', 'letters': '\u006D\u24DC\uFF4D\u1E3F\u1E41\u1E43\u0271\u026F'},
  {
    'base': 'n',
    'letters':
        '\u006E\u24DD\uFF4E\u01F9\u0144\u00F1\u1E45\u0148\u1E47\u0146\u1E4B\u1E49\u019E\u0272\u0149\uA791\uA7A5'
  },
  {'base': 'nj', 'letters': '\u01CC'},
  {
    'base': 'o',
    'letters':
        '\u006F\u24DE\uFF4F\u00F2\u00F3\u00F4\u1ED3\u1ED1\u1ED7\u1ED5\u00F5\u1E4D\u022D\u1E4F\u014D\u1E51\u1E53\u014F\u022F\u0231\u00F6\u022B\u1ECF\u0151\u01D2\u020D\u020F\u01A1\u1EDD\u1EDB\u1EE1\u1EDF\u1EE3\u1ECD\u1ED9\u01EB\u01ED\u00F8\u01FF\u0254\uA74B\uA74D\u0275'
  },
  {'base': 'oi', 'letters': '\u01A3'},
  {'base': 'ou', 'letters': '\u0223'},
  {'base': 'oo', 'letters': '\uA74F'},
  {
    'base': 'p',
    'letters': '\u0070\u24DF\uFF50\u1E55\u1E57\u01A5\u1D7D\uA751\uA753\uA755'
  },
  {'base': 'q', 'letters': '\u0071\u24E0\uFF51\u024B\uA757\uA759'},
  {
    'base': 'r',
    'letters':
        '\u0072\u24E1\uFF52\u0155\u1E59\u0159\u0211\u0213\u1E5B\u1E5D\u0157\u1E5F\u024D\u027D\uA75B\uA7A7\uA783'
  },
  {
    'base': 's',
    'letters':
        '\u0073\u24E2\uFF53\u00DF\u015B\u1E65\u015D\u1E61\u0161\u1E67\u1E63\u1E69\u0219\u015F\u023F\uA7A9\uA785\u1E9B'
  },
  {
    'base': 't',
    'letters':
        '\u0074\u24E3\uFF54\u1E6B\u1E97\u0165\u1E6D\u021B\u0163\u1E71\u1E6F\u0167\u01AD\u0288\u2C66\uA787'
  },
  {'base': 'tz', 'letters': '\uA729'},
  {
    'base': 'u',
    'letters':
        '\u0075\u24E4\uFF55\u00F9\u00FA\u00FB\u0169\u1E79\u016B\u1E7B\u016D\u00FC\u01DC\u01D8\u01D6\u01DA\u1EE7\u016F\u0171\u01D4\u0215\u0217\u01B0\u1EEB\u1EE9\u1EEF\u1EED\u1EF1\u1EE5\u1E73\u0173\u1E77\u1E75\u0289'
  },
  {'base': 'v', 'letters': '\u0076\u24E5\uFF56\u1E7D\u1E7F\u028B\uA75F\u028C'},
  {'base': 'vy', 'letters': '\uA761'},
  {
    'base': 'w',
    'letters':
        '\u0077\u24E6\uFF57\u1E81\u1E83\u0175\u1E87\u1E85\u1E98\u1E89\u2C73'
  },
  {'base': 'x', 'letters': '\u0078\u24E7\uFF58\u1E8B\u1E8D'},
  {
    'base': 'y',
    'letters':
        '\u0079\u24E8\uFF59\u1EF3\u00FD\u0177\u1EF9\u0233\u1E8F\u00FF\u1EF7\u1E99\u1EF5\u01B4\u024F\u1EFF'
  },
  {
    'base': 'z',
    'letters':
        '\u007A\u24E9\uFF5A\u017A\u1E91\u017C\u017E\u1E93\u1E95\u01B6\u0225\u0240\u2C6C\uA763'
  }
];
final diacriticsMap = {};

final diacriticsRegExp = new RegExp('[^\u0000-\u007E]', multiLine: true);

extension StringExtension on String {
  get validarDocumento {
    if (this.toLowerCase().contains('CNH'.toLowerCase()) ||
        this
            .toLowerCase()
            .contains('CARTEIRA NACIONAL DE HABILITAÇÃO'.toLowerCase()) ||
        this
            .toLowerCase()
            .contains('CARTEIRA NACIONAL DE HABILITACAO'.toLowerCase())) {
      return documentos.CNH;
    }
    if (this.toLowerCase().contains('REGISTRO GERAL'.toLowerCase())) {
      return documentos.RG;
    }
    if (this
            .toLowerCase()
            .contains('Cadastro de Pessoas Fisicas'.toLowerCase()) ||
        this.toLowerCase().contains('CPF'.toLowerCase())) {
      List<String> list = this.split(' ');
      bool isValid = false;
      for (String s in list) {
        if (CPFValidator.isValid(s.replaceAll('.', '').replaceAll('-', ''))) {
          isValid = true;
        }
      }
      print("AQUI TIPO: CPF > Valido? ${isValid}");
      if (isValid) {
        return documentos.CPF;
      } else {
        return null;
      }
    }
    if (this.toLowerCase().contains('PASSAPORTE'.toLowerCase()) ||
        this.toLowerCase().contains('PASSPORT'.toLowerCase()) ||
        this.toLowerCase().contains('PASAPORT'.toLowerCase())) {
      return documentos.PASSAPORTE;
    }
  }

  String get getCPF {
    List<String> list = this.split(' ');
    String cpf = null;
    for (String s in list) {
      if (CPFValidator.isValid(s.replaceAll('.', '').replaceAll('-', ''))) {
        cpf = s;
      }
    }
    return cpf;
  }

  String get removerAcentos {
    if (diacriticsMap.isEmpty) {
      for (var i = 0; i < defaultDiacriticsRemovalap.length; i++) {
        var letters = defaultDiacriticsRemovalap[i]['letters'];
        for (var j = 0; j < letters.length; j++) {
          diacriticsMap[letters[j]] = defaultDiacriticsRemovalap[i]['base'];
        }
      }
    }
    // "what?" version ... http://jsperf.com/diacritics/12
    return this.replaceAllMapped(diacriticsRegExp, (a) {
      return diacriticsMap[a.group(0)] != null
          ? diacriticsMap[a.group(0)]
          : a.group(0);
    });
  }
}
