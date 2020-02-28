import 'dart:io';


import 'package:autooh/Telas/Perfil/PerfilVistoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:autooh/Helpers/Helper.dart';

import 'package:autooh/Helpers/Styles.dart';

import 'package:autooh/Objetos/Produto.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/Marketplace/Produto/CadastrarProduto/CadastrarProdutoController.dart';
import 'package:short_stream_builder/short_stream_builder.dart';

import '../../../../Objetos/Endereco.dart';
import '../../../../main.dart';
import 'EditarProdutoController.dart';

class EditarProdutoPage extends StatefulWidget {
  @override
  _EditarProdutoPageState createState() {
    return _EditarProdutoPageState();
  }
  Produto produtos;
  EditarProdutoPage({this.produtos});

}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  bool _sel = false;
  final _formKey = GlobalKey<FormState>();
  var controllerTitulo = new TextEditingController(text: '');
  var controllerDescricao = TextEditingController(text: '');

  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerEstado = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNumero = new TextEditingController(text: '');
  bool isCadastrarPressed = false;
  var controllerPreco = new TextEditingController();
  CadastrarProdutoController cpc;

  Produto produto;
  Endereco endereco;
  bool resp;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    /*Future.delayed(Duration(seconds: 4)).then((v) {
      coachRef.document(Helper.localUser.prestador).get().then((v) {
        prestador c = prestador.fromJson(v.data);
        if (!c.isMerchant) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CadastrarMerchantPage(
                        c: c,
                      )));
        }
      });
    });*/
  }

  Future getImage(Produto pp) async {
    if (pp == null) {
      pp = new Produto.Empty();
    }

    if (pp.fotos == null) {
      pp.fotos = new List();
    }
    showDialog(context:context, builder: (context) {
      return AlertDialog( shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            defaultActionButton('Camera', context, () {
              ImagePicker.pickImage(
                source: ImageSource.camera,
              ).timeout(Duration(seconds: 30)).then((image) {
                print('AQUI FOTO ${image}');
                if (image != null) {
                  if (image.path != null) {
                    pp.fotos.add(image.path);
                    epc.inProduto.add(pp);
                    dToast('Salvando Foto!');
                  }
                }
              }).catchError((err) {
                print('ERRO NO IMAGE PICKER ${err.toString()}');
              });
            },icon:Icons.camera),
            defaultActionButton('Galeria', context, () {
              ImagePicker.pickImage(
                source: ImageSource.gallery,
              ).timeout(Duration(seconds: 30)).then((image) {
                print('AQUI FOTO ${image}');
                if (image != null) {
                  if (image.path != null) {
                    pp.fotos.add(image.path);
                    epc.inProduto.add(pp);
                    dToast('Salvando Foto!');
                  }
                }
              }).catchError((err) {
                print('ERRO NO IMAGE PICKER ${err.toString()}');
              });
            },icon:Icons.photo),
          ],
        ),
      );
    });
  }
  EditarProdutoController epc;
  @override
  Widget build(BuildContext context) {
    if (cpc == null) {
      cpc = CadastrarProdutoController();
    }

    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawerWidget(),
      appBar: myAppBar('Editar Produto', context, showBack: true),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: SSB(
                isList: false,
                stream: cpc.outProduto,
                buildfunction: (context, AsyncSnapshot snap) {

                  produto = snap.data;
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        sb,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Cadastrar',
                                  textAlign: TextAlign.center,
                                  style: estiloTextoBotao),
                            ),
                          ],
                        ),
                        Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(children: <Widget>[
                              produto.fotos != null
                                  ? produto.fotos.length != 1
                                  ? Swiper(
                                itemBuilder: (BuildContext context,
                                    int index) {
                                  return Container(
                                    child: produto.fotos[index]
                                        .contains('http')
                                        ? Image(
                                        image:
                                        CachedNetworkImageProvider(
                                            produto.fotos[
                                            index]),
                                        height: 200,
                                        fit: BoxFit.fitHeight,
                                        width: 300)
                                        : Image.file(
                                        File(
                                            produto.fotos[index]),
                                        height: 200,
                                        fit: BoxFit.fitHeight,
                                        width: 300),
                                    height: 200,
                                    width: 300,
                                  );
                                },
                                itemHeight: 200,
                                itemWidth: 300,
                                containerWidth: 300,
                                itemCount: produto.fotos.length,
                                scrollDirection: Axis.horizontal,
                                pagination: new SwiperPagination(),
                                control: new SwiperControl(),
                              )
                                  : Container(
                                  child: Center(
                                      child: produto.fotos[0]
                                          .contains('http')
                                          ? Image(
                                        image:
                                        CachedNetworkImageProvider(
                                            produto.fotos[0]),
                                        height: 200,
                                      )
                                          : Image.file(
                                          File(produto.fotos[0]))))
                                  : Image.asset(
                                'assets/images/nutrannoLogo.png',
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Center(
                                child: MaterialButton(
                                  child: Icon(
                                    MdiIcons.cameraOutline,
                                    color: Colors.white,
                                  ),
                                  color: Colors.transparent,
                                  onPressed: () {
                                    getImage(produto);
                                  },
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color: Colors.transparent)),
                                ),
                              )
                            ])),
                        DefaultField(
                            controller: controllerTitulo,
                            hint: produto.titulo,
                            context: context,
                            label: 'Título',
                            icon: FontAwesomeIcons.adn,
                            validator: (v) {},
                            keyboardType: TextInputType.text,
                            capitalization: TextCapitalization.words,
                            onSubmited: (s) {}),
                        Container(
                            height: 120,
                            child: DefaultField(
                              hint:
                              'Mistura à base de Nutrev, ovo, água e queijo.',
                              onSubmited: (s) {},
                              capitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              expands: true,
                              minLines: null,
                              context: context,
                              icon: FontAwesomeIcons.envelopeOpenText,
                              validator: (v) {},
                              controller: controllerDescricao,
                              label: 'Descrição',
                              maxLines: null,
                            )),
                        sb,
                        DefaultField(
                            controller: controllerPreco,
                            hint: 'R\$4,00',
                            label: 'Preço + taxa 15%',
                            enabled: true,
                            context: context,
                            icon: FontAwesomeIcons.cashRegister,
                            capitalization: TextCapitalization.none,
                            validator: (v) {
                              if (isCadastrarPressed) {
                                try {
                                  if (v.isEmpty ||
                                      double.parse(v
                                          .replaceAll(',', '.')
                                          .replaceAll('cm', '')
                                          .replaceAll('c', '')
                                          .replaceAll('m', '')) ==
                                          0 &&
                                          isCadastrarPressed) {
                                    return 'É necessário preencher o Preço';
                                  } else {}
                                } catch (err) {
                                  print(err.toString());
                                  return 'Erro: Formato numerico invalido!';
                                }
                              }
                            },
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                            onSubmited: (s) {}),
                        sb,
                        hText('Dias disponiveis para serviço', context),
                        sb,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                defaultCheckBox(
                                    produto.segunda, 'Segunda', context, () {
                                  produto.segunda = !produto.segunda;
                                  cpc.produto = produto;
                                  cpc.inProduto.add(cpc.produto);
                                }),
                                sb,
                                defaultCheckBox(produto.terca, 'Terça', context,
                                        () {
                                      produto.terca = !produto.terca;
                                      cpc.produto = produto;
                                      cpc.inProduto.add(cpc.produto);
                                    }),
                                sb,
                                defaultCheckBox(
                                    produto.quarta, 'Quarta', context, () {
                                  produto.quarta = !produto.quarta;
                                  cpc.produto = produto;
                                  cpc.inProduto.add(cpc.produto);
                                }),
                                sb,
                                defaultCheckBox(
                                    produto.quinta, 'Quinta', context, () {
                                  produto.quinta = !produto.quinta;
                                  cpc.produto = produto;
                                  cpc.inProduto.add(cpc.produto);
                                }),
                                sb,
                                defaultCheckBox(produto.sexta, 'Sexta', context,
                                        () {
                                      produto.sexta = !produto.sexta;
                                      cpc.produto = produto;
                                      cpc.inProduto.add(cpc.produto);
                                    }),
                                sb,
                                defaultCheckBox(
                                    produto.sabado, 'Sábado', context, () {
                                  produto.sabado = !produto.sabado;
                                  cpc.produto = produto;
                                  cpc.inProduto.add(cpc.produto);
                                }),
                                sb,
                                defaultCheckBox(
                                    produto.domingo, 'Domingo', context, () {
                                  produto.domingo = !produto.domingo;
                                  cpc.produto = produto;
                                  cpc.inProduto.add(cpc.produto);
                                }),
                              ],
                            ),
                          ),
                        ),
                        defaultActionButton('Cadastrar Produto', context, () {
                          isCadastrarPressed = true;
                          if (_formKey.currentState.validate()) {
                            dToast(
                                'Cadastrando Produto, isso pode levar algum tempo');
                            produto.titulo = controllerTitulo.text;
                            produto.descricao = controllerDescricao.text;
                            produto.criador = Helper.localUser.id;
                            produto.preco =
                                double.parse(controllerPreco.text) * 15 / 100 +
                                    double.parse(controllerPreco.text);

                            produto.updated_at = DateTime.now();
                            produto.created_at = DateTime.now();
                            produto.endereco = Helper.localUser.endereco;
                            print(
                                '${produto.endereco.toString()} aqui é o produto do mal');
                            cpc.CadastrarProduto(produto).then((v) {
                              if (v.titulo == produto.titulo) {
                                dToast('Produto cadastrado com sucesso!');
                                Navigator.of(context).pop();
                              } else {
                                dToast(
                                    'Erro ao cadastrar Produto! ${v.toString()}');
                              }
                            });
                          }
                        }, size: 80),
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
