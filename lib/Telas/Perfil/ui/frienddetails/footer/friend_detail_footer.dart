import 'package:bocaboca/Objetos/Produto.dart';
import 'package:bocaboca/Objetos/User.dart';
import 'package:bocaboca/Telas/Perfil/ui/frienddetails/footer/portfolio_showcase.dart';
import 'package:bocaboca/Telas/Perfil/ui/frienddetails/footer/skills_showcase.dart';

import 'package:flutter/material.dart';

import 'articles_showcase.dart';


class FriendShowcase extends StatefulWidget {
  User user;
  Produto produto;
  FriendShowcase({this.user, this.produto});



  @override
  _FriendShowcaseState createState() => new _FriendShowcaseState();
}

class _FriendShowcaseState extends State<FriendShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(text: 'Documentos'),
      new Tab(text: 'Serviços'),
      new Tab(text: 'Antecedentes'),
    ];
    _pages = [
       PortfolioShowcase(user: widget.user, produto: widget.produto),
       SkillsShowcase(user: widget.user, produto: widget.produto),
       ArticlesShowcase(),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.white,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
