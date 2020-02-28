import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'card_list_controller.dart';
import 'card_list_widget.dart';

class CardListPage extends StatefulWidget {
  _CardListPageState createState() => _CardListPageState();
  CardListPage();
}

class _CardListPageState extends State<CardListPage> {
  CardListController clc = CardListController();

  @override
  Widget build(BuildContext context) {
    return new BlocProvider<CardListController>(
      child: CardListWidget(),
      bloc: clc,
    );
  }
}
