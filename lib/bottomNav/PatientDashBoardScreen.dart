import 'dart:ui';

 import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/bottomNav/settintgs.dart';
import 'package:zatcare/bottomNav/topWidget.dart';

import '../appConstants.dart';
import '../utils/color_use.dart';
import 'PDashBoardFragment.dart';
import 'PatientAppointmentFragment.dart';
import 'feedList.dart';

class PatientDashBoardScreen extends StatefulWidget {
  @override
  _PatientDashBoardScreenState createState() => _PatientDashBoardScreenState();
}

class _PatientDashBoardScreenState extends State<PatientDashBoardScreen> {
  Color disableIconColor =   secondaryTxtColor;

  int currentIndex = 0;

  double iconSize = 24;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(  scaffoldBgColor);



    window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
       // appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: SafeArea(

        child: Scaffold(
           body: Stack(
            children: [
              TopNameWidget() ,
              Container(
                margin: EdgeInsets.only(top: currentIndex != 3 ? 70 : 0),
                child: [
                  PDashBoardFragment(),
                  PatientAppointmentFragment(),
                  FeedListFragment(),
                  SettingFragment(),
                ][currentIndex],
              ),
            ],
          ),
          bottomNavigationBar:
        /*  AwesomeBottomNav(

            icons: [
              Icons.home_outlined,

              Icons.calendar_today_rounded,
              Icons.newspaper_outlined,
              Icons.account_circle_outlined,
            ],
            highlightedIcons: [
              Icons.home,
              Icons. calendar_month_sharp,
              Icons.featured_play_list_rounded,
              Icons.account_circle,
            ],
            onTapped: (int value) {
              setState(() {
                currentIndex = value;
              });
            },
            bodyBgColor:scaffoldBgColor,
            highlightColor: Colors.blue,
            navFgColor: Colors.blue.withOpacity(0.8),
            navBgColor: Colors.white,
          ),*/
          BottomNavigationBar(

            currentIndex: currentIndex,
            onTap: (i) {
              currentIndex = i;
              setState(() {});
            },

            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.blue,
            backgroundColor:  Colors.white,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 12,
            items: [
              BottomNavigationBarItem(
                icon:  new Icon( MdiIcons.homeOutline,size: iconSize,  color: disableIconColor),

                activeIcon: new Icon( MdiIcons.home,size: 30,color: Colors.blue,),
                label: 'lblPatientDashboard',
              ),
              BottomNavigationBarItem(
                icon:  new Icon(  MdiIcons.calendarOutline,size: iconSize,  color: disableIconColor),

                activeIcon: new Icon(MdiIcons.calendarBadge,size: 30,color: Colors.blue,),
                label:  'lblAppointments',
              ),
              BottomNavigationBarItem(
                icon:  new Icon(Icons.search,size: iconSize,  color: disableIconColor),

                activeIcon: new Icon(Icons.search,size: 30,color: Colors.blue,),
                label:  'FeedsAndArticles',
              ),
              BottomNavigationBarItem(
                // icon: Image.asset('images/icons/user.png', height: iconSize, width: iconSize, color: disableIconColor),
                // activeIcon: Image.asset('', height: iconSize, width: iconSize, color: primaryColor),
                icon:  new Icon( Icons.person_outline_outlined,size: iconSize,  color: disableIconColor),

                activeIcon: new Icon( Icons.person,size: 30,color: Colors.blue,),

                label:  'lblSettings',
              ),
            ],
          )
        ),
      ),
    );
  }
}
