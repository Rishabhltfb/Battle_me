import 'package:battle_me/screens/auth_screen.dart';
import 'package:battle_me/screens/chatbox_screen.dart';
import 'package:battle_me/widgets/utilities/bottom_navbar.dart';
import 'package:battle_me/widgets/utilities/meme_card.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_scoped_model.dart';

class HomeScreen extends StatefulWidget {
  final MainModel model;

  HomeScreen(this.model);
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget body() {
    return widget.model.isLoading
        ? Center(
            child: Container(
              height: 50,
              width: 70,
              child: FlareActor(
                "assets/flare/Loader.flr",
                animation: 'start',
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          )
        : Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: widget.model.getFeedList.length,
                padding: EdgeInsets.symmetric(horizontal: 5),
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return MemeCard(index, widget.model); // Add Card
                },
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).primaryColor,
          // drawer: SideDrawer(),
          appBar: AppBar(
            leading: Hero(
              tag: "icon",
              child: Container(
                child: Image.asset('assets/images/icon.png'),
              ),
            ),
            title: Text('Home Screen'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  widget.model.logout();
                  Navigator.push(
                    context,
                    PageTransition(
                      child: AuthScreen(widget.model),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
            ],
            backgroundColor: Theme.of(context).appBarTheme.color,
          ),
          bottomNavigationBar: BottomNavbar(0),
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: body()),
        );
      },
    );
  }
}
