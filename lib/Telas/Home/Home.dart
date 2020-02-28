import 'package:autooh/Telas/Intro/IntroPage.dart';
import 'package:autooh/Telas/Marketplace/Produto/ProdutoGeneralController.dart';
import 'package:autooh/Telas/Marketplace/Produto/ProdutoList/ProdutoListItem.dart';
import 'package:autooh/Telas/Marketplace/Produto/ProdutoList/ProdutoListPage.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Grupo.dart';
import 'package:autooh/Telas/Compartilhados/custom_drawer_widget.dart';
import 'package:autooh/Telas/FichaPersonagem/FichaPersonagemPage.dart';
import 'package:autooh/Telas/Grupo/Chat/ChatList/ChatListPage.dart';
import 'package:autooh/Telas/Home/GruposController.dart';
import 'package:autooh/Telas/Personagens/PersonagensListaPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((v){


    Navigator.push(context,
                       MaterialPageRoute(builder: (context) => IntroPage()));
    });
    if (gc == null) {
      gc = new GruposController();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.shopping_cart),
          title: new Text('Serviços')
          ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.chat),
        title: new Text('conversas'),
        ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          title: Text('Yellow')
          )
    ];
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
    );

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(body: buildPageView(),
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: bottomSelectedIndex,
    onTap: (index) {
    bottomTapped(index);
    },
    items: buildBottomNavBarItems(),
    ),);
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        ProdutoListPage(),
        ChatListPage(),
        //Yellow(),
      ],
      );
  }




}
