import 'dart:async';

import 'package:battle_me/helpers/dimensions.dart';
import 'package:battle_me/scoped_models/main_scoped_model.dart';
import 'package:battle_me/screens/auth_screen.dart';
import 'package:battle_me/screens/home_screen.dart';
import 'package:battle_me/widgets/animations/navigation_animation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final MainModel model;
  SplashScreen(this.model);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(-0.8, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      ),
    );

    // Timer set to load authenticateduser and navigate
    Timer(Duration(seconds: 3), () {
      widget.model.isUserAuthenticated
          ? Navigator.pushReplacement(
              context,
              NavigationAnimationRoute(
                widget: HomeScreen(widget.model),
              ),
            )
          : Navigator.pushReplacement(
              context,
              NavigationAnimationRoute(
                widget: AuthScreen(widget.model),
              ),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Stack(children: <Widget>[
          SlideTransition(
            position: _offsetAnimation,
            child: Container(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: "icon",
                child: Container(
                  height: getDeviceHeight(context) * 0.60,
                  width: getDeviceWidth(context) * 0.60,
                  child: Image.asset('assets/images/icon.png'),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: getViewportHeight(context) * 0.6),
              child: Column(
                children: <Widget>[
                  Text(
                    'Tickle',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Manrope",
                        fontSize: getDeviceHeight(context) * 0.06,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getDeviceHeight(context) * 0.05),
                  Text(
                    "Have Fun ! \n Why so serious ?",
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        color: Colors.white,
                        fontSize: getDeviceHeight(context) * 0.03),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
