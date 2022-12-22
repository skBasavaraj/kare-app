import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/appConstants.dart';
import 'package:zatcare/bottomNav/PatientDashBoardScreen.dart';

import 'dart:developer' as logDev;

import 'package:zatcare/signInScreen.dart';
import 'package:zatcare/utils/color_use.dart';

import 'network/apiService.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static var  countShow;
  @override
  void initState() {
    super.initState();
    init();

  }

  init() async {
    checkFirstSeen();
   await getNotificaton( );
  }



  Future checkFirstSeen() async {
    //setStatusBarColor(Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark);

    afterBuildCreated(() {
      int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
     });

    await Future.delayed(Duration(seconds: 2));
    print("P0");
    //print("P0"+getBoolAsync(IS_LOGGED_IN).toString());
    if(getBoolAsync(IS_LOGGED_IN)==true) {
      print("P1");
      PatientDashBoardScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Scale);
    }else{
      print("P2");
      SignInScreen().launch(context, isNewTask: true);
    }

  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/appIcon.png', height: 200, width: 200).center(),

        ],
      ),
    );
  }
}