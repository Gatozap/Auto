import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:rxdart/rxdart.dart';

import 'References.dart';
import 'ShortStreamBuilder.dart';

class UserScroller extends StatelessWidget {
  UserScroller(this.ids, {this.title = 'Usuarios', this.radius = 40});
  final List ids;
  String title;
  double radius;
  List<User> actors;

  Widget _buildUser(BuildContext ctx, User user) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: user.foto != null
                ? CachedNetworkImageProvider(user.foto)
                : AssetImage('assets/images/customer.jpg'),
            radius: radius,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(user.nome),
          ),
        ],
      ),
    );
  }

  UserScrollerController usc;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    if (usc == null) {
      usc = new UserScrollerController(ids);
    }
    return SSB(
        stream: usc.outUsers,
        emptylist: Container(),
        error: Container(),
        isList: true,
        buildfunction: (context, snap) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  title,
                  style: textTheme.subhead.copyWith(fontSize: 18.0),
                ),
              ),
              SizedBox.fromSize(
                size: const Size.fromHeight(120.0),
                child: ListView.builder(
                  itemCount: snap.data.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 12.0, left: 20.0),
                  itemBuilder: (context, index) {
                    return _buildUser(context, snap.data[index]);
                  },
                ),
              ),
            ],
          );
        });
  }
}

class UserScrollerController extends BlocBase {
  BehaviorSubject<List<User>> controllerUsers =
      new BehaviorSubject<List<User>>();
  List<User> users;
  Stream<List<User>> get outUsers => controllerUsers.stream;

  Sink<List<User>> get inUsers => controllerUsers.sink;
  UserScrollerController(List ids) {
    if (users == null) {
      users = new List();
    }
    if (ids != null) {
      for (String s in ids) {
        bool contains = false;
        for (User u in users) {
          if (u.id == s) {
            contains = true;
          }
        }
        if (!contains) {
          userRef.document(s).get().then((v) {
            if (v.data != null) {
              if (v.exists) {
                User u = new User.fromJson(v.data);
                users.add(u);
                inUsers.add(users);
              }
            }
          });
        }
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controllerUsers.close();
  }
}
